#include <iostream>
#include <vector>

using namespace std;

class RNN {
public:
    int input_dim;
    int hidden_dim;
    int output_dim;

    vector<vector<double>> weights;
    vector<double> biases;

    vector<double> h;

    RNN(int input_dim, int hidden_dim, int output_dim) {
        this->input_dim = input_dim;
        this->hidden_dim = hidden_dim;
        this->output_dim = output_dim;

        weights = vector<vector<double>>(input_dim, vector<double>(hidden_dim));
        biases = vector<double>(hidden_dim);

        for (int i = 0; i < input_dim; i++) {
            for (int j = 0; j < hidden_dim; j++) {
                weights[i][j] = ((double)rand() / (double)RAND_MAX) - 0.5;
            }
        }

        for (int i = 0; i < hidden_dim; i++) {
            biases[i] = ((double)rand() / (double)RAND_MAX) - 0.5;
        }

        h = vector<double>(hidden_dim);
    }

    void Train(vector<vector<double>> data) {
        for (int i = 0; i < data.size(); i++) {
            h = vector<double>(hidden_dim);
            for (int j = 0; j < data[i].size(); j++) {
                double z = 0;
                for (int k = 0; k < data[i][j].size(); k++) {
                    z += data[i][j][k] * weights[k][j];
                }
                h = tanh(z + biases[j]);
            }
        }
    }

    vector<double> Predict(vector<vector<double>> data) {
        vector<double> predictions = vector<double>(data[0].size());
        for (int i = 0; i < data.size(); i++) {
            double z = 0;
            for (int j = 0; j < data[i].size(); j++) {
                z += data[i][j] * weights[j][i];
            }
            predictions[i] = tanh(z + biases[i]);
        }
        return predictions;
    }
};

int main() {
    // Generate some data
    vector<vector<double>> data = {
        {1, 2, 3, 4, 5},
        {6, 7, 8, 9, 10},
    };

    // Create a RNN model
    RNN model = RNN(10, 20, 10);

    // Train the model to the data
    model.Train(data);

    // Make predictions
    vector<double> predictions = model.Predict(data);

    // Print the predictions
    for (int i = 0; i < predictions.size(); i++) {
        cout << predictions[i] << endl;
    }

    return 0;
}
