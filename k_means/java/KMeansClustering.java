import java.util.ArrayList;
import java.util.List;
import java.util.Random;

record Point(double x, double y) {}

record Cluster(Point centroid, int numPoints) {}

public class KMeansClustering {
    private static final int K = 3; // Number of clusters
    private static final int MAX_ITERATIONS = 100;

    private static double distance(Point p1, Point p2) {
        return Math.sqrt(Math.pow(p2.x() - p1.x(), 2) + Math.pow(p2.y() - p1.y(), 2));
    }

    private static List<Point> initializeCentroids(List<Point> dataPoints) {
        List<Point> centroids = new ArrayList<>();
        Random random = new Random();

        for (int i = 0; i < K; i++) {
            int randomIndex = random.nextInt(dataPoints.size());
            centroids.add(dataPoints.get(randomIndex));
        }

        return centroids;
    }

    private static void assignPointsToCentroids(List<Point> dataPoints, List<Cluster> clusters) {
        for (Point dataPoint : dataPoints) {
            double minDistance = distance(dataPoint, clusters.get(0).centroid());
            int clusterIndex = 0;

            for (int j = 1; j < K; j++) {
                double currDistance = distance(dataPoint, clusters.get(j).centroid());
                if (currDistance < minDistance) {
                    minDistance = currDistance;
                    clusterIndex = j;
                }
            }

            Cluster updatedCluster = clusters.get(clusterIndex);
            clusters.set(clusterIndex, new Cluster(updatedCluster.centroid(), updatedCluster.numPoints() + 1));
        }
    }

    private static void updateCentroids(List<Point> dataPoints, List<Cluster> clusters) {
        for (Cluster cluster : clusters) {
            double sumX = 0.0, sumY = 0.0;
            int numPoints = cluster.numPoints();

            for (Point dataPoint : dataPoints) {
                sumX += dataPoint.x();
                sumY += dataPoint.y();
            }

            Point centroid = new Point(sumX / numPoints, sumY / numPoints);
            clusters.set(clusters.indexOf(cluster), new Cluster(centroid, numPoints));
        }
    }

    private static List<Cluster> kMeans(List<Point> dataPoints) {
        List<Point> centroids = initializeCentroids(dataPoints);
        List<Cluster> clusters = new ArrayList<>();

        for (Point centroid : centroids) {
            clusters.add(new Cluster(centroid, 0));
        }

        int iteration = 0;
        while (iteration < MAX_ITERATIONS) {
            assignPointsToCentroids(dataPoints, clusters);
            updateCentroids(dataPoints, clusters);
            iteration++;
        }

        return clusters;
    }

    public static void main(String[] args) {
        List<Point> dataPoints = new ArrayList<>();
        dataPoints.add(new Point(2.0, 3.0));
        dataPoints.add(new Point(2.5, 4.5));
        dataPoints.add(new Point(1.5, 2.5));
        dataPoints.add(new Point(6.0, 5.0));
        dataPoints.add(new Point(7.0, 7.0));
        dataPoints.add(new Point(5.0, 5.5));
        dataPoints.add(new Point(9.0, 2.0));
        dataPoints.add(new Point(10.0, 3.5));
        dataPoints.add(new Point(9.5, 2.5));

        List<Cluster> clusters = kMeans(dataPoints);

        for (int i = 0; i < K; i++) {
            Cluster cluster = clusters.get(i);
            System.out.printf("Cluster %d: Centroid (%.2f, %.2f), Points: %d%n",
                    i + 1, cluster.centroid().x(), cluster.centroid().y(), cluster.numPoints());
        }
    }
}