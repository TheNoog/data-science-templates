struct Itemset
    items::Vector{Int}
end

struct FrequentItemset
    itemset::Itemset
    support::Int
end

# Function to check if itemset B is a subset of itemset A
function isSubset(A::Itemset, B::Itemset)
    all(itemB -> in(itemB, A.items), B.items)
end

# Function to check if an itemset is frequent
function isFrequent(itemset::Itemset, transactions::Vector{Itemset}, minSupport::Int)
    count = count(transaction -> isSubset(transaction, itemset), transactions)
    count >= minSupport
end

# Function to generate frequent itemsets
function generateFrequentItemsets(transactions::Vector{Itemset}, numItems::Int, minSupport::Int)
    itemsets = Itemset[]

    # Initialize with single items
    for i in 1:numItems
        itemset = Itemset([i])
        push!(itemsets, itemset)
    end

    # Generate frequent itemsets
    for k in 2:numItems
        newItems = Itemset[]

        for i in 1:length(itemsets)
            for j in (i + 1):length(itemsets)
                # Create a candidate itemset
                candidate = Itemset(copy(itemsets[i].items))
                push!(candidate.items, last(itemsets[j].items))

                # Check if the candidate itemset is frequent
                if isFrequent(candidate, transactions, minSupport)
                    push!(newItems, candidate)
                end
            end
        end

        # Copy the new itemsets
        append!(itemsets, newItems)
    end

    # Print frequent itemsets
    for itemset in itemsets
        println("Itemset: ", itemset.items)
    end
end

numTransactions = 5
numItems = 4
minSupport = 2

# Create a sample dataset
transactions = [
    Itemset([1, 2, 3]),
    Itemset([2, 3]),
    Itemset([1, 3, 4]),
    Itemset([1, 3]),
    Itemset([1, 2, 3])
]

generateFrequentItemsets(transactions, numItems, minSupport)
