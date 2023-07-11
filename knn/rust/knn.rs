use std::cmp::Ordering;

// Structure to represent a data point
struct DataPoint {
    x: f64,
    y: f64,
    label: i32,
}

// Function to calculate Euclidean distance between two data points
fn calculate_distance(p1: &DataPoint, p2: &DataPoint) -> f64 {
    let dx = p2.x - p1.x;
    let dy = p2.y - p1.y;
    (dx * dx + dy * dy).sqrt()
}

// Function to perform KNN classification
fn classify(training_data: &[DataPoint], test_point: &DataPoint, k: usize) -> i32 {
    // Calculate distances to all training data points
    let mut distances: Vec<f64> = training_data
        .iter()
        .map(|data_point| calculate_distance(data_point, test_point))
        .collect();

    // Sort the distances in ascending order
    distances.sort_by(|a, b| a.partial_cmp(b).unwrap_or(Ordering::Equal));

    // Count the occurrences of each label among the k nearest neighbors
    let mut label_count = std::collections::HashMap::new();
    for i in 0..k {
        let index = distances.iter().position(|&d| d == distances[i]).unwrap();
        let label = training_data[index].label;
        *label_count.entry(label).or_insert(0) += 1;
    }

    // Return the label with the highest count
    *label_count
        .iter()
        .max_by(|(_, count1), (_, count2)| count1.cmp(count2))
        .map(|(&label, _)| label)
        .unwrap_or(&-1)
}

fn main() {
    // Training data
    let training_data = vec![
        DataPoint {
            x: 2.0,
            y: 4.0,
            label: 0,
        },
        DataPoint {
            x: 4.0,
            y: 6.0,
            label: 0,
        },
        DataPoint {
            x: 4.0,
            y: 8.0,
            label: 1,
        },
        DataPoint {
            x: 6.0,
            y: 4.0,
            label: 1,
        },
        DataPoint {
            x: 6.0,
            y: 6.0,
            label: 1,
        },
    ];

    // Test data point
    let test_point = DataPoint {
        x: 5.0,
        y: 5.0,
        label: 0,
    };

    // Perform KNN classification
    let k = 3;
    let predicted_label = classify(&training_data, &test_point, k);

    // Print the predicted label
    println!("Predicted label: {}", predicted_label);
}
