-- FoodDeliverySystem

create database food_delivery_system;
use food_delivery_system;


DROP TABLE IF EXISTS Order_Items;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Menu;
DROP TABLE IF EXISTS Restaurants;
DROP TABLE IF EXISTS Customers;


CREATE TABLE Customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  city VARCHAR(50)
);


CREATE TABLE Restaurants (
  restaurant_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  location VARCHAR(50)
);


CREATE TABLE Menu (
  menu_id INT PRIMARY KEY AUTO_INCREMENT,
  restaurant_id INT,
  item VARCHAR(100),
  price DECIMAL(10,2),
  FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);


CREATE TABLE Orders (
  order_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  restaurant_id INT,
  order_date DATE,
  total DECIMAL(10,2),
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
  FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);


CREATE TABLE Order_Items (
  order_item_id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT,
  item VARCHAR(100),
  quantity INT,
  price DECIMAL(10,2),
  FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);


INSERT INTO Customers (name, city) VALUES
('Aarav Sharma', 'Delhi'),
('Priya Verma', 'Mumbai'),
('Rohan Gupta', 'Bengaluru'),
('Neha Singh', 'Delhi'),
('Ishita Mehta', 'Pune');

INSERT INTO Restaurants (name, location) VALUES
('GreenBowl Cafe', 'Delhi'),
('SpiceHub', 'Mumbai'),
('UrbanEats', 'Bengaluru');


INSERT INTO Menu (restaurant_id, item, price) VALUES
(1, 'Veggie Delight Pizza', 299.00),
(1, 'Cheese Burst Pasta', 249.00),
(1, 'Green Smoothie', 149.00),
(1, 'Mushroom Soup', 129.00),
(1, 'Veg Wrap', 199.00);


INSERT INTO Menu (restaurant_id, item, price) VALUES
(2, 'Paneer Tikka', 299.00),
(2, 'Veg Biryani', 349.00),
(2, 'Masala Dosa', 199.00),
(2, 'Veg Manchurian', 229.00),
(2, 'Spring Rolls', 159.00);


INSERT INTO Menu (restaurant_id, item, price) VALUES
(3, 'Veg Burger', 179.00),
(3, 'Fries Combo', 149.00),
(3, 'Veggie Salad', 129.00),
(3, 'Cheese Sandwich', 199.00),
(3, 'Cold Coffee', 99.00);


INSERT INTO Orders (customer_id, restaurant_id, order_date, total) VALUES
(1, 1, '2025-08-01', 448.00),
(2, 2, '2025-08-01', 548.00),
(3, 3, '2025-08-02', 278.00),
(4, 1, '2025-08-02', 299.00),
(5, 2, '2025-08-03', 349.00),
(1, 3, '2025-08-03', 328.00),
(2, 1, '2025-08-04', 299.00),
(3, 2, '2025-08-04', 428.00),
(4, 3, '2025-08-05', 278.00),
(5, 1, '2025-08-05', 199.00);


INSERT INTO Order_Items (order_id, item, quantity, price) VALUES
(1, 'Veggie Delight Pizza', 1, 299.00),
(1, 'Green Smoothie', 1, 149.00);


INSERT INTO Order_Items (order_id, item, quantity, price) VALUES
(2, 'Paneer Tikka', 1, 299.00),
(2, 'Veg Biryani', 1, 249.00);


INSERT INTO Order_Items (order_id, item, quantity, price) VALUES
(3, 'Veg Burger', 1, 179.00),
(3, 'Cold Coffee', 1, 99.00);


INSERT INTO Order_Items (order_id, item, quantity, price) VALUES
(4, 'Veggie Delight Pizza', 1, 299.00);


INSERT INTO Order_Items (order_id, item, quantity, price) VALUES
(5, 'Veg Biryani', 1, 349.00);


INSERT INTO Order_Items (order_id, item, quantity, price) VALUES
(6, 'Veggie Salad', 1, 129.00),
(6, 'Cheese Sandwich', 1, 199.00);


INSERT INTO Order_Items (order_id, item, quantity, price) VALUES
(7, 'Cheese Burst Pasta', 1, 249.00),
(7, 'Green Smoothie', 1, 149.00);


INSERT INTO Order_Items (order_id, item, quantity, price) VALUES
(8, 'Veg Manchurian', 1, 229.00),
(8, 'Spring Rolls', 1, 199.00);


INSERT INTO Order_Items (order_id, item, quantity, price) VALUES
(9, 'Fries Combo', 1, 149.00),
(9, 'Veggie Salad', 1, 129.00);


INSERT INTO Order_Items (order_id, item, quantity, price) VALUES
(10, 'Veg Wrap', 1, 199.00);

-- A(3)

SET SQL_SAFE_UPDATES = 0;

update Menu
set price = 319.0
where item = 'Veggie Delight Pizza' and restaurant_id = 1
;

-- A(4)

delete from Customers
where name = 'Ishita Mehta'
;

-- B(5)

select o.*,c.name,r.name
from Orders o
join Customers c
on o.customer_id=c.customer_id
join Restaurants r
on r.restaurant_id=o.restaurant_id
;

-- B(6)

select o.customer_id, oi.item
from Orders o
join Order_Items oi
on oi.order_id = o.order_id
;

-- B(7)

select r.name AS restaurant_name, SUM(o.total) AS total_revenue
from Restaurants r
join Orders o 
on r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_id, r.name;


-- C(8)

select c.name, SUM(o.total) AS total_spent
from Customers c
join Orders o
on c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
having SUM(o.total) > (
						select avg(total) from Orders
)
;

-- c(9)

select r.name as restaurant_name, count(o.order_id) as total_orders
from Restaurants r
join Orders o on r.restaurant_id = o.restaurant_id
group by r.restaurant_id, r.name
having count(o.order_id) = (
    select count(order_id)
    from Orders
    group by restaurant_id
    order by count(order_id) desc
    limit 1
);


-- c(10)

select item, price
from Menu
where price > (
				select avg(price)
                from Menu
                );


-- D(11)

create view DailySales as 
select 
order_date, 
restaurant_id,
sum(total) as total_sales
from orders
group by order_date, restaurant_id;

select * from DailySales;

-- D(12)



