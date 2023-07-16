# Define the number of samples and features
N_SAMPLES = 100
N_FEATURES = 20

# Function to calculate the mean squared error
def calculate_mean_squared_error(y_true, y_pred)
  n = y_true.length
  mse = y_true.zip(y_pred).map { |y, y_pred| (y - y_pred)**2 }.sum / n.to_f
end

# Function to perform LASSO regression
def lasso_regression(X, y, alpha)
  # Maximum number of iterations for coordinate descent
  max_iterations = 100

  # Step size for coordinate descent
  step_size = 0.01

  n_samples = X.length
  n_features = X[0].length

  # Initialize the coefficients to zero
  coefficients = [0.0] * n_features

  # Perform coordinate descent
  max_iterations.times do
    n_features.times do |j|
      # Calculate the gradient for feature j
      gradient = 0.0
      n_samples.times do |i|
        pred = 0.0
        n_features.times do |k|
          pred += X[i][k] * coefficients[k] if k != j
        end
        gradient += (y[i] - pred) * X[i][j]
      end

      # Update the coefficient using LASSO penalty
      if gradient > alpha
        coefficients[j] = (gradient - alpha) * step_size
      elsif gradient < -alpha
        coefficients[j] = (gradient + alpha) * step_size
      else
        coefficients[j] = 0.0
      end
    end
  end

  coefficients
end

# Generate some synthetic data
def generate_synthetic_data
  X = Array.new(N_SAMPLES) { Array.new(N_FEATURES) { rand } }
  y = Array.new(N_SAMPLES) do |i|
    X[i].each_with_index.map { |x, j| x * (j + 1) }.sum + 0.1 * rand
  end
  [X, y]
end

# Main function
def main
  # Generate some synthetic data
  X, y = generate_synthetic_data

  # Split the data into training and test sets
  n_train_samples = (N_SAMPLES * 0.8).to_i
  n_test_samples = N_SAMPLES - n_train_samples
  X_train, y_train = X[0, n_train_samples], y[0, n_train_samples]
  X_test, y_test = X[n_train_samples..-1], y[n_train_samples..-1]

  # Perform LASSO regression
  alpha = 0.1
  coefficients = lasso_regression(X_train, y_train, alpha)

  # Make predictions on the test set
  y_pred = X_test.map { |sample| sample.zip(coefficients).map { |x, c| x * c }.sum }

  # Calculate the mean squared error
  mse = calculate_mean_squared_error(y_test, y_pred)
  puts "Mean Squared Error: #{mse}"

  # Print the true coefficients and the estimated coefficients
  puts "True Coefficients: [1.0 #{(2..N_FEATURES).to_a.join(' ')}]"
  puts "Estimated Coefficients: #{coefficients}"
end

main
