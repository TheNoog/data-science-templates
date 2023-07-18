def lda(data, n, d)
    # Initialize the coef and means arrays.
    coef = Array.new(d, 0)
    means = Array.new(d, 0)
  
    # Calculate the means of the two classes.
    for i in 0...n
      if data[i * d] == 0
        means[0] += data[i * d]
      else
        means[1] += data[i * d]
      end
    end
    means[0] /= n / 2.0
    means[1] /= n / 2.0
  
    # Calculate the coef array.
    for i in 0...d
      for j in 0...n
        if data[j * d] == 0
          coef[i] += data[j * d] - means[0]
        else
          coef[i] += data[j * d] - means[1]
        end
      end
      coef[i] /= n / 2.0
    end
  
    coef
  end
  
  # Initialize the data array.
  data = [1.0, 2.0, 0.0, 3.0, 4.0, 5.0, 1.0, 2.0, 1.0]
  n = 3
  d = 3
  
  # Calculate the coef array.
  coef = lda(data, n, d)
  
  # Print the coef array.
  p coef
  