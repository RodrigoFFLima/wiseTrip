using Microsoft.AspNetCore.Mvc;

namespace TripWise.Api.Controllers;

[ApiController]
[Route("api/trip")]
public class TripController : ControllerBase
{
    [HttpGet("estimate")]
    public IActionResult Estimate()
    {
        var distanceKm = 500;
        var consumptionKmL = 12;
        var fuelPrice = 6.0;

        var fuelCost = (distanceKm / consumptionKmL) * fuelPrice;

        var response = new
        {
            Distance = distanceKm,
            FuelCost = fuelCost,
            TollCost = 50,
            TotalCost = fuelCost + 50
        };

        return Ok(response);
    }
}