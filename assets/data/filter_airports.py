import pandas as pd
import json

# Read CSV (go up one directory to database/)
df = pd.read_csv('../airports.csv')

# Filter: only airports with IATA codes and commercial types
df = df[df['iata_code'].notna()]
df = df[df['iso_country'].notna()]
df = df[df['municipality'].notna()]
df = df[df['type'].isin(['large_airport', 'medium_airport'])]

# Keep only needed columns
df = df[['iata_code', 'name', 'municipality', 'iso_country']]

# Convert to JSON
result = df.to_dict('records')

# Save in database/ directory (go up one level)
with open('../airports.json', 'w') as f:
    json.dump(result, f, indent=2)

print(f"Filtered {len(result)} airports")
