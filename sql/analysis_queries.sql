-- ============================================================
-- FX & CFD Trading Performance Analytics
-- File: sql/analysis_queries.sql
-- Purpose: SQL analysis for trading performance, execution cost,
--          annual return, and high-volatility trading behaviour.
--
-- How to run from the project root after create_tables.sql:
--   duckdb notebooks/trading_analytics.duckdb < sql/analysis_queries.sql
-- ============================================================

-- ------------------------------------------------------------
-- Query 1: Asset-level trading performance after costs
-- Business question:
-- Which asset delivered the strongest risk-adjusted performance
-- after spread, slippage, and transaction costs?
-- ------------------------------------------------------------
SELECT
    asset,
    ROUND(cumulative_return_after_cost, 4) AS cumulative_return_after_cost,
    ROUND(annualised_return_after_cost, 4) AS annualised_return_after_cost,
    ROUND(annualised_volatility_after_cost, 4) AS annualised_volatility_after_cost,
    ROUND(sharpe_ratio_after_cost, 4) AS sharpe_ratio_after_cost,
    ROUND(max_drawdown_after_cost, 4) AS max_drawdown_after_cost,
    ROUND(win_rate_after_cost, 4) AS win_rate_after_cost,
    ROUND(exposure, 4) AS exposure
FROM performance_summary
ORDER BY sharpe_ratio_after_cost DESC;

-- ------------------------------------------------------------
-- Query 2: Execution cost impact by asset
-- Business question:
-- Which asset had the highest total trading cost, and how much
-- did cost reduce strategy performance?
-- ------------------------------------------------------------
SELECT
    asset,
    ROUND(total_transaction_cost, 6) AS total_transaction_cost,
    ROUND(total_slippage_cost, 6) AS total_slippage_cost,
    ROUND(total_cost, 6) AS total_cost,
    ROUND(cost_impact, 4) AS cost_impact,
    total_trades
FROM performance_summary
ORDER BY total_cost DESC;

-- ------------------------------------------------------------
-- Query 3: Annual performance and trading cost trend
-- Business question:
-- How did after-cost return, cost, volatility, and trade count
-- change across different years for each asset?
--
-- Formula note:
-- EXP(SUM(LN(1 + strategy_return_after_cost))) - 1
-- is the SQL equivalent of cumulative compounded return:
-- (1 + returns).prod() - 1
-- ------------------------------------------------------------
SELECT
    asset,
    EXTRACT(YEAR FROM Date) AS trading_year,
    ROUND(EXP(SUM(LN(1 + strategy_return_after_cost))) - 1, 4) AS annual_return_after_cost,
    ROUND(SUM(total_cost), 6) AS annual_total_cost,
    ROUND(AVG(volatility_20d), 6) AS avg_volatility_20d,
    ROUND(SUM(turnover), 0) AS annual_trades
FROM trade_performance
GROUP BY asset, trading_year
ORDER BY asset, trading_year;

-- ------------------------------------------------------------
-- Query 4: High-volatility execution analysis
-- Business question:
-- During high-volatility periods, which assets experienced higher
-- slippage and trading costs?
-- ------------------------------------------------------------
SELECT
    asset,
    ROUND(AVG(strategy_return_after_cost), 6) AS avg_return_after_cost,
    ROUND(AVG(volatility_20d), 6) AS avg_volatility,
    ROUND(AVG(slippage_cost), 6) AS avg_slippage_cost,
    ROUND(SUM(total_cost), 6) AS total_cost,
    ROUND(SUM(turnover), 0) AS total_trades
FROM trade_performance
WHERE volatility_20d > (
    SELECT AVG(volatility_20d)
    FROM trade_performance
)
GROUP BY asset
ORDER BY avg_slippage_cost DESC;

-- ------------------------------------------------------------
-- Optional export queries
-- Uncomment these COPY statements if you want to regenerate the
-- SQL result CSV files directly from DuckDB.
-- ------------------------------------------------------------

-- COPY (
--     SELECT
--         asset,
--         ROUND(cumulative_return_after_cost, 4) AS cumulative_return_after_cost,
--         ROUND(annualised_return_after_cost, 4) AS annualised_return_after_cost,
--         ROUND(annualised_volatility_after_cost, 4) AS annualised_volatility_after_cost,
--         ROUND(sharpe_ratio_after_cost, 4) AS sharpe_ratio_after_cost,
--         ROUND(max_drawdown_after_cost, 4) AS max_drawdown_after_cost,
--         ROUND(win_rate_after_cost, 4) AS win_rate_after_cost,
--         ROUND(exposure, 4) AS exposure
--     FROM performance_summary
--     ORDER BY sharpe_ratio_after_cost DESC
-- ) TO 'data/sql_performance_summary.csv' (HEADER, DELIMITER ',');
--
-- COPY (
--     SELECT
--         asset,
--         ROUND(total_transaction_cost, 6) AS total_transaction_cost,
--         ROUND(total_slippage_cost, 6) AS total_slippage_cost,
--         ROUND(total_cost, 6) AS total_cost,
--         ROUND(cost_impact, 4) AS cost_impact,
--         total_trades
--     FROM performance_summary
--     ORDER BY total_cost DESC
-- ) TO 'data/sql_cost_impact.csv' (HEADER, DELIMITER ',');
--
-- COPY (
--     SELECT
--         asset,
--         EXTRACT(YEAR FROM Date) AS trading_year,
--         ROUND(EXP(SUM(LN(1 + strategy_return_after_cost))) - 1, 4) AS annual_return_after_cost,
--         ROUND(SUM(total_cost), 6) AS annual_total_cost,
--         ROUND(AVG(volatility_20d), 6) AS avg_volatility_20d,
--         ROUND(SUM(turnover), 0) AS annual_trades
--     FROM trade_performance
--     GROUP BY asset, trading_year
--     ORDER BY asset, trading_year
-- ) TO 'data/sql_annual_performance.csv' (HEADER, DELIMITER ',');
--
-- COPY (
--     SELECT
--         asset,
--         ROUND(AVG(strategy_return_after_cost), 6) AS avg_return_after_cost,
--         ROUND(AVG(volatility_20d), 6) AS avg_volatility,
--         ROUND(AVG(slippage_cost), 6) AS avg_slippage_cost,
--         ROUND(SUM(total_cost), 6) AS total_cost,
--         ROUND(SUM(turnover), 0) AS total_trades
--     FROM trade_performance
--     WHERE volatility_20d > (
--         SELECT AVG(volatility_20d)
--         FROM trade_performance
--     )
--     GROUP BY asset
--     ORDER BY avg_slippage_cost DESC
-- ) TO 'data/sql_high_volatility_analysis.csv' (HEADER, DELIMITER ',');
