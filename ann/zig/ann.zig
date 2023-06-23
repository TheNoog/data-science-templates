const std = @import("std");
const math = @import("std").math;
const Allocator = std.mem.Allocator;

// Define the neural network structure
const inputSize: usize = 2;
const hiddenSize: usize = 4;
const outputSize: usize = 1;
const learningRate: f32 = 0.1;
const epochs: usize = 1000;

var Allocator = std.heap.page_allocator;
const Allocator = std.heap.page_allocator;
const Vector = std.Vector;
const HashMap = std.HashMap;

pub fn sigmoid(x: f32) f32 {
    return 1.0 / (1.0 + math.exp(-x));
}

pub fn sigmoidDerivative(x: f32) f32 {
    const sigmoidValue = sigmoid(x);
    return sigmoidValue * (1.0 - sigmoidValue);
}

pub fn forwardPropagate(inputs: []f32, weights: [][]f32, biases: []f32) f32 {
    var hiddenLayer: [hiddenSize]f32 = undefined;
    var output: f32 = 0.0;

    // Calculate hidden layer activations
    for (hiddenIndex, _) |hiddenLayerValue| {
        hiddenLayer[hiddenIndex] = sigmoid(
            std.math.dotProduct(inputs, weights[hiddenIndex]) + biases[hiddenIndex]
        );
    }

    // Calculate output
    output = sigmoid(std.math.dotProduct(hiddenLayer[:], weights[hiddenSize]) + biases[hiddenSize]);

    return output;
}

pub fn backPropagate(inputs: []f32, expectedOutput: f32, weights: [][]f32, biases: []f32,
                     weightDeltas: [][]f32, biasDeltas: []f32) void {
    var hiddenLayer: [hiddenSize]f32 = undefined;
    var output: f32 = 0.0;
    var outputDelta: f32 = 0.0;

    // Calculate hidden layer activations
    for (hiddenIndex, _) |hiddenLayerValue| {
        hiddenLayer[hiddenIndex] = sigmoid(
            std.math.dotProduct(inputs, weights[hiddenIndex]) + biases[hiddenIndex]
        );
    }

    // Calculate output
    output = sigmoid(std.math.dotProduct(hiddenLayer[:], weights[hiddenSize]) + biases[hiddenSize]);

    // Calculate output delta
    outputDelta = (expectedOutput - output) * sigmoidDerivative(output);

    // Calculate hidden layer deltas
    for (hiddenIndex, _) |hiddenDelta| {
        hiddenDelta = sigmoidDerivative(hiddenLayer[hiddenIndex]) *
            std.math.dotProduct(weights[hiddenIndex][:], &outputDelta);
    }

    // Update weight and bias deltas
    for (hiddenIndex, _) |hiddenDelta| {
        for (weightIndex, _) |weightDelta| {
            weightDelta = learningRate * hiddenDelta * inputs[weightIndex];
            weightDeltas[hiddenIndex][weightIndex] += weightDelta;
        }
        biasDeltas[hiddenIndex] += learningRate * hiddenDelta;
    }

    for (weightIndex, _) |weightDelta| {
        weightDelta = learningRate * outputDelta * hiddenLayer[weightIndex];
        weightDeltas[hiddenSize][weightIndex] += weightDelta;
    }
    biasDeltas[hiddenSize] += learningRate * outputDelta;
}

pub fn updateWeights(weights: [][]f32, weightDeltas: [][]f32, biases: []f32, biasDeltas: []f32) void {
    for (hiddenIndex, _) |hiddenDelta| {
        for (weightIndex, _) |weightDelta| {
            weights[hiddenIndex][weightIndex] += weightDelta;
        }
        biases[hiddenIndex] += biasDeltas[hiddenIndex];
    }
    for (weightIndex, _) |weightDelta| {
        weights[hiddenSize][weightIndex] += weightDelta;
    }
    biases[hiddenSize] += biasDeltas[hiddenSize];
}

pub fn main() !void {
    var allocator = Allocator.init(std.heap.page_allocator);
    defer allocator.deinit();

    // Training data
    const trainingData = [
        { .inputs = [0.0, 0.0], .output = 0.0 },
        { .inputs = [0.0, 1.0], .output = 1.0 },
        { .inputs = [1.0, 0.0], .output = 1.0 },
        { .inputs = [1.0, 1.0], .output = 0.0 },
    ];

    // Initialize weights and biases
    var weights: [][]f32 = allocator.allocSlice([]f32{0.0}).{null};
    defer weights.deinit();
    weights = weights.resize(hiddenSize + 1);
    for (weights[hiddenIndex], weightIndex) |weight| {
        weight = allocator.allocSlice([]f32{0.0}).{null};
        defer weight.deinit();
        weight = weight.resize(inputSize);
        for (weight, _) |value, weightIndex| {
            value = std.rand.nextFloat32(0.0, 1.0);
        }
    }

    var biases: []f32 = allocator.allocSlice([]f32{0.0}).{null};
    defer biases.deinit();
    biases = biases.resize(hiddenSize + 1);
    for (biases, _) |bias| {
        bias = std.rand.nextFloat32(0.0, 1.0);
    }

    // Training loop
    for (0 .. epochs) |epoch| {
        var weightDeltas: [][]f32 = allocator.allocSlice([]f32{0.0}).{null};
        defer weightDeltas.deinit();
        weightDeltas = weightDeltas.resize(hiddenSize + 1);
        for (weightDeltas[hiddenIndex], _) |weightDelta| {
            weightDelta = allocator.allocSlice([]f32{0.0}).{null};
            defer weightDelta.deinit();
            weightDelta = weightDelta.resize(inputSize);
        }

        var biasDeltas: []f32 = allocator.allocSlice([]f32{0.0}).{null};
        defer biasDeltas.deinit();
        biasDeltas = biasDeltas.resize(hiddenSize + 1);

        // Train on each training data point
        for (trainingData) |data| {
            backPropagate(data.inputs, data.output, weights, biases, weightDeltas, biasDeltas);
        }

        updateWeights(weights, weightDeltas, biases, biasDeltas);
    }

    // Test the trained neural network
    for (trainingData) |data| {
        const output = forwardPropagate(data.inputs, weights, biases);
        std.log.info("Input: {}, Expected Output: {}, Predicted Output: {}", .{data.inputs, data.output, output});
    }

    return .{};
}
