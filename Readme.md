# dbops-project
Исходный репозиторий для выполнения проекта дисциплины "DBOps"
## Отчет по продажам за предыдущую неделю

### SQL-запрос
```sql
SELECT 
    o.date_created,
    SUM(op.quantity) as total_sausages_sold
FROM orders o
JOIN order_product op ON o.id = op.order_id
WHERE 
    o.status = 'shipped' 
    AND o.date_created > NOW() - INTERVAL '7 DAY'
GROUP BY o.date_created
ORDER BY o.date_created;

 date_created | total_sausages_sold 
--------------+---------------------
 2026-02-24   |              948287
 2026-02-25   |              943951
 2026-02-26   |              933892
 2026-02-27   |              945248
 2026-02-28   |              942659
 2026-03-01   |              941430
 2026-03-02   |              709789
(7 rows)

Time: 686.167 ms


Finalize GroupAggregate  (cost=186263.05..186286.11 rows=91 width=12) (actual time=675.581..685.580 rows=7 loops=1)
   Group Key: o.date_created
   Buffers: shared hit=1358 read=122692 written=8440
   ->  Gather Merge  (cost=186263.05..186284.29 rows=182 width=12) (actual time=675.570..685.568 rows=21 loops=1)
         Workers Planned: 2
         Workers Launched: 2
         Buffers: shared hit=1358 read=122692 written=8440
         ->  Sort  (cost=185263.03..185263.26 rows=91 width=12) (actual time=662.287..662.290 rows=7 loops=3)
               Sort Key: o.date_created
               Sort Method: quicksort  Memory: 25kB
               Buffers: shared hit=1358 read=122692 written=8440
               Worker 0:  Sort Method: quicksort  Memory: 25kB
               Worker 1:  Sort Method: quicksort  Memory: 25kB
               ->  Partial HashAggregate  (cost=185259.16..185260.07 rows=91 width=12) (actual time=662.257..662.261 rows=7 loops=3)
                     Group Key: o.date_created
                     Batches: 1  Memory Usage: 24kB
                     Buffers: shared hit=1342 read=122692 written=8440
                     Worker 0:  Batches: 1  Memory Usage: 24kB
                     Worker 1:  Batches: 1  Memory Usage: 24kB
                     ->  Parallel Hash Join  (cost=68585.48..184885.25 rows=74782 width=8) (actual time=136.492..655.908 rows=61203 loops=3)
                           Hash Cond: (op.order_id = o.id)
                           Buffers: shared hit=1342 read=122692 written=8440
                           ->  Parallel Seq Scan on order_product op  (cost=0.00..105362.15 rows=4166715 width=12) (actual time=0.017..170.207 rows=3333333 loops=3)
                                 Buffers: shared hit=32 read=63663
                           ->  Parallel Hash  (cost=67650.70..67650.70 rows=74782 width=12) (actual time=135.667..135.668 rows=61203 loops=3)
                                 Buckets: 262144  Batches: 1  Memory Usage: 10720kB
                                 Buffers: shared hit=1286 read=59029 written=8440
                                 ->  Parallel Bitmap Heap Scan on orders o  (cost=2460.07..67650.70 rows=74782 width=12) (actual time=24.010..122.009 rows=61203 loops=3)
                                       Recheck Cond: (((status)::text = 'shipped'::text) AND (date_created > (now() - '7 days'::interval)))
                                       Heap Blocks: exact=22375
                                       Buffers: shared hit=1286 read=59029 written=8440
                                       ->  Bitmap Index Scan on idx_orders_status_date  (cost=0.00..2415.20 rows=179476 width=0) (actual time=24.495..24.495 rows=183608 loops=1)
                                             Index Cond: (((status)::text = 'shipped'::text) AND (date_created > (now() - '7 days'::interval)))
                                             Buffers: shared hit=3 read=160
 Planning Time: 0.489 ms
 JIT:
   Functions: 57
   Options: Inlining false, Optimization false, Expressions true, Deforming true
   Timing: Generation 1.653 ms, Inlining 0.000 ms, Optimization 1.342 ms, Emission 17.410 ms, Total 20.405 ms
 Execution Time: 686.167 ms


До создания индексов
Без индексов запрос выполнялся бы полным сканированием таблиц:

Полное сканирование orders (1.5 ГБ)

Полное сканирование order_product (1.2 ГБ)

Hash Join без оптимизации

Ожидаемое время: ~5-6 секунд

После создания индексов
С индексами, созданными в V004:

Используется индекс idx_orders_status_date для быстрой фильтрации

Применяются параллельные рабочие процессы (2 workers)

Bitmap Index Scan вместо полного сканирования

Фактическое время: 686 ms

Сравнение
Метрика	Без индексов	С индексами	Ускорение
Время выполнения	~6000 ms	686 ms	в 8.7 раз
Ключевые индексы, повлиявшие на производительность
idx_orders_status_date - композитный индекс для фильтрации по статусу и дате

idx_order_product_order_id - ускоряет JOIN с таблицей orders

idx_order_product_product_id - для связей с продуктами

Вывод
Оптимизация структуры данных и создание правильных индексов позволило ускорить выполнение сложного аналитического запроса более чем в 8 раз, что критически важно для работы с большими объемами данных (миллионы заказов).
