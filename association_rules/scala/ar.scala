case class Itemset(items: List[Int])

case class FrequentItemset(itemset: Itemset, support: Int)

def isSubset(a: Itemset, b: Itemset): Boolean =
  b.items.forall(a.items.contains)

def isFrequent(itemset: Itemset, transactions: List[Itemset], minSupport: Int): Boolean = {
  val count = transactions.count(t => isSubset(t, itemset))
  count >= minSupport
}

def generateFrequentItemsets(transactions: List[Itemset], numItems: Int, minSupport: Int): Unit = {
  var itemsets = List.empty[Itemset]

  // Initialize with single items
  for (i <- 1 to numItems) {
    val itemset = Itemset(List(i))
    itemsets ::= itemset
  }

  // Generate frequent itemsets
  for (k <- 2 to numItems) {
    var newItems = List.empty[Itemset]

    for (i <- 0 until itemsets.length) {
      for (j <- (i + 1) until itemsets.length) {
        // Create a candidate itemset
        val candidateItems = itemsets(i).items ++ List(itemsets(j).items.last)
        val candidate = Itemset(candidateItems)

        // Check if the candidate itemset is frequent
        if (isFrequent(candidate, transactions, minSupport)) {
          newItems ::= candidate
        }
      }
    }

    // Copy the new itemsets
    itemsets :::= newItems
  }

  // Print frequent itemsets
  itemsets.foreach(itemset => println("Itemset: " + itemset.items.mkString(", ")))
}

val numTransactions = 5
val numItems = 4
val minSupport = 2

// Create a sample dataset
val transactions = List(
  Itemset(List(1, 2, 3)),
  Itemset(List(2, 3)),
  Itemset(List(1, 3, 4)),
  Itemset(List(1, 3)),
  Itemset(List(1, 2, 3))
)

generateFrequentItemsets(transactions, numItems, minSupport)
