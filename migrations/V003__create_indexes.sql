-- V003: Создание дополнительных индексов

-- Композитный индекс для оптимизации отчетов
CREATE INDEX idx_orders_status_date ON orders(status, date_created);

-- Анализ таблиц для обновления статистики
ANALYZE orders;
ANALYZE order_product;
ANALYZE product;
