const NUM_TREES = 10;
const NUM_FEATURES = 5;

fn load_data(filename: string) -> []u8[NUM_FEATURES] {
  var data = []u8[NUM_FEATURES];
  var file = std.io.File.open(filename, .read);
  while (file.readline()) |line| {
    var features = line.split(',').map(std.ascii.parse_u8);
    data.append(features[0 .. NUM_FEATURES]);
  }
  return data;
}

fn create_random_forest() -> []u8 {
  var tree_labels = std.array.init(u8, NUM_TREES);
  for (i in 0 .. NUM_TREES) {
    tree_labels[i] = std.random.uniform(0, 1);
  }
  return tree_labels;
}

fn classify_data(data: []u8[NUM_FEATURES], tree_labels: []u8) -> []u8 {
  var predictions = []u8;
  for (dp in data) {
    var correct_label = dp[0];
    var prediction = 0;
    for (tree_label in tree_labels) {
      if (tree_label == correct_label) {
        prediction += 1;
      }
    }
    predictions.append(prediction > NUM_TREES / 2);
  }
  return predictions;
}

fn calculate_accuracy(predictions: []u8, data: []u8[NUM_FEATURES]) -> f32 {
  var correct = 0;
  for (i in 0 .. len(predictions)) {
    if (predictions[i] == data[i][0]) {
      correct += 1;
    }
  }
  return (correct / len(predictions)) * 100.0;
}

fn main() {
  var data = load_data("data.csv");
  var tree_labels = create_random_forest();
  var predictions = classify_data(data, tree_labels);
  var accuracy = calculate_accuracy(predictions, data);
  std.debug.print("Accuracy: {}%\n", accuracy);
}
