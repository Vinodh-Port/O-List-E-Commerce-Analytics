
-- 1.

Select Count(*) As TotalCustomers
From Customers;

-- 2.

Select Top 5 * From Orders;

--3. Orders lo frist and last date chudataniki

Select
	MIN(order_purchase_timestamp) As StartDate,
	MAX(order_purchase_timestamp) As EndDate
From Orders;

-- 4. Orders table lo orders yokka orders status ni count cheyyali ante

Select
	order_status As OrderStatus,
	Count(*) As OrderCount
From Orders
Group By order_status
Order By OrderCount;

-- 5. Orders table lo year wise orders chudali ante
		-- 5.a Only years tho output
			Select
				Year(order_purchase_timestamp) As OrderYear,
				Count(*) As TotalOrders
			From Orders
			Group by Year(order_purchase_timestamp)
			Order By OrderYear;

		-- 5.a Years and Months tho output

			Select
				Year(order_purchase_timestamp) As OrderYear,
				Format(order_purchase_timestamp, 'MMM') As OrderMonth,
				Count(*) As TotalOrders
			From Orders
			Group By 
				Year(order_purchase_timestamp),
				Format(order_purchase_timestamp, 'MMM')
			Order By
				OrderYear,
				TotalOrders;

-- 6. City wise customers count ni chudali ante

Select Top 5
	customer_city As CustomerCity,
	Count(*) As CustomersCount
From Customers
Group by customer_city
Order By CustomersCount DESC;

-- 7. Payment type and count

SELECT 
    payment_type AS PaymentType, 
    COUNT(*) AS PaymentCount
FROM OrderPayments
GROUP BY payment_type
ORDER BY PaymentCount DESC;

-- 8. Duplicates find cheyyali ante

		SELECT 
			order_id AS OrderId, 
			COUNT(*) AS DuplicateCount
		FROM Orders
		GROUP BY order_id
		HAVING COUNT(*) > 1;

		SELECT 
			order_status AS OrderStatus,
			COUNT(*) AS MissingDeliveryDates
		FROM Orders
		WHERE order_delivered_customer_date IS NULL
		GROUP BY order_status
		ORDER BY MissingDeliveryDates DESC;

-- 9. Customers ki deliver aina dates lo yenni Null unnai chudali ante

SELECT 
    Trim(order_status) AS OrderStatus, 
    COUNT(*) AS GhostOrdersCount
FROM Orders
WHERE order_status = 'delivered' 
  AND order_delivered_customer_date IS NULL
GROUP BY order_status;

-- 10. Data Cleaning

		-- 1. Customers Table Cleaning
		
		UPDATE Customers
		SET customer_city = UPPER(TRIM(customer_city)),
			customer_state = UPPER(TRIM(customer_state));

		-- 2. Sellers Table Cleaning
		
		UPDATE Sellers
		SET seller_city = UPPER(TRIM(seller_city)),
			seller_state = UPPER(TRIM(seller_state));

		-- 3. Products Table Cleaning
		
		UPDATE Products
		SET product_category_name = LOWER(TRIM(product_category_name));

		-- 4. OrderPayments Table Cleaning
		
		UPDATE OrderPayments
		SET payment_type = LOWER(TRIM(payment_type)); 

		--5. Orders Table Cleaning
		
		UPDATE Orders
		SET order_status = Upper(TRIM(order_status));

		-- 6. Products Table: Underscores tholaginchi, NULLs ni fill cheyyadam
		
		UPDATE Products
		SET product_category_name = ISNULL(REPLACE(product_category_name, '_', ' '), 'unknown category');

		-- 7. OrderPayments Table: Missing payment types ni safe ga handle cheyyadam
		
		UPDATE OrderPayments
		SET payment_type = COALESCE(payment_type, 'other');


		-- Check 1: Order pettaka munde delivery aipoyina thappu rows enni unnai?
		
		SELECT COUNT(*) AS TimeTravelOrdersCount
		FROM Orders
		WHERE order_delivered_customer_date < order_purchase_timestamp;

		-- Check 2: Ekkadanna prices minus values (-10, -50) lo paddaya?
		
		SELECT COUNT(*) AS NegativePriceOrdersCount
		FROM OrderItems
		WHERE price < 0 OR freight_value < 0;


-- 11. TotalRevenue, TotalOrders, and AverageValue

SELECT 
    SUM(payment_value) AS TotalRevenue,
    COUNT(DISTINCT order_id) AS TotalOrders,
    SUM(payment_value) / COUNT(DISTINCT order_id) AS AverageOrderValue
FROM OrderPayments;

-- 12. Year and Month wise revenue

