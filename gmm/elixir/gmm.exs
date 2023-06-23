defmodule GaussianMixtureModelExample do
  @n_samples 500
  @n_components 2

  def run do
    # Generate data from the first Gaussian distribution
    data1 = generate_data([0, 0], [[1, 0], [0, 1]], @n_samples div 2)

    # Generate data from the second Gaussian distribution
    data2 = generate_data([3, 3], [[1, 0], [0, 1]], @n_samples div 2)

    # Combine the data from both distributions
    data = data1 ++ data2

    # Fit the Gaussian Mixture Model
    gmm = GMM.train(data, @n_components)

    # Retrieve the GMM parameters
    weights = GMM.weights(gmm)
    means = GMM.means(gmm)
    covs = GMM.covariances(gmm)

    # Print the results
    IO.puts("Weights:")
    Enum.each(weights, &IO.write("#{&1} "))
    IO.puts("")

    IO.puts("\nMeans:")
    Enum.each(means, fn mean -> IO.puts("#{elem(mean, 0)} #{elem(mean, 1)}") end)

    IO.puts("\nCovariances:")
    Enum.each(covs, fn cov -> IO.puts("#{elem(elem(cov, 0), 0)} #{elem(elem(cov, 0), 1)}") end)
  end

  defp generate_data(mean, cov, n) do
    {:ok, pid} = :rand.uniform()
    {:ok, samples} = :rand.multivariate_normal(mean, cov, n, pid)
    samples
  end
end

GaussianMixtureModelExample.run()
