import pandas as pd

import matplotlib.pyplot as plt

df = pd.read_csv("data/sales_data.csv")

print("Dataset Shape:")
print(df.shape)

print("\nColumn Names:")
print(df.columns)

print("\nData Information:")
print(df.info())

print("\nMissing Values:")
print(df.isnull().sum())

print("\nDuplicate Orders:")
print(df["Order_ID"].duplicated().sum())

df["Order_Date"] = pd.to_datetime(df["Order_Date"], format="%d-%m-%Y")

print("\nData Types After Date Conversion:")
print(df.dtypes)

df["Calculated_Sales"] = df["Quantity"] * df["Unit_Price"]

print("\nSales Amount Check:")
print((df["Sales_Amount"] == df["Calculated_Sales"]).all())

print("\nTotal Sales:")
print(df["Sales_Amount"].sum())

print("\nTotal Quantity Sold:")
print(df["Quantity"].sum())

average_order_value =  df["Sales_Amount"].sum()/df["Order_ID"].nunique()

print("\nAverage order value:")
print(average_order_value)

product_sales = df.groupby("Product")["Sales_Amount"].sum().sort_values(ascending = False)

print("\nSales by Product:")
print(product_sales)

region_sales = df.groupby("Region")["Sales_Amount"].sum().sort_values(ascending = False)

print("\nSales by Region:")
print(region_sales)

category_sales = df.groupby("Category")["Sales_Amount"].sum().sort_values(ascending=False)

print("\nSales by Category:")
print(category_sales)

customer_sales = df.groupby("Customer_Name")["Sales_Amount"].sum().sort_values(ascending = False)

print("\nSales by Customer:")
print(customer_sales)

salesperson_sales = df.groupby("Salesperson")["Sales_Amount"].sum().sort_values(ascending=False)

print("\nSales by Salesperson:")
print(salesperson_sales)

payment_sales = df.groupby("Payment_Method")["Sales_Amount"].sum().sort_values(ascending=False)

print("\nSales by Payment Method:")
print(payment_sales)

monthly_sales = df.groupby(df["Order_Date"].dt.to_period("M"))["Sales_Amount"].sum()

print("\nMonthly Sales:")
print(monthly_sales)

daily_sales = df.groupby("Order_Date")["Sales_Amount"].sum().sort_values(ascending=False)

print("\nTop Sales Days:")
print(daily_sales.head(10))

product_quantity = df.groupby("Product")["Quantity"].sum().sort_values(ascending=False)

print("\nQuantity Sold by Product:")
print(product_quantity)

region_aov = df.groupby("Region")["Sales_Amount"].mean().sort_values(ascending=False)

print("\nAverage Order Value by Region:")
print(region_aov)

region_salesperson = (
    df.groupby(["Region", "Salesperson"])["Sales_Amount"]
    .sum()
    .reset_index()
)

top_salesperson_by_region = (
    region_salesperson.loc[
        region_salesperson.groupby("Region")["Sales_Amount"].idxmax()
    ]
)

print("\nTop Salesperson in Each Region:")
print(top_salesperson_by_region)

salesperson_quantity = (
    df.groupby("Salesperson")["Quantity"]
    .sum()
    .sort_values(ascending=False)
)

print("\nQuantity Sold by Salesperson:")
print(salesperson_quantity)

region_payment = (
    df.groupby(["Region", "Payment_Method"])["Sales_Amount"]
    .sum()
    .reset_index()
)

top_payment_by_region = (
    region_payment.loc[
        region_payment.groupby("Region")["Sales_Amount"].idxmax()
    ]
)

print("\nTop Payment Method in Each Region:")
print(top_payment_by_region)

monthly_sales = df.groupby(
    df["Order_Date"].dt.to_period("M")
)["Sales_Amount"].sum()

monthly_growth = monthly_sales.pct_change() * 100

print("\nMonthly Sales Growth (%):")
print(monthly_growth)

monthly_sales = df.groupby(
    df["Order_Date"].dt.to_period("M")
)["Sales_Amount"].sum()

monthly_sales.index = monthly_sales.index.astype(str)

