% Structure to represent a data point
DataPoint = struct('x', 0, 'y', 0, 'label', 0);

% Function to calculate Euclidean distance between two data points
function distance = calculateDistance(p1, p2)
    dx = p2.x - p1.x;
    dy = p2.y - p1.y;
    distance = sqrt(dx * dx + dy * dy);
end

% Function to perform KNN classification
function predictedLabel = classify(trainingData, testPoint, k)
    % Calculate distances to all training data points
    distances = zeros(length(trainingData), 1);
    for i = 1:length(trainingData)
        distances(i) = calculateDistance(trainingData(i), testPoint);
    end

    % Sort the distances in ascending order
    sortedDistances = sort(distances);

    % Count the occurrences of each label among the k nearest neighbors
    labelCount = containers.Map('KeyType', 'double', 'ValueType', 'double');
    for i = 1:k
        index = find(distances == sortedDistances(i), 1);
        label = trainingData(index).label;
        if isKey(labelCount, label)
            labelCount(label) = labelCount(label) + 1;
        else
            labelCount(label) = 1;
        end
    end

    % Return the label with the highest count
    [~, maxCountIndex] = max(cell2mat(values(labelCount)));
    predictedLabel = cell2mat(keys(labelCount(maxCountIndex)));
end

% Training data
trainingData = [
    struct('x', 2.0, 'y', 4.0, 'label', 0),
    struct('x', 4.0, 'y', 6.0, 'label', 0),
    struct('x', 4.0, 'y', 8.0, 'label', 1),
    struct('x', 6.0, 'y', 4.0, 'label', 1),
    struct('x', 6.0, 'y', 6.0, 'label', 1)
];

% Test data point
testPoint = struct('x', 5.0, 'y', 5.0, 'label', 0);

% Perform KNN classification
k = 3;
predictedLabel = classify(trainingData, testPoint, k);

% Print the predicted label
fprintf('Predicted label: %d\n', predictedLabel);