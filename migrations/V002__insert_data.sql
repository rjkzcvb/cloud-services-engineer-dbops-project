-- V002: Заполнение таблиц данными

-- Вставка продуктов
INSERT INTO product (name, picture_url, price) VALUES 
('Сливочная', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/6.jpg', 320.00),
('Особая', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/5.jpg', 179.00),
('Молочная', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/4.jpg', 225.00),
('Нюренбергская', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/3.jpg', 315.00),
('Мюнхенская', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/2.jpg', 330.00),
('Русская', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/1.jpg', 189.00);

-- Вставка заказов (10 миллионов)
INSERT INTO orders (status, date_created)
SELECT 
    (ARRAY['pending', 'shipped', 'delivered', 'cancelled'])[floor(random() * 4 + 1)],
    DATE(NOW() - (random() * INTERVAL '90 days'))
FROM generate_series(1, 10000000);

-- Вставка связей (10 миллионов)
INSERT INTO order_product (quantity, order_id, product_id)
SELECT 
    floor(1 + random() * 50)::int,
    floor(random() * 10000000 + 1)::int,
    floor(random() * 6 + 1)::int
FROM generate_series(1, 10000000);
