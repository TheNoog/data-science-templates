struct Point
    x::Float64
    y::Float64
end

struct Cluster
    centroid::Point
    numPoints::Int64
end

function distance(p1::Point, p2::Point)
    return sqrt((p2.x - p1.x)^2 + (p2.y - p1.y)^2)
end

function initializeCentroids(dataPoints, k)
    centroids = Point[]
    for _ in 1:k
        randomIndex = rand(1:length(dataPoints))
        push!(centroids, dataPoints[randomIndex])
    end
    return centroids
end

function assignPointsToCentroids(dataPoints, clusters)
    for point in dataPoints
        minDistance = distance(point, clusters[1].centroid)
        clusterIndex = 1

        for j in 2:length(clusters)
            currDistance = distance(point, clusters[j].centroid)
            if currDistance < minDistance
                minDistance = currDistance
                clusterIndex = j
            end
        end

        clusters[clusterIndex].numPoints += 1
    end
end

function updateCentroids(dataPoints, clusters)
    for cluster in clusters
        sumX = 0.0
        sumY = 0.0
        numPoints = cluster.numPoints

        for point in dataPoints
            sumX += point.x
            sumY += point.y
        end

        cluster.centroid.x = sumX / numPoints
        cluster.centroid.y = sumY / numPoints
    end
end

function kMeans(dataPoints, k)
    clusters = Cluster[]
    for centroid in initializeCentroids(dataPoints, k)
        push!(clusters, Cluster(centroid, 0))
    end

    iteration = 0
    while iteration < 100
        assignPointsToCentroids(dataPoints, clusters)
        updateCentroids(dataPoints, clusters)
        iteration += 1
    end

    return clusters
end

dataPoints = [Point(2.0, 3.0),
              Point(2.5, 4.5),
              Point(1.5, 2.5),
              Point(6.0, 5.0),
              Point(7.0, 7.0),
              Point(5.0, 5.5),
              Point(9.0, 2.0),
              Point(10.0, 3.5),
              Point(9.5, 2.5)]

clusters = kMeans(dataPoints, 3)

for (i, cluster) in enumerate(clusters)
    println("Cluster $i: Centroid (${cluster.centroid.x}, ${cluster.centroid.y}), Points: ${cluster.numPoints}")
end