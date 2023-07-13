NUM_TREES <- 10
NUM_FEATURES <- 5

load_data <- function(filename) {
  data <- data.frame()
  with(open(filename, 'r') as f) {
    for (line in readLines(f)) {
      features <- strsplit(line, ',')[[1]]
      label <- as.integer(features[1])
      feature_values <- as.numeric(features[2:length(features)])
      data <- rbind(data, c(label, feature_values))
    }
  }
  data
}

create_random_forest <- function() {
  tree_labels <- sample(0:1, NUM_TREES, replace = TRUE)
  tree_labels
}

classify_data <- function(data, tree_labels) {
  predictions <- c()
  for (dp in data) {
    correct_label <- dp[1]
    prediction <- 0
    for (tree_label in tree_labels) {
      if (tree_label == correct_label) {
        prediction <- prediction + 1
      }
    }
    predictions <- c(predictions, prediction > NUM_TREES / 2)
  }
  predictions
}

calculate_accuracy <- function(predictions, data) {
  correct <- sum(predictions == data[, 1])
  accuracy <- correct / length(data)
  accuracy * 100
}

main <- function() {
  data <- load_data('data.csv')
  tree_labels <- create_random_forest()
  predictions <- classify_data(data, tree_labels)
  accuracy <- calculate_accuracy(predictions, data)
  print(paste('Accuracy:', accuracy, '%'))
}

if (interactive()) {
  main()
}
