defmodule KMeansClustering do
  defstruct point: {0, 0}, centroid: {0, 0}, num_points: 0

  def distance({x1, y1}, {x2, y2}) do
    :math.sqrt(:math.pow(x2 - x1, 2) + :math.pow(y2 - y1, 2))
  end

  def initialize_centroids(data_points, k) do
    Enum.map(1..k, fn _ -> %KMeansClustering{} end)
    |> Enum.map(fn cluster ->
      random_index = Enum.random(0..(length(data_points) - 1))
      %{cluster | centroid: List.to_tuple(Enum.at(data_points, random_index))}
    end)
  end

  def assign_points_to_centroids(data_points, clusters) do
    Enum.reduce(data_points, clusters, fn point, acc ->
      min_distance = distance(point, acc.head.centroid)
      {_, cluster_index} = Enum.reduce_with_index(acc.tail, {min_distance, 0}, fn cluster, {curr_distance, idx} ->
        new_distance = distance(point, cluster.centroid)
        if new_distance < curr_distance, do: {new_distance, idx}, else: {curr_distance, idx + 1}
      end)

      updated_cluster = acc[cluster_index]
      %{updated_cluster | num_points: updated_cluster.num_points + 1} ++ acc -- [updated_cluster]
    end)
  end

  def update_centroids(data_points, clusters) do
    Enum.map(clusters, fn cluster ->
      num_points = cluster.num_points
      sum_x = Enum.reduce(data_points, 0, fn {x, _}, acc -> acc + x end)
      sum_y = Enum.reduce(data_points, 0, fn {_, y}, acc -> acc + y end)

      %{cluster | centroid: {sum_x / num_points, sum_y / num_points}}
    end)
  end

  def k_means(data_points, k, max_iterations \\ 100) do
    clusters = initialize_centroids(data_points, k)
    iterate_k_means(data_points, clusters, max_iterations)
  end

  defp iterate_k_means(data_points, clusters, iterations) when iterations <= 0 do
    clusters
  end

  defp iterate_k_means(data_points, clusters, iterations) do
    assigned_clusters = assign_points_to_centroids(data_points, clusters)
    updated_centroids = update_centroids(data_points, assigned_clusters)

    iterate_k_means(data_points, updated_centroids, iterations - 1)
  end

  def run_k_means(data_points, k) do
    final_clusters = k_means(data_points, k)
    Enum.each(final_clusters, fn %{centroid: centroid, num_points: num_points} ->
      IO.puts "Cluster: Centroid (#{inspect centroid}), Points: #{num_points}"
    end)
  end
end

# Sample data points
data_points = [
  {2.0, 3.0},
  {2.5, 4.5},
  {1.5, 2.5},
  {6.0, 5.0},
  {7.0, 7.0},
  {5.0, 5.5},
  {9.0, 2.0},
  {10.0, 3.5},
  {9.5, 2.5}
]

# Perform K-means clustering
KMeansClustering.run_k_means(data_points, 3)