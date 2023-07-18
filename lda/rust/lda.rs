fn lda(data: &[f64], n: usize, d: usize) -> Vec<f64> {
    // Initialize the coef and means arrays.
    let mut coef = vec![0.0; d];
    let mut means = vec![0.0; d];
  
    // Calculate the means of the two classes.
    for i in 0..n {
      if data[i * d] == 0.0 {
        means[0] += data[i * d];
      } else {
        means[1] += data[i * d];
      }
    }
    means[0] /= n / 2.0;
    means[1] /= n / 2.0;
  
    // Calculate the coef array.
    for i in 0..d {
      for j in 0..n {
        if data[j * d] == 0.0 {
          coef[i] += data[j * d] - means[0];
        } else {
          coef[i] += data[j * d] - means[1];
        }
      }
      coef[i] /= n / 2.0;
    }
  
    coef
  }
  
  fn main() {
    // Initialize the data array.
    let data = [1.0, 2.0, 0.0, 3.0, 4.0, 5.0, 1.0, 2.0, 1.0];
    let n = 3;
    let d = 3;
  
    // Calculate the coef array.
    let coef = lda(&data, n, d);
  
    // Print the coef array.
    for coef in coef {
      println!("{}", coef);
    }
  }
  