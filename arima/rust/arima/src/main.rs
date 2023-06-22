extern crate statsmodels;

use statsmodels::arima::ARIMA;

fn fit_arima_model(data: &[f64], order: (usize, usize, usize)) -> Result<ARIMA, Box<dyn std::error::Error>> {
    // Create the ARIMA model
    let model = ARIMA::new(data, order)?;

    // Fit the model to the data
    let model_fit = model.fit()?;

    Ok(model_fit)
}

fn main() {
    let data = &[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0];
    let order = (1, 0, 1);

    match fit_arima_model(data, order) {
        Ok(model) => {
            // Use the fitted model for predictions
            let forecast = model.predict(3); // Predict the next 3 values
            // The predict method returns a Vec<f64> containing the predicted values.
            println!("Forecast: {:?}", forecast);
        }
        Err(err) => {
            eprintln!("An error occurred: {}", err);
        }
    }
}
