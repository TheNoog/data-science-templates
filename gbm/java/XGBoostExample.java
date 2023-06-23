package gbm.java;

import ml.dmlc.xgboost4j.java.DMatrix;
import ml.dmlc.xgboost4j.java.XGBoostError;
import ml.dmlc.xgboost4j.java.XGBoost;
import ml.dmlc.xgboost4j.java.XGBoostModel;

public class XGBoostExample {

    public static void main(String[] args) throws XGBoostError {
        // Load the training and testing data
        DMatrix trainData = new DMatrix("train.libsvm");
        DMatrix testData = new DMatrix("test.libsvm");

        // Set the parameters for the XGBoost model
        String[] parameters = {
                "objective=reg:squarederror",
                "max_depth=3",
                "eta=0.1",
                "subsample=0.8",
                "colsample_bytree=0.8"
        };

        // Train the model
        int numRounds = 100;
        XGBoostModel model = XGBoost.train(trainData, parameters, numRounds);

        // Make predictions on the test data
        float[][] predictions = model.predict(testData);

        // Evaluate the model
        float[] labels = testData.getLabel();
        float sumSquaredError = 0;
        for (int i = 0; i < labels.length; i++) {
            float error = labels[i] - predictions[i][0];
            sumSquaredError += error * error;
        }
        float rmse = (float) Math.sqrt(sumSquaredError / labels.length);
        System.out.println("RMSE: " + rmse);
    }
}
