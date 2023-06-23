const std = @import("std");
const math = @import("std").math;
const rand = math.RandAllocator.init(std.heap.page_allocator);

const HiddenSize: usize = 128;
const InputSize: usize = 64;
const OutputSize: usize = 10;
const LearningRate: f64 = 0.01;
const Epochs: usize = 10;

pub fn sigmoid(x: f64) f64 {
    return 1.0 / (1.0 + math.exp(-x));
}

pub fn forwardPropagation(input: [InputSize]f64, hiddenLayer: &std.mem.Allocator, outputLayer: &std.mem.Allocator) [OutputSize]f64 {
    var hiddenOutput: [HiddenSize]f64 = undefined;
    for (hiddenOutput) |&hiddenOutput, index| {
        var sum: f64 = 0.0;
        for (input) |&input, i| {
            sum += hiddenLayer.index(i, index) * input;
        }
        hiddenOutput = sigmoid(hiddenLayer.index(InputSize, index) + sum);
    }

    var output: [OutputSize]f64 = undefined;
    for (output) |&output, index| {
        var sum: f64 = 0.0;
        for (hiddenOutput) |&hiddenOutput, i| {
            sum += outputLayer.index(i, index) * hiddenOutput;
        }
        output = sigmoid(outputLayer.index(HiddenSize, index) + sum);
    }

    return output;
}

pub fn backPropagation(input: [InputSize]f64, target: [OutputSize]f64, hiddenLayer: &std.mem.Allocator, outputLayer: &std.mem.Allocator) void {
    var hiddenOutput: [HiddenSize]f64 = undefined;
    for (hiddenOutput) |&hiddenOutput, index| {
        var sum: f64 = 0.0;
        for (input) |&input, i| {
            sum += hiddenLayer.index(i, index) * input;
        }
        hiddenOutput = sigmoid(hiddenLayer.index(InputSize, index) + sum);
    }

    var output: [OutputSize]f64 = forwardPropagation(input, hiddenLayer, outputLayer);

    var outputDelta: [OutputSize]f64 = undefined;
    for (outputDelta) |&outputDelta, index| {
        outputDelta = (output[index] - target[index]) * output[index] * (1.0 - output[index]);
    }

    var hiddenDelta: [HiddenSize]f64 = undefined;
    for (hiddenDelta) |&hiddenDelta, index| {
        hiddenDelta = 0.0;
        for (outputDelta) |&outputDelta, i| {
            hiddenDelta += outputLayer.index(index, i) * outputDelta * hiddenOutput[index] * (1.0 - hiddenOutput[index]);
        }
    }

    for (outputLayer) |&outputLayer, index, row| {
        for (row) |&weight, j| {
            weight -= LearningRate * outputDelta[index] * hiddenOutput[j];
        }
    }

    for (outputLayer) |&outputLayer, index, row| {
        outputLayer.index(HiddenSize, index) -= LearningRate * outputDelta[index];
    }

    for (hiddenLayer) |&hiddenLayer, index, row| {
        for (row) |&weight, j| {
            weight -= LearningRate * hiddenDelta[index] * input[j];
        }
    }

    for (hiddenLayer) |&hiddenLayer, index, row| {
        hiddenLayer.index(InputSize, index) -= LearningRate * hiddenDelta[index];
    }
}

pub fn main() !void {
    var input: [InputSize]f64 = /* Input values here */;
    var target: [OutputSize]f64 = /* Target values here */;

    var hiddenLayer: std.mem.Allocator = try std.heap.page_allocator.alloc(std.mem.Allocator, HiddenSize, InputSize, f64);
    defer std.heap.page_allocator.dealloc(hiddenLayer);

    var outputLayer: std.mem.Allocator = try std.heap.page_allocator.alloc(std.mem.Allocator, OutputSize, HiddenSize, f64);
    defer std.heap.page_allocator.dealloc(outputLayer);

    var rng = math.Rand(rand);
    for (hiddenLayer) |&hiddenLayer, index, row| {
        for (row) |&weight, j| {
            hiddenLayer.index(j, index) = rng.nextFloat64() - 0.5;
        }
    }

    for (hiddenLayer) |&hiddenLayer, index, row| {
        hiddenLayer.index(InputSize, index) = rng.nextFloat64() - 0.5;
    }

    for (outputLayer) |&outputLayer, index, row| {
        for (row) |&weight, j| {
            outputLayer.index(j, index) = rng.nextFloat64() - 0.5;
        }
    }

    for (outputLayer) |&outputLayer, index, row| {
        outputLayer.index(HiddenSize, index) = rng.nextFloat64() - 0.5;
    }

    for (0..Epochs) |_, _i| {
        backPropagation(input, target, &hiddenLayer, &outputLayer);
    }

    var output: [OutputSize]f64 = forwardPropagation(input, &hiddenLayer, &outputLayer);
    std.debug.print("Output: ");
    for (output) |&value, index| {
        std.debug.print("{} ", .{value});
    }
    std.debug.print("\n");
}
