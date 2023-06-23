defmodule NaiveBayes do
  @num_classes 3
  @num_features 4

  defstruct features: [], label: nil

  def load_dataset do
    # Load the dataset
    dataset = []

    # Your code to load the data from a file or any other source goes here
    # Append each data point as a NaiveBayes struct to the dataset list

    dataset
  end

  def train_naive_bayes(dataset) do
    num_data_points = length(dataset)
    class_counts = Enum.map(0..@num_classes-1, fn _ -> 0 end)
    priors = Enum.map(0..@num_classes-1, fn _ -> 0.0 end)
    likelihoods = Enum.map(0..@num_classes-1, fn _ -> Enum.map(0..@num_features-1, fn _ -> 0.0 end) end)

    # Count the occurrences of each class label
    Enum.each(dataset, fn data_point ->
      class_counts = update_in(class_counts, [data_point.label], &(&1 + 1))
    end)

    # Calculate priors
    Enum.each(0..@num_classes-1, fn i ->
      priors = update_in(priors, [i], fn _ -> class_counts[i] / num_data_points end)
    end)

    # Calculate likelihoods
    Enum.each(0..@num_classes-1, fn i ->
      Enum.each(0..@num_features-1, fn j ->
        {feature_sum, feature_count} = Enum.reduce(dataset, {0.0, 0}, fn data_point, {sum, count} ->
          if data_point.label == i do
            {sum + List.nth(data_point.features, j), count + 1}
          else
            {sum, count}
          end
        end)

        likelihoods = update_in(likelihoods, [i, j], fn _ -> feature_sum / feature_count end)
      end)
    end)

    {priors, likelihoods}
  end

  def predict(data_point, priors, likelihoods) do
    max_posterior = 0.0
    predicted_class = nil

    Enum.each(0..@num_classes-1, fn i ->
      posterior = Enum.reduce(0..@num_features-1, priors[i], fn j, acc ->
        acc * :math.exp(-(data_point.features[j] - likelihoods[i][j])^2 / 2)
      end)

      if posterior > max_posterior do
        max_posterior = posterior
        predicted_class = i
      end
    end)

    predicted_class
  end

  def main do
    dataset = load_dataset()
    {priors, likelihoods} = train_naive_bayes(dataset)

    # Example usage: Predict the class label for a new data point
    new_data_point = %NaiveBayes{features: [5.1, 3.5, 1.4, 0.2]}

    predicted_label = predict(new_data_point, priors, likelihoods)
    IO.puts("Predicted Label: #{predicted_label}")
  end
end

NaiveBayes.main()
