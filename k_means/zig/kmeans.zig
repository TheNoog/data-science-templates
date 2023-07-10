const std = @import("std");
const math = @import("std").math;

const Point = struct {
    x: f64,
    y: f64,
};

const Cluster = struct {
    centroid: Point,
    numPoints: u32,
};

fn distance(p1: Point, p2: Point) f64 {
    return math.sqrt(math.pow(p2.x - p1.x, 2.0) + math.pow(p2.y - p1.y, 2.0));
}

fn initializeCentroids(dataPoints: []Point, k: usize) [k]Point {
    var rng = std.rand.Rng.init(std.time.milli());
    var centroids: [k]Point = undefined;
    var indices: [k]usize = undefined;
    for (centroids) |centroid, i| {
        const randomIndex = rng.next() % dataPoints.len();
        centroids[i] = dataPoints[randomIndex];
        indices[i] = randomIndex;
    }
    return centroids;
}

fn assignPointsToCentroids(dataPoints: []Point, clusters: []Cluster) void {
    for (dataPoints) |point| {
        var minDistance = distance(point, clusters[0].centroid);
        var clusterIndex: usize = 0;
        for (clusters[1..]) |_, i| {
            const currDistance = distance(point, clusters[i].centroid);
            if (currDistance < minDistance) {
                minDistance = currDistance;
                clusterIndex = i;
            }
        }
        clusters[clusterIndex].numPoints += 1;
    }
}

fn updateCentroids(dataPoints: []Point, clusters: []Cluster) void {
    for (clusters) |cluster| {
        var sumX: f64 = 0.0;
        var sumY: f64 = 0.0;
        const numPoints: f64 = f64(cluster.numPoints);

        for (dataPoints) |point| {
            sumX += point.x;
            sumY += point.y;
        }

        cluster.centroid.x = sumX / numPoints;
        cluster.centroid.y = sumY / numPoints;
    }
}

pub fn kMeans(dataPoints: []Point, k: usize) [k]Cluster {
    const centroids = initializeCentroids(dataPoints, k);
    var clusters: [k]Cluster = undefined;
    for (clusters) |cluster, i| {
        cluster.centroid = centroids[i];
        cluster.numPoints = 0;
    }

    const maxIterations = 100;
    var iteration: usize = 0;
    while (iteration < maxIterations) {
        assignPointsToCentroids(dataPoints, clusters);
        updateCentroids(dataPoints, clusters);
        iteration += 1;
    }

    return clusters;
}

pub fn main() !void {
    const dataPoints: [9]Point = [
        Point{x: 2.0, y: 3.0},
        Point{x: 2.5, y: 4.5},
        Point{x: 1.5, y: 2.5},
        Point{x: 6.0, y: 5.0},
        Point{x: 7.0, y: 7.0},
        Point{x: 5.0, y: 5.5},
        Point{x: 9.0, y: 2.0},
        Point{x: 10.0, y: 3.5},
        Point{x: 9.5, y: 2.5},
    ];

    const k: usize = 3;

    const clusters = kMeans(dataPoints, k);

    for (clusters) |cluster, i| {
        std.debug.print("Cluster {}, Centroid ({}, {}), Points: {}\n",
            .{i + 1, cluster.centroid.x, cluster.centroid.y, cluster.numPoints});
    }
}