defmodule PCA do
  def pca(data) do
    # Standardize the data.
    mean = data.mean(axis=1)
    std = data.std(axis=1)
    data = data - mean
    data = data / std

    # Calculate the covariance matrix.
    covariance_matrix = data.dot(data, transpose=true) / (data.n - 1)

    # Calculate the eigenvalues and eigenvectors of the covariance matrix.
    eigenvalues, eigenvectors = covariance_matrix.eig()

    # Sort the eigenvalues and eigenvectors in descending order.
    eigenvalues, eigenvectors = eigenvalues |> Enum.sort_by(fn x -> -x end), eigenvectors |> Enum.sort_by(fn x -> -x end)

    # Return the principal components.
    eigenvectors
  end
end