Select
	Year(O.order_purchase_timestamp) As OrderYear,
	Format(O.order_purchase_timestamp, 'MMM') As OrderMonth,
	Round(Sum(P.payment_value), 2) As Revenue
From Orders O
Join OrderPayments P On O.order_id = P.order_id
Group By Year(O.order_purchase_timestamp), MONTH(o.order_purchase_timestamp), Format(O.order_purchase_timestamp, 'MMM')
Order By OrderYear, MONTH(o.order_purchase_timestamp) DESC;  -- Manam Month kosam Format use chesam but months order lo ravataniki Group by and Order By lo 'MONTH(o.order_purchase_timestamp)' kuda add chesam

-- 13. Procust category ki entha sale jarigindi ani telusukuntaniki

Select Top 5
	P.product_category_name As ProductCategory,
	Round(Sum(O.price), 2) As TotalSale
From OrderItems O
Join Products P On O.product_id = P.product_id
Group By P.product_category_name
Order By TotalSale DESC;

-- 14. Ye payment type ki yekkuva transactions and entha amount chudataniki

Select
	payment_type As PaymetType,
	Count(*) As TotalTransactions,
	Round(Sum(payment_value), 2) As TotalAmount
From OrderPayments
Group by payment_type
Order By TotalAmount DESC;

-- 15. Fastest avrg Delivery time chudataniki

Select
	C.customer_state As CustomerState,
	C.customer_city As CustomerCity,
	Avg(Datediff(day, O.order_purchase_timestamp, O.order_delivered_customer_date)) As AvgDeliveryDays
From Orders O
Join Customers C On O.customer_id = C.customer_id
Where O.order_status = 'Delivered' And O.order_delivered_customer_date IS Not Null
Group By C.customer_state, C.customer_city
Order By CustomerState, AvgDeliveryDays ASC;

-- 16. Ye time lo orders ekkuva jarigutunnai ani teluskovataniki

Select
	DATEPART(hour, order_purchase_timestamp) As OrderHour,
	Count(*) As Totalorders
From Orders
Group By DATEPART(hour, order_purchase_timestamp)
Order By OrderHour;

-- 17. Highest revenue unna cities chudali ante

Select Top 5
	C.customer_city As City,
	Round(Sum(P.payment_value), 2) As Revenue
From Orders O
Join Customers C On C.customer_id = O.customer_id
Join OrderPayments P On O.order_id = P.order_id
Group By C.customer_city
Order By Revenue DESC;

-- 18. Order Status ni base cheskuni yenni orders unnayi ani chudali anukunte

SELECT 
    order_status AS OrderStatus,
    COUNT(*) AS TotalOrders,
	CAST((COUNT(*) * 100) / (SELECT COUNT(*) FROM Orders) AS DECIMAL(10, 2)) AS PercentageContribution
FROM Orders
GROUP BY order_status
ORDER BY TotalOrders DESC;  -- Indulo manam Subquery ni use chesam andukani denominator fixed ga total value ga lock ayyi untundi and Group By ki wrk avvadu

-- 19. Ye seller state wise yentha sale chesaru chudali anukunte

SELECT
    s.seller_id AS SellerID,
    s.seller_state AS SellerState,
    Round(SUM(i.price), 2) AS TotalSellerSales
FROM OrderItems i
JOIN Sellers s ON i.seller_id = s.seller_id
GROUP BY s.seller_id, s.seller_state
ORDER BY SellerState, TotalSellerSales DESC;

-- 20. Payment type ni base cheskuni order status and %s check cheyyataniki

Select
	P.payment_type AS PaymentType,
	O.order_status AS OrderStatus,
	Count(*) As TotalOrders, 
	CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() AS DECIMAL(5, 2)) AS GlobalPercentage,
	CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(Partition by P.payment_type) AS DECIMAL(5, 2)) AS PaymentTypePercentage
From Orders O
Join OrderPayments P On O.order_id = P.order_id
Group By P.payment_type, O.order_status
Order By PaymentType, TotalOrders DESC;  -- GlobalPercentage ki partition akkarledu bcoz total value meda manaki % kavali but Patment type ki ala kadu so partition ni use chesam

-- 21. Monthly rvenue and orders trend kavali ante

Select
	Format(O.order_purchase_timestamp, 'yyyy') As Years,
	Format(O.order_purchase_timestamp, 'MM') As Months,
	Round(Sum(p.payment_value), 2) As Revenue,
	Count(Distinct O.order_id) As Orders
From Orders O
Join OrderPayments P On O.order_id = P.order_id
Group by Format(O.order_purchase_timestamp, 'yyyy'), Format(O.order_purchase_timestamp, 'MM')
Order By Years DESC, Months ASC;

-- 22. Delivery lo enni days diff undi ani chudali anukunte

