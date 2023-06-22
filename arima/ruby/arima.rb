class ARIMA
    attr_accessor :ar, :ma, :p, :q, :diff, :residuals, :scale_factor, :forecast, :num_parameters
  
    def initialize(p, q, diff)
      @ar = []
      @ma = []
      @p = p
      @q = q
      @diff = diff
      @residuals = []
      @scale_factor = 0.0
      @forecast = []
      @num_parameters = p + q
    end
  
    def fit(data) 
      # Perform necessary calculations and parameter estimation
  
      # Example placeholder code to demonstrate parameter estimation
      # Assumes p = 1, q = 1, and diff = 0 for simplicity
  
      # Estimate AR coefficient
      @ar << 0.5 # Placeholder value
  
      # Estimate MA coefficient
      @ma << 0.3 # Placeholder value
  
      # Estimate residuals
      @residuals = []
      (diff...data.length).each do |i|
        predicted_value = @ar[0] * data[i - 1] + @ma[0] * @residuals[i - diff]
        @residuals << data[i] - predicted_value
      end
  
      # Calculate scale factor
      min_val = data.min
      max_val = data.max
      @scale_factor = max_val - min_val
    end
  
    def forecast(data, steps)
      forecast = []
  
      # Example placeholder code for forecasting
      # Assumes p = 1, q = 1, and diff = 0 for simplicity
  
      steps.times do
        last_index = data.length + forecast.length - 1
  
        # Forecast the next value based on the AR and MA coefficients
        next_value = @ar[0] * data[last_index] + @ma[0] * @residuals[last_index - diff]
  
        # Add the forecasted value to the result array
        forecast << next_value
      end
  
      forecast
    end
  end
  
  # Usage example
  data = [1.0, 2.0, 3.0, 4.0, 5.0]
  p = 1
  q = 1
  diff = 0
  
  # Create and fit ARIMA model
  model = ARIMA.new(p, q, diff)
  model.fit(data)
  
  # Forecast next value
  forecast_steps = 1
  forecast = model.forecast(data, forecast_steps)
  
  # Print the forecasted value
  puts "Next value: #{forecast[0]}"
  