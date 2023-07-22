using System;

public class SVM
{
  public int C;
  public string Kernel;
  public double[] W;
  public double B;

  public SVM(int c, string kernel)
  {
    C = c;
    Kernel = kernel;
    W = new double[2];
    B = 0.0;
  }

  public void Fit(double[][] X, int[] y, int n)
  {
    for (int i = 0; i < n; i++)
    {
      double score = 0.0;
      for (int j = 0; j < 2; j++)
      {
        score += W[j] * X[i][j];
      }
      if (y[i] * score + B <= 1.0)
      {
        for (int j = 0; j < 2; j++)
        {
          W[j] += C * y[i] * X[i][j];
        }
        B += C * y[i];
      }
    }
  }

  public int Predict(double[] X)
  {
    double score = 0.0;
    for (int j = 0; j < 2; j++)
    {
      score += W[j] * X[j];
    }
    return score >= 0.0 ? 1 : -1;
  }
}
