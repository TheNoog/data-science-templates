const std = @import("std");

// Structure to represent a data point
const DataPoint = struct {
    x: f64,
    y: f64,
    label: i32,
};

// Function to calculate Euclidean distance between two data points
fn calculateDistance(p1: DataPoint, p2: DataPoint) f64 {
    var dx: f64 = p2.x - p1.x;
    var dy: f64 = p2.y - p1.y;
    return std.math.sqrt(dx * dx + dy * dy);
}

// Function to perform KNN classification
fn classify(trainingData: []DataPoint, testPoint: DataPoint, k: usize) i32 {
    // Calculate distances to all training data points
    var distances: [trainingData.len]f64 = undefined;
    for (trainingData) |dataPoint, i| {
        distances[i] = calculateDistance(dataPoint, testPoint);
    }

    // Sort the distances in ascending order
    std.sort.f64s(distances[0..trainingData.len]);

    // Count the occurrences of each label among the k nearest neighbors
    var labelCount: [0]std.HashMap(i32, u32) = undefined;
    for (distances[0..k]) |distance, _| {
        var index: usize = distances.find(distance).?;
        var label: i32 = trainingData[index].label;
        _ = labelCount.getOrInsert(label) catch |err| {
            err | std.HashMapError.Alloc => std.log.err("HashMap allocation failed"),
        };
        labelCount[label] += 1;
    }

    // Return the label with the highest count
    var maxCount: u32 = 0;
    var predictedLabel: i32 = -1;
    for (labelCount) |_, count| {
        if (count > maxCount) {
            maxCount = count;
            predictedLabel = _;
        }
    }

    return predictedLabel;
}

pub fn main() !void {
    const trainingData: []DataPoint = &[
        DataPoint { .x = 2.0, .y = 4.0, .label = 0 },
        DataPoint { .x = 4.0, .y = 6.0, .label = 0 },
        DataPoint { .x = 4.0, .y = 8.0, .label = 1 },
        DataPoint { .x = 6.0, .y = 4.0, .label = 1 },
        DataPoint { .x = 6.0, .y = 6.0, .label = 1 },
    ];

    const testPoint: DataPoint = DataPoint { .x = 5.0, .y = 5.0, .label = 0 };

    // Perform KNN classification
    const k: usize = 3;
    const predictedLabel: i32 = try classify(trainingData, testPoint, k);

    // Print the predicted label
    std.debug.print("Predicted label: {}\n", .{predictedLabel});
}
