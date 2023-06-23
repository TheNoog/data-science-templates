defmodule DecisionTree do
  def run do
    # Load the dataset (Iris dataset as an example)
    iris = Sklearn.Datasets.load_iris()
    X = iris.data
    y = iris.target

    # Split the dataset into training and testing sets
    {X_train, X_test, y_train, y_test} = Sklearn.ModelSelection.train_test_split(X, y, test_size: 0.2, random_state: 42)

    # Create a decision tree classifier
    classifier = Sklearn.Tree.DecisionTreeClassifier.new()

    # Train the classifier on the training data
    classifier = Sklearn.Tree.DecisionTreeClassifier.fit(classifier, X_train, y_train)

    # Make predictions on the test data
    y_pred = Sklearn.Tree.DecisionTreeClassifier.predict(classifier, X_test)

    # Calculate the accuracy of the model
    accuracy = Sklearn.Metrics.accuracy_score(y_test, y_pred)
    IO.puts("Accuracy: #{accuracy}")
  end
end

DecisionTree.run()
