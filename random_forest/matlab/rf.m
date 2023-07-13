NUM_TREES = 10;
NUM_FEATURES = 5;

function loadData(filename)
  data = [];
  fid = fopen(filename);
  while ~feof(fid)
    line = fgetl(fid);
    features = split(line, ',');
    label = str2num(features{1});
    feature_values = str2num(features{2:end});
    data.push({label, feature_values});
  end
  fclose(fid);
  data
end

function createRandomForest()
  tree_labels = rand(2, NUM_TREES);
  tree_labels
end

function classifyData(data, tree_labels)
  predictions = [];
  for dp in data
    correct_label = dp.label;
    prediction = 0;
    for tree_label in tree_labels
      if tree_label(1) == correct_label
        prediction += 1;
      end
    end
    predictions.push(prediction > NUM_TREES / 2 ? 1 : 0);
  end
  predictions
end

function calculateAccuracy(predictions, data)
  correct = sum(predictions == data.label);
  accuracy = correct / length(predictions);
  accuracy * 100
end

function main()
  data = loadData('data.csv');
  tree_labels = createRandomForest();
  predictions = classifyData(data, tree_labels);
  accuracy = calculateAccuracy(predictions, data);
  disp(['Accuracy: ', num2str(accuracy), '%'])
end

main()
