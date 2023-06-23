#include <stdio.h>

// Function to calculate the mean
double calculate_mean(double arr[], int n) {
    double sum = 0.0;
    for (int i = 0; i < n; i++) {
        sum += arr[i];
    }
    return sum / n;
}

// Function to calculate the slope (beta1)
double calculate_slope(double x[], double y[], int n) {
    double mean_x = calculate_mean(x, n);
    double mean_y = calculate_mean(y, n);
    double numerator = 0.0;
    double denominator = 0.0;

    for (int i = 0; i < n; i++) {
        numerator += (x[i] - mean_x) * (y[i] - mean_y);
        denominator += (x[i] - mean_x) * (x[i] - mean_x);
    }

    return numerator / denominator;
}

// Function to calculate the intercept (beta0)
double calculate_intercept(double x[], double y[], int n, double slope) {
    double mean_x = calculate_mean(x, n);
    double mean_y = calculate_mean(y, n);

    return mean_y - slope * mean_x;
}

// Function to make predictions
double predict(double x, double slope, double intercept) {
    return slope * x + intercept;
}

int main() {
    double x[] = {1, 2, 3, 4, 5};  // Input features
    double y[] = {2, 4, 5, 4, 6};  // Target variable
    int n = sizeof(x) / sizeof(x[0]);

    double slope = calculate_slope(x, y, n);
    double intercept = calculate_intercept(x, y, n, slope);

    double new_x[] = {6, 7};
    int new_n = sizeof(new_x) / sizeof(new_x[0]);

    printf("Input\tPredicted Output\n");
    for (int i = 0; i < new_n; i++) {
        double y_pred = predict(new_x[i], slope, intercept);
        printf("%g\t%g\n", new_x[i], y_pred);
    }

    return 0;
}
