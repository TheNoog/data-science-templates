const std = @import("std");

fn calculateMean(list: []f64) f64 {
    var sum: f64 = 0.0;
    for (list) |value| {
        sum += value;
    }
    return sum / f64(list.len);
}

fn calculateSlope(x: []f64, y: []f64) f64 {
    var meanX = calculateMean(x);
    var meanY = calculateMean(y);
    var numerator: f64 = 0.0;
    var denominator: f64 = 0.0;
    for (x) |xi, idx| {
        numerator += (xi - meanX) * (y[idx] - meanY);
        denominator += (xi - meanX) * (xi - meanX);
    }
    return numerator / denominator;
}

fn calculateIntercept(x: []f64, y: []f64, slope: f64) f64 {
    var meanX = calculateMean(x);
    var meanY = calculateMean(y);
    return meanY - slope * meanX;
}

fn predict(x: f64, slope: f64, intercept: f64) f64 {
    return slope * x + intercept;
}

pub fn main() !void {
    var x: [5]f64 = [1.0, 2.0, 3.0, 4.0, 5.0];  // Input features
    var y: [5]f64 = [2.0, 4.0, 5.0, 4.0, 6.0];  // Target variable

    var slope = calculateSlope(x, y);
    var intercept = calculateIntercept(x, y, slope);

    var newX: [2]f64 = [6.0, 7.0];

    std.debug.print("Input\tPredicted Output\n");
    for (newX) |xVal| {
        var yPred = predict(xVal, slope, intercept);
        std.debug.print("{:.1}\t{:.2}\n", .{xVal, yPred});
    }
}
