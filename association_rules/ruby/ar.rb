class Itemset
    attr_reader :items
  
    def initialize(*items)
      @items = items
    end
  end
  
  class FrequentItemset
    attr_reader :itemset, :support
  
    def initialize(itemset, support)
      @itemset = itemset
      @support = support
    end
  end
  
  # Function to check if itemset B is a subset of itemset A
  def is_subset?(a, b)
    b.items.all? { |item_b| a.items.include?(item_b) }
  end
  
  # Function to check if an itemset is frequent
  def is_frequent?(itemset, transactions, min_support)
    count = transactions.count { |transaction| is_subset?(transaction, itemset) }
    count >= min_support
  end
  
  # Function to generate frequent itemsets
  def generate_frequent_itemsets(transactions, num_items, min_support)
    itemsets = []
  
    # Initialize with single items
    (1..num_items).each do |i|
      itemset = Itemset.new(i)
      itemsets << itemset
    end
  
    # Generate frequent itemsets
    (2..num_items).each do |k|
      new_items = []
  
      (0...itemsets.length).each do |i|
        (i + 1...itemsets.length).each do |j|
          # Create a candidate itemset
          items = itemsets[i].items + [itemsets[j].items.last]
          candidate = Itemset.new(*items)
  
          # Check if the candidate itemset is frequent
          if is_frequent?(candidate, transactions, min_support)
            new_items << candidate
          end
        end
      end
  
      # Copy the new itemsets
      itemsets.concat(new_items)
    end
  
    # Print frequent itemsets
    itemsets.each do |itemset|
      puts "Itemset: #{itemset.items.join(', ')}"
    end
  end
  
  num_transactions = 5
  num_items = 4
  min_support = 2
  
  # Create a sample dataset
  transactions = [
    Itemset.new(1, 2, 3),
    Itemset.new(2, 3),
    Itemset.new(1, 3, 4),
    Itemset.new(1, 3),
    Itemset.new(1, 2, 3)
  ]
  
  generate_frequent_itemsets(transactions, num_items, min_support)
  