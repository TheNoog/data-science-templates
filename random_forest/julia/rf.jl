using Random

const NUM_TREES = 10
const NUM_FEATURES = 5

function load_data(filename)
  data = []
  open(filename) do f
    for line in readlines(f)
      features = split(line, ",")
      label = parse(Int, features[1])
      feature_values = [parse(Float64, f) for f in features[2:end]]
      data.push({label, feature_values})
    end
  end
  data
end

function create_random_forest()
  tree_labels = rand(Bool, NUM_TREES)
  tree_labels
end

function classify_data(data, tree_labels)
  predictions = []
  for dp in data
    correct_label = dp.label
    prediction = 0
    for tree_label in tree_labels
      if tree_label == correct_label
        prediction += 1
      end
    end
    predictions.push(prediction > NUM_TREES / 2 ? 1 : 0)
  end
  predictions
end

function calculate_accuracy(predictions, data)
  correct = sum(predictions .== data.label)
  accuracy = correct / length(predictions)
  accuracy * 100
end

function main()
  data = load_data("data.csv")
  tree_labels = create_random_forest()
  predictions = classify_data(data, tree_labels)
  accuracy = calculate_accuracy(predictions, data)
  println("Accuracy: ", accuracy, "%")
end

main()
