function LDA(data, n, d, coef, means)
    coef = zeros(d)
    means = zeros(d)

    for i in 1:n
        if data[i * d] == 0
            means[1] += data[i * d]
        else
            means[0] += data[i * d]
        end
    end
    means[0] /= n / 2.0
    means[1] /= n / 2.0

    for i in 1:d
        for j in 1:n
            if data[j * d] == 0
                coef[i] += data[j * d] - means[0]
            else
                coef[i] += data[j * d] - means[1]
            end
        end
        coef[i] /= n / 2.0
    end

    return coef
end

data = [1.0, 2.0, 0.0, 3.0, 4.0, 5.0, 1.0, 2.0, 1.0]
n = 3
d = 3

coef = LDA(data, n, d, [], [])

println(coef)
