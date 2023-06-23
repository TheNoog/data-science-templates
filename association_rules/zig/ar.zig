const std = @import("std");

pub fn Itemset(comptime Items: []u32) type Itemset {
    return Itemset{ .items = Items };
}

pub fn FrequentItemset(Itemset: Itemset, Support: u32) type FrequentItemset {
    return FrequentItemset{ .itemset = Itemset, .support = Support };
}

pub fn isSubset(A: Itemset, B: Itemset) bool {
    var found = true;
    for (B.items) |item_b| {
        var itemFound = false;
        for (A.items) |item_a| {
            if (item_a == item_b) {
                itemFound = true;
                break;
            }
        }
        if (!itemFound) {
            found = false;
            break;
        }
    }
    return found;
}

pub fn isFrequent(Itemset: Itemset, Transactions: []Itemset, MinSupport: u32) bool {
    var count: u32 = 0;
    for (Transactions) |transaction| {
        if (isSubset(transaction, Itemset)) {
            count += 1;
        }
    }
    return count >= MinSupport;
}

pub fn generateFrequentItemsets(Transactions: []Itemset, NumItems: u32, MinSupport: u32) void {
    var itemsets: [0]Itemset = undefined;
    var itemsetsCount: u32 = 0;

    // Initialize with single items
    for (NumItems) |i| {
        itemsets[itemsetsCount] = Itemset(&[_]u32{i});
        itemsetsCount += 1;
    }

    // Generate frequent itemsets
    for (2..NumItems) |k| : (i) {
        var newItems: [0]Itemset = undefined;
        var newItemsCount: u32 = 0;

        for (0..itemsetsCount) |i| {
            for (i+1..itemsetsCount) |j| {
                // Create a candidate itemset
                var candidateItems: [k]u32 = undefined;
                for (0..k-1) |l| {
                    candidateItems[l] = itemsets[i].items[l];
                }
                candidateItems[k-1] = itemsets[j].items[k-1];
                const candidate = Itemset(candidateItems);

                // Check if the candidate itemset is frequent
                if (isFrequent(candidate, Transactions, MinSupport)) {
                    newItems[newItemsCount] = candidate;
                    newItemsCount += 1;
                }
            }
        }

        // Copy the new itemsets
        for (newItemsCount) |i| {
            itemsets[itemsetsCount] = newItems[i];
            itemsetsCount += 1;
        }
    }

    // Print frequent itemsets
    for (itemsetsCount) |i| {
        std.debug.print("Itemset: ");
        for (itemsets[i].items) |item| {
            std.debug.print("{d} ", .{item});
        }
        std.debug.println("");
    }
}

pub fn main() void {
    const numTransactions: u32 = 5;
    const numItems: u32 = 4;
    const minSupport: u32 = 2;

    // Create a sample dataset
    var transactions: [5]Itemset = undefined;
    transactions = &[
        Itemset(&[_]u32{1, 2, 3}),
        Itemset(&[_]u32{2, 3}),
        Itemset(&[_]u32{1, 3, 4}),
        Itemset(&[_]u32{1, 3}),
        Itemset(&[_]u32{1, 2, 3}),
    ];

    generateFrequentItemsets(transactions, numItems, minSupport);
}
