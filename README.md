# MyFatoorah Flutter SDK

A Flutter/Dart SDK for integrating MyFatoorah payments with a clean, typed API.

The package is being built incrementally. The current SDK focuses on the safe
payment foundations: creating Hosted Payment URLs, checking official payment
status, launching hosted checkout, parsing redirects, verifying/parsing
webhooks, and initiating Embedded Payment sessions.

## Supported platforms

- Android
- iOS
- Web

The SDK includes a Hosted Payment URL launcher using `url_launcher`. Embedded
native/mobile checkout adapters are not implemented yet.

## Current features

- Hosted Payment v3 create payment URL: `POST /v3/payments`
- Hosted Payment URL launcher for Android, iOS, and Web
- Payment Methods lookup: `POST /v2/InitiatePayment`
- Optional Payment Methods list/tile widgets
- Invoice/payment link creation: `POST /v2/SendPayment`
- Refund requests: `POST /v2/MakeRefund`
- Payment Details / Status: `GET /v3/payments/{paymentId}`
- Callback/redirect URL parser
- Webhook parser and signature verifier helpers
- Embedded Payment session initiation: `POST /v3/sessions`

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  my_fatoorah: ^0.1.0
```

Then import the public SDK entry point:

```dart
import 'package:my_fatoorah/my_fatoorah.dart';
```

## Basic initialization

The Flutter package is backend-only. It sends SDK endpoint paths to your
merchant backend; your backend stores the MyFatoorah API key and forwards
validated requests to MyFatoorah.

```dart
final myFatoorah = MyFatoorah(
  config: MyFatoorahConfig.backendProxy(
    backendBaseUrl: Uri.parse('https://merchant.example.com/myfatoorah/'),
    country: MyFatoorahCountry.kuwait,
    language: MyFatoorahLanguage.english,
    enableLogging: true,
  ),
);
```

The Flutter app sends these SDK endpoint paths to your backend:

- `POST /v3/payments`
- `GET /v3/payments/{paymentId}`
- `POST /v3/sessions`
- `POST /v2/InitiatePayment`
- `POST /v2/SendPayment`
- `POST /v2/MakeRefund`

Your backend should store the MyFatoorah API key, add the Authorization header,
forward requests to MyFatoorah, and return the MyFatoorah response shape to the
Flutter app. The SDK does not implement backend server code.

See the backend proxy contract for the expected endpoints and backend security
responsibilities: [docs/backend_proxy.md](docs/backend_proxy.md).

Ready-to-copy backend proxy examples are available in:

- [backend_examples/node_express](backend_examples/node_express)
- [backend_examples/dotnet_minimal_api](backend_examples/dotnet_minimal_api)

## Payment methods example

Fetch available and enabled payment methods for your portal account before
checkout:

```dart
final result = await myFatoorah.payments.methods.get(
  const InitiatePaymentRequest(
    invoiceAmount: '10.000',
    currencyIso: 'KWD',
  ),
);

switch (result) {
  case MyFatoorahSuccess(value: final response):
    final methods = response.paymentMethods;
    final cardMethods = methods.where((method) => method.isCard);
    final applePayMethods = methods.where((method) => method.isApplePay);
    final googlePayMethods = methods.where((method) => method.isGooglePay);
    break;

  case MyFatoorahFailure(exception: final error):
    // Handle typed SDK error.
    break;
}
```

This uses MyFatoorah `POST /v2/InitiatePayment`. It only returns available
methods and charges; it does not execute or store a payment.

You can render the returned methods with the optional lightweight widgets:

```dart
MyFatoorahPaymentMethodsList(
  methods: methods,
  selectedPaymentMethodId: selectedPaymentMethodId,
  onSelected: (method) {
    setState(() {
      selectedPaymentMethodId = method.paymentMethodId;
    });
  },
  style: const MyFatoorahPaymentMethodsStyle(
    showImages: true,
    spacing: 8,
  ),
)
```

The widget does not make network or payment API calls. Your app owns fetching,
state, and checkout flow.

## Invoice/payment link example

Create a MyFatoorah invoice/payment link with SendPayment:

```dart
final result = await myFatoorah.invoices.send(
  const SendPaymentRequest(
    invoiceValue: '10.000',
    customer: InvoiceCustomer(
      name: 'Customer Name',
      email: 'customer@example.com',
    ),
    notificationOption: SendPaymentNotificationOption.email,
    displayCurrencyIso: 'KWD',
    callBackUrl: 'https://example.com/payment/success',
    errorUrl: 'https://example.com/payment/error',
  ),
);

