package association_rules.java;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

class Itemset {
    private List<Integer> items;

    public Itemset(Integer... items) {
        this.items = Arrays.asList(items);
    }

    public List<Integer> getItems() {
        return items;
    }
}

class FrequentItemset {
    private Itemset itemset;
    private int support;

    public FrequentItemset(Itemset itemset, int support) {
        this.itemset = itemset;
        this.support = support;
    }

    public Itemset getItemset() {
        return itemset;
    }

    public int getSupport() {
        return support;
    }
}

public class AssociationRules {
    // Function to check if itemset B is a subset of itemset A
    private static boolean isSubset(Itemset A, Itemset B) {
        return A.getItems().containsAll(B.getItems());
    }

    // Function to check if an itemset is frequent
    private static boolean isFrequent(Itemset itemset, List<Itemset> transactions, int minSupport) {
        int count = (int) transactions.stream()
                .filter(transaction -> isSubset(transaction, itemset))
                .count();
        return count >= minSupport;
    }

    // Function to generate frequent itemsets
    private static void generateFrequentItemsets(List<Itemset> transactions, int numItems, int minSupport) {
        List<Itemset> itemsets = new ArrayList<>();

        // Initialize with single items
        for (int i = 1; i <= numItems; i++) {
            Itemset itemset = new Itemset(i);
            itemsets.add(itemset);
        }

        // Generate frequent itemsets
        for (int k = 2; k <= numItems; k++) {
            List<Itemset> newItems = new ArrayList<>();

            for (int i = 0; i < itemsets.size(); i++) {
                for (int j = i + 1; j < itemsets.size(); j++) {
                    // Create a candidate itemset
                    List<Integer> items = new ArrayList<>(itemsets.get(i).getItems());
                    items.add(itemsets.get(j).getItems().get(itemsets.get(j).getItems().size() - 1));
                    Itemset candidate = new Itemset(items.toArray(Integer[]::new));

                    // Check if the candidate itemset is frequent
                    if (isFrequent(candidate, transactions, minSupport)) {
                        newItems.add(candidate);
                    }
                }
            }

            // Copy the new itemsets
            itemsets.addAll(newItems);
        }

        // Print frequent itemsets
        for (Itemset itemset : itemsets) {
            System.out.println("Itemset: " + itemset.getItems());
        }
    }

    public static void main(String[] args) {
        int numTransactions = 5;
        int numItems = 4;
        int minSupport = 2;

        // Create a sample dataset
        List<Itemset> transactions = new ArrayList<>();
        transactions.add(new Itemset(1, 2, 3));
        transactions.add(new Itemset(2, 3));
        transactions.add(new Itemset(1, 3, 4));
        transactions.add(new Itemset(1, 3));
        transactions.add(new Itemset(1, 2, 3));

        generateFrequentItemsets(transactions, numItems, minSupport);
    }
}

