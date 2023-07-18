function coef = LDA(data, n, d)
% LDA Calculates the discriminant function coefficients for linear discriminant analysis

% Initialize the coef array.
coef = zeros(d, 1);

% Calculate the means of the two classes.
means = [0;0];
for i = 1:n
    if data(i, d) == 0
        means(1) += data(i, 1:d-1);
    else
        means(2) += data(i, 1:d-1);
    end
end
means(1) /= n/2;
means(2) /= n/2;

% Calculate the coef array.
for i = 1:d
    for j = 1:n
        if data(j, d) == 0
            coef(i) += data(j, i) - means(1);
        else
            coef(i) += data(j, i) - means(2);
        end
    end
    coef(i) /= n/2;
end

end

% Initialize the data array.
data = [1.0, 2.0, 0.0, 3.0, 4.0, 5.0, 1.0, 2.0, 1.0];
n = 3;
d = 3;

% Calculate the coef array.
coef = LDA(data, n, d);

% Print the coef array.
coef