switch (result) {
  case MyFatoorahSuccess(value: final invoice):
    final invoiceId = invoice.invoiceId;
    final invoiceUrl = invoice.invoiceUrl;

    // Send or open invoiceUrl in your own app flow.
    // Confirm final payment with Get Payment Details or webhook.
    break;

  case MyFatoorahFailure(exception: final error):
    // Handle typed SDK error.
    break;
}
```

Do not mark an order paid when the invoice link is created. Confirm final
payment with Get Payment Details or a verified backend webhook.

## Refund example

Create a MyFatoorah refund request by invoice ID or payment ID:

```dart
final result = await myFatoorah.refunds.make(
  const MakeRefundRequest.invoiceId(
    invoiceId: '6424767',
    amount: '1.000',
    comment: 'partial refund to the customer',
    externalIdentifier: 'refund-external-id',
  ),
);

switch (result) {
  case MyFatoorahSuccess(value: final refund):
    final refundId = refund.refundId;
    final refundReference = refund.refundReference;

    // Store these values and confirm final refund state from backend,
    // MyFatoorah portal/status APIs, or a verified refund webhook.
    break;

  case MyFatoorahFailure(exception: final error):
    // Handle typed SDK error.
    break;
}
```

Send one refund request at a time for an order or transaction. Your backend
should prevent duplicate partial refund requests and verify ownership before
forwarding refunds to MyFatoorah.

## Hosted Payment quickstart

Create a MyFatoorah hosted payment URL:

```dart
final result = await myFatoorah.payments.hosted.createPaymentUrl(
  const CreateHostedPaymentRequest(
    paymentMethod: 'CARD',
    order: HostedPaymentOrder(amount: '10.000'),
    integrationUrls: HostedPaymentIntegrationUrls(
      redirection: 'https://example.com/payment/callback',
    ),
  ),
);

switch (result) {
  case MyFatoorahSuccess(value: final payment):
    final paymentUrl = payment.paymentUrl;
    final paymentId = payment.paymentId;
    final invoiceId = payment.invoiceId;

    final opened = await myFatoorah.payments.hosted.openPaymentUrl(
      paymentUrl,
    );
    // On Android/iOS this prefers Chrome Custom Tabs / Safari View Controller
    // when available. On Web it opens a browser tab/window.
    break;

  case MyFatoorahFailure(exception: final error):
    // Show or log the typed SDK error.
    break;
}
```

Opening the payment URL does not confirm payment. After redirect, confirm with
`confirmFromCallback(...)` or `payments.status.get(paymentId)`.

After MyFatoorah redirects back to your `redirection` URL, parse the callback
and confirm payment status:

```dart
final confirmed = await myFatoorah.payments.hosted.confirmFromCallback(
  redirectUrl,
);

switch (confirmed) {
  case MyFatoorahSuccess(value: final details):
    if (details.isPaid) {
      // Payment is confirmed by Get Payment Details.
    }
    break;

  case MyFatoorahFailure(exception: final error):
    // Missing paymentId, network failure, API failure, etc.
    break;
}
```

Do not treat redirect success as a paid payment. Always confirm using Get
Payment Details or a verified backend webhook.

## Simple checkout flow

For a smaller app-facing API, use the high-level checkout facade. It
orchestrates existing SDK calls only; it does not add payment endpoints.

```dart
final checkoutResult = await myFatoorah.checkout.createHostedCheckout(
  const HostedCheckoutRequest(
    amount: '10.000',
    currencyIso: 'KWD',
    redirectUrl: 'https://example.com/payment/callback',
    loadPaymentMethods: true,
  ),
);

