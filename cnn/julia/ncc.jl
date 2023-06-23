struct HiddenLayer
    weights::Array{Float64, 2}
    bias::Array{Float64, 1}
end

struct OutputLayer
    weights::Array{Float64, 2}
    bias::Array{Float64, 1}
end

const InputSize = 64
const HiddenSize = 128
const OutputSize = 10
const LearningRate = 0.01
const Epochs = 10

sigmoid(x) = 1.0 / (1.0 + exp(-x))

function initializeHiddenLayer(hiddenSize, inputSize)
    weights = randn(hiddenSize, inputSize)
    bias = randn(hiddenSize)
    return HiddenLayer(weights, bias)
end

function initializeOutputLayer(outputSize, hiddenSize)
    weights = randn(outputSize, hiddenSize)
    bias = randn(outputSize)
    return OutputLayer(weights, bias)
end

function forwardPropagation(input, hiddenLayer, outputLayer)
    hiddenOutput = sigmoid.(hiddenLayer.bias .+ hiddenLayer.weights * input)

    output = sigmoid.(outputLayer.bias .+ outputLayer.weights * hiddenOutput)

    return output
end

function backPropagation(input, target, hiddenLayer, outputLayer)
    hiddenOutput = sigmoid.(hiddenLayer.bias .+ hiddenLayer.weights * input)
    output = forwardPropagation(input, hiddenLayer, outputLayer)

    outputDelta = (output .- target) .* output .* (1 .- output)

    hiddenDelta = (transpose(outputLayer.weights) * outputDelta) .* hiddenOutput .* (1 .- hiddenOutput)

    outputLayer.weights .-= LearningRate .* outputDelta * transpose(hiddenOutput)
    outputLayer.bias .-= LearningRate .* outputDelta

    hiddenLayer.weights .-= LearningRate .* hiddenDelta * transpose(input)
    hiddenLayer.bias .-= LearningRate .* hiddenDelta
end

function main()
    input = [/* Input values here */]
    target = [/* Target values here */]

    hiddenLayer = initializeHiddenLayer(HiddenSize, InputSize)
    outputLayer = initializeOutputLayer(OutputSize, HiddenSize)

    for epoch in 1:Epochs
        backPropagation(input, target, hiddenLayer, outputLayer)
    end

    output = forwardPropagation(input, hiddenLayer, outputLayer)

    println("Output: ", output)
end

main()
