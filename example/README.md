# MyFatoorah SDK Example

This is a runnable Flutter example app for the current SDK surface. It does not
contain real merchant credentials, and it stores entered configuration in memory
only.

## Screens

- Setup: enter your backend URL and choose test/live.
- Payment Methods: fetch methods and render `MyFatoorahPaymentMethodsList`.
- Hosted Payment: create a payment URL, copy it, or open it externally.
- Payment Status: query Get Payment Details by `paymentId`.
- Callback Parser: parse a redirect URL and optionally confirm using status API.
- Embedded Web: initiate a session and render `MyFatoorahEmbeddedWebCheckout`
  on Flutter Web.
- Invoice: send a payment link/invoice.
- Refund: make a refund request from an invoice ID or payment ID.

## Run

```sh
cd example
flutter run -d chrome
flutter run -d android
flutter run -d ios
```

The example only uses `backendProxy` mode. Flutter never receives or sends the
MyFatoorah API key.

The example intentionally does not implement a backend server. Point
`backendProxy` at a merchant backend that follows `../docs/backend_proxy.md`.

## Security Notes

- Never hardcode real API keys in this example or any Flutter app.
- Do not trust redirect or JavaScript callback data as final payment proof.
- Confirm payments with Get Payment Details or a verified backend webhook.
- Refunds should normally be performed from a backend/admin context.
