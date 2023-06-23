use xgboost::{DMatrix, Booster};

fn main() {
    // Load the training and testing data
    let train_data = DMatrix::from_file("train.libsvm").unwrap();
    let test_data = DMatrix::from_file("test.libsvm").unwrap();

    // Set the parameters for the XGBoost model
    let params = [
        ("objective", "reg:squarederror"),
        ("max_depth", "3"),
        ("eta", "0.1"),
        ("subsample", "0.8"),
        ("colsample_bytree", "0.8"),
    ];

    // Train the model
    let num_rounds = 100;
    let model = Booster::train(&train_data, &params, num_rounds).unwrap();

    // Make predictions on the test data
    let predictions = model.predict(&test_data).unwrap();

    // Evaluate the model
    let labels = test_data.get_labels().unwrap();
    let sum_squared_error: f32 = labels
        .iter()
        .zip(predictions.iter())
        .map(|(label, prediction)| (label - prediction).powi(2))
        .sum();
    let rmse = (sum_squared_error / labels.len() as f32).sqrt();
    println!("RMSE: {}", rmse);
}
