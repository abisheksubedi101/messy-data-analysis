import pandas as pd
import numpy as np
import re

# Read the messy dataset
df = pd.read_csv('raw_data/sales_data_messy.csv')

print("Original Dataset Shape:", df.shape)
print("\nData Quality Issues Found:")

# 1. Standardize Date Formats
def clean_date(date_str):
    if pd.isna(date_str) or date_str == '':
        return None
    
    date_str = str(date_str).strip()
    
    # Remove extra text
    date_str = date_str.replace('th ', '').replace('st ', '').replace('nd ', '').replace('rd ', '')
    date_str = date_str.replace('FEBUARY', 'February').replace('FEBRARY', 'February').replace('FEB', 'February').replace('FE', 'February').replace('feb', 'February')
    date_str = date_str.replace('-O2-', '-02-').replace('O2', '02').replace(' O2 ', ' 02 ')
    
    formats = ['%d %B %Y', '%d/%m/%Y', '%d-%m-%Y', '%d.%m.%y', '%d-%b-%y', '%Y/%b/%d', '%d %b %Y', '%Y-Feb-%d']
    
    for fmt in formats:
        try:
            return pd.to_datetime(date_str, format=fmt).strftime('%Y-%m-%d')
        except:
            continue
    return None

df['Date'] = df['Date'].apply(clean_date)
print("✓ Dates standardized to YYYY-MM-DD format")

# 2. Standardize Currency Format (remove $ and USD text, extract numbers)
def clean_currency(value):
    if pd.isna(value) or value == '' or value == 0:
        return np.nan
    
    value = str(value).strip()
    value = value.replace('USD', '').replace('usd', '').replace('$', '').replace('DollaRs', '').replace('Dollars', '')
    value = value.replace(' ', '')
    
    try:
        return float(value)
    except:
        return np.nan

df['Unit_Price'] = df['Unit_Price'].apply(clean_currency)
df['Total'] = df['Total'].apply(clean_currency)
print("✓ Currency values standardized to numeric format")

# 3. Clean Customer Names (strip whitespace, proper case, remove duplicates with different case)
df['Custumer_Name'] = df['Custumer_Name'].str.strip().str.title()
df['Custumer_Name'] = df['Custumer_Name'].replace('', np.nan)
print("✓ Customer names standardized to Title Case")

# 4. Clean Product Names (strip whitespace, proper case)
df['Product'] = df['Product'].str.strip().str.title()
df['Product'] = df['Product'].replace('', np.nan)
print("✓ Product names standardized")

# 5. Clean Category (standardize case and consolidate similar categories)
def clean_category(cat):
    if pd.isna(cat) or cat == '':
        return np.nan
    
    cat = str(cat).strip().upper()
    
    # Consolidate similar categories
    category_map = {
        'MEAT$SEAFOOD': 'MEAT & SEAFOOD',
        'MEAT & SEAFOOD': 'MEAT & SEAFOOD',
        'MEAТ & SEAFOOD': 'MEAT & SEAFOOD',
        'ALCHOLIC BEVERAGE': 'ALCOHOLIC BEVERAGE',
        'ALCHOIC BEVERAGE': 'ALCOHOLIC BEVERAGE',
        'DIARY': 'DAIRY',
        'FROZEN': 'FROZEN FOODS',
        'PERSONAL CARE': 'PERSONAL CARE',
        'STATIONARY': 'STATIONERY',
        'STATIONERY': 'STATIONERY',
        'GROCERIES': 'GROCERIES',
        'HOUSEHOLD': 'HOUSEHOLD',
        'SNACKS': 'SNACKS',
        'BAKERY': 'BAKERY',
        'BEVERAGES': 'BEVERAGES',
        'VEGETABLE': 'VEGETABLES',
        'VEGETABLES': 'VEGETABLES',
        'FRUITS': 'FRUITS'
    }
    
    return category_map.get(cat, cat)

df['Category'] = df['Category'].apply(clean_category)
print("✓ Categories standardized and consolidated")

# 6. Clean Quantity (remove non-numeric characters)
def clean_quantity(qty):
    if pd.isna(qty) or qty == '':
        return np.nan
    
    qty = str(qty).strip().replace('O', '0').replace('o', '0')
    
    try:
        return int(float(qty))
    except:
        return np.nan

df['Quantity'] = df['Quantity'].apply(clean_quantity)
print("✓ Quantities standardized to integers")

# 7. Clean Payment Method (standardize case, consolidate similar methods)
def clean_payment(payment):
    if pd.isna(payment) or payment == '':
        return np.nan
    
    payment = str(payment).strip().upper()
    
    payment_map = {
        'CASH': 'CASH',
        'CREDIT CARD': 'CREDIT CARD',
        'DEBIT CARD': 'DEBIT CARD',
        'VENMO': 'Venmo',
        'PAYPAL': 'PayPal',
        'PAY PAL': 'PayPal',
        'GOOGLE PAY': 'Google Pay',
        'APPLE PAY': 'Apple Pay',
        'BANK TRANSFER': 'Bank Transfer',
        'CSASH': 'CASH',
        'CAH': 'CASH',
    }
    
    return payment_map.get(payment, payment)

df['Payment_Method'] = df['Payment_Method'].apply(clean_payment)
print("✓ Payment methods standardized")

# 8. Remove duplicate rows
initial_rows = len(df)
df = df.drop_duplicates(subset=['Sales_ID', 'Date', 'Custumer_Name', 'Product', 'Quantity', 'Unit_Price', 'Total'])
print(f"✓ Removed {initial_rows - len(df)} duplicate rows")

# 9. Save cleaned dataset
df.to_csv('cleaned_data/sales_data_cleaned.csv', index=False)
print(f"\n✓ Data cleaning complete!")
print(f"Final Dataset Shape: {df.shape}")
print("\n✓ Cleaned data saved to 'cleaned_data/sales_data_cleaned.csv'")

# Print summary statistics
print("\n" + "="*50)
print("CLEANED DATA SUMMARY")
print("="*50)
print(f"\nDate Range: {df['Date'].min()} to {df['Date'].max()}")
print(f"Total Transactions: {len(df)}")
print(f"Unique Customers: {df['Custumer_Name'].nunique()}")
print(f"Unique Products: {df['Product'].nunique()}")
print(f"Unique Categories: {df['Category'].nunique()}")
print(f"\nCategories: {sorted(df['Category'].dropna().unique())}")
print(f"\nPayment Methods: {sorted(df['Payment_Method'].dropna().unique())}")
print(f"\nTotal Revenue: ${df['Total'].sum():.2f}")
