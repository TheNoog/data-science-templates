defmodule LDA do
  def LDA(data, n, d, coef, means) do
    coef = Enum.map(0.0, 1..d)
    means = Enum.map(0.0, 1..d)

    for i in 1..n do
      if data[i * d] == 0 do
        means[0] += data[i * d]
      else
        means[1] += data[i * d]
      end
    end

    means[0] = means[0] / n / 2.0
    means[1] = means[1] / n / 2.0

    for i in 1..d do
      for j in 1..n do
        if data[j * d] == 0 do
          coef[i] += data[j * d] - means[0]
        else
          coef[i] += data[j * d] - means[1]
        end
      end
      coef[i] = coef[i] / n / 2.0
    end

    coef
  end
end

def main do
  data = [1.0, 2.0, 0.0, 3.0, 4.0, 5.0, 1.0, 2.0, 1.0]
  n = 3
  d = 3

  coef = LDA.LDA(data, n, d, [], [])

  for i in 1..d do
    IO.puts(coef[i])
  end
end

main()
