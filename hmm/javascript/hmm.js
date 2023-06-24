function forwardAlgorithm(observations, initialProb, transitionProb, emissionProb) {
    const numObservations = observations.length;
    const alpha = new Array(numObservations).fill(null).map(() => new Array(NUM_STATES));
  
    // Initialize alpha values for the first observation
    for (let state = 0; state < NUM_STATES; state++) {
      alpha[0][state] = initialProb[state] * emissionProb[state][observations[0]];
    }
  
    // Recursion: compute alpha values for subsequent observations
    for (let t = 1; t < numObservations; t++) {
      for (let state = 0; state < NUM_STATES; state++) {
        alpha[t][state] = 0.0;
        for (let prevState = 0; prevState < NUM_STATES; prevState++) {
          alpha[t][state] += alpha[t-1][prevState] * transitionProb[prevState][state];
        }
        alpha[t][state] *= emissionProb[state][observations[t]];
      }
    }
  
    // Compute the probability of the observations
    let prob = 0.0;
    for (let state = 0; state < NUM_STATES; state++) {
      prob += alpha[numObservations-1][state];
    }
  
    // Print the probability of the observations
    console.log(`Probability of the observations: ${prob}`);
  }
  
  const NUM_STATES = 2;
  const NUM_OBSERVATIONS = 3;
  
  const observations = [0, 1, 2];
  
  const initialProb = [0.8, 0.2];
  
  const transitionProb = [
    [0.7, 0.3],
    [0.4, 0.6]
  ];
  
  const emissionProb = [
    [0.2, 0.3, 0.5],
    [0.6, 0.3, 0.1]
  ];
  
  forwardAlgorithm(observations, initialProb, transitionProb, emissionProb);
  