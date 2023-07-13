package main

import (
    "fmt"
    "math/rand"
    "os"
    "strings"
)

type DataPoint struct {
    Label int
    Features []float64
}

func LoadData(filename string) []DataPoint {
    data := []DataPoint{}
    file, err := os.Open(filename)
    if err != nil {
        fmt.Println(err)
        return data
    }
    defer file.Close()

    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        line := scanner.Text()
        features := strings.Split(line, ",")
        label := int(features[0])
        features = features[1:]
        features = make([]float64, len(features))
        for i, f := range features {
            features[i] = float64(f)
        }

        data = append(data, DataPoint{Label: label, Features: features})
    }

    return data
}

func CreateRandomForest(numTrees int) []int {
    treeLabels := make([]int, numTrees)
    for i := 0; i < numTrees; i++ {
        treeLabels[i] = rand.Intn(2)
    }

    return treeLabels
}

func ClassifyData(data []DataPoint, treeLabels []int) []int {
    predictions := make([]int, len(data))
    for i, dp := range data {
        correctLabel := dp.Label
        prediction := 0
        for _, treeLabel := range treeLabels {
            if treeLabel == dp.Label {
                prediction++
            }
        }

        predictions[i] = prediction > numTrees/2 ? 1 : 0
    }

    return predictions
}

func CalculateAccuracy(predictions []int, data []DataPoint) float64 {
    correct := 0
    for i, prediction := range predictions {
        if prediction == data[i].Label {
            correct++
        }
    }

    accuracy := float64(correct) / float64(len(data))
    return accuracy * 100
}

func main() {
    data := LoadData("data.csv")
    treeLabels := CreateRandomForest(10)
    predictions := ClassifyData(data, treeLabels)
    accuracy := CalculateAccuracy(predictions, data)
    fmt.Printf("Accuracy: %.2f%%\n", accuracy)
}