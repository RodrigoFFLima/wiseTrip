using System.Net.Http.Json;

namespace TripWise.App.Services;

public class TripEstimateResponse
{
    public int Distance { get; set; }
    public decimal FuelCost { get; set; }
    public decimal TollCost { get; set; }
    public decimal TotalCost { get; set; }
}

public class TripService
{
    private readonly HttpClient _httpClient;

    public TripService()
    {
        _httpClient = new HttpClient
        {
            BaseAddress = new Uri("http://localhost:5222")
        };
    }

    public async Task<TripEstimateResponse?> GetEstimate(int distance)
    {
        try
        {
            return await _httpClient.GetFromJsonAsync<TripEstimateResponse>(
                $"/api/trip/estimate?distance={distance}"
            );
        }
        catch
        {
            return null;
        }
    }
}