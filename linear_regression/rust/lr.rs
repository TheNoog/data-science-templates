// Function to calculate the mean
fn calculate_mean(list: &[f64]) -> f64 {
    list.iter().sum::<f64>() / list.len() as f64
}

// Function to calculate the slope (beta1)
fn calculate_slope(x: &[f64], y: &[f64]) -> f64 {
    let mean_x = calculate_mean(x);
    let mean_y = calculate_mean(y);
    let numerator = x.iter().zip(y.iter()).fold(0.0, |acc, (&xi, &yi)| acc + (xi - mean_x) * (yi - mean_y));
    let denominator = x.iter().fold(0.0, |acc, &xi| acc + (xi - mean_x).powi(2));
    numerator / denominator
}

// Function to calculate the intercept (beta0)
fn calculate_intercept(x: &[f64], y: &[f64], slope: f64) -> f64 {
    let mean_x = calculate_mean(x);
    let mean_y = calculate_mean(y);
    mean_y - slope * mean_x
}

// Function to make predictions
fn predict(x: f64, slope: f64, intercept: f64) -> f64 {
    slope * x + intercept
}

fn main() {
    let x = &[1.0, 2.0, 3.0, 4.0, 5.0];  // Input features
    let y = &[2.0, 4.0, 5.0, 4.0, 6.0];  // Target variable

    let slope = calculate_slope(x, y);
    let intercept = calculate_intercept(x, y, slope);

    let new_x = &[6.0, 7.0];

    println!("Input\tPredicted Output");
    for &x_val in new_x {
        let y_pred = predict(x_val, slope, intercept);
        println!("{:.1}\t{:.2}", x_val, y_pred);
    }
}
