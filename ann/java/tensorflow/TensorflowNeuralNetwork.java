package ann.java;

import org.tensorflow.Graph;
import org.tensorflow.Session;
import org.tensorflow.Tensor;
import org.tensorflow.TensorFlow;
import org.tensorflow.op.Ops;
import org.tensorflow.op.core.Placeholder;
import org.tensorflow.op.core.Variable;
import org.tensorflow.op.math.MeanSquaredError;
import org.tensorflow.op.nn.Sigmoid;
import org.tensorflow.op.train.ApplyGradientDescent;
import org.tensorflow.op.train.GradientDescent;
import org.tensorflow.types.TFloat32;

public class TensorflowNeuralNetwork {
    public static void main(String[] args) {
        // Training data
        float[][] inputs = {{0.0f, 0.0f}, {0.0f, 1.0f}, {1.0f, 0.0f}, {1.0f, 1.0f}};
        float[][] targets = {{0.0f}, {1.0f}, {1.0f}, {0.0f}};

        // Hyperparameters
        float learningRate = 0.1f;
        int epochs = 1000;

        try (Graph graph = new Graph()) {
            Ops ops = Ops.create(graph);

            // Define placeholders for inputs and targets
            Placeholder<TFloat32> inputsPlaceholder = ops.placeholder(TFloat32.class);
            Placeholder<TFloat32> targetsPlaceholder = ops.placeholder(TFloat32.class);

            // Define variables for weights and biases
            Variable<TFloat32> weights1Variable = ops.variable(ops.randomNormal(ops.constant(new long[]{2, 4}), TFloat32.class)));
            Variable<TFloat32> weights2Variable = ops.variable(ops.randomNormal(ops.constant(new long[]{4, 1}), TFloat32.class)));
            Variable<TFloat32> bias1Variable = ops.variable(ops.zeros(ops.constant(new long[]{4}), TFloat32.class)));
            Variable<TFloat32> bias2Variable = ops.variable(ops.zeros(ops.constant(new long[]{1}), TFloat32.class)));

            // Define model architecture
            Sigmoid sigmoid = ops.sigmoid();
            TFloat32 hiddenLayer = sigmoid.call(ops.add(ops.matMul(inputsPlaceholder, weights1Variable), bias1Variable));
            TFloat32 outputLayer = sigmoid.call(ops.add(ops.matMul(hiddenLayer, weights2Variable), bias2Variable));

            // Define loss function
            MeanSquaredError loss = ops.meanSquaredError(targetsPlaceholder, outputLayer);

            // Define optimizer
            GradientDescent optimizer = ops.gradientDescent(learningRate);
            ApplyGradientDescent applyGradients = optimizer.applyGradients(
                    weights1Variable.gradient(),
                    weights2Variable.gradient(),
                    bias1Variable.gradient(),
                    bias2Variable.gradient()
            );

            // Create a TensorFlow session and initialize variables
            try (Session session = new Session(graph)) {
                session.runner().addTarget(ops.init()).run();

                // Train the model
                for (int epoch = 0; epoch < epochs; epoch++) {
                    Tensor<TFloat32> inputsTensor = TFloat32.tensorOf(inputs);
                    Tensor<TFloat32> targetsTensor = TFloat32.tensorOf(targets);

                    session.runner()
                            .feed(inputsPlaceholder.asOutput(), inputsTensor)
                            .feed(targetsPlaceholder.asOutput(), targetsTensor)
                            .addTarget(applyGradients)
                            .run();

                    inputsTensor.close();
                    targetsTensor.close();
                }

                // Test the trained model
                Tensor<TFloat32> inputsTensor = TFloat32.tensorOf(inputs);
                Tensor<TFloat32> outputTensor = session.runner()
                        .feed(inputsPlaceholder.asOutput(), inputsTensor)
                        .fetch(outputLayer)
                        .run()
                        .get(0)
                        .expect(TFloat32.class);

                float[][] predictions = new float[inputs.length][1];
                outputTensor.copyTo(predictions);

                for (int i = 0; i < inputs.length; i++) {
                    System.out.println("Input: " + inputs[i][0] + ", " + inputs[i][1]
                            + ", Predicted Output: " + predictions[i][0]);
                }

                inputsTensor.close();
                outputTensor.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
