import pandas as pd

# Read the CSV file
file_path = 'us-cities-table.csv'
columns_to_read = ['name', 'pop2023', 'usps']
df = pd.read_csv(file_path, usecols=columns_to_read)

# Filter rows where usps='CA'
ca_data = df[df['usps'] == 'CA']

# Randomly select ten values from the filtered data
selected_rows = ca_data.sample(n=10)

# Sort by the 'pop2023' attribute in descending order
sorted_df = selected_rows.sort_values(by='pop2023', ascending=False)
print(sorted_df)

filtered_data = sorted_df[sorted_df['pop2023'] > 600000]
print(filtered_data)

