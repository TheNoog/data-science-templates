function forward_algorithm(observations, initial_prob, transition_prob, emission_prob)
    num_observations = length(observations)
    alpha = zeros(num_observations, NUM_STATES)

    # Initialize alpha values for the first observation
    for state = 1:NUM_STATES
        alpha[1, state] = initial_prob[state] * emission_prob[state, observations[1]]
    end

    # Recursion: compute alpha values for subsequent observations
    for t = 2:num_observations
        for state = 1:NUM_STATES
            alpha[t, state] = sum(alpha[t-1, :] .* transition_prob[:, state]) * emission_prob[state, observations[t]]
        end
    end

    # Compute the probability of the observations
    prob = sum(alpha[num_observations, :])

    # Print the probability of the observations
    println("Probability of the observations: ", prob)
end

const NUM_STATES = 2
const NUM_OBSERVATIONS = 3

observations = [0, 1, 2]

initial_prob = [0.8, 0.2]

transition_prob = [
    0.7 0.3;
    0.4 0.6
]

emission_prob = [
    0.2 0.3 0.5;
    0.6 0.3 0.1
]

forward_algorithm(observations, initial_prob, transition_prob, emission_prob)
