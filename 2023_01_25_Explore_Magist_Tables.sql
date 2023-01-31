USE magist;

-- 1. How many orders are there in the dataset?
SELECT DISTINCT 
	COUNT(order_id) 
FROM 
	orders
;
-- ** 99441 orders total

-- 2. Are orders actually delivered?
SELECT 
	order_status
    , COUNT(order_id)
FROM 
	orders
GROUP BY 
	order_status
;
-- ** 96478 orders have been delivered
-- ** 97 % 

-- 3. Is Magist having user growth?
SELECT 
	YEAR(order_purchase_timestamp) AS year
		, MONTH(order_purchase_timestamp) AS month
		, COUNT(DISTINCT customer_id) AS unique_customer
FROM 
	orders
GROUP BY 
	YEAR(order_purchase_timestamp)
	, MONTH(order_purchase_timestamp)
ORDER BY 
	YEAR(order_purchase_timestamp)
    , MONTH(order_purchase_timestamp)
;
-- number of customers increased until 03/2018 and numbers crashed in 09/2018

-- 4. How many products are there on the products table?
SELECT 
	DISTINCT COUNT(product_id) AS unique_product_ID
FROM 
	products
;
-- total 32951

-- 5. Which are the categories with the most products?
SELECT 
	product_category_name, COUNT(product_id)
FROM 
	products
GROUP BY 
	product_category_name
ORDER BY 
	COUNT(product_id) DESC
; 

-- with category name translation
SELECT 
	cn.product_category_name_english
	, cn.product_category_name
    , COUNT(p.product_id)
FROM 
	products AS p
LEFT JOIN 
	product_category_name_translation AS cn
ON 
	p.product_category_name = cn.product_category_name
GROUP BY 
	p.product_category_name
ORDER BY 
	COUNT(p.product_id) DESC
; 
-- computers 7th place - 1639

-- 6. How many of those products were present in actual transactions? 
SELECT 
	DISTINCT p.product_category_name
    , COUNT(oi.product_id) AS unique_sold_products
FROM 
	order_items AS oi
LEFT JOIN 
	products AS p
ON 
	oi.product_id = p.product_id
GROUP BY 
	p.product_category_name
ORDER BY 
	unique_sold_products DESC
;
-- 5th place 7827

-- 7. What’s the price for the most expensive and cheapest products?
-- for technology
SELECT 
	MIN(OI.pRice)
	, MAX(OI.pRice)
	, AVG(OI.pRice)
FROM 
	order_items AS Oi
LEFT JOIN 
	products AS P
ON 
	oi.pRoduct_id = P.pRoduct_id
WHERE 
	p.pRoduct_category_name 
IN ('Pcs', 'informatica_acessorios', 'consoles_games', 'telefonia')
;

-- 8. What are the highest and lowest payment values?
SELECT 
    MAX(PAyment_value) AS Highest, 
    MIN(PAyment_value) AS Lowest
FROM 
    order_payments
WHERE 
    payment_value 
    IN
    (SELECT SUM(PAyment_value) FROM Order_payments GROUP BY Order_id)
;
      
SELECT 
	order_id
		, SUM(PAyment_value)
FROM 
	order_payments 
GROUP BY 
	order_id
ORDER BY 
	SUM(PAyment_value) DESC
LIMIT 1
;

SELECT 
	order_id
    , SUM(PAyment_value)
FROM 
	order_payments
GROUP BY 
	order_id
ORDER BY 
	SUM(PAyment_value) ASC
LIMIT 1
;
