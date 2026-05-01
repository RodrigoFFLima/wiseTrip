using Microsoft.AspNetCore.Mvc;

namespace TripWise.Api.Controllers;

[ApiController]
[Route("api/trip")]
public class TripController : ControllerBase
{
    [HttpGet("estimate")]
    public IActionResult Estimate([FromQuery] decimal distance)
    {
        if (distance <= 0)
            return BadRequest("Distance must be greater than zero.");

        const decimal fuelPrice = 6.0m;
        const decimal consumptionKmL = 12m;
        const decimal tollCost = 50m;

        var fuelCost = (distance / consumptionKmL) * fuelPrice;
        var totalCost = fuelCost + tollCost;

        var response = new
        {
            Distance = distance,
            FuelCost = decimal.Round(fuelCost, 2),
            TollCost = tollCost,
            TotalCost = decimal.Round(totalCost, 2)
        };

        return Ok(response);
    }
}