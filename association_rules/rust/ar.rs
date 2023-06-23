struct Itemset {
    items: Vec<u32>,
}

struct FrequentItemset {
    itemset: Itemset,
    support: u32,
}

impl Itemset {
    fn new(items: Vec<u32>) -> Itemset {
        Itemset { items }
    }
}

impl FrequentItemset {
    fn new(itemset: Itemset, support: u32) -> FrequentItemset {
        FrequentItemset { itemset, support }
    }
}

fn is_subset(a: &Itemset, b: &Itemset) -> bool {
    b.items.iter().all(|item_b| a.items.contains(item_b))
}

fn is_frequent(itemset: &Itemset, transactions: &[Itemset], min_support: u32) -> bool {
    let count = transactions.iter().filter(|transaction| is_subset(transaction, itemset)).count();
    count as u32 >= min_support
}

fn generate_frequent_itemsets(transactions: &[Itemset], num_items: u32, min_support: u32) {
    let mut itemsets = Vec::new();

    // Initialize with single items
    for i in 1..=num_items {
        let itemset = Itemset::new(vec![i]);
        itemsets.push(itemset);
    }

    // Generate frequent itemsets
    for k in 2..=num_items {
        let mut new_items = Vec::new();

        for i in 0..itemsets.len() {
            for j in (i + 1)..itemsets.len() {
                // Create a candidate itemset
                let mut candidate_items = itemsets[i].items.clone();
                candidate_items.push(*itemsets[j].items.last().unwrap());
                let candidate = Itemset::new(candidate_items);

                // Check if the candidate itemset is frequent
                if is_frequent(&candidate, transactions, min_support) {
                    new_items.push(candidate);
                }
            }
        }

        // Copy the new itemsets
        itemsets.extend(new_items);
    }

    // Print frequent itemsets
    for itemset in itemsets {
        println!("Itemset: {:?}", itemset.items);
    }
}

fn main() {
    let num_transactions = 5;
    let num_items = 4;
    let min_support = 2;

    // Create a sample dataset
    let transactions = vec![
        Itemset::new(vec![1, 2, 3]),
        Itemset::new(vec![2, 3]),
        Itemset::new(vec![1, 3, 4]),
        Itemset::new(vec![1, 3]),
        Itemset::new(vec![1, 2, 3]),
    ];

    generate_frequent_itemsets(&transactions, num_items, min_support);
}
