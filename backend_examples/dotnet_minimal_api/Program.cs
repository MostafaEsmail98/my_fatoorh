using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        var origins = builder.Configuration.GetSection("AllowedOrigins").Get<string[]>();
        if (origins is { Length: > 0 })
        {
            policy.WithOrigins(origins).AllowAnyHeader().AllowAnyMethod();
        }
        else
        {
            policy.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod();
        }
    });
});

builder.Services.AddHttpClient("myfatoorah", client =>
{
    var baseUrl = builder.Configuration["MyFatoorah:BaseUrl"] ?? "https://apitest.myfatoorah.com";
    client.BaseAddress = new Uri(baseUrl.TrimEnd('/') + "/");
    client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
});

var app = builder.Build();

app.UseCors();

static bool HasPositiveAmount(JsonElement body)
{
    return TryReadDecimal(body, out var amount) && amount > 0;
}

static bool TryReadDecimal(JsonElement body, out decimal amount)
{
    amount = 0;

    if (TryGetNested(body, ["Order", "Amount"], out var orderAmount) ||
        TryGet(body, "InvoiceAmount", out orderAmount) ||
        TryGet(body, "InvoiceValue", out orderAmount) ||
        TryGet(body, "Amount", out orderAmount))
    {
        return orderAmount.ValueKind switch
        {
            JsonValueKind.Number => orderAmount.TryGetDecimal(out amount),
            JsonValueKind.String => decimal.TryParse(orderAmount.GetString(), out amount),
            _ => false
        };
    }

    return false;
}

static bool TryGet(JsonElement element, string name, out JsonElement value)
{
    if (element.ValueKind == JsonValueKind.Object && element.TryGetProperty(name, out value))
    {
        return true;
    }

    value = default;
    return false;
}

static bool TryGetNested(JsonElement element, string[] path, out JsonElement value)
{
    value = element;
    foreach (var segment in path)
    {
        if (!TryGet(value, segment, out value))
        {
            value = default;
            return false;
        }
    }

    return true;
}

static IResult AmountValidationFailure()
{
    return Results.Json(
        new
        {
            IsSuccess = false,
            Message = "A positive amount is required.",
            ValidationErrors = new[] { "A positive amount is required." },
            Data = (object?)null
        },
        statusCode: StatusCodes.Status400BadRequest);
}

async Task<IResult> ForwardAsync(
    IHttpClientFactory httpClientFactory,
    IConfiguration configuration,
    HttpMethod method,
    string path,
    JsonElement? body = null)
{
    var apiKey = configuration["MyFatoorah:ApiKey"];
    if (string.IsNullOrWhiteSpace(apiKey))
    {
        return Results.Json(
            new
            {
                IsSuccess = false,
                Message = "Server is missing MyFatoorah:ApiKey.",
                ValidationErrors = (object?)null,
                Data = (object?)null
            },
            statusCode: StatusCodes.Status500InternalServerError);
    }

    var client = httpClientFactory.CreateClient("myfatoorah");
    using var request = new HttpRequestMessage(method, path.TrimStart('/'));
    request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);

    if (body is not null)
    {
        request.Content = new StringContent(
            body.Value.GetRawText(),
            Encoding.UTF8,
            "application/json");
    }

    using var response = await client.SendAsync(request);
    var content = await response.Content.ReadAsStringAsync();
    var contentType = response.Content.Headers.ContentType?.ToString() ?? "application/json";

    return Results.Content(content, contentType, statusCode: (int)response.StatusCode);
}

app.MapPost("/v3/payments", async (
    JsonElement body,
    IHttpClientFactory httpClientFactory,
    IConfiguration configuration) =>
{
    // Replace this sample guard with validation against your order database.
    // Validate payment method, order ownership, amount, and redirect URL.
    if (!HasPositiveAmount(body))
    {
        return AmountValidationFailure();
    }

    return await ForwardAsync(httpClientFactory, configuration, HttpMethod.Post, "/v3/payments", body);
});

app.MapGet("/v3/payments/{paymentId}", async (
    string paymentId,
    IHttpClientFactory httpClientFactory,
    IConfiguration configuration) =>
{
    var encodedPaymentId = Uri.EscapeDataString(paymentId);
    return await ForwardAsync(
        httpClientFactory,
        configuration,
        HttpMethod.Get,
        $"/v3/payments/{encodedPaymentId}");
});

app.MapPost("/v3/sessions", async (
    JsonElement body,
    IHttpClientFactory httpClientFactory,
    IConfiguration configuration) =>
{
    // Validate session amount and order ownership before forwarding.
    if (!HasPositiveAmount(body))
    {
        return AmountValidationFailure();
    }

    return await ForwardAsync(httpClientFactory, configuration, HttpMethod.Post, "/v3/sessions", body);
});

app.MapPost("/v2/InitiatePayment", async (
    JsonElement body,
    IHttpClientFactory httpClientFactory,
    IConfiguration configuration) =>
{
    // Validate amount/currency and user-specific pricing rules server-side.
    if (!HasPositiveAmount(body))
    {
        return AmountValidationFailure();
    }

    return await ForwardAsync(httpClientFactory, configuration, HttpMethod.Post, "/v2/InitiatePayment", body);
});

app.MapPost("/v2/SendPayment", async (
    JsonElement body,
    IHttpClientFactory httpClientFactory,
    IConfiguration configuration) =>
{
    // Validate customer fields, amount, notification option, and order ownership.
    if (!HasPositiveAmount(body))
    {
        return AmountValidationFailure();
    }

    return await ForwardAsync(httpClientFactory, configuration, HttpMethod.Post, "/v2/SendPayment", body);
});

app.MapPost("/v2/MakeRefund", async (
    JsonElement body,
    IHttpClientFactory httpClientFactory,
    IConfiguration configuration) =>
{
    // Validate invoice/payment ownership and prevent duplicate refunds.
    if (!HasPositiveAmount(body))
    {
        return AmountValidationFailure();
    }

    return await ForwardAsync(httpClientFactory, configuration, HttpMethod.Post, "/v2/MakeRefund", body);
});

app.MapPost("/webhooks/myfatoorah", async (
    HttpRequest request,
    IConfiguration configuration) =>
{
    using var document = await JsonDocument.ParseAsync(request.Body);
    var signature = request.Headers["myfatoorah-signature"].FirstOrDefault()
        ?? request.Headers["MyFatoorah-Signature"].FirstOrDefault();
    var webhookSecret = configuration["MyFatoorah:WebhookSecret"];

    // Verify the webhook signature before updating orders.
    // Options:
    // - Implement the official MyFatoorah HMAC/signature algorithm here.
    // - Or call shared backend code that mirrors the SDK webhook verifier.
    // Do not update payment/refund state until the signature is valid.
    Console.WriteLine(
        "Received MyFatoorah webhook. HasSignature={0}, HasSecret={1}",
        !string.IsNullOrWhiteSpace(signature),
        !string.IsNullOrWhiteSpace(webhookSecret));

    // Update your backend order state idempotently. Duplicate webhook delivery
    // should not double-process an order or refund.
    return Results.NoContent();
});

app.Run();
