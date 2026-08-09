var builder = WebApplication.CreateBuilder(args);
builder.Logging.ClearProviders();
builder.Logging.AddSimpleConsole(options =>
{
    options.SingleLine = true;
    options.TimestampFormat = "yyyy-MM-dd HH:mm:ss ";
});

var app = builder.Build();

app.MapGet("/health", () => Results.Ok(new { status = "up" }));
// Receives activity messages from Spring Boot and writes them as structured
// console lines. Returning Accepted keeps this service focused on logging only.
app.MapPost("/logs", (LogEvent entry, ILogger<Program> logger) =>
{
    logger.LogInformation(
        "Quiz event {EventType}: {Message} (user: {UserId})",
        entry.EventType, entry.Message, entry.UserId);
    return Results.Accepted();
});

app.Run("http://localhost:5050");

public record LogEvent(string EventType, string Message, long? UserId);