Select
	O.order_id AS OrderID,
	C.customer_state As CustomerState,
	P.product_category_name AS ProductName,
	O.order_estimated_delivery_date As PromisedDate,
	O.order_delivered_customer_date AS ActualDeliveredDate,
	DatedIFF(Day, o.order_estimated_delivery_date, O.order_delivered_customer_date) As DaysDelayed
From Orders O
Join Customers C On O.customer_id = C.customer_id
Join OrderItems I On I.order_id = O.order_id
Join Products P On I.product_id = P.product_id
Where O.order_status = 'Delivered' And O.order_delivered_customer_date > O.order_estimated_delivery_date
Order By DaysDelayed DESC;

-- 23. Product Categories with Highest Average Delivery Delay

SELECT
    p.product_category_name AS ProductCategory,
    COUNT(DISTINCT o.order_id) AS TotalDelayedOrders,
    ROUND(AVG(CAST(DATEDIFF(day, o.order_estimated_delivery_date, o.order_delivered_customer_date) AS DECIMAL(10,2))), 2) AS AvgDaysDelayed
FROM Orders o
JOIN OrderItems i ON o.order_id = i.order_id
JOIN Products p ON i.product_id = p.product_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date > o.order_estimated_delivery_date
GROUP BY p.product_category_name
ORDER BY TotalDelayedOrders DESC, AvgDaysDelayed DESC;

				
-- 24.  Ordered Items ki MinPrice, MaxPrice, AvgPrice chudali anukunte

Select
	Round(Min(price), 2) As MinPrice,
	Round(Max(price), 2) As MaxPrice,
	Round(Avg(price), 2) As AvgPrice
From OrderItems;

-- 25. Customers table lo unique cities count and cities customers count telusukuntaniki

SELECT 
    COUNT(DISTINCT customer_city) AS TotalUniqueCountAlias
FROM Customers;

SELECT 
    customer_city AS City,
    COUNT(customer_id) AS TotalCustomersInCity
FROM Customers
GROUP BY customer_city
ORDER BY TotalCustomersInCity DESC;

-- 26. Payment type ni base cheskuni vaati total and avrg kanukkuntaniki

Select
	payment_type AS PaymentMethod,
	Round(Sum(payment_value), 2) As TotalRevenue,
	Round(Avg(payment_value), 2) AS AvrgValue
From OrderPayments
Group By payment_type
Order By TotalRevenue DESC;

-- 27. Order status ni base cheskuni vati count chudataniki

Select
	order_status As OrderStatus,
	COUNT(order_status) As TotalOrdersCount
From Orders
Group By order_status
Order By TotalOrdersCount DESC;

-- 28. Total sellers sate wise count chudataniki

Select
	seller_state AS SellerState,
	Count(seller_state) AS TotalSellers
From Sellers
Group By seller_state
Order By TotalSellers DESC;

-- 29. Ekkuva ga spend chesina Top 5 customers ni kanukkovali anukunte

Select Top 5
	C.customer_id,
	C.customer_state,
	Count(O.order_id) As OrdersCount,
	Round(Sum(P.payment_value), 2) As TotalRevenue
From Customers C 
Join Orders O On C.customer_id = O.customer_id
Join OrderPayments P On P.order_id = O.order_id
Group by C.customer_id, C.customer_state
Order By TotalRevenue DESC;

-- 30. State wise delivery speed performance chudataniki

		Select
		C.customer_state,
		C.customer_city,
		Avg(DATEDIFF(Day, O.order_purchase_timestamp, O.order_delivered_customer_date)) As AvrgDeliveryTime
		From Customers C
		Join Orders O On C.customer_id = O.customer_id
		Where O.order_status = 'Delivered'
		Group By 
		C.customer_state,
		C.customer_city
		Order By C.customer_state, AvrgDeliveryTime DESC;
		---------------
		Select
		C.customer_state,
		Avg(DATEDIFF(Day, O.order_purchase_timestamp, O.order_delivered_customer_date)) As AvrgDeliveryTime
		From Customers C
		Join Orders O On C.customer_id = O.customer_id
		Where O.order_status = 'Delivered'
		Group By 
		C.customer_state
		Order By AvrgDeliveryTime DESC;

-- 31. Cancelled orders loss revenue chudataniki

Select
	P.product_category_name As ProductName,
	Round(Sum(I.price), 2) As PriceLoss,
	Round(Avg(I.price), 2) As AvrgPriceLoss
From Orders O
Join OrderItems I On O.order_id = I.order_id
Join Products P On I.product_id = P.product_id
Where O.order_status = 'Canceled'
Group By P.product_category_name
Order By PriceLoss DESC;

-- 32. Freight value ekkuva unna products chudataniki

