defmodule LinearRegression do
  def calculate_mean(list) do
    Enum.sum(list) / length(list)
  end

  def calculate_slope(x, y) do
    mean_x = calculate_mean(x)
    mean_y = calculate_mean(y)
    numerator = Enum.zip(x, y) |> Enum.reduce(0, fn {xi, yi}, acc -> acc + (xi - mean_x) * (yi - mean_y) end)
    denominator = Enum.reduce(x, 0, fn xi, acc -> acc + (xi - mean_x) * (xi - mean_x) end)
    numerator / denominator
  end

  def calculate_intercept(x, y, slope) do
    mean_x = calculate_mean(x)
    mean_y = calculate_mean(y)
    mean_y - slope * mean_x
  end

  def predict(x, slope, intercept) do
    slope * x + intercept
  end
end

x = [1, 2, 3, 4, 5]  # Input features
y = [2, 4, 5, 4, 6]  # Target variable

slope = LinearRegression.calculate_slope(x, y)
intercept = LinearRegression.calculate_intercept(x, y, slope)

new_x = [6, 7]

IO.puts "Input\tPredicted Output"
Enum.each(new_x, fn x ->
  y_pred = LinearRegression.predict(x, slope, intercept)
  IO.puts "#{x}\t#{y_pred}"
end)
