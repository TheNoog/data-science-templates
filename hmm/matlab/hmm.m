function forwardAlgorithm(observations, initialProb, transitionProb, emissionProb)
    numObservations = length(observations);
    alpha = zeros(numObservations, NUM_STATES);

    % Initialize alpha values for the first observation
    for state = 1:NUM_STATES
        alpha(1, state) = initialProb(state) * emissionProb(state, observations(1));
    end

    % Recursion: compute alpha values for subsequent observations
    for t = 2:numObservations
        for state = 1:NUM_STATES
            alpha(t, state) = sum(alpha(t-1, :) .* transitionProb(:, state)') * emissionProb(state, observations(t));
        end
    end

    % Compute the probability of the observations
    prob = sum(alpha(numObservations, :));

    % Print the probability of the observations
    fprintf('Probability of the observations: %f\n', prob);
end

NUM_STATES = 2;
NUM_OBSERVATIONS = 3;

observations = [0, 1, 2];

initialProb = [0.8, 0.2];

transitionProb = [
    0.7, 0.3;
    0.4, 0.6
];

emissionProb = [
    0.2, 0.3, 0.5;
    0.6, 0.3, 0.1
];

forwardAlgorithm(observations, initialProb, transitionProb, emissionProb);
