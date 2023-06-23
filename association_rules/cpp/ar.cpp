#include <iostream>
#include <vector>
#include <unordered_map>
#include <set>

// Structure to represent an itemset
struct Itemset {
    std::vector<int> items;
};

// Structure to represent a frequent itemset
struct FrequentItemset {
    Itemset itemset;
    int support;
};

// Function to check if itemset B is a subset of itemset A
bool isSubset(const Itemset& A, const Itemset& B) {
    for (int i = 0; i < B.items.size(); i++) {
        bool found = false;
        for (int j = 0; j < A.items.size(); j++) {
            if (A.items[j] == B.items[i]) {
                found = true;
                break;
            }
        }
        if (!found) {
            return false;
        }
    }
    return true;
}

// Function to check if an itemset is frequent
bool isFrequent(const Itemset& itemset, const std::vector<Itemset>& transactions, int minSupport) {
    int count = 0;
    for (const auto& transaction : transactions) {
        bool found = true;
        for (int j = 0; j < itemset.items.size(); j++) {
            bool itemFound = false;
            for (int k = 0; k < transaction.items.size(); k++) {
                if (transaction.items[k] == itemset.items[j]) {
                    itemFound = true;
                    break;
                }
            }
            if (!itemFound) {
                found = false;
                break;
            }
        }
        if (found) {
            count++;
        }
    }
    return count >= minSupport;
}

// Function to generate frequent itemsets
void generateFrequentItemsets(const std::vector<Itemset>& transactions, int numItems, int minSupport) {
    std::vector<Itemset> itemsets;

    // Initialize with single items
    for (int i = 1; i <= numItems; i++) {
        Itemset itemset;
        itemset.items.push_back(i);
        itemsets.push_back(itemset);
    }

    // Generate frequent itemsets
    for (int k = 2; k <= numItems; k++) {
        std::vector<Itemset> newItems;

        for (int i = 0; i < itemsets.size(); i++) {
            for (int j = i + 1; j < itemsets.size(); j++) {
                // Create a candidate itemset
                Itemset candidate;
                candidate.items = itemsets[i].items;

                // Add the last item from the second itemset
                candidate.items.push_back(itemsets[j].items.back());

                // Check if the candidate itemset is frequent
                if (isFrequent(candidate, transactions, minSupport)) {
                    newItems.push_back(candidate);
                }
            }
        }

        // Copy the new itemsets
        for (const auto& newItem : newItems) {
            itemsets.push_back(newItem);
        }
    }

    // Print frequent itemsets
    for (const auto& itemset : itemsets) {
        std::cout << "Itemset: ";
        for (const auto& item : itemset.items) {
            std::cout << item << " ";
        }
        std::cout << std::endl;
    }
}

int main() {
    int numTransactions = 5;
    int numItems = 4;
    int minSupport = 2;

    // Create a sample dataset
    std::vector<Itemset> transactions = {
        {{1, 2, 3}},
        {{2, 3}},
        {{1, 3, 4}},
        {{1, 3}},
        {{1, 2, 3}}
    };

    generateFrequentItemsets(transactions, numItems, minSupport);

    return 0;
}
