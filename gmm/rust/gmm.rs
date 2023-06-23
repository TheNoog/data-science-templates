extern crate statrs;
extern crate rand;

use statrs::distribution::{Normal, Distribution};
use statrs::statistics::Statistics;
use statrs::cluster::GaussianMixtureModel;
use rand::prelude::*;

const NSAMPLES: usize = 500;
const NCOMPONENTS: usize = 2;

fn main() {
    let mut rng = thread_rng();

    // Generate data from the first Gaussian distribution
    let dist1 = Normal::new(0.0, 1.0).unwrap();
    let data1: Vec<[f64; 2]> = (0..NSAMPLES/2)
        .map(|_| [dist1.sample(&mut rng), dist1.sample(&mut rng)])
        .collect();

    // Generate data from the second Gaussian distribution
    let dist2 = Normal::new(3.0, 1.0).unwrap();
    let data2: Vec<[f64; 2]> = (0..NSAMPLES/2)
        .map(|_| [dist2.sample(&mut rng), dist2.sample(&mut rng)])
        .collect();

    // Combine the data from both distributions
    let mut data = Vec::with_capacity(NSAMPLES);
    data.extend(data1);
    data.extend(data2);

    // Fit the Gaussian Mixture Model
    let gmm = GaussianMixtureModel::new(NCOMPONENTS);
    gmm.fit(&data).unwrap();

    // Retrieve the GMM parameters
    let weights = gmm.weights();
    let means = gmm.means();
    let covariances = gmm.covariances();

    // Print the results
    println!("Weights:");
    for weight in weights.iter() {
        println!("{:.4}", weight);
    }

    println!("\nMeans:");
    for mean in means.iter() {
        println!("{:.4} {:.4}", mean[0], mean[1]);
    }

    println!("\nCovariances:");
    for covariance in covariances.iter() {
        println!("{:.4} {:.4}", covariance[0][0], covariance[0][1]);
    }
}
