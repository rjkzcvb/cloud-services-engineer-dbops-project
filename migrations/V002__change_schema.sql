-- V002: Нормализация схемы базы данных

-- 1. Добавляем колонку price в таблицу product
ALTER TABLE product ADD COLUMN price double precision;

-- 2. Переносим данные о ценах из product_info в product
UPDATE product 
SET price = product_info.price 
FROM product_info 
WHERE product.id = product_info.product_id;

-- 3. Добавляем колонки date_created и order_status в таблицу orders
ALTER TABLE orders ADD COLUMN date_created date DEFAULT current_date;
ALTER TABLE orders ADD COLUMN order_status varchar(255);

-- 4. Переносим данные из orders_date в orders
UPDATE orders 
SET 
    date_created = orders_date.date_created,
    order_status = orders_date.status
FROM orders_date 
WHERE orders.id = orders_date.order_id;

-- 5. Обновляем статус в orders из orders_date
UPDATE orders 
SET status = orders.order_status 
WHERE order_status IS NOT NULL;

-- 6. Удаляем колонку order_status (больше не нужна)
ALTER TABLE orders DROP COLUMN order_status;

-- 7. Добавляем внешние ключи для обеспечения целостности данных
ALTER TABLE order_product 
    ADD CONSTRAINT fk_order_product_order 
    FOREIGN KEY (order_id) REFERENCES orders(id);

ALTER TABLE order_product 
    ADD CONSTRAINT fk_order_product_product 
    FOREIGN KEY (product_id) REFERENCES product(id);

-- 8. Удаляем неиспользуемые таблицы
DROP TABLE product_info;
DROP TABLE orders_date;
