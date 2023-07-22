struct LogisticRegression
    weights::Array{Float64,1}
    bias::Float64
  end
  
  function train(model::LogisticRegression, features::Array{Float64,1}, label::Int64)
    prediction = sigmoid(dot(model.weights, features) + model.bias)
    error = label - prediction
  
    for i in 1:length(features)
      model.weights[i] += error * features[i]
    end
    model.bias += error
  end
  
  function sigmoid(x::Float64)
    return 1.0 / (1.0 + exp(-x))
  end
  
  function dot(x::Array{Float64,1}, y::Array{Float64,1})
    sum = 0.0
  
    for i in 1:length(x)
      sum += x[i] * y[i]
    end
  
    return sum
  end
  
  function predict(model::LogisticRegression, features::Array{Float64,1})
    prediction = sigmoid(dot(model.weights, features) + model.bias)
    return prediction > 0.5
  end
  
  function main()
    features = [1.0, 2.0]
    label = 1
  
    model = LogisticRegression(Array(Float64, 2))
  
    for i in 1:100
      train(model, features, label)
    end
  
    new_features = [3.0, 4.0]
    new_label = predict(model, new_features)
  
    println("The predicted label is $(new_label)")
  end
  
  main()
  