/* ==========================================================================
   Project  : BrightMart Data Analytics - SQL Module
   File     : 01_data_analysis_eda.sql
   Purpose  : Exploratory Data Analysis (EDA) and data-quality checks on all
              BrightMart tables BEFORE any cleaning is done
   Database : SQL Server (SSMS)
   Tables   : Fact     - Brightmart_OverallSales, Brightmart_CustomerReturns
              Dimension- Brightmart_Customers, Brightmart_Employees,
                         Brightmart_Products, Brightmart_Stores
   Note     : SELECT-only script. Nothing is modified here.
   How to read: every check has a "Finding" (what the query showed) and,
                where needed, the follow-up that is handled in
                02_data_cleaning.sql or in the views.
   ========================================================================== */


/* ==========================================================================
   SECTION 1 : Fact table - Brightmart_OverallSales
   ========================================================================== */

-- Check 1.1 : Preview the table
select * from Brightmart_OverallSales


-- Check 1.2 : NULL UnitPrice
-- Finding   : UnitPrice cannot be NULL in the Sales table.
-- Action    : Need to confirm with data team.
select * from Brightmart_OverallSales
where UnitPrice is NULL


-- Check 1.3 : NULL UnitPrice on COMPLETED orders
-- Finding   : Completed orders cannot have a NULL UnitPrice.
--             Note the spelling/casing variants of 'Completed' in the data.
-- Action    : Need to confirm with data team.
select * from Brightmart_OverallSales
where UnitPrice is NULL
  and OrderStatus in ('Completed', 'Compeleted', 'COMPLETED')


-- Check 1.4 : Inconsistent text values
-- Finding   : Inconsistent casing in the OrderStatus and PaymentMode columns.
select * from Brightmart_OverallSales


-- Check 1.5 : Invalid ProductID
-- Finding   : 5-digit ProductIDs exist in Sales. These are incorrect entries
--             because the IDs are not present in Dim_Product.
-- Action    : Removed in 02_data_cleaning.sql
select distinct ProductID from Brightmart_OverallSales
order by 1 desc


-- Check 1.6 : Invalid CustomerID
-- Finding   : 6-digit CustomerIDs exist in Sales. These are incorrect entries
--             because the IDs are not present in Dim_Customers.
-- Action    : Removed in 02_data_cleaning.sql
select distinct CustomerID from Brightmart_OverallSales
order by 1 desc


-- Check 1.7 : NULL CustomerID
-- Finding   : CustomerID should not be NULL; these orders will not map
--             to the Customers table.
select * from Brightmart_OverallSales
where CustomerID is NULL



/* ==========================================================================
   SECTION 2 : Fact table - Brightmart_CustomerReturns
   ========================================================================== */

-- Check 2.1 : Preview the table
select * from [dbo].[Brightmart_CustomerReturns]


-- Check 2.2 : Duplicate OrderID
-- Finding   : No duplicates found.
select OrderID, COUNT(*) from [dbo].[Brightmart_CustomerReturns]
group by OrderID
having COUNT(*) > 1



/* ==========================================================================
   SECTION 3 : Dimension table - Brightmart_Customers
   ========================================================================== */

-- Check 3.1 : Preview the table
select * from [dbo].[Brightmart_Customers]


-- Check 3.2 : Duplicate CustomerID
-- Finding   : Duplicated CustomerIDs found.
select CustomerID, COUNT(*) from [dbo].[Brightmart_Customers]
group by CustomerID
having COUNT(*) > 1


-- Check 3.3 : Are these true duplicates?
-- Finding   : Validated the duplicated IDs row by row (full-row duplicates).
-- Action    : Removed in 02_data_cleaning.sql
select * from [dbo].[Brightmart_Customers]
where CustomerID in ('6','69','77','147','162','208','257','272','274','278',
                     '469','560','571','660','892')
order by CustomerID


-- Check 3.4 : Inconsistent text values
-- Finding   : Inconsistent casing in the REGION column.
select * from Brightmart_Customers



/* ==========================================================================
   SECTION 4 : Dimension table - Brightmart_Employees
   ========================================================================== */

-- Check 4.1 : NULL ManagerID
-- Finding   : ManagerID is NULL for some rows.
-- Action    : Business needs to confirm.
select * from [dbo].[Brightmart_Employees]
order by EmployeeID



/* ==========================================================================
   SECTION 5 : Dimension table - Brightmart_Products
   ========================================================================== */

-- Check 5.1 : Preview the table
select * from [dbo].[Brightmart_Products]
order by ProductID


-- Check 5.2 : Duplicate ProductID
-- Finding   : Duplicated ProductIDs found.
select ProductID, COUNT(*) from [dbo].[Brightmart_Products]
group by ProductID
having COUNT(*) > 1


-- Check 5.3 : Are these true duplicates?
-- Finding   : Validated the duplicated IDs row by row (full-row duplicates).
-- Action    : Removed in 02_data_cleaning.sql
select * from [dbo].[Brightmart_Products]
where ProductID in ('2','58','76','100','126')
order by 1


-- Check 5.4 : NULL CostPrice
-- Finding   : CostPrice cannot be NULL according to the business rules.
-- Action    : Need to confirm with data team.
select * from [dbo].[Brightmart_Products]
where CostPrice is NULL


-- Check 5.5 : Inconsistent text values
-- Finding   : Category values use various cases and need to be aligned.
-- Action    : To be fixed while creating the views.
select * from [dbo].[Brightmart_Products]



/* ==========================================================================
   SECTION 6 : Dimension table - Brightmart_Stores
   ========================================================================== */

-- Check 6.1 : Preview the table
-- Finding   : Looks good as per the requirement. No issues found.
select * from [dbo].[Brightmart_Stores]
