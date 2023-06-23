# Function to calculate the mean
def calculate_mean(list)
    list.reduce(:+) / list.length.to_f
  end
  
  # Function to calculate the slope (beta1)
  def calculate_slope(x, y)
    mean_x = calculate_mean(x)
    mean_y = calculate_mean(y)
    numerator = x.zip(y).reduce(0) { |acc, (xi, yi)| acc + (xi - mean_x) * (yi - mean_y) }
    denominator = x.reduce(0) { |acc, xi| acc + (xi - mean_x) ** 2 }
    numerator / denominator
  end
  
  # Function to calculate the intercept (beta0)
  def calculate_intercept(x, y, slope)
    mean_x = calculate_mean(x)
    mean_y = calculate_mean(y)
    mean_y - slope * mean_x
  end
  
  # Function to make predictions
  def predict(x, slope, intercept)
    slope * x + intercept
  end
  
  x = [1, 2, 3, 4, 5]  # Input features
  y = [2, 4, 5, 4, 6]  # Target variable
  
  slope = calculate_slope(x, y)
  intercept = calculate_intercept(x, y, slope)
  
  new_x = [6, 7]
  
  puts "Input\tPredicted Output"
  new_x.each do |x_val|
    y_pred = predict(x_val, slope, intercept)
    puts "#{x_val}\t#{y_pred}"
  end
  