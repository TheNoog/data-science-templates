struct HiddenLayer {
    weights: Vec<Vec<f64>>,
    bias: Vec<f64>,
}

impl HiddenLayer {
    fn new(hidden_size: usize, input_size: usize) -> HiddenLayer {
        let weights: Vec<Vec<f64>> = (0..hidden_size)
            .map(|_| (0..input_size).map(|_| rand::random::<f64>() - 0.5).collect())
            .collect();
        let bias: Vec<f64> = (0..hidden_size).map(|_| rand::random::<f64>() - 0.5).collect();
        HiddenLayer { weights, bias }
    }
}

struct OutputLayer {
    weights: Vec<Vec<f64>>,
    bias: Vec<f64>,
}

impl OutputLayer {
    fn new(output_size: usize, hidden_size: usize) -> OutputLayer {
        let weights: Vec<Vec<f64>> = (0..output_size)
            .map(|_| (0..hidden_size).map(|_| rand::random::<f64>() - 0.5).collect())
            .collect();
        let bias: Vec<f64> = (0..output_size).map(|_| rand::random::<f64>() - 0.5).collect();
        OutputLayer { weights, bias }
    }
}

const INPUT_SIZE: usize = 64;
const HIDDEN_SIZE: usize = 128;
const OUTPUT_SIZE: usize = 10;
const LEARNING_RATE: f64 = 0.01;
const EPOCHS: usize = 10;

fn sigmoid(x: f64) -> f64 {
    1.0 / (1.0 + (-x).exp())
}

fn forward_propagation(input: &[f64], hidden_layer: &HiddenLayer, output_layer: &OutputLayer) -> Vec<f64> {
    let hidden_output: Vec<f64> = hidden_layer.bias.iter().zip(&hidden_layer.weights).map(|(&b, w)| {
        sigmoid(b + w.iter().zip(input).map(|(&w, &i)| w * i).sum::<f64>())
    }).collect();

    let output: Vec<f64> = output_layer.bias.iter().zip(&output_layer.weights).map(|(&b, w)| {
        sigmoid(b + w.iter().zip(&hidden_output).map(|(&w, &h)| w * h).sum::<f64>())
    }).collect();

    output
}

fn back_propagation(input: &[f64], target: &[f64], hidden_layer: &mut HiddenLayer, output_layer: &mut OutputLayer) {
    let hidden_output: Vec<f64> = hidden_layer.bias.iter().zip(&hidden_layer.weights).map(|(&b, w)| {
        sigmoid(b + w.iter().zip(input).map(|(&w, &i)| w * i).sum::<f64>())
    }).collect();

    let output: Vec<f64> = forward_propagation(input, hidden_layer, output_layer);

    let output_delta: Vec<f64> = output.iter().zip(target).map(|(&o, &t)| (o - t) * o * (1.0 - o)).collect();

    let hidden_delta: Vec<f64> = output_layer.weights.iter()
        .flat_map(|row| row.iter())
        .zip(&output_delta)
        .zip(&hidden_output)
        .map(|((&w, &od), &h)| w * h * (1.0 - h))
        .collect();

    for (weights, output_delta) in output_layer.weights.iter_mut().zip(&output_delta) {
        for (weight, hidden_output) in weights.iter_mut().zip(&hidden_output) {
            *weight -= LEARNING_RATE * output_delta * hidden_output;
        }
    }

    for (bias, output_delta) in output_layer.bias.iter_mut().zip(&output_delta) {
        *bias -= LEARNING_RATE * output_delta;
    }

    for (weights, hidden_delta) in hidden_layer.weights.iter_mut().zip(&hidden_delta) {
        for (weight, &input) in weights.iter_mut().zip(input) {
            *weight -= LEARNING_RATE * hidden_delta * input;
        }
    }

    for (bias, &hidden_delta) in hidden_layer.bias.iter_mut().zip(&hidden_delta) {
        *bias -= LEARNING_RATE * hidden_delta;
    }
}

fn main() {
    let input: [f64; INPUT_SIZE] = /* Input values here */;
    let target: [f64; OUTPUT_SIZE] = /* Target values here */;

    let mut hidden_layer = HiddenLayer::new(HIDDEN_SIZE, INPUT_SIZE);
    let mut output_layer = OutputLayer::new(OUTPUT_SIZE, HIDDEN_SIZE);

    for _ in 0..EPOCHS {
        back_propagation(&input, &target, &mut hidden_layer, &mut output_layer);
    }

    let output = forward_propagation(&input, &hidden_layer, &output_layer);

    println!("Output: {:?}", output);
}
