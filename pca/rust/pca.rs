use ml_rust::linear_algebra::pca::PCA;
use ml_rust::linear_algebra::dense_matrix::DenseMatrix;

fn main() {
  // Load the data.
  let data = vec![
    DenseMatrix::new(3, 1, vec![1.0, 2.0, 3.0]),
    DenseMatrix::new(3, 1, vec![4.0, 5.0, 6.0]),
    DenseMatrix::new(3, 1, vec![7.0, 8.0, 9.0]),
  ];

  // Create a PCA model with 2 principal components.
  let pca = PCA::new(2);

  // Fit the model to the data.
  let pca = pca.fit(&data);

  // Transform the data.
  let transformed_data = pca.transform(&data);

  // Print the principal components.
  println!("{:?}", transformed_data);

  // Tune the PCA parameters.
  let parameters = PCAParameters {
    n_components: 2..4,
  };

  let analysis = RayTune::tune(
    pca,
    parameters,
    num_samples: 3,
  );

  // Get the best PCA model.
  let best_pca = analysis.best_config().unwrap().pca;

  // Print the best PCA model's parameters.
  println!("{:?}", best_pca);
}

struct PCAParameters {
  n_components: RangeInclusive<usize>,
}
