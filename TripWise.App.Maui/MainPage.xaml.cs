using TripWise.App.Services;

namespace TripWise.App;

public partial class MainPage : ContentPage
{
    private readonly TripService _tripService = new();

    public MainPage()
    {
        InitializeComponent();
    }

    private async void OnCalculateClicked(object sender, EventArgs e)
    {
        await DistanceEntry.HideSoftInputAsync(CancellationToken.None);

        ClearState();
        SetLoading(true);

        try
        {
            if (!int.TryParse(DistanceEntry.Text, out var distance) || distance <= 0)
            {
                ShowError("Please enter a valid distance greater than zero.");
                return;
            }

            var result = await _tripService.GetEstimate(distance);

            if (result is null)
            {
                ShowError("Could not calculate trip estimate.");
                return;
            }

            DistanceLabel.Text = $"{result.Distance} km";
            FuelLabel.Text = $"R$ {result.FuelCost:F2}";
            TollLabel.Text = $"R$ {result.TollCost:F2}";
            TotalLabel.Text = $"R$ {result.TotalCost:F2}";

            ResultCard.IsVisible = true;
        }
        finally
        {
            SetLoading(false);
        }
    }

    private void ClearState()
    {
        ErrorLabel.Text = string.Empty;
        ErrorLabel.IsVisible = false;
        ResultCard.IsVisible = false;
    }

    private void ShowError(string message)
    {
        ErrorLabel.Text = message;
        ErrorLabel.IsVisible = true;
    }

    private void SetLoading(bool isLoading)
    {
        LoadingIndicator.IsVisible = isLoading;
        LoadingIndicator.IsRunning = isLoading;
        CalculateButton.IsEnabled = !isLoading;
        CalculateButton.Text = isLoading ? "Calculating..." : "Calculate trip";
    }
}