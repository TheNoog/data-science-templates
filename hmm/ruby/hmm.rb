def forward_algorithm(observations, initial_prob, transition_prob, emission_prob)
    num_observations = observations.length
    alpha = Array.new(num_observations) { Array.new(NUM_STATES, 0.0) }
  
    # Initialize alpha values for the first observation
    NUM_STATES.times do |state|
      alpha[0][state] = initial_prob[state] * emission_prob[state][observations[0]]
    end
  
    # Recursion: compute alpha values for subsequent observations
    (1...num_observations).each do |t|
      NUM_STATES.times do |state|
        alpha[t][state] = 0.0
        NUM_STATES.times do |prev_state|
          alpha[t][state] += alpha[t-1][prev_state] * transition_prob[prev_state][state]
        end
        alpha[t][state] *= emission_prob[state][observations[t]]
      end
    end
  
    # Compute the probability of the observations
    prob = alpha[num_observations - 1].sum
  
    # Print the probability of the observations
    puts "Probability of the observations: #{prob}"
  end
  
  NUM_STATES = 2
  NUM_OBSERVATIONS = 3
  
  observations = [0, 1, 2]
  
  initial_prob = [0.8, 0.2]
  
  transition_prob = [
    [0.7, 0.3],
    [0.4, 0.6]
  ]
  
  emission_prob = [
    [0.2, 0.3, 0.5],
    [0.6, 0.3, 0.1]
  ]
  
  forward_algorithm(observations, initial_prob, transition_prob, emission_prob)
  