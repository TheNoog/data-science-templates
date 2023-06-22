const std = @import("std");
const statsmodels = @import("statsmodels");

pub fn fit_arima_model(data: []f64, order: (usize, usize, usize)) statsmodels.ARIMAModel {
    var model: statsmodels.ARIMAModel = undefined;

    try {
        // Create the ARIMA model
        model = statsmodels.ARIMAModel.init(data, order);

        // Fit the model to the data
        var modelFit: statsmodels.ARIMAResult = model.fit();

        return modelFit;

    } catch (err: error) {
        std.debug.warn("An error occurred: {}\n", .{err});
        return model;
    }
}
