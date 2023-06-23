#include <stdio.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include <gsl/gsl_statistics.h>
#include <gsl/gsl_fit.h>
#include <gsl/gsl_multifit.h>

#define N_SAMPLES 500
#define N_COMPONENTS 2

int main()
{
    gsl_rng* rng = gsl_rng_alloc(gsl_rng_default);
    gsl_rng_set(rng, 0);

    double data[N_SAMPLES][2];

    // Generate data from the first Gaussian distribution
    double mean1[2] = {0, 0};
    double cov1[2][2] = {{1, 0}, {0, 1}};
    for (int i = 0; i < N_SAMPLES / 2; ++i)
    {
        gsl_ran_multivariate_gaussian(rng, mean1, cov1, &data[i][0], &data[i][1]);
    }

    // Generate data from the second Gaussian distribution
    double mean2[2] = {3, 3};
    double cov2[2][2] = {{1, 0}, {0, 1}};
    for (int i = N_SAMPLES / 2; i < N_SAMPLES; ++i)
    {
        gsl_ran_multivariate_gaussian(rng, mean2, cov2, &data[i][0], &data[i][1]);
    }

    gsl_rng_free(rng);

    // Fit the Gaussian Mixture Model
    gsl_matrix* samples = gsl_matrix_alloc(N_SAMPLES, 2);
    for (int i = 0; i < N_SAMPLES; ++i)
    {
        gsl_matrix_set(samples, i, 0, data[i][0]);
        gsl_matrix_set(samples, i, 1, data[i][1]);
    }

    gsl_vector* weights = gsl_vector_alloc(N_COMPONENTS);
    gsl_matrix* means = gsl_matrix_alloc(N_COMPONENTS, 2);
    gsl_matrix* covs = gsl_matrix_alloc(N_COMPONENTS, 2);
    gsl_multifit_linear_workspace* workspace = gsl_multifit_linear_alloc(N_SAMPLES, 2);

    gsl_multifit_linear(samples, weights, means, covs, workspace);

    // Print the results
    printf("Weights:\n");
    gsl_vector_fprintf(stdout, weights, "%g");

    printf("\nMeans:\n");
    gsl_matrix_fprintf(stdout, means, "%g");

    printf("\nCovariances:\n");
    gsl_matrix_fprintf(stdout, covs, "%g");

    gsl_matrix_free(samples);
    gsl_vector_free(weights);
    gsl_matrix_free(means);
    gsl_matrix_free(covs);
    gsl_multifit_linear_free(workspace);

    return 0;
}
