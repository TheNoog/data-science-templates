# Input features
x <- c(1, 2, 3, 4, 5)
# Target variable
y <- c(2, 4, 5, 4, 6)

# Calculate the slope (beta1)
meanX <- mean(x)
meanY <- mean(y)
numerator <- sum((x - meanX) * (y - meanY))
denominator <- sum((x - meanX) ^ 2)
slope <- numerator / denominator

# Calculate the intercept (beta0)
intercept <- meanY - slope * meanX

# New input features
newX <- c(6, 7)

cat("Input\tPredicted Output\n")
for (val in newX) {
  # Make predictions
  yPred <- slope * val + intercept
  cat(val, "\t", yPred, "\n")
}
