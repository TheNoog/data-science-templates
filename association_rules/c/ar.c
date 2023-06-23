#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

// Structure to represent an itemset
typedef struct {
    int* items;
    int length;
} Itemset;

// Structure to represent a frequent itemset
typedef struct {
    Itemset itemset;
    int support;
} FrequentItemset;

// Function to check if itemset B is a subset of itemset A
bool isSubset(Itemset A, Itemset B) {
    for (int i = 0; i < B.length; i++) {
        bool found = false;
        for (int j = 0; j < A.length; j++) {
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
bool isFrequent(Itemset itemset, int** transactions, int numTransactions, int minSupport) {
    int count = 0;
    for (int i = 0; i < numTransactions; i++) {
        bool found = true;
        for (int j = 0; j < itemset.length; j++) {
            bool itemFound = false;
            for (int k = 0; k < transactions[i][0]; k++) {
                if (transactions[i][k + 1] == itemset.items[j]) {
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
void generateFrequentItemsets(int** transactions, int numTransactions, int numItems, int minSupport) {
    Itemset* itemsets = (Itemset*)malloc(sizeof(Itemset) * numItems);
    int numItemsets = 0;

    // Initialize with single items
    for (int i = 1; i <= numItems; i++) {
        Itemset itemset;
        itemset.items = (int*)malloc(sizeof(int));
        itemset.items[0] = i;
        itemset.length = 1;
        itemsets[numItemsets++] = itemset;
    }

    // Generate frequent itemsets
    for (int k = 2; k <= numItems; k++) {
        Itemset* newItems = (Itemset*)malloc(sizeof(Itemset) * numItems);
        int numNewItems = 0;

        for (int i = 0; i < numItemsets; i++) {
            for (int j = i + 1; j < numItemsets; j++) {
                // Create a candidate itemset
                Itemset candidate;
                candidate.items = (int*)malloc(sizeof(int) * (itemsets[i].length + 1));

                // Add items from the first itemset
                for (int m = 0; m < itemsets[i].length; m++) {
                    candidate.items[m] = itemsets[i].items[m];
                }

                // Add the last item from the second itemset
                candidate.items[itemsets[i].length] = itemsets[j].items[itemsets[j].length - 1];
                candidate.length = itemsets[i].length + 1;

                // Check if the candidate itemset is frequent
                if (isFrequent(candidate, transactions, numTransactions, minSupport)) {
                    newItems[numNewItems++] = candidate;
                } else {
                    free(candidate.items);
                }
            }
        }

        // Copy the new itemsets
        for (int i = 0; i < numNewItems; i++) {
            itemsets[numItemsets++] = newItems[i];
        }

        free(newItems);
    }

    // Print frequent itemsets
    for (int i = 0; i < numItemsets; i++) {
        printf("Itemset: ");
        for (int j = 0; j < itemsets[i].length; j++) {
            printf("%d ", itemsets[i].items[j]);
        }
        printf("\n");
    }

    // Clean up
    for (int i = 0; i < numItemsets; i++) {
        free(itemsets[i].items);
    }
    free(itemsets);
}

int main() {
    int numTransactions = 5;
    int numItems = 4;
    int minSupport = 2;

    // Create a sample dataset
    int** transactions = (int**)malloc(sizeof(int*) * numTransactions);
    transactions[0] = (int[]){3, 1, 2, 3};
    transactions[1] = (int[]){2, 2, 3};
    transactions[2] = (int[]){4, 1, 3, 4};
    transactions[3] = (int[]){2, 1, 3};
    transactions[4] = (int[]){3, 1, 2, 3};

    generateFrequentItemsets(transactions, numTransactions, numItems, minSupport);

    // Clean up
    for (int i = 0; i < numTransactions; i++) {
        free(transactions[i]);
    }
    free(transactions);

    return 0;
}
