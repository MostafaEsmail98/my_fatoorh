# Backend Proxy Contract

Flutter integrations should use `MyFatoorahConfig.backendProxy(...)`.

The SDK keeps the same public payment APIs, but sends requests to your backend
instead of calling MyFatoorah REST APIs directly from Flutter.

## Why Flutter Needs A Backend Proxy

Direct frontend calls to MyFatoorah REST APIs are not appropriate because:

- Browser CORS policies can block direct REST calls.
- Merchant API keys must not be exposed in frontend code, browser dev tools, or
  network requests.

Use this flow instead:

```text
Flutter Web app -> Merchant backend -> MyFatoorah REST API
```

Android, iOS, and Web all use backend proxy mode in this package.

## Required Backend Endpoints

By default, the SDK sends the same endpoint paths to `backendBaseUrl`.

Your backend should expose:

```text
POST /v3/payments
GET  /v3/payments/{paymentId}
POST /v3/sessions
POST /v2/InitiatePayment
POST /v2/SendPayment
POST /v2/MakeRefund
```

Ready-to-copy backend examples are available in:

- [../backend_examples/node_express](../backend_examples/node_express)
- [../backend_examples/dotnet_minimal_api](../backend_examples/dotnet_minimal_api)

If your backend base URL is:

```text
https://merchant.example.com/myfatoorah/
```

Then the SDK will call:

```text
POST https://merchant.example.com/myfatoorah/v3/payments
GET  https://merchant.example.com/myfatoorah/v3/payments/{paymentId}
POST https://merchant.example.com/myfatoorah/v3/sessions
POST https://merchant.example.com/myfatoorah/v2/InitiatePayment
POST https://merchant.example.com/myfatoorah/v2/SendPayment
POST https://merchant.example.com/myfatoorah/v2/MakeRefund
```

## Backend Responsibilities

Your backend should:

- Store the MyFatoorah API key securely.
- Add the MyFatoorah `Authorization` header server-side.
- Forward validated requests to the official MyFatoorah API.
- Return the same MyFatoorah response envelope to Flutter.
- Verify MyFatoorah webhook signatures.
- Update backend order/payment status from verified webhooks or Get Payment
  Details.
- Keep order updates idempotent so duplicate webhook delivery does not
  double-process an order.

The Flutter SDK expects the backend response body to keep the common
MyFatoorah envelope shape, for example:

```json
{
  "IsSuccess": true,
  "Message": "",
  "ValidationErrors": null,
  "Data": {}
}
```

## Node/Express Pseudo-code

```js
import express from 'express';

const app = express();
app.use(express.json());

const MYFATOORAH_API_KEY = process.env.MYFATOORAH_API_KEY;
const MYFATOORAH_BASE_URL = 'https://apitest.myfatoorah.com';

async function forwardToMyFatoorah(path, options) {
  const response = await fetch(`${MYFATOORAH_BASE_URL}${path}`, {
    ...options,
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${MYFATOORAH_API_KEY}`,
      ...options.headers,
    },
  });

  return {
    status: response.status,
    body: await response.json(),
  };
}

app.post('/v3/payments', async (req, res) => {
  // Validate amount, orderId, customer ownership, and allowed payment method.
  // Do not trust frontend amount blindly.
  const result = await forwardToMyFatoorah('/v3/payments', {
    method: 'POST',
    body: JSON.stringify(req.body),
  });
  res.status(result.status).json(result.body);
});

app.get('/v3/payments/:paymentId', async (req, res) => {
  const paymentId = encodeURIComponent(req.params.paymentId);
  const result = await forwardToMyFatoorah(`/v3/payments/${paymentId}`, {
    method: 'GET',
  });
  res.status(result.status).json(result.body);
});

app.post('/v3/sessions', async (req, res) => {
  // Validate amount and order ownership server-side.
  const result = await forwardToMyFatoorah('/v3/sessions', {
    method: 'POST',
    body: JSON.stringify(req.body),
  });
  res.status(result.status).json(result.body);
});

app.post('/v2/InitiatePayment', async (req, res) => {
  // Validate amount and currency server-side before forwarding.
  const result = await forwardToMyFatoorah('/v2/InitiatePayment', {
    method: 'POST',
    body: JSON.stringify(req.body),
  });
  res.status(result.status).json(result.body);
});

