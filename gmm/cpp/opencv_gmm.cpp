#include <iostream>
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
    std::cout << "Weights:" << std::endl;
    for (int i = 0; i < N_COMPONENTS; ++i)
    {
        std::cout << weights.at<double>(i) << " ";
    }
    std::cout << std::endl;

    std::cout << "Means:" << std::endl;
    for (int i = 0; i < N_COMPONENTS; ++i)
    {
        std::cout << means.at<double>(i, 0) << " " << means.at<double>(i, 1) << std::endl;
    }
    std::cout << std::endl;

    std::cout << "Covariances:" << std::endl;
    for (int i = 0; i < N_COMPONENTS; ++i)
    {
        std::cout << covs.at<cv::Vec2d>(i, 0)[0] << " " << covs.at<cv::Vec2d>(i, 0)[1] << std::endl;
    }

    return 0;
}
