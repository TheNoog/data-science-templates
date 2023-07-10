class Point
    attr_accessor :x, :y
  
    def initialize(x, y)
      @x = x
      @y = y
    end
  end
  
  class Cluster
    attr_accessor :centroid, :num_points
  
    def initialize(centroid)
      @centroid = centroid
      @num_points = 0
    end
  end
  
  def distance(p1, p2)
    Math.sqrt((p2.x - p1.x)**2 + (p2.y - p1.y)**2)
  end
  
  def initialize_centroids(data_points, k)
    centroids = []
    random_indices = data_points.sample(k)
    random_indices.each { |index| centroids << data_points[index] }
    centroids
  end
  
  def assign_points_to_centroids(data_points, clusters)
    data_points.each do |point|
      min_distance = distance(point, clusters[0].centroid)
      cluster_index = 0
      (1...clusters.length).each do |j|
        curr_distance = distance(point, clusters[j].centroid)
        if curr_distance < min_distance
          min_distance = curr_distance
          cluster_index = j
        end
      end
      clusters[cluster_index].num_points += 1
    end
  end
  
  def update_centroids(data_points, clusters)
    clusters.each do |cluster|
      sum_x = sum_y = 0.0
      num_points = cluster.num_points
      data_points.each do |point|
        sum_x += point.x
        sum_y += point.y
      end
      cluster.centroid.x = sum_x / num_points
      cluster.centroid.y = sum_y / num_points
    end
  end
  
  def k_means(data_points, k)
    clusters = initialize_centroids(data_points, k).map { |centroid| Cluster.new(centroid) }
    max_iterations = 100
    iteration = 0
    while iteration < max_iterations
      assign_points_to_centroids(data_points, clusters)
      update_centroids(data_points, clusters)
      iteration += 1
    end
    clusters
  end
  
  data_points = [
    Point.new(2.0, 3.0),
    Point.new(2.5, 4.5),
    Point.new(1.5, 2.5),
    Point.new(6.0, 5.0),
    Point.new(7.0, 7.0),
    Point.new(5.0, 5.5),
    Point.new(9.0, 2.0),
    Point.new(10.0, 3.5),
    Point.new(9.5, 2.5)
  ]
  
  k = 3
  
  clusters = k_means(data_points, k)
  
  clusters.each_with_index do |cluster, i|
    puts "Cluster #{i + 1}: Centroid (#{cluster.centroid.x}, #{cluster.centroid.y}), Points: #{cluster.num_points}"
  end
  