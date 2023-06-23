class Itemset {
    constructor(...items) {
      this.items = items;
    }
  }
  
  class FrequentItemset {
    constructor(itemset, support) {
      this.itemset = itemset;
      this.support = support;
    }
  }
  
  // Function to check if itemset B is a subset of itemset A
  function isSubset(A, B) {
    return B.items.every((itemB) => A.items.includes(itemB));
  }
  
  // Function to check if an itemset is frequent
  function isFrequent(itemset, transactions, minSupport) {
    const count = transactions.filter((transaction) => isSubset(transaction, itemset)).length;
    return count >= minSupport;
  }
  
  // Function to generate frequent itemsets
  function generateFrequentItemsets(transactions, numItems, minSupport) {
    const itemsets = [];
  
    // Initialize with single items
    for (let i = 1; i <= numItems; i++) {
      const itemset = new Itemset(i);
      itemsets.push(itemset);
    }
  
    // Generate frequent itemsets
    for (let k = 2; k <= numItems; k++) {
      const newItems = [];
  
      for (let i = 0; i < itemsets.length; i++) {
        for (let j = i + 1; j < itemsets.length; j++) {
          // Create a candidate itemset
          const items = [...itemsets[i].items, itemsets[j].items[itemsets[j].items.length - 1]];
          const candidate = new Itemset(...items);
  
          // Check if the candidate itemset is frequent
          if (isFrequent(candidate, transactions, minSupport)) {
            newItems.push(candidate);
          }
        }
      }
  
      // Copy the new itemsets
      itemsets.push(...newItems);
    }
  
    // Print frequent itemsets
    for (const itemset of itemsets) {
      console.log(`Itemset: ${itemset.items}`);
    }
  }
  
  const numTransactions = 5;
  const numItems = 4;
  const minSupport = 2;
  
  // Create a sample dataset
  const transactions = [
    new Itemset(1, 2, 3),
    new Itemset(2, 3),
    new Itemset(1, 3, 4),
    new Itemset(1, 3),
    new Itemset(1, 2, 3),
  ];
  
  generateFrequentItemsets(transactions, numItems, minSupport);
  