Select Top 5
	P.product_category_name AS ProductName,
	Round(Avg(I.freight_value), 2) As AvrgShippingCost
From Orders O
Join OrderItems I On I.order_id = O.order_id
Join Products P On P.product_id = I.product_id
Where O.order_status = 'Delivered'
Group By P.product_category_name
Order by AvrgShippingCost DESC;

-- 33. Sellers state ni batti valla sales chudataniki

Select Top 5
	S.seller_id AS SellerID,
	S.seller_state AS State,
	Round(Sum(I.price), 2) AS SaleValue
From Sellers S
join OrderItems I On I.seller_id = S.seller_id
Group By S.seller_id, S.seller_state
Order By SaleValue DESC;

-- 34. 5000 + delivere chesina states list chudataniki

Select
	C.customer_state As State,
	Count(O.order_status) As TotalDelivered
From Orders O
Join Customers C on C.customer_id = O.customer_id
Where O.order_status = 'Delivered'
Group by C.customer_state
Having Count(O.order_status) > 5000
Order by TotalDelivered DESC;


-- 35. Highest total sales revenue generate chesina Top 1 Seller ni chudataniki

With HighSale As
(Select
	S.seller_state AS StateName,
	S.seller_id As ID,
	Round(Sum(I.price), 2) As Sales,
	Row_Number() Over(Partition By S.seller_state Order By Sum(I.price) DESC) As RankNum
From Sellers S
Join OrderItems I On S.seller_id = I.seller_id
Group by S.seller_state,
	S.seller_id)

	Select
		StateName,
		ID,
		Sales
	From HighSale
	Where RankNum = 1
	Order By StateName;


-- 36. Month yokka Total Revenue mariyu dhani Previous Month and Next Month Revenue details extract cheyali anukunte

Select
	Format(O.order_purchase_timestamp, 'MMM') As OrderedMonth,
	Round(Sum(P.payment_value), 2) As TotalValue,
	Lag(Round(Sum(P.payment_value), 2)) Over (Order By Month(O.order_purchase_timestamp)) As PreviousMonthValue,
	Lead(Round(Sum(P.payment_value), 2)) Over (Order By Month(O.order_purchase_timestamp)) As NextMonthValue
From Orders O
Join OrderPayments P On P.order_id = O.order_id
Where Year(O.order_purchase_timestamp) = 2017 and O.order_status = 'Delivered'
Group By Month(O.order_purchase_timestamp), Format(O.order_purchase_timestamp, 'MMM');

-- 37. Running totals chudataniki

With MonthRevenue As (
Select
	Format(O.order_purchase_timestamp, 'MMM') As OrderedMonth,
	Month(O.order_purchase_timestamp) As MonthNum,
	Round(Sum(P.payment_value), 2) As MonthlyRevenue
From Orders O
Join OrderPayments P On P.order_id = O.order_id
Where Year(O.order_purchase_timestamp) = 2017 and O.order_status = 'Delivered'
Group By Month(O.order_purchase_timestamp), Format(O.order_purchase_timestamp, 'MMM')
)
Select
	OrderedMonth,
	MonthlyRevenue,
	Sum(MonthlyRevenue) Over(Order by MonthNum) As CumulativeRevenue
From MonthRevenue;

-- 38. Total successful orders lo Low Value Orders, Medium Value Orders, mariyu High Value Orders ani divide chesi vati count chudataniki

With Category As(
Select
	Case
		When I.price < 50 Then 'Low Value Orders'
		When I.price between 50 and 200 Then 'Medium Value Orders'
		When I.price > 200 Then 'High Value Orders'
	End As OrderCategory
From Orders O
Join OrderItems I On I.order_id = O.order_id
Where O.order_status = 'Delivered'
)
Select
	OrderCategory,
	Count(OrderCategory) As TotalOrdersCount
From Category
Group By OrderCategory
Order by TotalOrdersCount DESC;

-- 39. Year wise highest sale jarigina top 3 products chudataniki

With CategoryRanking As(
Select
	Year(o.order_purchase_timestamp) As OrderedYear,
	P.product_category_name As ProductName,
	Round(Sum(I.price), 2) As Price,
	DENSE_RANK() Over(Partition By Year(o.order_purchase_timestamp) Order By Sum(I.price) DESC) As CategoryRank
From Orders O
Join OrderItems I on I.order_id = O.order_id
Join Products P On P.product_id = I.product_id
Where O.order_status = 'Delivered'
Group By Year(o.order_purchase_timestamp), P.product_category_name
)
Select
	OrderedYear,
	ProductName,
	Price
From CategoryRanking
Where CategoryRank <= 3
Order By OrderedYear, Price DESC










































