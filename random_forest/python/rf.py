import random

NUM_TREES = 10
NUM_FEATURES = 5

def load_data(filename):
    data = []
    with open(filename, 'r') as f:
        for line in f:
            features = line.split(',')
            label = int(features[0])
            feature_values = [float(f) for f in features[1:]]
            data.append({'label': label, 'features': feature_values})
    return data

def create_random_forest():
    tree_labels = []
    for _ in range(NUM_TREES):
        tree_labels.append(random.randint(0, 1))
    return tree_labels

def classify_data(data, tree_labels):
    predictions = []
    for dp in data:
        correct_label = dp['label']
        prediction = 0
        for tree_label in tree_labels:
            if tree_label == correct_label:
                prediction += 1
        predictions.append(prediction > NUM_TREES / 2)
    return predictions

def calculate_accuracy(predictions, data):
    correct = sum(predictions == dp['label'] for dp in data)
    accuracy = correct / len(data)
    return accuracy * 100

def main():
    data = load_data('data.csv')
    tree_labels = create_random_forest()
    predictions = classify_data(data, tree_labels)
    accuracy = calculate_accuracy(predictions, data)
    print('Accuracy: {}%'.format(accuracy))

if __name__ == '__main__':
    main()
