% Target probability distribution: a mixture of two Gaussian distributions
function p = targetDistribution(x)
    gaussian1 = 0.3 * exp(-0.2 * (x - 10).^2);
    gaussian2 = 0.7 * exp(-0.2 * (x + 10).^2);
    p = gaussian1 + gaussian2;
end

% Metropolis-Hastings algorithm for MCMC sampling
function samples = metropolisHastings(target, numSamples, initialState, proposalStd)
    currentState = initialState;
    accepted = 0;
    samples = zeros(1, numSamples);
    
    for i = 1:numSamples
        % Generate a proposal state from a normal distribution
        proposal = currentState + proposalStd * randn();
        
        % Calculate the acceptance probability
        acceptanceProb = min(1, target(proposal) / target(currentState));
        
        % Accept or reject the proposal
        if rand() < acceptanceProb
            currentState = proposal;
            accepted = accepted + 1;
        end
        
        % Save the current state as a sample
        samples(i) = currentState;
    end
    
    acceptanceRate = accepted / numSamples;
    fprintf('Acceptance rate: %.4f\n', acceptanceRate);
end

% Define parameters for MCMC sampling
numSamples = 10000;
initialState = 0.0;
proposalStd = 5.0;

% Run MCMC sampling using Metropolis-Hastings algorithm
samples = metropolisHastings(@targetDistribution, numSamples, initialState, proposalStd);

% Plot the sampled distribution
histogram(samples, 'Normalization', 'pdf');
xlabel('x');
ylabel('Probability Density');
title('Sampled Distribution');
