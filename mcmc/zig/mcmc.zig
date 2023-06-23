const std = @import("std");
const rand = std.math.random;
const io = std.io;

// Target probability distribution: a mixture of two Gaussian distributions
fn targetDistribution(x: f64) f64 {
    const gaussian1 = 0.3 * (-0.2 * (x - 10.0).mul(x - 10.0)).exp();
    const gaussian2 = 0.7 * (-0.2 * (x + 10.0).mul(x + 10.0)).exp();
    return gaussian1 + gaussian2;
}

// Metropolis-Hastings algorithm for MCMC sampling
fn metropolisHastings(target: fn(f64) f64, numSamples: usize, initialState: f64, proposalStd: f64) [numSamples]f64 {
    var currentState: f64 = initialState;
    var accepted: usize = 0;
    var samples: [numSamples]f64 = undefined;

    var rng = std.rand.DefaultPrng.init(std.time.currentTime());

    for (samples) |_, sample| {
        // Generate a proposal state from a normal distribution
        const proposal = currentState + proposalStd * rng.nextGaussian();

        // Calculate the acceptance probability
        const acceptanceProb = target(proposal) / target(currentState);

        // Accept or reject the proposal
        if (rng.nextFloat64() < acceptanceProb) {
            currentState = proposal;
            accepted += 1;
        }

        // Save the current state as a sample
        sample = currentState;
    }

    const acceptanceRate = f64(accepted) / f64(numSamples);
    std.log.warn("Acceptance rate: {}\n", .{acceptanceRate});

    return samples;
}

pub fn main() !void {
    // Define parameters for MCMC sampling
    const numSamples: usize = 10000;
    const initialState: f64 = 0.0;
    const proposalStd: f64 = 5.0;

    // Run MCMC sampling using Metropolis-Hastings algorithm
    const samples = metropolisHastings(targetDistribution, numSamples, initialState, proposalStd);

    // Print the sampled distribution
    for (samples) |sample| {
        io.stdout.print("{f}\n", .{sample});
    }
}
