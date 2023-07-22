svm <- function(C, kernel) {
  
  w <- c(0, 0)
  b <- 0
  
  fit <- function(X, y, n) {
    for (i in 1:n) {
      score <- 0
      for (j in 1:2) {
        score <- score + w[j] * X[i, j]
      }
      if (y[i] * score + b <= 1) {
        for (j in 1:2) {
          w[j] <- w[j] + C * y[i] * X[i, j]
        }
        b <- b + C * y[i]
      }
    }
    return(list(w=w, b=b))
  }
  
  predict <- function(X) {
    score <- 0
    for (j in 1:2) {
      score <- score + w[j] * X[j]
    }
    return(as.integer(score >= 0))
  }
  
  list(fit=fit, predict=predict)
}

model <- svm(1, "linear")
result <- model$fit(matrix(c(1, 2, 3, 4), nrow=2, byrow=TRUE), c(1, -1), 2)
model$predict(c(5, 6)) # prints 1