app.post('/v2/SendPayment', async (req, res) => {
  // Validate amount, customer, notification option, and order ownership.
  const result = await forwardToMyFatoorah('/v2/SendPayment', {
    method: 'POST',
    body: JSON.stringify(req.body),
  });
  res.status(result.status).json(result.body);
});

app.post('/v2/MakeRefund', async (req, res) => {
  // Validate invoice/payment ownership and prevent duplicate refund requests.
  const result = await forwardToMyFatoorah('/v2/MakeRefund', {
    method: 'POST',
    body: JSON.stringify(req.body),
  });
  res.status(result.status).json(result.body);
});

app.post('/webhooks/myfatoorah', async (req, res) => {
  const signature = req.header('myfatoorah-signature');
  // Verify the signature using the portal secret before updating orders.
  // Update order state idempotently.
  res.sendStatus(204);
});
```

## .NET Minimal API Pseudo-code

```csharp
var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

var apiKey = builder.Configuration["MyFatoorah:ApiKey"];
var baseUrl = "https://apitest.myfatoorah.com";

async Task<IResult> ForwardAsync(
    HttpMethod method,
    string path,
    object? body = null)
{
    using var client = new HttpClient();
    using var request = new HttpRequestMessage(method, $"{baseUrl}{path}");

    request.Headers.Add("Accept", "application/json");
    request.Headers.Add("Authorization", $"Bearer {apiKey}");

    if (body is not null)
    {
        request.Content = JsonContent.Create(body);
    }

    var response = await client.SendAsync(request);
    var content = await response.Content.ReadAsStringAsync();

    return Results.Content(
        content,
        "application/json",
        statusCode: (int)response.StatusCode);
}

app.MapPost("/v3/payments", async (CreatePaymentRequest request) =>
{
    // Validate amount, orderId, customer ownership, and allowed payment method.
    // Do not trust frontend amount blindly.
    return await ForwardAsync(HttpMethod.Post, "/v3/payments", request);
});

app.MapGet("/v3/payments/{paymentId}", async (string paymentId) =>
{
    var encodedPaymentId = Uri.EscapeDataString(paymentId);
    return await ForwardAsync(
        HttpMethod.Get,
        $"/v3/payments/{encodedPaymentId}");
});

app.MapPost("/v3/sessions", async (InitiateSessionRequest request) =>
{
    // Validate amount and order ownership server-side.
    return await ForwardAsync(HttpMethod.Post, "/v3/sessions", request);
});

app.MapPost("/v2/InitiatePayment", async (InitiatePaymentRequest request) =>
{
    // Validate amount and currency server-side before forwarding.
    return await ForwardAsync(
        HttpMethod.Post,
        "/v2/InitiatePayment",
        request);
});

app.MapPost("/v2/SendPayment", async (SendPaymentRequest request) =>
{
    // Validate amount, customer, notification option, and order ownership.
    return await ForwardAsync(HttpMethod.Post, "/v2/SendPayment", request);
});

app.MapPost("/v2/MakeRefund", async (MakeRefundRequest request) =>
{
    // Validate invoice/payment ownership and prevent duplicate refund requests.
    return await ForwardAsync(HttpMethod.Post, "/v2/MakeRefund", request);
});

app.MapPost("/webhooks/myfatoorah", async (HttpRequest request) =>
{
    var signature = request.Headers["myfatoorah-signature"].ToString();
    // Verify the signature using the portal secret before updating orders.
    // Update order state idempotently.
    return Results.NoContent();
});
```

The pseudo-code intentionally omits concrete request DTOs and authentication
middleware. Your backend should use your real order model, user/session
authorization, validation, logging, and error handling.

## Security Notes

- Never return the MyFatoorah API key to the frontend.
- Never hardcode the API key in Flutter Web.
- Validate amount, currency, order ID, and customer ownership server-side.
- Do not trust frontend amount blindly.
- Use idempotency where possible for payment creation and webhook handling.
- Verify webhook signatures before updating order state.
- Do not mark an order paid from redirect/callback data alone.
- Confirm final payment state with Get Payment Details or a verified webhook.
