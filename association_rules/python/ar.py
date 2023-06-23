from mlxtend.frequent_patterns import apriori
from mlxtend.frequent_patterns import association_rules
import pandas as pd

# Create a sample dataset
data = {'TransactionID': [1, 1, 1, 2, 2, 3, 3, 4, 4, 4, 5, 5, 5],
        'Item': ['Milk', 'Bread', 'Butter', 'Milk', 'Bread', 'Milk', 'Diapers', 'Milk', 'Bread', 'Diapers', 'Milk', 'Bread', 'Butter']}
df = pd.DataFrame(data)

# Convert the dataset into a one-hot encoded format
one_hot_encoded = pd.get_dummies(df['Item'])

# Concatenate the one-hot encoded dataframe with the original dataframe
df_encoded = pd.concat([df['TransactionID'], one_hot_encoded], axis=1)

# Generate frequent itemsets using the Apriori algorithm
frequent_itemsets = apriori(df_encoded.drop('TransactionID', axis=1), min_support=0.2, use_colnames=True)

# Generate association rules from the frequent itemsets
association_rules = association_rules(frequent_itemsets, metric='confidence', min_threshold=0.7)

# Print the association rules
print(association_rules)
