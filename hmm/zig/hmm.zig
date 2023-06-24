const std = @import("std");

fn forwardAlgorithm(observations: []usize, initialProb: []f64, transitionProb: [][]f64, emissionProb: [][]f64) void {
    const numObservations: usize = observations.len;
    const numStates: usize = initialProb.len;
    var alpha: [][numStates]f64 = undefined;

    // Initialize alpha values for the first observation
    for (state := 0; state < numStates; state += 1) {
        alpha[0][state] = initialProb[state] * emissionProb[state][observations[0]];
    }

    // Recursion: compute alpha values for subsequent observations
    for (t := 1; t < numObservations; t += 1) {
        for (state := 0; state < numStates; state += 1) {
            alpha[t][state] = 0.0;
            for (prev := 0; prev < numStates; prev += 1) {
                alpha[t][state] += alpha[t - 1][prev] * transitionProb[prev][state];
            }
            alpha[t][state] *= emissionProb[state][observations[t]];
        }
    }

    // Compute the probability of the observations
    var prob: f64 = 0.0;
    for (state := 0; state < numStates; state += 1) {
        prob += alpha[numObservations - 1][state];
    }

    // Print the probability of the observations
    std.debug.print("Probability of the observations: {}\n", .{prob});
}

pub fn main() !void {
    const NUM_STATES: usize = 2;
    const NUM_OBSERVATIONS: usize = 3;

    const observations: [NUM_OBSERVATIONS]usize = [0, 1, 2];

    const initialProb: [NUM_STATES]f64 = [0.8, 0.2];

    const transitionProb: [NUM_STATES][NUM_STATES]f64 = [
        [0.7, 0.3],
        [0.4, 0.6],
    ];

    const emissionProb: [NUM_STATES][NUM_OBSERVATIONS]f64 = [
        [0.2, 0.3, 0.5],
        [0.6, 0.3, 0.1],
    ];

    try forwardAlgorithm(observations, initialProb, transitionProb, emissionProb);
    return;
}
