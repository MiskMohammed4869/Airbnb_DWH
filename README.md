# Airbnb Data Warehouse 

## Project Overview

This project demonstrates the design and implementation of a Data Warehouse for Airbnb listings using the Medallion Architecture (Bronze, Silver, Gold). The project includes data validation and transformation using Python, data warehouse implementation in SQL Server using a Star Schema, and data visualization with Power BI.

---

## Technologies Used

- Python
- Pandas
- SQL Server
- SQL
- Power BI
- Git & GitHub

---

## Dataset

The project uses an Airbnb listings dataset containing information about:

- City
- Room Type
- Price
- Bedrooms
- Person Capacity
- Superhost Status
- Guest Satisfaction
- Cleanliness Rating
- Distance from City Center
- Metro Distance
- Latitude & Longitude

---

# Project Architecture

```
Raw Dataset
      │
      ▼
 Bronze Layer
      │
      ▼
 Silver Layer
      │
      ▼
 Gold Layer (Star Schema)
      │
      ▼
 Power BI Dashboard
```

---

# Bronze Layer

The raw Airbnb dataset was imported without modifications.

Tasks:

- Load raw dataset
- Preserve original data
- Store data for further processing

---

# Silver Layer

The dataset was validated and prepared using Python.

Performed operations:

- Checked for missing values
- Checked for duplicate records
- Removed unnecessary columns (Unnamed: 0)
- Validated data quality
- Converted data types
- Exported the cleaned dataset

Although no missing values or duplicate records were found, data validation and type conversion were performed before loading the data into SQL Server.

---

# Gold Layer

A Star Schema was implemented in SQL Server.

## Dimension Tables

- DimLocation
- DimRoom
- DimHost
- DimDay

## Fact Table

- FactListing

Foreign Keys were created between the Fact table and all Dimension tables.

---

# Power BI

The Gold Layer was connected to Power BI to build interactive dashboards and analytical reports.

Example visualizations include:

- Average Price
- Average Guest Satisfaction
- Listings Count
- Average Price by City
- Listings by Room Type
- Average Price by Day Type
- Interactive Filters (Slicers)

---

# Project Structure

```
Airbnb-Data-Warehouse
│
├── data
│   ├── airbnb_raw.csv
│   └── airbnb_clean.csv
│
├── python
│   └── Airbnb.ipynb
│
├── sql
│   ├── create_schema.sql
│   ├── dimensions.sql
│   ├── fact_table.sql
│   └── insert_data.sql
│
├── powerbi
│   └── AirbnbDWH.pbix
│
├── images
│
└── README.md
```

---
## Star Schema

<img width="1247" height="871" alt="Star_Schema" src="https://github.com/user-attachments/assets/fe70d7ff-7aa1-4a69-9acb-03aa1b22e0ce" />

## Dashboard

<img width="1280" height="720" alt="image" src="https://github.com/user-attachments/assets/6b711885-f8e3-4103-9432-1be400d69604" />
<img width="1280" height="720" alt="image" src="https://github.com/user-attachments/assets/89de5002-8a25-4da1-a16a-19a58b926f4c" />
<img width="1282" height="723" alt="image" src="https://github.com/user-attachments/assets/ed3e5a97-edd5-4800-8674-fbce5a2cc2c4" />
<img width="1281" height="722" alt="image" src="https://github.com/user-attachments/assets/15e0e049-3788-40df-a706-8289d2369e77" />




