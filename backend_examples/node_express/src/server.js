import cors from 'cors';
import 'dotenv/config';
import express from 'express';

const app = express();

const port = Number(process.env.PORT || 8080);
const apiKey = process.env.MYFATOORAH_API_KEY;
const baseUrl = (process.env.MYFATOORAH_BASE_URL || 'https://apitest.myfatoorah.com').replace(/\/$/, '');
const allowedOrigin = process.env.ALLOWED_ORIGIN;

app.use(express.json({ limit: '1mb' }));
app.use(
  cors({
    origin: allowedOrigin || true,
    credentials: false,
  }),
);

if (!apiKey) {
  console.warn('MYFATOORAH_API_KEY is not set. Requests will fail until you configure it.');
}

function hasPositiveAmount(value) {
  const amount = Number.parseFloat(String(value ?? '').trim());
  return Number.isFinite(amount) && amount > 0;
}

function firstAmount(body) {
  return body?.Order?.Amount ?? body?.InvoiceAmount ?? body?.InvoiceValue ?? body?.Amount;
}

function requirePositiveAmount(req, res, next) {
  // Replace this sample guard with real server-side validation against your
  // order database. Never trust frontend amount/order values blindly.
  if (!hasPositiveAmount(firstAmount(req.body))) {
    return res.status(400).json({
      IsSuccess: false,
      Message: 'A positive amount is required.',
      ValidationErrors: ['A positive amount is required.'],
      Data: null,
    });
  }

  return next();
}

async function forwardToMyFatoorah(req, res, path, { method = 'POST', body } = {}) {
  if (!apiKey) {
    return res.status(500).json({
      IsSuccess: false,
      Message: 'Server is missing MYFATOORAH_API_KEY.',
      ValidationErrors: null,
      Data: null,
    });
  }

  const response = await fetch(`${baseUrl}${path}`, {
    method,
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
      Authorization: `Bearer ${apiKey}`,
    },
    body: body == null ? undefined : JSON.stringify(body),
  });

  const text = await response.text();
  res.status(response.status).type(response.headers.get('content-type') || 'application/json');
  return res.send(text);
}

app.post('/v3/payments', requirePositiveAmount, (req, res) => {
  // Validate payment method, order ownership, and redirect URL for your app.
  return forwardToMyFatoorah(req, res, '/v3/payments', { body: req.body });
});

app.get('/v3/payments/:paymentId', (req, res) => {
  const paymentId = encodeURIComponent(req.params.paymentId);
  return forwardToMyFatoorah(req, res, `/v3/payments/${paymentId}`, {
    method: 'GET',
  });
});

app.post('/v3/sessions', requirePositiveAmount, (req, res) => {
  // Validate session amount and order ownership before forwarding.
  return forwardToMyFatoorah(req, res, '/v3/sessions', { body: req.body });
});

app.post('/v2/InitiatePayment', requirePositiveAmount, (req, res) => {
  // Validate amount/currency and any user-specific pricing rules.
  return forwardToMyFatoorah(req, res, '/v2/InitiatePayment', { body: req.body });
});

app.post('/v2/SendPayment', requirePositiveAmount, (req, res) => {
  // Validate customer fields, amount, notification option, and order ownership.
  return forwardToMyFatoorah(req, res, '/v2/SendPayment', { body: req.body });
});

app.post('/v2/MakeRefund', requirePositiveAmount, (req, res) => {
  // Validate invoice/payment ownership and prevent duplicate refunds.
  return forwardToMyFatoorah(req, res, '/v2/MakeRefund', { body: req.body });
});

app.post('/webhooks/myfatoorah', (req, res) => {
  const signature = req.header('myfatoorah-signature') || req.header('MyFatoorah-Signature');
  const webhookSecret = process.env.MYFATOORAH_WEBHOOK_SECRET;

  // Verify the webhook signature before updating orders.
  // Options:
  // - Implement the official MyFatoorah HMAC/signature algorithm here.
  // - Or call shared backend code that mirrors the SDK webhook verifier.
  // Do not update payment/refund state until the signature is valid.
  console.log('Received MyFatoorah webhook', {
    hasSignature: Boolean(signature),
    hasWebhookSecret: Boolean(webhookSecret),
    eventType: req.body?.EventType,
  });

  // Update your backend order state idempotently. Duplicate webhook delivery
  // should not double-process an order or refund.
  return res.sendStatus(204);
});

app.listen(port, () => {
  console.log(`MyFatoorah backend proxy listening on http://localhost:${port}`);
});
