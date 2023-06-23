#include <xgboost/c_api.h>
#include <stdio.h>

int main() {
    DMatrixHandle dtrain, dtest;
    BoosterHandle booster;
    const char* train_path = "train.libsvm";
    const char* test_path = "test.libsvm";
    const char* param_name = "objective";
    const char* param_value = "reg:squarederror";
    const char* eval_name_list[] = { "eval" };
    const char* eval_result_list[] = { "eval_result" };
    const int num_rounds = 100;
    int silent = 1;

    // Load the training and testing data
    XGDMatrixCreateFromFile(train_path, silent, &dtrain);
    XGDMatrixCreateFromFile(test_path, silent, &dtest);

    // Set the parameters
    XGBoosterCreate(&dtrain, 1, &booster);
    XGBoosterSetParam(booster, param_name, param_value);

    // Train the model
    for (int i = 0; i < num_rounds; ++i) {
        XGBoosterUpdateOneIter(booster, i, dtrain);
    }

    // Make predictions on the testing data
    bst_ulong test_size;
    const float* test_data;
    XGDMatrixGetFloatInfo(dtest, "float_info", &test_data, &test_size);
    bst_ulong num_preds;
    const float* preds;
    XGBoosterPredict(booster, dtest, 0, 0, &num_preds, &preds);

    // Evaluate the model
    float eval_result;
    XGBoosterEvalOneIter(booster, num_rounds, &dtest, eval_name_list, eval_result_list, 1, &eval_result);
    printf("Evaluation Result: %f\n", eval_result);

    // Clean up resources
    XGDMatrixFree(dtrain);
    XGDMatrixFree(dtest);
    XGBoosterFree(booster);

    return 0;
}
