-- Trade Operations Reconciliation & Exception Monitoring Queries

-- 1. Missing broker confirmations
SELECT
    i.trade_id,
    i.trade_date,
    i.asset,
    i.side,
    i.quantity,
    i.execution_price
FROM internal_trades i
LEFT JOIN broker_confirmations b
    ON i.trade_id = b.trade_id
WHERE b.trade_id IS NULL;


-- 2. Quantity mismatches
SELECT
    i.trade_id,
    i.asset,
    i.quantity AS internal_quantity,
    b.confirmed_quantity,
    i.quantity - b.confirmed_quantity AS quantity_difference
FROM internal_trades i
JOIN broker_confirmations b
    ON i.trade_id = b.trade_id
WHERE i.quantity <> b.confirmed_quantity;


-- 3. Price discrepancies above tolerance
SELECT
    i.trade_id,
    i.asset,
    i.execution_price,
    b.confirmed_price,
    ABS(b.confirmed_price - i.execution_price) / i.execution_price AS price_diff_rate
FROM internal_trades i
JOIN broker_confirmations b
    ON i.trade_id = b.trade_id
WHERE ABS(b.confirmed_price - i.execution_price) / i.execution_price > 0.002;


-- 4. PnL variances above tolerance
SELECT
    i.trade_id,
    i.asset,
    i.expected_pnl,
    b.reported_pnl,
    b.reported_pnl - i.expected_pnl AS pnl_difference
FROM internal_trades i
JOIN broker_confirmations b
    ON i.trade_id = b.trade_id
WHERE ABS(b.reported_pnl - i.expected_pnl) > 100;


-- 5. Settlement exceptions
SELECT
    i.trade_id,
    i.trade_date,
    i.asset,
    s.settlement_date,
    s.settlement_status
FROM internal_trades i
LEFT JOIN settlement_records s
    ON i.trade_id = s.trade_id
WHERE s.trade_id IS NULL
   OR s.settlement_status IN ('FAILED', 'PENDING')
   OR DATE_DIFF('day', i.trade_date, s.settlement_date) > 4;


-- 6. Exception summary
SELECT
    exception_type,
    severity,
    COUNT(*) AS exception_count
FROM trade_exception_report
GROUP BY exception_type, severity
ORDER BY exception_count DESC;