package main

import (
	"fmt"
	"sort"
)

// Structure to represent an itemset
type Itemset struct {
	Items []int
}

// Structure to represent a frequent itemset
type FrequentItemset struct {
	Itemset Itemset
	Support int
}

// Function to check if itemset B is a subset of itemset A
func isSubset(A, B Itemset) bool {
	for _, itemB := range B.Items {
		found := false
		for _, itemA := range A.Items {
			if itemA == itemB {
				found = true
				break
			}
		}
		if !found {
			return false
		}
	}
	return true
}

// Function to check if an itemset is frequent
func isFrequent(itemset Itemset, transactions []Itemset, minSupport int) bool {
	count := 0
	for _, transaction := range transactions {
		found := true
		for _, item := range itemset.Items {
			itemFound := false
			for _, tItem := range transaction.Items {
				if tItem == item {
					itemFound = true
					break
				}
			}
			if !itemFound {
				found = false
				break
			}
		}
		if found {
			count++
		}
	}
	return count >= minSupport
}

// Function to generate frequent itemsets
func generateFrequentItemsets(transactions []Itemset, numItems, minSupport int) {
	itemsets := make([]Itemset, 0)

	// Initialize with single items
	for i := 1; i <= numItems; i++ {
		itemset := Itemset{Items: []int{i}}
		itemsets = append(itemsets, itemset)
	}

	// Generate frequent itemsets
	for k := 2; k <= numItems; k++ {
		newItems := make([]Itemset, 0)

		for i := 0; i < len(itemsets); i++ {
			for j := i + 1; j < len(itemsets); j++ {
				// Create a candidate itemset
				candidate := Itemset{Items: append([]int(nil), itemsets[i].Items...)}
				candidate.Items = append(candidate.Items, itemsets[j].Items[len(itemsets[j].Items)-1])

				// Check if the candidate itemset is frequent
				if isFrequent(candidate, transactions, minSupport) {
					newItems = append(newItems, candidate)
				}
			}
		}

		// Copy the new itemsets
		itemsets = append(itemsets, newItems...)
	}

	// Print frequent itemsets
	for _, itemset := range itemsets {
		fmt.Printf("Itemset: %v\n", itemset.Items)
	}
}

func main() {
	numTransactions := 5
	numItems := 4
	minSupport := 2

	// Create a sample dataset
	transactions := []Itemset{
		{Items: []int{1, 2, 3}},
		{Items: []int{2, 3}},
		{Items: []int{1, 3, 4}},
		{Items: []int{1, 3}},
		{Items: []int{1, 2, 3}},
	}

	// Sort the items in each transaction
	for i := range transactions {
		sort.Ints(transactions[i].Items)
	}

	generateFrequentItemsets(transactions, numItems, minSupport)
}
