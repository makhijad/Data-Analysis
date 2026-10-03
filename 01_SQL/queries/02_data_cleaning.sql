/* ==========================================================================
   Project  : BrightMart Data Analytics - SQL Module
   File     : 02_data_cleaning.sql
   Purpose  : Fix the data-quality issues identified in 01_data_analysis_eda.sql
   Database : SQL Server (SSMS)
   Run order: Run AFTER 01_data_analysis_eda.sql

   WARNING  : The DELETE statements below permanently change the tables.
              Keep a copy of the raw data (see /data) before running them.

   Issues handled here:
     - Sales     : invalid ProductID and CustomerID records removed
     - Customers : duplicate rows removed
     - Products  : duplicate rows removed
   Issues NOT handled here (open / fixed later in views):
     - NULL UnitPrice, NULL CustomerID, NULL CostPrice, NULL ManagerID
       -> waiting for data team / business confirmation
     - Inconsistent casing (OrderStatus, PaymentMode, Region, Category)
       -> standardised via _upd columns in the views
   ========================================================================== */


/* ==========================================================================
   SECTION 1 : Brightmart_OverallSales
   ========================================================================== */

-- Step 1.1 : Review the invalid 5-digit ProductIDs (not present in Dim_Product)
select distinct ProductID from Brightmart_OverallSales
order by 1 desc


-- Step 1.2 : Create a temp table and test the delete first (validation only)
select * into #sales from Brightmart_OverallSales

delete from #sales
where ProductID in (
    '88820','88819','88818','88817','88816','88815','88814','88813','88812','88811',
    '88810','88809','88808','88807','88806','88805','88804','88803','88802','88801'
)


-- Step 1.3 : Delete records having incorrect ProductID entries
delete from Brightmart_OverallSales
where ProductID in (
    '88820','88819','88818','88817','88816','88815','88814','88813','88812','88811',
    '88810','88809','88808','88807','88806','88805','88804','88803','88802','88801'
)


-- Step 1.4 : Review the invalid 6-digit CustomerIDs (not present in Dim_Customers)
select CustomerID from Brightmart_OverallSales
order by 1 desc


-- Step 1.5 : Delete records having incorrect CustomerID entries
delete from Brightmart_OverallSales
where CustomerID in (
    '999049','999048','999047','999046','999045','999044','999043','999042','999041','999040',
    '999039','999038','999037','999036','999035','999034','999033',
    '999031','999030','999029','999027','999026','999025','999023','999022',
    '999020','999019','999018','999016','999015','999014','999013','999012','999011',
    '999010','999009','999008','999007','999005','999003','999002','999001'
)



/* ==========================================================================
   SECTION 2 : Brightmart_Customers - remove duplicate rows
   Logic: each duplicated CustomerID appears exactly twice, so number the rows
          and delete every second row (2, 4, 6 ...), keeping one copy of each.
   ========================================================================== */
WITH CTE AS (
    select CustomerID, ROW_NUMBER() OVER (ORDER BY CustomerID) AS ROW#
    from [dbo].[Brightmart_Customers]
    where CustomerID in ('6','69','77','147','162','208','257','272','274','278',
                         '469','560','571','660','892')
)
DELETE FROM CTE
WHERE ROW# IN (2,4,6,8,10,12,14,16,18,20,22,24,26,28,30)



/* ==========================================================================
   SECTION 3 : Brightmart_Products - remove duplicate rows
   Logic: same approach as Customers - keep one copy of each duplicated ProductID.
   ========================================================================== */
WITH CTE AS (
    select ProductID, ROW_NUMBER() OVER (ORDER BY ProductID) AS ROW#
    from [dbo].[Brightmart_Products]
    where ProductID in ('2','58','76','100','126')
)
DELETE FROM CTE
WHERE ROW# IN (2,4,6,8,10)
