-- V001: Создание нормализованных таблиц

-- Таблица продуктов (сосиски)
CREATE TABLE product (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    picture_url VARCHAR(255),
    price DOUBLE PRECISION
);

-- Таблица заказов
CREATE TABLE orders (
    id BIGSERIAL PRIMARY KEY,
    status VARCHAR(50) NOT NULL,
    date_created DATE DEFAULT CURRENT_DATE
);

-- Таблица связи заказов и продуктов
CREATE TABLE order_product (
    quantity INTEGER NOT NULL,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    CONSTRAINT fk_order_product_order FOREIGN KEY (order_id) REFERENCES orders(id),
    CONSTRAINT fk_order_product_product FOREIGN KEY (product_id) REFERENCES product(id)
);

-- Создаем индексы для производительности
CREATE INDEX idx_order_product_order_id ON order_product(order_id);
CREATE INDEX idx_order_product_product_id ON order_product(product_id);
CREATE INDEX idx_orders_date_created ON orders(date_created);
