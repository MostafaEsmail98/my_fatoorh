# MyFatoorah Backend Proxy - Node/Express

Backend proxy example for Flutter Web `MyFatoorahConfig.backendProxy(...)`.

The backend keeps the MyFatoorah API key server-side, forwards SDK requests to
MyFatoorah, and returns the same response envelope back to Flutter.

## Setup

```sh
cd backend_examples/node_express
cp .env.example .env
npm install
npm run dev
```

Set `MYFATOORAH_API_KEY` in `.env`. Never put real API keys in Flutter Web or
commit `.env` to source control.

For Flutter Web, configure:

```dart
final myFatoorah = MyFatoorah(
  config: MyFatoorahConfig.backendProxy(
    backendBaseUrl: Uri.parse('http://localhost:8080/'),
  ),
);
```

## Endpoints

- `POST /v3/payments`
- `GET /v3/payments/:paymentId`
- `POST /v3/sessions`
- `POST /v2/InitiatePayment`
- `POST /v2/SendPayment`
- `POST /v2/MakeRefund`
- `POST /webhooks/myfatoorah`

## Security Notes

- Store `MYFATOORAH_API_KEY` only on the backend.
- Replace the sample amount guard with validation against your order database.
- Do not trust frontend amount/order/customer values blindly.
- Verify webhook signatures before updating order or refund state.
- Handle duplicate webhook delivery idempotently.
- Confirm final payment status with Get Payment Details or a verified webhook.
