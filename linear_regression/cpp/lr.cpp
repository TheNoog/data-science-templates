#include <iostream>
#include <vector>

using namespace std;

// Function to calculate the mean
double calculateMean(const vector<double>& arr) {
    double sum = 0.0;
    for (double num : arr) {
        sum += num;
    }
    return sum / arr.size();
}

// Function to calculate the slope (beta1)
double calculateSlope(const vector<double>& x, const vector<double>& y) {
    double mean_x = calculateMean(x);
    double mean_y = calculateMean(y);
    double numerator = 0.0;
    double denominator = 0.0;

    for (int i = 0; i < x.size(); i++) {
        numerator += (x[i] - mean_x) * (y[i] - mean_y);
        denominator += (x[i] - mean_x) * (x[i] - mean_x);
    }

    return numerator / denominator;
}

// Function to calculate the intercept (beta0)
double calculateIntercept(const vector<double>& x, const vector<double>& y, double slope) {
    double mean_x = calculateMean(x);
    double mean_y = calculateMean(y);

    return mean_y - slope * mean_x;
}

// Function to make predictions
double predict(double x, double slope, double intercept) {
    return slope * x + intercept;
}

int main() {
    vector<double> x = {1, 2, 3, 4, 5};  // Input features
    vector<double> y = {2, 4, 5, 4, 6};  // Target variable

    double slope = calculateSlope(x, y);
    double intercept = calculateIntercept(x, y, slope);

    vector<double> new_x = {6, 7};

    cout << "Input\tPredicted Output" << endl;
    for (double num : new_x) {
        double y_pred = predict(num, slope, intercept);
        cout << num << "\t" << y_pred << endl;
    }

    return 0;
}
