# MyFatoorah Backend Proxy - .NET Minimal API

Backend proxy example for Flutter Web `MyFatoorahConfig.backendProxy(...)`.

The backend stores the MyFatoorah API key server-side, forwards SDK requests to
MyFatoorah, and returns the same response envelope back to Flutter.

## Setup

Create a minimal API project, then replace its `Program.cs` with this example:

```sh
mkdir myfatoorah-proxy
cd myfatoorah-proxy
dotnet new web
cp ../backend_examples/dotnet_minimal_api/Program.cs Program.cs
cp ../backend_examples/dotnet_minimal_api/appsettings.example.json appsettings.Development.json
dotnet run
```

Set `MyFatoorah:ApiKey` in `appsettings.Development.json`, user secrets, or an
environment variable:

```sh
dotnet user-secrets set "MyFatoorah:ApiKey" "your-server-side-api-key"
dotnet user-secrets set "MyFatoorah:BaseUrl" "https://apitest.myfatoorah.com"
```

Never put real API keys in Flutter Web or commit secrets to source control.

For Flutter Web, configure:

```dart
final myFatoorah = MyFatoorah(
  config: MyFatoorahConfig.backendProxy(
    backendBaseUrl: Uri.parse('http://localhost:5000/'),
  ),
);
```

## Endpoints

- `POST /v3/payments`
- `GET /v3/payments/{paymentId}`
- `POST /v3/sessions`
- `POST /v2/InitiatePayment`
- `POST /v2/SendPayment`
- `POST /v2/MakeRefund`
- `POST /webhooks/myfatoorah`

## Security Notes

- Store `MyFatoorah:ApiKey` only on the backend.
- Replace the sample amount guard with validation against your order database.
- Do not trust frontend amount/order/customer values blindly.
- Verify webhook signatures before updating order or refund state.
- Handle duplicate webhook delivery idempotently.
- Confirm final payment status with Get Payment Details or a verified webhook.
