const NUM_TREES = 10;
const NUM_FEATURES = 5;

function loadData(filename) {
  const data = [];
  const reader = new FileReader(filename);
  reader.onload = () => {
    const lines = reader.result.split("\n");
    for (const line of lines) {
      const features = line.split(",");
      const label = parseInt(features[0]);
      const featureValues = new Float32Array(features.slice(1));
      data.push({ label, featureValues });
    }
  };
}

function createRandomForest() {
  const treeLabels = [];
  for (let i = 0; i < NUM_TREES; i++) {
    treeLabels.push(Math.random() < 0.5 ? 0 : 1);
  }
  return treeLabels;
}

function classifyData(data, treeLabels) {
  const predictions = [];
  for (const dp of data) {
    const correctLabel = dp.label;
    const prediction = 0;
    for (const treeLabel of treeLabels) {
      if (treeLabel === correctLabel) {
        prediction++;
      }
    }
    predictions.push(prediction > NUM_TREES / 2 ? 1 : 0);
  }
  return predictions;
}

function calculateAccuracy(predictions, data) {
  const correct = predictions.reduce((acc, p) => acc + (p === data[p].label ? 1 : 0), 0);
  return (correct / predictions.length) * 100;
}

function main() {
  const data = loadData("data.csv");
  const treeLabels = createRandomForest();
  const predictions = classifyData(data, treeLabels);
  const accuracy = calculateAccuracy(predictions, data);
  console.log("Accuracy: " + accuracy + "%");
}

main();
