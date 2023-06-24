defmodule HiddenMarkovModel do
  @states 2
  @observations 3

  def forward_algorithm(observations, initial_prob, transition_prob, emission_prob) do
    num_observations = length(observations)
    alpha = :array.new(fn _ -> :array.new(fn _ -> 0.0 end, @states) end, num_observations)

    # Initialize alpha values for the first observation
    for state <- 0..@states-1 do
      alpha = :array.put(alpha, {0, state}, initial_prob[state] * emission_prob[state][List.first(observations)])
    end

    # Recursion: compute alpha values for subsequent observations
    for t <- 1..num_observations-1 do
      for state <- 0..@states-1 do
        current_alpha = :array.get(alpha, {t, state})
        new_alpha = Enum.reduce(0..@states-1, current_alpha, fn prev_state, acc ->
          prev_alpha = :array.get(alpha, {t-1, prev_state})
          acc + prev_alpha * transition_prob[prev_state][state]
        end)
        alpha = :array.put(alpha, {t, state}, new_alpha * emission_prob[state][List.to_tuple(List.delete_first(observations))])
      end
    end

    # Compute the probability of the observations
    prob = Enum.reduce(0..@states-1, 0.0, fn state, acc ->
      acc + :array.get(alpha, {num_observations-1, state})
    end)

    # Print the probability of the observations
    IO.puts("Probability of the observations: #{prob}")
  end
end

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

HiddenMarkovModel.forward_algorithm(observations, initial_prob, transition_prob, emission_prob)
