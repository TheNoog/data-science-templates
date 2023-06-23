defmodule AssociationRules do
  # Function to check if itemset B is a subset of itemset A
  def is_subset(a, b) do
    Enum.all?(b, &Enum.member?(a, &1))
  end

  # Function to check if an itemset is frequent
  def is_frequent(itemset, transactions, min_support) do
    count = Enum.count(transactions, fn transaction ->
      Enum.all?(itemset, &Enum.member?(transaction, &1))
    end)
    count >= min_support
  end

  # Function to generate frequent itemsets
  def generate_frequent_itemsets(transactions, num_items, min_support) do
    itemsets = Enum.map(1..num_items, fn item ->
      [item]
    end)

    for k <- 2..num_items do
      new_items = for i <- 0..length(itemsets) - 1, j <- i + 1..length(itemsets) - 1 do
        candidate = itemsets[i] ++ [hd(itemsets[j])]
        if is_frequent(candidate, transactions, min_support) do
          candidate
        end
      end
      itemsets = itemsets ++ new_items
    end

    Enum.each(itemsets, fn itemset ->
      IO.puts("Itemset: #{inspect itemset}")
    end)
  end
end

# Define the transactions
transactions = [
  [1, 2, 3],
  [2, 3],
  [1, 3, 4],
  [1, 3],
  [1, 2, 3]
]

# Set the minimum support and number of items
min_support = 2
num_items = 4

# Generate frequent itemsets
AssociationRules.generate_frequent_itemsets(transactions, num_items, min_support)
