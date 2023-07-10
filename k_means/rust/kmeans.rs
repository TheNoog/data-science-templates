use rand::seq::SliceRandom;
use rand::thread_rng;
use std::f64;

#[derive(Clone, Copy)]
struct Point {
    x: f64,
    y: f64,
}

impl Point {
    fn new(x: f64, y: f64) -> Self {
        Point { x, y }
    }
}

struct Cluster {
    centroid: Point,
    num_points: u32,
}

impl Cluster {
    fn new(centroid: Point) -> Self {
        Cluster {
            centroid,
            num_points: 0,
        }
    }
}

fn distance(p1: Point, p2: Point) -> f64 {
    ((p2.x - p1.x).powi(2) + (p2.y - p1.y).powi(2)).sqrt()
}

fn initialize_centroids(data_points: &[Point], k: usize) -> Vec<Point> {
    let mut rng = thread_rng();
    let mut centroids: Vec<Point> = data_points
        .choose_multiple(&mut rng, k)
        .cloned()
        .collect();
    centroids
}

fn assign_points_to_centroids(data_points: &[Point], clusters: &mut Vec<Cluster>) {
    for point in data_points {
        let mut min_distance = f64::MAX;
        let mut cluster_index = 0;
        for (j, cluster) in clusters.iter().enumerate() {
            let curr_distance = distance(*point, cluster.centroid);
            if curr_distance < min_distance {
                min_distance = curr_distance;
                cluster_index = j;
            }
        }
        clusters[cluster_index].num_points += 1;
    }
}

fn update_centroids(data_points: &[Point], clusters: &mut Vec<Cluster>) {
    for cluster in clusters.iter_mut() {
        let mut sum_x = 0.0;
        let mut sum_y = 0.0;
        let num_points = cluster.num_points as f64;

        for point in data_points {
            sum_x += point.x;
            sum_y += point.y;
        }

        cluster.centroid.x = sum_x / num_points;
        cluster.centroid.y = sum_y / num_points;
    }
}

fn k_means(data_points: &[Point], k: usize) -> Vec<Cluster> {
    let mut clusters: Vec<Cluster> = initialize_centroids(data_points, k)
        .into_iter()
        .map(Cluster::new)
        .collect();

    let max_iterations = 100;
    let mut iteration = 0;

    while iteration < max_iterations {
        assign_points_to_centroids(data_points, &mut clusters);
        update_centroids(data_points, &mut clusters);
        iteration += 1;
    }

    clusters
}

fn main() {
    let data_points = [
        Point::new(2.0, 3.0),
        Point::new(2.5, 4.5),
        Point::new(1.5, 2.5),
        Point::new(6.0, 5.0),
        Point::new(7.0, 7.0),
        Point::new(5.0, 5.5),
        Point::new(9.0, 2.0),
        Point::new(10.0, 3.5),
        Point::new(9.5, 2.5),
    ];

    let k = 3;

    let clusters = k_means(&data_points, k);

    for (i, cluster) in clusters.iter().enumerate() {
        println!(
            "Cluster {}: Centroid ({:.2}, {:.2}), Points: {}",
            i + 1,
            cluster.centroid.x,
            cluster.centroid.y,
            cluster.num_points
        );
    }
}