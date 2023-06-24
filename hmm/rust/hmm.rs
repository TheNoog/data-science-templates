fn forward_algorithm(observations: &[usize], initial_prob: &[f64], transition_prob: &[Vec<f64>], emission_prob: &[Vec<f64>]) {
    let num_observations = observations.len();
    let num_states = initial_prob.len();
    let mut alpha = vec![vec![0.0; num_states]; num_observations];

    // Initialize alpha values for the first observation
    for state in 0..num_states {
        alpha[0][state] = initial_prob[state] * emission_prob[state][observations[0]];
    }

    // Recursion: compute alpha values for subsequent observations
    for t in 1..num_observations {
        for state in 0..num_states {
            alpha[t][state] = (0..num_states)
                .map(|prev_state| alpha[t-1][prev_state] * transition_prob[prev_state][state])
                .sum::<f64>() * emission_prob[state][observations[t]];
        }
    }

    // Compute the probability of the observations
    let prob = alpha[num_observations - 1].iter().sum::<f64>();

    // Print the probability of the observations
    println!("Probability of the observations: {}", prob);
}

fn main() {
    const NUM_STATES: usize = 2;
    const NUM_OBSERVATIONS: usize = 3;

    let observations = vec![0, 1, 2];

    let initial_prob = vec![0.8, 0.2];

    let transition_prob = vec![
        vec![0.7, 0.3],
        vec![0.4, 0.6],
    ];

    let emission_prob = vec![
        vec![0.2, 0.3, 0.5],
        vec![0.6, 0.3, 0.1],
    ];

    forward_algorithm(&observations, &initial_prob, &transition_prob, &emission_prob);
}
