const { ArffParser } = require('arff-parser');
const { DecisionTreeClassifier } = require('decision-tree');
const { Matrix, ConfusionMatrix } = require('ml-confusion-matrix');

// Load the dataset (Iris dataset as an example)
const parser = new ArffParser();
const irisData = `
@relation iris

@attribute sepallength  numeric
@attribute sepalwidth   numeric
@attribute petallength  numeric
@attribute petalwidth   numeric
@attribute class        {Iris-setosa,Iris-versicolor,Iris-virginica}

@data
5.1,3.5,1.4,0.2,Iris-setosa
4.9,3.0,1.4,0.2,Iris-setosa
...
`;

const dataset = parser.parse(irisData);

// Split the dataset into training and testing sets
const splitRatio = 0.8;
const splitIndex = Math.floor(dataset.data.length * splitRatio);
const X_train = dataset.data.slice(0, splitIndex);
const y_train = dataset.data.slice(0, splitIndex).map((row) => row[4]);
const X_test = dataset.data.slice(splitIndex);
const y_test = dataset.data.slice(splitIndex).map((row) => row[4]);

// Create a decision tree classifier
const classifier = new DecisionTreeClassifier();

// Train the classifier on the training data
classifier.train(X_train, y_train);

// Make predictions on the test data
const predictions = X_test.map((row) => classifier.predict(row));

// Calculate the accuracy of the model
const confusionMatrix = new ConfusionMatrix(y_test, predictions);
const accuracy = confusionMatrix.getAccuracy();
console.log('Accuracy:', accuracy);