switch (checkoutResult) {
  case MyFatoorahSuccess(value: final checkout):
    final paymentMethods = checkout.paymentMethods;

    await myFatoorah.checkout.openHostedCheckout(checkout);
    // Opening checkout does not mean the payment is paid.
    break;

  case MyFatoorahFailure(exception: final error):
    // Handle validation, API, or network errors.
    break;
}
```

After the redirect, confirm with the official payment status API:

```dart
final confirmed = await myFatoorah.checkout.confirmHostedCallback(redirectUrl);
```

You can also confirm directly when you already have a payment ID:

```dart
final status = await myFatoorah.payments.status.get(paymentId);
```

## Payment status example

```dart
final result = await myFatoorah.payments.status.get(paymentId);

switch (result) {
  case MyFatoorahSuccess(value: final details):
    if (details.isPaid) {
      // Mark the order as paid.
    } else if (details.isFailed) {
      // Handle failed payment.
    } else if (details.isPending) {
      // Keep waiting or ask the backend for the latest state.
    }
    break;

  case MyFatoorahFailure(exception: final error):
    // Handle typed SDK error.
    break;
}
```

## Embedded session example

The SDK can initiate an Embedded Payment session. It does not render Embedded
Payment UI, execute payment, or provide JS/platform adapters yet.

```dart
final result = await myFatoorah.payments.embedded.initiateSession(
  const InitiateSessionRequest(
    paymentMode: EmbeddedPaymentMode.completePayment,
    order: InitiateSessionOrder(amount: '10.000'),
  ),
);

switch (result) {
  case MyFatoorahSuccess(value: final session):
    final sessionId = session.sessionId;

    // SessionId is valid for one payment only.
    // Pass it to your future Embedded Payment UI integration.
    break;

  case MyFatoorahFailure(exception: final error):
    // Handle typed SDK error.
    break;
}
```

## Embedded Web checkout foundation

The SDK includes an optional Flutter Web container widget for the official
MyFatoorah Embedded Payment JavaScript integration. It is Web-only and does not
execute payment on your backend.

```dart
MyFatoorahEmbeddedWebCheckout(
  sessionId: sessionId,
  countryCode: 'KWT',
  currencyCode: 'KWD',
  amount: '10.000',
  environment: MyFatoorahEnvironment.test,
  onCallback: (data) {
    // JS callback data is not final payment proof.
    // Confirm with Get Payment Details or a verified backend webhook.
  },
  onError: (error) {
    // Handle container or future JS initialization errors.
  },
)
```

On Android and iOS, the widget shows a clear unsupported message. On Web, it
loads the official `session.js` script for the selected environment/country,
registers the HTML container expected by MyFatoorah Embedded Payment, and calls
`myfatoorah.init(...)`.

This widget renders the Embedded Payment form only. Final confirmation still
requires backend ExecutePayment handling, Get Payment Details, or a verified
backend webhook. Do not mark orders paid from the JavaScript callback alone.

## Webhook helper example

Webhook handling should run on your backend. The Flutter app should read the
final order status from your backend or confirm with Get Payment Details.

```dart
final parsed = MyFatoorahWebhookParser.parseJsonString(requestBody);

switch (parsed) {
  case MyFatoorahSuccess(value: final event):
    final verification = MyFatoorahWebhookVerifier.verify(
      event: event,
      signature: requestHeaders[MyFatoorahWebhookVerifier.signatureHeader] ?? '',
      secretKey: webhookSecretKey,
    );

    if (!verification.isValid) {
      // Reject or ignore the webhook.
      return;
    }

    // Update backend order state idempotently.
    // Duplicate webhook delivery should not double-process an order.
    break;

  case MyFatoorahFailure(exception: final error):
    // Invalid webhook payload.
    break;
}
```

## Security notes

- Never expose MyFatoorah API keys in Flutter apps.
- The Flutter SDK only supports backend proxy mode for payment API calls.
- Do not trust redirect callbacks alone.
- Confirm payment with Get Payment Details or a verified backend webhook.
- Webhooks should be handled on your backend, not directly in a Flutter client.
- Webhook handlers should be idempotent because duplicate delivery can happen.

## Roadmap

- Embedded UI
- Web JS interop
- Mobile platform adapters
- Invoice APIs
- Refund APIs
- Recurring payments
- Saved cards/token payments

## Development

Run checks before contributing:

```sh
flutter analyze
flutter test
```
