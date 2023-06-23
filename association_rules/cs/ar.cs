using System;
using System.Collections.Generic;
using System.Linq;

// Structure to represent an itemset
struct Itemset
{
    public List<int> Items;
}

// Structure to represent a frequent itemset
struct FrequentItemset
{
    public Itemset Itemset;
    public int Support;
}

class Program
{
    // Function to check if itemset B is a subset of itemset A
    static bool IsSubset(Itemset A, Itemset B)
    {
        return B.Items.All(itemB => A.Items.Contains(itemB));
    }

    // Function to check if an itemset is frequent
    static bool IsFrequent(Itemset itemset, List<Itemset> transactions, int minSupport)
    {
        int count = 0;
        foreach (var transaction in transactions)
        {
            bool found = true;
            foreach (var item in itemset.Items)
            {
                if (!transaction.Items.Contains(item))
                {
                    found = false;
                    break;
                }
            }
            if (found)
            {
                count++;
            }
        }
        return count >= minSupport;
    }

    // Function to generate frequent itemsets
    static void GenerateFrequentItemsets(List<Itemset> transactions, int numItems, int minSupport)
    {
        List<Itemset> itemsets = new List<Itemset>();

        // Initialize with single items
        for (int i = 1; i <= numItems; i++)
        {
            Itemset itemset = new Itemset { Items = new List<int> { i } };
            itemsets.Add(itemset);
        }

        // Generate frequent itemsets
        for (int k = 2; k <= numItems; k++)
        {
            List<Itemset> newItems = new List<Itemset>();

            for (int i = 0; i < itemsets.Count; i++)
            {
                for (int j = i + 1; j < itemsets.Count; j++)
                {
                    // Create a candidate itemset
                    Itemset candidate = new Itemset();
                    candidate.Items = new List<int>(itemsets[i].Items);
                    candidate.Items.Add(itemsets[j].Items.Last());

                    // Check if the candidate itemset is frequent
                    if (IsFrequent(candidate, transactions, minSupport))
                    {
                        newItems.Add(candidate);
                    }
                }
            }

            // Copy the new itemsets
            foreach (var newItem in newItems)
            {
                itemsets.Add(newItem);
            }
        }

        // Print frequent itemsets
        foreach (var itemset in itemsets)
        {
            Console.Write("Itemset: ");
            foreach (var item in itemset.Items)
            {
                Console.Write(item + " ");
            }
            Console.WriteLine();
        }
    }

    static void Main()
    {
        int numTransactions = 5;
        int numItems = 4;
        int minSupport = 2;

        // Create a sample dataset
        List<Itemset> transactions = new List<Itemset>
        {
            new Itemset { Items = new List<int> { 1, 2, 3 } },
            new Itemset { Items = new List<int> { 2, 3 } },
            new Itemset { Items = new List<int> { 1, 3, 4 } },
            new Itemset { Items = new List<int> { 1, 3 } },
            new Itemset { Items = new List<int> { 1, 2, 3 } }
        };

        GenerateFrequentItemsets(transactions, numItems, minSupport);
    }
}
