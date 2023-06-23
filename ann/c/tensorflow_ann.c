#include <stdio.h>
#include <tensorflow/c/c_api.h>

// Helper function to create a dense layer
TF_Output denseLayer(TF_Graph* graph, TF_Output input, int inputSize, int outputSize, const char* activation) {
    TF_Status* status = TF_NewStatus();
    TF_Output denseOutput;

    TF_Operation* weights = TF_Const(graph, TF_MakeShape(2, (const int64_t[]){inputSize, outputSize}), TF_FLOAT, /* buffer */ NULL, /* len */ 0);
    TF_Operation* biases = TF_Const(graph, TF_MakeShape(1, (const int64_t[]){outputSize}), TF_FLOAT, /* buffer */ NULL, /* len */ 0);

    denseOutput.oper = TF_FullyConnected(graph, input, weights, biases, activation, status);
    denseOutput.index = 0;

    if (TF_GetCode(status) != TF_OK) {
        fprintf(stderr, "Error creating dense layer: %s\n", TF_Message(status));
        return denseOutput;
    }

    TF_DeleteStatus(status);
    return denseOutput;
}

int main() {
    // Example dataset
    float X[4][2] = {{0, 0}, {0, 1}, {1, 0}, {1, 1}};
    float y[4][1] = {{0}, {1}, {1}, {0}};

    TF_Graph* graph = TF_NewGraph();
    TF_SessionOptions* sessionOpts = TF_NewSessionOptions();
    TF_Status* status = TF_NewStatus();

    // Create input placeholders
    TF_Operation* input = TF_Placeholder(graph, TF_FLOAT, TF_NewTensorShape(2, (const int64_t[]){-1, 2}), "input");

    // Create hidden layer
    TF_Output hiddenOutput = denseLayer(graph, TF_Output{input, 0}, 2, 4, "relu");

    // Create output layer
    TF_Output output = denseLayer(graph, hiddenOutput, 4, 1, "sigmoid");

    // Create loss operation
    TF_Operation* target = TF_Placeholder(graph, TF_FLOAT, TF_NewTensorShape(2, (const int64_t[]){-1, 1}), "target");
    TF_Operation* loss = TF_SigmoidCrossEntropyWithLogits(graph, target, output.oper, status);

    if (TF_GetCode(status) != TF_OK) {
        fprintf(stderr, "Error creating loss operation: %s\n", TF_Message(status));
        return 1;
    }

    // Create optimizer
    TF_Operation* minimize = TF_AdamOptimizer(graph, loss, 0.001f);

    // Initialize session
    TF_Session* session = TF_NewSession(graph, sessionOpts, status);
    if (TF_GetCode(status) != TF_OK) {
        fprintf(stderr, "Error creating session: %s\n", TF_Message(status));
        return 1;
    }

    // Convert input and target data to TF_Tensors
    TF_Tensor* xTensor = TF_NewTensor(TF_FLOAT, (const int64_t[]){4, 2}, 2, X, sizeof(float) * 4 * 2, NULL, NULL);
    TF_Tensor* yTensor = TF_NewTensor(TF_FLOAT, (const int64_t[]){4, 1}, 2, y, sizeof(float) * 4 * 1, NULL, NULL);

    // Train the model
    for (int epoch = 0; epoch < 1000; ++epoch) {
        TF_SessionRun(session, NULL,
                      &(TF_Output){input, xTensor, 2},
                      &(TF_Output){target, yTensor, 1},
                      &(TF_Output){minimize, NULL, 0},
                      NULL, 0, NULL, 0, NULL, status);

        if (TF_GetCode(status) != TF_OK) {
            fprintf(stderr, "Error running session: %s\n", TF_Message(status));
            return 1;
        }
    }

    // Make predictions on new data
    float predictions[4][1];
    TF_SessionRun(session, NULL,
                  &(TF_Output){input, xTensor, 2},
                  NULL,
                  &(TF_Output){output.oper, predictions, sizeof(float) * 4 * 1},
                  NULL, 0, NULL, 0, NULL, status);

    if (TF_GetCode(status) != TF_OK) {
        fprintf(stderr, "Error running session: %s\n", TF_Message(status));
        return 1;
    }

    // Print the predictions
    for (int i = 0; i < 4; ++i) {
        printf("Input: [%f, %f], Predicted Output: %f\n", X[i][0], X[i][1], predictions[i][0]);
    }

    // Clean up resources
    TF_DeleteTensor(xTensor);
    TF_DeleteTensor(yTensor);
    TF_CloseSession(session, status);
    TF_DeleteSession(session, status);
    TF_DeleteSessionOptions(sessionOpts);
    TF_DeleteStatus(status);
    TF_DeleteGraph(graph);

    return 0;
}
