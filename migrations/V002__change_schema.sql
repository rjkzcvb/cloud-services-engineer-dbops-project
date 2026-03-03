-- V002: Нормализация схемы базы данных

-- 1. Добавляем колонку price в таблицу product
ALTER TABLE product ADD COLUMN price double precision;

-- 2. Переносим данные о ценах из product_info в product
UPDATE product SET price = product_info.price FROM product_info WHERE product.id = product_info.product_id;

-- 3. Добавляем колонку date_created в таблицу orders
ALTER TABLE orders ADD COLUMN date_created date DEFAULT CURRENT_DATE;

-- 4. Переносим данные о датах из orders_date в orders
UPDATE orders SET date_created = orders_date.date_created FROM orders_date WHERE orders.id = orders_date.order_id;

-- 5. Обновляем статусы в orders из orders_date (где нужно)
UPDATE orders SET status = orders_date.status FROM orders_date WHERE orders.id = orders_date.order_id;

-- 6. Добавляем внешние ключи (теперь orders имеет PRIMARY KEY)
ALTER TABLE order_product ADD CONSTRAINT fk_order_product_order FOREIGN KEY (order_id) REFERENCES orders(id);
ALTER TABLE order_product ADD CONSTRAINT fk_order_product_product FOREIGN KEY (product_id) REFERENCES product(id);

-- 7. Удаляем неиспользуемые таблицы
DROP TABLE product_info;
DROP TABLE orders_date;
