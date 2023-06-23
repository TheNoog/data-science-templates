const std = @import("std");
const xgb = @import("xgboost");
const sklearn.datasets = @import("sklearn.datasets");
const sklearn.model_selection = @import("sklearn.model_selection");
const sklearn.metrics = @import("sklearn.metrics");

pub fn main() !void {
    // Load the Boston Housing dataset
    const boston = sklearn.datasets.load_boston();
    const X = boston.data;
    const y = boston.target;

    // Split the data into training and testing sets
    var rng: std.rand.Rng = std.rand.defaultPrngInit(42);
    const X_train = std.ArrayList([]const u8).init(std.heap.page_allocator);
    const X_test = std.ArrayList([]const u8).init(std.heap.page_allocator);
    const y_train = std.ArrayList(f64).init(std.heap.page_allocator);
    const y_test = std.ArrayList(f64).init(std.heap.page_allocator);
    try sklearn.model_selection.train_test_split(rng, X, y, X_train, X_test, y_train, y_test, 0.2);

    // Create the gradient boosted model
    var model = xgb.XGBRegressor.init(
        .objective = .reg_squarederror,  // Specify the loss function for regression
        .n_estimators = 100,  // Number of boosting rounds (trees)
        .learning_rate = 0.1,  // Learning rate (shrinkage) of each tree
        .max_depth = 3,  // Maximum depth of each tree
        .subsample = 0.8,  // Fraction of training samples used for each tree
        .colsample_bytree = 0.8,  // Fraction of features used for each tree
        .random_state = 42,
    );

    // Train the model
    try model.fit(X_train, y_train);

    // Make predictions on the test set
    const y_pred = std.ArrayList(f64).init(std.heap.page_allocator);
    try model.predict(X_test, y_pred);

    // Evaluate the model
    const mse = sklearn.metrics.mean_squared_error(y_test.items, y_pred.items);
    std.debug.print("Mean Squared Error: {}\n", .{mse});
}
