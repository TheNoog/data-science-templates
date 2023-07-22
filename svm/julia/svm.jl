struct SVM
    C::Float64
    kernel::String
    w::Vector{Float64}
    b::Float64
end

function SVM(C::Float64, kernel::String)
    SVM(C, kernel, zeros(Float64, 2), 0.0)
end

function fit(svm::SVM, X::Array{Float64}, y::Array{Int}, n::Int)
    for i in 1:n
        score = 0.0
        for j in 1:2
            score += svm.w[j] * X[i, j]
        end
        if y[i] * score + svm.b <= 1.0
            for j in 1:2
                svm.w[j] += svm.C * y[i] * X[i, j]
            end
            svm.b += svm.C * y[i]
        end
    end
    svm
end

function predict(svm::SVM, X::Array{Float64})
    score = 0.0
    for j in 1:2
        score += svm.w[j] * X[j]
    end
    score >= 0 ? 1 : -1
end

svm = SVM(1.0, "linear")
svm = fit(svm, [[1, 2], [3, 4]], [1, -1], 2)
println(predict(svm, [5, 6])) # prints "1"
