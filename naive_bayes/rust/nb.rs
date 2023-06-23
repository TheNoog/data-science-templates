struct DataPoint {
    features: Vec<f64>,
    label: usize,
}

struct Dataset {
    data: Vec<DataPoint>,
}

impl DataPoint {
    fn new(features: Vec<f64>, label: usize) -> DataPoint {
        DataPoint {
            features,
            label,
        }
    }
}

impl Dataset {
    fn new(data: Vec<DataPoint>) -> Dataset {
        Dataset {
            data,
        }
    }
}

fn load_dataset() -> Dataset {
    // Load the dataset
    let mut data = Vec::new();

    // Your code to load the data from a file or any other source goes here
    // Push each data point as a DataPoint object to the data vector

    Dataset::new(data)
}

fn train_naive_bayes(dataset: &Dataset) -> (Vec<f64>, Vec<Vec<f64>>) {
    let num_data_points = dataset.data.len();
    let num_classes = 3;  // Number of classes in your dataset
    let num_features = 4;  // Number of features in your dataset

    let mut class_counts = vec![0; num_classes];
    let mut priors = vec![0.0; num_classes];
    let mut likelihoods = vec![vec![0.0; num_features]; num_classes];

    // Count the occurrences of each class label
    for data_point in &dataset.data {
        class_counts[data_point.label] += 1;
    }

    // Calculate priors
    for i in 0..num_classes {
        priors[i] = class_counts[i] as f64 / num_data_points as f64;
    }

    // Calculate likelihoods
    for i in 0..num_classes {
        for j in 0..num_features {
            let mut feature_sum = 0.0;
            let mut feature_count = 0;

            // Sum the values of the feature for the current class
            for data_point in &dataset.data {
                if data_point.label == i {
                    feature_sum += data_point.features[j];
                    feature_count += 1;
                }
            }

            // Calculate the average of the feature for the current class
            likelihoods[i][j] = feature_sum / feature_count as f64;
        }
    }

    (priors, likelihoods)
}

fn predict(data_point: &DataPoint, priors: &[f64], likelihoods: &[Vec<f64>]) -> usize {
    let num_classes = priors.len();
    let num_features = likelihoods[0].len();
    let mut max_posterior = 0.0;
    let mut predicted_label = 0;

    // Calculate the posterior probability for each class
    for i in 0..num_classes {
        let mut posterior = priors[i];

        for j in 0..num_features {
            posterior *= f64::exp(-(data_point.features[j] - likelihoods[i][j]).powi(2) / 2.0);
        }

        // Update the predicted class if the posterior is higher than the current maximum
        if posterior > max_posterior {
            max_posterior = posterior;
            predicted_label = i;
        }
    }

    predicted_label
}

fn main() {
    let dataset = load_dataset();
    let (priors, likelihoods) = train_naive_bayes(&dataset);

    // Example usage: Predict the class label for a new data point
    let new_data_point = DataPoint::new(vec![5.1, 3.5, 1.4, 0.2], 0);

    let predicted_label = predict(&new_data_point, &priors, &likelihoods);
    println!("Predicted Label: {}", predicted_label);
}
