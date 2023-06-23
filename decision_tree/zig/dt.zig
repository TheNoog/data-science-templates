const std = @import("std");
const csv = std.encoding.csv;
const DecisionTree = @import("decision_tree");

pub fn main() !void {
    // Load the dataset (Iris dataset as an example)
    const irisData = try std.fs.cwd().openFile("iris.csv", .{ .read = true });
    defer irisData.close();

    var csvReader = csv.Reader.init(irisData.reader());
    const header = try csvReader.next();
    var irisRows = []std.ArrayList(u8).init(std.heap.page_allocator);

    while (try csvReader.next()) |row| {
        const sepalLength = std.fmt.parseFloat(row[0]) catch unreachable;
        const sepalWidth = std.fmt.parseFloat(row[1]) catch unreachable;
        const petalLength = std.fmt.parseFloat(row[2]) catch unreachable;
        const petalWidth = std.fmt.parseFloat(row[3]) catch unreachable;
        const species = std.fmt.parseEnum("Species", row[4]) catch unreachable;

        var rowData = std.ArrayList(u8).init(std.heap.page_allocator);
        try rowData.appendAll(u8, &[_]u8{ sepalLength, sepalWidth, petalLength, petalWidth });
        irisRows.append(rowData);
    }

    const splitRatio: f32 = 0.8;
    const splitIndex = @divTrunc(irisRows.len, 1.0 / splitRatio);
    const trainingData = irisRows[0..splitIndex];
    const testingData = irisRows[splitIndex..];

    // Create a decision tree classifier
    var tree = DecisionTree.ID3Tree.init(4);

    // Train the classifier on the training data
    for (trainingData) |rowData, _index| {
        const features = rowData.items;
        const label = std.fmt.parseEnum(u8, "Species", header.items[4]) catch unreachable;
        try tree.train(features, label);
    }

    // Make predictions on the test data
    var predictions = []std.ArrayList(u8).init(std.heap.page_allocator);
    for (testingData) |rowData, _index| {
        const features = rowData.items;
        const prediction = try tree.predict(features);
        predictions.append(prediction);
    }

    // Calculate the accuracy of the model
    const accuracy = accuracyScore(predictions, testingData);
    std.log.info("Accuracy: {}", .{accuracy});
}

fn accuracyScore(predictions: []std.ArrayList(u8), testData: []std.ArrayList(u8)) f32 {
    var correctPredictions: u32 = 0;
    const n = predictions.len;
    for (predictions) |prediction, index| {
        const actual = testData[index].items[4];
        if (prediction.items[0] == actual) {
            correctPredictions += 1;
        }
    }

    return f32(correctPredictions) / f32(n);
}
