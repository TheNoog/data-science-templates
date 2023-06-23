% Input features
x = [1, 2, 3, 4, 5];
% Target variable
y = [2, 4, 5, 4, 6];

% Calculate the slope (beta1)
meanX = mean(x);
meanY = mean(y);
numerator = sum((x - meanX) .* (y - meanY));
denominator = sum((x - meanX) .^ 2);
slope = numerator / denominator;

% Calculate the intercept (beta0)
intercept = meanY - slope * meanX;

% New input features
newX = [6, 7];

fprintf('Input\tPredicted Output\n');
for i = 1:numel(newX)
    % Make predictions
    yPred = slope * newX(i) + intercept;
    fprintf('%d\t%.2f\n', newX(i), yPred);
end
