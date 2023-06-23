use rand::Rng;

// Target probability distribution: a mixture of two Gaussian distributions
fn target_distribution(x: f64) -> f64 {
    let gaussian1 = 0.3 * (-0.2 * (x - 10.0).powi(2)).exp();
    let gaussian2 = 0.7 * (-0.2 * (x + 10.0).powi(2)).exp();
    gaussian1 + gaussian2
}

// Metropolis-Hastings algorithm for MCMC sampling
fn metropolis_hastings(target: fn(f64) -> f64, num_samples: usize, initial_state: f64, proposal_std: f64) -> Vec<f64> {
    let mut current_state = initial_state;
    let mut accepted = 0;
    let mut samples = Vec::with_capacity(num_samples);

    let mut rng = rand::thread_rng();

    for _ in 0..num_samples {
        // Generate a proposal state from a normal distribution
        let proposal = current_state + proposal_std * rng.gen::<f64>() * 2.0 - proposal_std;

        // Calculate the acceptance probability
        let acceptance_prob = f64::min(1.0, target(proposal) / target(current_state));

        // Accept or reject the proposal
        if rng.gen::<f64>() < acceptance_prob {
            current_state = proposal;
            accepted += 1;
        }

        // Save the current state as a sample
        samples.push(current_state);
    }

    let acceptance_rate = accepted as f64 / num_samples as f64;
    println!("Acceptance rate: {:.4}", acceptance_rate);
    samples
}

fn main() {
    // Define parameters for MCMC sampling
    let num_samples = 10000;
    let initial_state = 0.0;
    let proposal_std = 5.0;

    // Run MCMC sampling using Metropolis-Hastings algorithm
    let samples = metropolis_hastings(target_distribution, num_samples, initial_state, proposal_std);

    // Print the sampled distribution
    for sample in samples {
        println!("{}", sample);
    }
}
