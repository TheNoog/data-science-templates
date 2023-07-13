NUM_TREES = 10
NUM_FEATURES = 5

def load_data(filename)
  data = []
  File.open(filename, "r") do |f|
    while line = f.readline
      features = line.split(",")
      label = features.shift.to_i
      feature_values = features.map(&:to_f)
      data << { label: label, feature_values: feature_values }
    end
  end
  data
end

def create_random_forest
  tree_labels = Array.new(NUM_TREES) { rand(2) }
  tree_labels
end

def classify_data(data, tree_labels)
  predictions = []
  data.each do |dp|
    correct_label = dp[:label]
    prediction = 0
    tree_labels.each do |tree_label|
      if tree_label == correct_label
        prediction += 1
      end
    end
    predictions << prediction > NUM_TREES / 2
  end
  predictions
end

def calculate_accuracy(predictions, data)
  correct = predictions.count { |prediction| prediction == dp[:label] }
  accuracy = correct / predictions.size
  accuracy * 100
end

def main
  data = load_data("data.csv")
  tree_labels = create_random_forest
  predictions = classify_data(data, tree_labels)
  accuracy = calculate_accuracy(predictions, data)
  puts "Accuracy: #{accuracy}%"
end

if __FILE__ == $PROGRAM_NAME
  main
end
