#include <stdio.h>
#include <stdlib.h>

#define NUM_STATES 2
#define NUM_OBSERVATIONS 3

void forward_algorithm(int observations[], int num_observations, double initial_prob[], double transition_prob[][NUM_STATES], double emission_prob[][NUM_OBSERVATIONS]) {
    double alpha[num_observations][NUM_STATES];

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
    printf("Probability of the observations: %f\n", prob);
}

int main() {
    int observations[] = {0, 1, 2};
    int num_observations = sizeof(observations) / sizeof(observations[0]);

    double initial_prob[NUM_STATES] = {0.8, 0.2};

    double transition_prob[NUM_STATES][NUM_STATES] = {
        {0.7, 0.3},
        {0.4, 0.6}
    };

    double emission_prob[NUM_STATES][NUM_OBSERVATIONS] = {
        {0.2, 0.3, 0.5},
        {0.6, 0.3, 0.1}
    };

    forward_algorithm(observations, num_observations, initial_prob, transition_prob, emission_prob);

    return 0;
}