plt.figure(figsize=(8, 5))
plt.plot(monthly_sales.index, monthly_sales.values, marker="o")

plt.title("Monthly Sales Trend")
plt.xlabel("Month")
plt.ylabel("Sales Amount")
plt.grid(True)

plt.show()

product_sales = df.groupby("Product")["Sales_Amount"].sum().sort_values(ascending=False)

plt.figure(figsize=(9, 5))
plt.bar(product_sales.index, product_sales.values)

plt.title("Sales by Product")
plt.xlabel("Product")
plt.ylabel("Sales Amount")
plt.xticks(rotation=45)
plt.grid(axis="y")

plt.show()

# Visualization 3: Sales by Region

region_sales = df.groupby("Region")["Sales_Amount"].sum().sort_values(ascending=False)

plt.figure(figsize=(8, 5))
plt.bar(region_sales.index, region_sales.values)

plt.title("Sales by Region")
plt.xlabel("Region")
plt.ylabel("Sales Amount")
plt.grid(axis="y")

plt.show()

# Visualization 4: Sales by Category

category_sales = df.groupby("Category")["Sales_Amount"].sum()

plt.figure(figsize=(7, 7))
plt.pie(
    category_sales.values,
    labels=category_sales.index,
    autopct="%1.1f%%",
    startangle=90
)

plt.title("Sales by Category")

plt.show()

# Visualization 5: Sales by Salesperson

salesperson_sales = (
    df.groupby("Salesperson")["Sales_Amount"]
    .sum()
    .sort_values(ascending=False)
)

plt.figure(figsize=(8, 5))
plt.bar(salesperson_sales.index, salesperson_sales.values)

plt.title("Sales by Salesperson")
plt.xlabel("Salesperson")
plt.ylabel("Sales Amount")
plt.grid(axis="y")

plt.show()

# Visualization 6: Sales by Payment Method

payment_sales = (
    df.groupby("Payment_Method")["Sales_Amount"]
    .sum()
    .sort_values(ascending=False)
)

plt.figure(figsize=(8, 5))
plt.bar(payment_sales.index, payment_sales.values)

plt.title("Sales by Payment Method")
plt.xlabel("Payment Method")
plt.ylabel("Sales Amount")
plt.grid(axis="y")

plt.show()

# Visualization 7: Quantity Sold by Product

product_quantity = (
    df.groupby("Product")["Quantity"]
    .sum()
    .sort_values(ascending=False)
)

plt.figure(figsize=(9, 5))
plt.bar(product_quantity.index, product_quantity.values)

plt.title("Quantity Sold by Product")
plt.xlabel("Product")
plt.ylabel("Quantity Sold")
plt.xticks(rotation=45)
plt.grid(axis="y")

plt.show()

# Visualization 8: Sales by Customer

customer_sales = (
    df.groupby("Customer_Name")["Sales_Amount"]
    .sum()
    .sort_values(ascending=True)
)

plt.figure(figsize=(9, 6))
plt.barh(customer_sales.index, customer_sales.values)

plt.title("Sales by Customer")
plt.xlabel("Sales Amount")
plt.ylabel("Customer")

plt.grid(axis="x")

plt.show()

# Visualization 9: Average Order Value by Region

region_aov = (
    df.groupby("Region")["Sales_Amount"]
    .mean()
    .sort_values(ascending=False)
)

plt.figure(figsize=(8, 5))
plt.bar(region_aov.index, region_aov.values)

plt.title("Average Order Value by Region")
plt.xlabel("Region")
plt.ylabel("Average Order Value")

plt.grid(axis="y")

plt.show()

# Visualization 10: Top 10 Sales Days

daily_sales = (
    df.groupby("Order_Date")["Sales_Amount"]
    .sum()
    .sort_values(ascending=False)
    .head(10)
    .sort_values(ascending=True)
)

plt.figure(figsize=(9, 6))
plt.barh(daily_sales.index.astype(str), daily_sales.values)

plt.title("Top 10 Sales Days")
plt.xlabel("Sales Amount")
plt.ylabel("Order Date")

plt.grid(axis="x")

plt.show()