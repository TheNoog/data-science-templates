const std = @import("std");
const statsmodels = @import("statsmodels");

pub fn main() void {
    const data: [10]f64 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    const order: (usize, usize, usize) = (1, 0, 1);

    var model: statsmodels.ARIMAModel = fit_arima_model(data, order);

    // Use the fitted model for predictions or further analysis

}
