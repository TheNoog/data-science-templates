import random
import math

class Point:
    def __init__(self, x, y):
        self.x = x
        self.y = y

class Cluster:
    def __init__(self, centroid):
        self.centroid = centroid
        self.num_points = 0

def distance(p1, p2):
    return math.sqrt((p2.x - p1.x) ** 2 + (p2.y - p1.y) ** 2)

def initialize_centroids(data_points, k):
    centroids = []
    random_indices = random.sample(range(len(data_points)), k)
    for index in random_indices:
        centroids.append(data_points[index])
    return centroids

def assign_points_to_centroids(data_points, clusters):
    for point in data_points:
        min_distance = distance(point, clusters[0].centroid)
        cluster_index = 0
        for j in range(1, len(clusters)):
            curr_distance = distance(point, clusters[j].centroid)
            if curr_distance < min_distance:
                min_distance = curr_distance
                cluster_index = j
        clusters[cluster_index].num_points += 1

def update_centroids(data_points, clusters):
    for cluster in clusters:
        sum_x = sum_y = 0.0
        num_points = cluster.num_points
        for point in data_points:
            sum_x += point.x
            sum_y += point.y
        cluster.centroid.x = sum_x / num_points
        cluster.centroid.y = sum_y / num_points

def k_means(data_points, k):
    clusters = []
    for centroid in initialize_centroids(data_points, k):
        clusters.append(Cluster(centroid))

    max_iterations = 100
    iteration = 0
    while iteration < max_iterations:
        assign_points_to_centroids(data_points, clusters)
        update_centroids(data_points, clusters)
        iteration += 1

    return clusters

data_points = [
    Point(2.0, 3.0),
    Point(2.5, 4.5),
    Point(1.5, 2.5),
    Point(6.0, 5.0),
    Point(7.0, 7.0),
    Point(5.0, 5.5),
    Point(9.0, 2.0),
    Point(10.0, 3.5),
    Point(9.5, 2.5)
]

k = 3

clusters = k_means(data_points, k)

for i, cluster in enumerate(clusters):
    print(f"Cluster {i+1}: Centroid ({cluster.centroid.x}, {cluster.centroid.y}), Points: {cluster.num_points}")