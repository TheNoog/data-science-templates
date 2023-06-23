extern crate csv;
extern crate rustlearn;

use csv::ReaderBuilder;
use rustlearn::prelude::*;
use rustlearn::trees::decision_tree::{DecisionTree, Hyperparameters};
use std::fs::File;

fn main() {
    // Load the dataset (Iris dataset as an example)
    let file = File::open("iris.csv").unwrap();
    let mut reader = ReaderBuilder::new().has_header(true).from_reader(file);

    let mut X = Vec::<SparseRow>::new();
    let mut y = Vec::<usize>::new();

    for result in reader.records() {
        let record = result.unwrap();
        let features: Vec<f32> = record.iter().take(4).map(|x| x.parse().unwrap()).collect();
        let label: usize = record[4].parse().unwrap();

        X.push(SparseRow::new((), features));
        y.push(label);
    }

    // Split the dataset into training and testing sets
    let (X_train, X_test, y_train, y_test) = train_test_split(&X, &y, 0.2);

    // Create a decision tree classifier
    let mut tree = DecisionTree::new(Hyperparameters::new(4));

    // Train the classifier on the training data
    tree.fit(&X_train, &y_train).unwrap();

    // Make predictions on the test data
    let y_pred = tree.predict(&X_test).unwrap();

    // Calculate the accuracy of the model
    let accuracy = accuracy_score(&y_test, &y_pred);
    println!("Accuracy: {}", accuracy);
}

fn train_test_split<T>(
    X: &[SparseRow<T>],
    y: &[usize],
    test_size: f32,
) -> (Vec<SparseRow<T>>, Vec<SparseRow<T>>, Vec<usize>, Vec<usize>) {
    let test_size = (X.len() as f32 * test_size) as usize;
    let X_train = X[..X.len() - test_size].to_vec();
    let X_test = X[X.len() - test_size..].to_vec();
    let y_train = y[..y.len() - test_size].to_vec();
    let y_test = y[y.len() - test_size..].to_vec();
    (X_train, X_test, y_train, y_test)
}

fn accuracy_score(y_true: &[usize], y_pred: &[usize]) -> f32 {
    assert_eq!(y_true.len(), y_pred.len());
    let correct: usize = y_true
        .iter()
        .zip(y_pred.iter())
        .map(|(&a, &b)| (a == b) as usize)
        .sum();
    correct as f32 / y_true.len() as f32
}
