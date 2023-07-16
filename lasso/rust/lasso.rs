// Define the number of samples and features
const N_SAMPLES: usize = 100;
const N_FEATURES: usize = 20;

// Function to calculate the mean squared error
fn calculate_mean_squared_error(y_true: &[f64], y_pred: &[f64]) -> f64 {
    let n = y_true.len();
    let squared_errors: f64 = y_true
        .iter()
        .zip(y_pred.iter())
        .map(|(&y, &y_pred)| (y - y_pred) * (y - y_pred))
        .sum();
    squared_errors / n as f64
}

// Function to perform LASSO regression
fn lasso_regression(X: &[Vec<f64>], y: &[f64], alpha: f64) -> Vec<f64> {
    // Maximum number of iterations for coordinate descent
    const MAX_ITERATIONS: usize = 100;
    
    // Step size for coordinate descent
    const STEP_SIZE: f64 = 0.01;

    let n_samples = X.len();
    let n_features = X[0].len();

    // Initialize the coefficients to zero
    let mut coefficients: Vec<f64> = vec![0.0; n_features];

    // Perform coordinate descent
    for _ in 0..MAX_ITERATIONS {
        for j in 0..n_features {
            // Calculate the gradient for feature j
            let mut gradient = 0.0;
            for i in 0..n_samples {
                let mut pred = 0.0;
                for k in 0..n_features {
                    if k != j {
                        pred += X[i][k] * coefficients[k];
                    }
                }
                gradient += (y[i] - pred) * X[i][j];
            }

            // Update the coefficient using LASSO penalty
            if gradient > alpha {
                coefficients[j] = (gradient - alpha) * STEP_SIZE;
            } else if gradient < -alpha {
                coefficients[j] = (gradient + alpha) * STEP_SIZE;
            } else {
                coefficients[j] = 0.0;
            }
        }
    }

    coefficients
}

// Generate some synthetic data
fn generate_synthetic_data() -> (Vec<Vec<f64>>, Vec<f64>) {
    let mut rng = rand::thread_rng();
    let mut X: Vec<Vec<f64>> = vec![vec![0.0; N_FEATURES]; N_SAMPLES];
    let mut y: Vec<f64> = vec![0.0; N_SAMPLES];

    for i in 0..N_SAMPLES {
        for j in 0..N_FEATURES {
            X[i][j] = rng.gen();
        }

        y[i] = X[i].iter().enumerate().map(|(j, &x)| x * (j as f64 + 1.0)).sum::<f64>() + 0.1 * rng.gen();
    }

    (X, y)
}

// Main function
fn main() {
    // Generate some synthetic data
    let (X, y) = generate_synthetic_data();

    // Split the data into training and test sets
    let n_train_samples = (N_SAMPLES as f64 * 0.8) as usize;
    let n_test_samples = N_SAMPLES - n_train_samples;
    let X_train = &X[0..n_train_samples];
    let y_train = &y[0..n_train_samples];
    let X_test = &X[n_train_samples..];
    let y_test = &y[n_train_samples..];

    // Perform LASSO regression
    let alpha = 0.1;
    let coefficients = lasso_regression(X_train, y_train, alpha);

    // Make predictions on the test set
    let y_pred: Vec<f64> = X_test.iter()
        .map(|sample| sample.iter().zip(coefficients.iter()).map(|(&x, &c)| x * c).sum())
        .collect();

    // Calculate the mean squared error
    let mse = calculate_mean_squared_error(y_test, &y_pred);
    println!("Mean Squared Error: {}", mse);

    // Print the true coefficients and the estimated coefficients
    print!("True Coefficients: [1.0 ");
    for i in 1..N_FEATURES {
        print!("{} ", i + 1);
    }
    println!("]");

    println!("Estimated Coefficients: {:?}", coefficients);
}
