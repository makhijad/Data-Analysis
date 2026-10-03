# SQL - EDA & Data Cleaning

## Objective
Explore the BrightMart retail database, find data-quality problems, and clean the data so it is ready for reporting and analysis.

## Dataset
BrightMart is a fictional retail dataset (SQL Server) with 2 fact tables and 4 dimension tables.

| Type | Table | Description |
|------|-------|-------------|
| Fact | `Brightmart_OverallSales` | Sales orders |
| Fact | `Brightmart_CustomerReturns` | Returned orders |
| Dimension | `Brightmart_Customers` | Customer details |
| Dimension | `Brightmart_Employees` | Employee details |
| Dimension | `Brightmart_Products` | Product details |
| Dimension | `Brightmart_Stores` | Store details |

## Workflow

| Step | File | What it does |
|------|------|--------------|
| 1 | [`01_data_analysis_eda.sql`](queries/01_data_analysis_eda.sql) | Checks every table for NULLs, duplicates, invalid IDs and inconsistent text |
| 2 | [`02_data_cleaning.sql`](queries/02_data_cleaning.sql) | Removes invalid records and duplicate rows |
| 3 | [`03_create_views_upd.sql`] | Views with new `_upd` columns for standardised values |

## Data Quality Issue Log

| # | Table | Issue found | Action | Status |
|---|-------|-------------|--------|--------|
| 1 | Sales | `UnitPrice` is NULL (including Completed orders) | Raised with data team | Open |
| 2 | Sales | Inconsistent casing / spelling in `OrderStatus` (e.g. Completed, Compeleted, COMPLETED) and `PaymentMode` | Standardised in views (`_upd` columns) | View |
| 3 | Sales | 5-digit `ProductID`s (88801-88820) not present in Products | Records deleted | Fixed |
| 4 | Sales | 6-digit `CustomerID`s (999001-999049 range) not present in Customers | Records deleted | Fixed |
| 5 | Sales | `CustomerID` is NULL, so orders cannot map to Customers | Raised with data team | Open |
| 6 | Returns | Duplicate `OrderID` check | No duplicates found | OK |
| 7 | Customers | 15 duplicated `CustomerID`s (validated as true duplicates) | Duplicate rows deleted using `ROW_NUMBER()` CTE | Fixed |
| 8 | Customers | Inconsistent casing in `Region` | Standardised in views (`_upd` columns) | View |
| 9 | Employees | `ManagerID` is NULL for some rows | Business to confirm | Open |
| 10 | Products | 5 duplicated `ProductID`s (validated as true duplicates) | Duplicate rows deleted using `ROW_NUMBER()` CTE | Fixed |
| 11 | Products | `CostPrice` is NULL (not allowed by business rules) | Raised with data team | Open |
| 12 | Products | Inconsistent casing in `Category` | Standardised in views (`_upd` columns) | View |
| 13 | Stores | Quality check | No issues found | OK |

**Status key:** Fixed = cleaned in `02_data_cleaning.sql` | View = standardised in views | Open = waiting for confirmation | OK = no issue.

## Key Findings
- [Add the number of invalid Sales rows removed: X]
- [Add the number of NULL UnitPrice rows: X]
- [Add one more insight from your analysis]

## Screenshots
Before / after results are in the [`screenshots`](screenshots/) folder.

## SQL Skills Demonstrated
`SELECT` | `WHERE` | `GROUP BY` / `HAVING` | `DISTINCT` | Temp tables | CTEs | `ROW_NUMBER()` window function | `DELETE` | Data validation | Views

## How to Run
1. Load the CSVs from [`data`](data/) into SQL Server using the table names above.
2. Run `01_data_analysis_eda.sql` to review the issues.
3. Run `02_data_cleaning.sql` to clean the data. These queries permanently delete rows, so keep a backup of the raw tables first.
