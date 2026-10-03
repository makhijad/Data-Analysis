
CREATE VIEW [dbo].[Vw_Brighmart_OverallSales] AS 
(
SELECT 
	'OVERALLSALES_TABLE' AS TABLE_NAME,
	GETDATE() AS INSERTED_DATETIME,
	OrderID,
	CustomerID,
	ProductID,
	EmployeeID,
	StoreID,
	OrderDate,
	ShipDate,
	Quantity,
	UnitPrice,
	DiscountPercent,
	ShippingCost,
	CASE WHEN PaymentMode IN ('Upi', 'U.P.I') THEN 'UPI' 
		WHEN PaymentMode IN ('cash', 'Cash') THEN 'CASH'
		WHEN PaymentMode IN ('net banking', 'NetBanking') THEN 'Net Banking'
		WHEN PaymentMode IN ('card', 'Card') THEN 'CARD' 
	END AS PaymentMode_Upd,
	CASE WHEN OrderStatus IN ('COMPLETED', 'Compeleted') THEN 'Completed' 
		WHEN OrderStatus IN ('pending') THEN 'Pending'
		WHEN OrderStatus IN ('Retuned', 'RETURNED') THEN 'Returned'
		WHEN OrderStatus IN ('cancelled') THEN 'Cancelled' 
	END AS OrderStatus_Upd,
	OrderChannel,
	Notes
FROM Brightmart_OverallSales
where CustomerID is NOT NULL --these are excluded because these IDs are mot in customers table
)
GO


