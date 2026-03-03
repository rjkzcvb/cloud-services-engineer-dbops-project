-- V003: Заполнение таблиц данными

-- Очищаем таблицы перед вставкой (чтобы избежать дублирования)
TRUNCATE TABLE order_product CASCADE;
TRUNCATE TABLE orders CASCADE;
TRUNCATE TABLE product CASCADE;

-- Вставка продуктов (сосиски) - НЕ указываем id, пусть генерируется автоматически
INSERT INTO product (name, picture_url, price) VALUES 
('Сливочная', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/6.jpg', 320.00),
('Особая', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/5.jpg', 179.00),
('Молочная', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/4.jpg', 225.00),
('Нюренбергская', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/3.jpg', 315.00),
('Мюнхенская', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/2.jpg', 330.00),
('Русская', 'https://res.cloudinary.com/sugrobov/image/upload/v1623323635/repos/sausages/1.jpg', 189.00);

-- Вставка заказов (10 миллионов записей) - id генерируется автоматически
INSERT INTO orders (status, date_created) 
SELECT 
    (array['pending', 'shipped', 'delivered', 'cancelled'])[floor(random() * 4 + 1)],
    DATE(NOW() - (random() * INTERVAL '90 days'))
FROM generate_series(1, 10000000) s(i);

-- Вставка связей заказов и продуктов
-- Получаем максимальные ID для генерации случайных ссылок
WITH product_ids AS (
    SELECT id FROM product
),
order_ids AS (
    SELECT id FROM orders
)
INSERT INTO order_product (quantity, order_id, product_id) 
SELECT 
    floor(1 + random() * 50)::int,
    (SELECT id FROM order_ids ORDER BY random() LIMIT 1),
    (SELECT id FROM product_ids ORDER BY random() LIMIT 1)
FROM generate_series(1, 10000000) s(i);
