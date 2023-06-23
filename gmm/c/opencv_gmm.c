#include <stdio.h>
#include <stdlib.h>
#include <opencv2/opencv.hpp>

#define N_SAMPLES 500
#define N_COMPONENTS 2

int main()
{
    cv::Mat data(N_SAMPLES, 2, CV_64FC1);

    // Generate data from the first Gaussian distribution
    cv::Mat mean1 = (cv::Mat_<double>(1, 2) << 0, 0);
    cv::Mat cov1 = (cv::Mat_<double>(2, 2) << 1, 0, 0, 1);
    cv::randn(data(cv::Range(0, N_SAMPLES / 2), cv::Range::all()), mean1, cov1);

    // Generate data from the second Gaussian distribution
    cv::Mat mean2 = (cv::Mat_<double>(1, 2) << 3, 3);
    cv::Mat cov2 = (cv::Mat_<double>(2, 2) << 1, 0, 0, 1);
    cv::randn(data(cv::Range(N_SAMPLES / 2, N_SAMPLES), cv::Range::all()), mean2, cov2);

    // Reshape the data for GMM fitting
    cv::Mat reshapedData = data.reshape(1, N_SAMPLES);

    // Fit the Gaussian Mixture Model
    cv::Ptr<cv::ml::EM> gmm = cv::ml::EM::create();
    gmm->setClustersNumber(N_COMPONENTS);
    gmm->trainEM(reshapedData);

    // Retrieve the GMM parameters
    cv::Mat weights, means, covs;
    gmm->getWeights(weights);
    gmm->getMeans(means);
    gmm->getCovs(covs);

    // Print the results
    printf("Weights:\n");
    for (int i = 0; i < N_COMPONENTS; ++i)
    {
        printf("%f ", weights.at<double>(i));
    }
    printf("\n");

    printf("\nMeans:\n");
    for (int i = 0; i < N_COMPONENTS; ++i)
    {
        printf("%f %f\n", means.at<double>(i, 0), means.at<double>(i, 1));
    }
    printf("\n");

    printf("Covariances:\n");
    for (int i = 0; i < N_COMPONENTS; ++i)
    {
        printf("%f %f\n", covs.at<double>(i, 0), covs.at<double>(i, 1));
    }

    return 0;
}
