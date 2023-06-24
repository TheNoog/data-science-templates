#include <iostream>
#include <vector>

#define NUM_STATES 2
#define NUM_OBSERVATIONS 3

void forward_algorithm(const std::vector<int>& observations, const std::vector<double>& initial_prob, const std::vector<std::vector<double>>& transition_prob, const std::vector<std::vector<double>>& emission_prob) {
    int num_observations = observations.size();
    std::vector<std::vector<double>> alpha(num_observations, std::vector<double>(NUM_STATES));

    // Initialize alpha values for the first observation
    for (int state = 0; state < NUM_STATES; state++) {
        alpha[0][state] = initial_prob[state] * emission_prob[state][observations[0]];
    }

    // Recursion: compute alpha values for subsequent observations
    for (int t = 1; t < num_observations; t++) {
        for (int state = 0; state < NUM_STATES; state++) {
            alpha[t][state] = 0.0;
            for (int prev_state = 0; prev_state < NUM_STATES; prev_state++) {
                alpha[t][state] += alpha[t-1][prev_state] * transition_prob[prev_state][state];
            }
            alpha[t][state] *= emission_prob[state][observations[t]];
        }
    }

    // Compute the probability of the observations
    double prob = 0.0;
    for (int state = 0; state < NUM_STATES; state++) {
        prob += alpha[num_observations-1][state];
    }

    // Print the probability of the observations
    std::cout << "Probability of the observations: " << prob << std::endl;
}

int main() {
    std::vector<int> observations = {0, 1, 2};

    std::vector<double> initial_prob = {0.8, 0.2};

    std::vector<std::vector<double>> transition_prob = {
        {0.7, 0.3},
        {0.4, 0.6}
    };

    std::vector<std::vector<double>> emission_prob = {
        {0.2, 0.3, 0.5},
        {0.6, 0.3, 0.1}
    };

    forward_algorithm(observations, initial_prob, transition_prob, emission_prob);

    return 0;
}
