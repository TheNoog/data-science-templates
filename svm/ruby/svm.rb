require 'linear_algebra'

class SVM

  attr_reader :C, :kernel, :w, :b

  def initialize(C, kernel)
    @C = C
    @kernel = kernel
    @w = [0.0, 0.0]
    @b = 0.0
  end

  def fit(X, y, n)
    for i in 0...n
      score = dot(w, X[i]) + b
      if y[i] * score <= 1
        for j in 0...2
          w[j] += C * y[i] * X[i][j]
        end
        b += C * y[i]
      end
    end
  end

  def predict(X)
    score = dot(w, X) + b
    score >= 0 ? 1 : -1
  end

private

  def dot(x, y)
    x.inject(0) { |sum, xi| sum + xi * y[xi] }
  end

end

svm = SVM(1.0, "linear")
svm.fit([[1, 2], [3, 4]], [1, -1], 2)
puts svm.predict([5, 6]) # prints 1
