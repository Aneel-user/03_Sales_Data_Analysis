import csv
import random
from datetime import datetime, timedelta

#Dataset settings
num_rows = 100

customers = [
    "Rahul", "Priya", "Amith", "Sneha", "Arjun",
    "Neha", "Vikram", "Pooja", "Kiran", "Anjali"
]

products = {
    "Laptop": ("Electronics", 55000),
    "Mobile": ("Electronics", 25000),
    "Headphones": ("Electronics", 3000),
    "Keyboard": ("Electronics", 1500),
    "Office Chair": ("Furniture", 8000),
    "Desk": ("Furniture", 12000)
}

regions = ["South", "North", "East", "West"]

salespersons = ["Anil", "Ravi", "Suresh", "Meena", "Kavya"]

payment_methods = ["UPI", "Credit Card", "Debit Card", "Cash"]

#Starting date
start_date = datetime(2026, 1, 1)

#Create CSV file
with open("03_Sales_Data_Analysis/data/sales_data.csv", "w", newline="", encoding="utf-8") as file:

    writer = csv.writer(file)

    #Column names
    writer.writerow([
        "Order_ID",
        "Order_Date",
        "Customer_Name",
        "Product",
        "Category",
        "Quantity",
        "Unit_Price",
        "Region",
        "Salesperson",
        "Payment_Method"
    ])

    #Generate rows
    for i in range(1, num_rows + 1):

        order_id = f"ORD{1000 + i}"

        order_date = start_date + timedelta(
            days = random.randint(0, 89)
            )

        customer_name = random.choice(customers)

        product = random.choice(list(products.keys()))

        category, unit_price = products[product]

        quntity = random.randint(1, 5)

        region = random.choice(regions)

        salesperson = random.choice(salespersons)

        paymentP_method = random.choice(payment_methods)

        writer.writerow([
            order_id,
            order_date.strftime("%Y-%m-%d"),
            customer_name,
            product,
            category,
            quntity,
            unit_price,
            region,
            salesperson,
            paymentP_method
        ])

print("Sales dataset created successfully!")
print("Total rows:", num_rows)