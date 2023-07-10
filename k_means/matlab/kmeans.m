classdef Point
    properties
        x
        y
    end
    
    methods
        function obj = Point(x, y)
            obj.x = x;
            obj.y = y;
        end
    end
end

classdef Cluster
    properties
        centroid
        numPoints
    end
    
    methods
        function obj = Cluster(centroid)
            obj.centroid = centroid;
            obj.numPoints = 0;
        end
    end
end

function dist = distance(p1, p2)
    dist = sqrt((p2.x - p1.x)^2 + (p2.y - p1.y)^2);
end

function centroids = initializeCentroids(dataPoints, k)
    centroids = Point.empty;
    for i = 1:k
        randomIndex = randi(length(dataPoints));
        centroids(i) = dataPoints(randomIndex);
    end
end

function assignPointsToCentroids(dataPoints, clusters)
    for i = 1:length(dataPoints)
        minDistance = distance(dataPoints(i), clusters(1).centroid);
        clusterIndex = 1;
        
        for j = 2:length(clusters)
            currDistance = distance(dataPoints(i), clusters(j).centroid);
            if currDistance < minDistance
                minDistance = currDistance;
                clusterIndex = j;
            end
        end
        
        clusters(clusterIndex).numPoints = clusters(clusterIndex).numPoints + 1;
    end
end

function updateCentroids(dataPoints, clusters)
    for i = 1:length(clusters)
        sumX = 0.0;
        sumY = 0.0;
        numPoints = clusters(i).numPoints;
        
        for j = 1:length(dataPoints)
            sumX = sumX + dataPoints(j).x;
            sumY = sumY + dataPoints(j).y;
        end
        
        clusters(i).centroid.x = sumX / numPoints;
        clusters(i).centroid.y = sumY / numPoints;
    end
end

function clusters = kMeans(dataPoints, k)
    clusters = Cluster.empty;
    for i = 1:k
        clusters(i) = Cluster(Point(0, 0));
    end
    
    iteration = 0;
    maxIterations = 100;
    while iteration < maxIterations
        assignPointsToCentroids(dataPoints, clusters);
        updateCentroids(dataPoints, clusters);
        iteration = iteration + 1;
    end
end

dataPoints = [Point(2.0, 3.0), Point(2.5, 4.5), Point(1.5, 2.5), Point(6.0, 5.0), Point(7.0, 7.0), Point(5.0, 5.5), Point(9.0, 2.0), Point(10.0, 3.5), Point(9.5, 2.5)];
k = 3;

clusters = kMeans(dataPoints, k);

for i = 1:length(clusters)
    fprintf("Cluster %d: Centroid (%.2f, %.2f), Points: %d\n", i, clusters(i).centroid.x, clusters(i).centroid.y, clusters(i).numPoints);
end