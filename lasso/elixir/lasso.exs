defmodule LassoRegression do
  # Define the number of samples and features
  @n_samples 100
  @n_features 20

  # Function to calculate the mean squared error
  def calculate_mean_squared_error(y_true, y_pred) do
    n = length(y_true)
    mse = Enum.reduce(y_true, 0, fn (y, acc) -> acc + (y - hd(y_pred)) * (y - hd(y_pred)) end)
    mse / n
  end

  # Function to perform LASSO regression
  def lasso_regression(X, y, alpha) do
    # Maximum number of iterations for coordinate descent
    max_iterations = 100
    
    # Step size for coordinate descent
    step_size = 0.01

    n_samples = length(X)
    n_features = length(hd(X))

    # Initialize the coefficients to zero
    coefficients = Enum.map(1..n_features, fn _ -> 0.0 end)

    # Perform coordinate descent
    Enum.reduce(1..max_iterations, coefficients, fn _, coeffs ->
      Enum.reduce(1..n_features, coeffs, fn j, acc_coeffs ->
        # Calculate the gradient for feature j
        gradient = Enum.reduce(1..n_samples, 0.0, fn i, acc ->
          pred = Enum.reduce(1..n_features, 0.0, fn k, pred_acc ->
            if k != j, do: pred_acc + List.at(List.at(X, i - 1), k - 1) * List.at(acc_coeffs, k - 1), else: pred_acc
          end)
          acc + (List.at(y, i - 1) - pred) * List.at(List.at(X, i - 1), j - 1)
        end)

        # Update the coefficient using LASSO penalty
        new_coeff = if gradient > alpha, do: (gradient - alpha) * step_size,
                    else: if gradient < -alpha, do: (gradient + alpha) * step_size, else: 0.0

        List.replace_at(acc_coeffs, j - 1, new_coeff)
      end)
    end)
  end
end

# Generate some synthetic data
defmodule LassoRegressionExample do
  def generate_synthetic_data(n_samples, n_features) do
    {X, y} =
      Enum.reduce(1..n_samples, {[], []}, fn _sample, {acc_X, acc_y} ->
        random_values = Enum.map(1..n_features, &Float.random/1.0)
        X_new = [random_values | acc_X]
        y_new = Enum.reduce(random_values, 0.0, &(&1 + &2)) + 0.1 * Float.random() | acc_y
        {X_new, y_new}
      end)

    {Enum.reverse(X), Enum.reverse(y)}
  end
end

# Split the data into training and test sets
{X, y} = LassoRegressionExample.generate_synthetic_data(@n_samples, @n_features)
n_train_samples = round(@n_samples * 0.8)
n_test_samples = @n_samples - n_train_samples
X_train = Enum.take(X, n_train_samples)
y_train = Enum.take(y, n_train_samples)
X_test = Enum.drop(X, n_train_samples)
y_test = Enum.drop(y, n_train_samples)

# Perform LASSO regression
alpha = 0.1
coefficients = LassoRegression.lasso_regression(X_train, y_train, alpha)

# Make predictions on the test set
y_pred = Enum.map(X_test, fn sample ->
  Enum.zip(sample, coefficients)
  |> Enum.reduce(0.0, fn {x, coeff}, acc -> acc + x * coeff end)
end)

# Calculate the mean squared error
mse = LassoRegression.calculate_mean_squared_error(y_test, y_pred)
IO.puts("Mean Squared Error: #{mse}")

# Print the true coefficients and the estimated coefficients
IO.puts("True Coefficients: #{inspect(Enum.reverse([1.0 | List.duplicate(0.0, @n_features - 1)]))}")
IO.puts("Estimated Coefficients: #{inspect(Enum.reverse(coefficients))}")
