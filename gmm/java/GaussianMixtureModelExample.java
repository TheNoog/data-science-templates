package gmm.java;

import org.apache.commons.math4.distribution.MultivariateNormalDistribution;
import org.apache.commons.math4.fitting.gauss.GaussianMixture;
import org.apache.commons.math4.fitting.gauss.GaussianMixtureExpectationMaximization;
import org.apache.commons.math4.util.Pair;

public class GaussianMixtureModelExample {
    private static final int N_SAMPLES = 500;
    private static final int N_COMPONENTS = 2;

    public static void main(String[] args) {
        // Generate data from the first Gaussian distribution
        MultivariateNormalDistribution g1 = new MultivariateNormalDistribution(new double[]{0, 0},
                new double[][]{{1, 0}, {0, 1}});
        double[][] data1 = g1.sample(N_SAMPLES / 2);

        // Generate data from the second Gaussian distribution
        MultivariateNormalDistribution g2 = new MultivariateNormalDistribution(new double[]{3, 3},
                new double[][]{{1, 0}, {0, 1}});
        double[][] data2 = g2.sample(N_SAMPLES / 2);

        // Combine the data from both distributions
        double[][] data = new double[N_SAMPLES][];
        System.arraycopy(data1, 0, data, 0, data1.length);
        System.arraycopy(data2, 0, data, data1.length, data2.length);

        // Fit the Gaussian Mixture Model
        GaussianMixtureExpectationMaximization em = new GaussianMixtureExpectationMaximization(N_COMPONENTS);
        GaussianMixture gmm = em.fit(data);

        // Retrieve the GMM parameters
        double[] weights = gmm.getWeights();
        double[][] means = gmm.getMeans();
        double[][][] covariances = gmm.getCovariances();

        // Print the results
        System.out.println("Weights:");
        for (double weight : weights) {
            System.out.print(weight + " ");
        }
        System.out.println();

        System.out.println("\nMeans:");
        for (double[] mean : means) {
            System.out.println(mean[0] + " " + mean[1]);
        }
        System.out.println();

        System.out.println("Covariances:");
        for (double[][] covariance : covariances) {
            System.out.println(covariance[0][0] + " " + covariance[0][1]);
        }
    }
}
