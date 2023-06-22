#!/usr/bin/python3

from statsmodels.tsa.arima.model import ARIMA

def fit_arima_model(data, order):
    """
    Fits an ARIMA model to the given time series data.

    Parameters:
    - data (array-like): The time series data to fit the model to.
    - order (tuple): The order of the ARIMA model in the format (p, d, q),
                    where p is the order of the autoregressive (AR) component,
                    d is the order of differencing, and q is the order of the
                    moving average (MA) component.

    Returns:
    - model: The fitted ARIMA model.

    """
    try:
        # Create the ARIMA model
        model = ARIMA(data, order=order)

        # Fit the model to the data
        model_fit = model.fit()

        return model_fit

    except Exception as e:
        print("An error occurred:", str(e))


# Example usage
data = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
order = (1, 0, 1)

model = fit_arima_model(data, order)
