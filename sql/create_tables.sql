-- ============================================================
-- FX & CFD Trading Performance Analytics
-- File: sql/create_tables.sql
-- Purpose: Load cleaned CSV outputs into DuckDB tables for SQL analysis.
--
-- How to run from the project root:
--   duckdb notebooks/trading_analytics.duckdb < sql/create_tables.sql
-- ============================================================

-- Main daily trading performance table.
-- One row represents one trading day for one asset.
CREATE OR REPLACE TABLE trade_performance AS
SELECT
    CAST(Date AS DATE) AS Date,
    Open,
    High,
    Low,
    Close,
    Volume,
    asset,
    ticker,
    daily_return,
    log_return,
    volatility_20d,
    ma_20,
    ma_50,
    signal,
    position,
    strategy_return_before_cost,
    turnover,
    spread_cost_rate,
    transaction_cost,
    slippage_cost,
    total_cost,
    strategy_return_after_cost,
    cumulative_return_before_cost,
    cumulative_return_after_cost,
    equity_curve_after_cost,
    running_peak_after_cost,
    drawdown_after_cost
FROM read_csv_auto('data/trade_performance.csv', header = true);

-- Asset-level performance summary table.
-- One row represents the overall backtest result for one asset.
CREATE OR REPLACE TABLE performance_summary AS
SELECT
    asset,
    cumulative_return_before_cost,
    cumulative_return_after_cost,
    cost_impact,
    annualised_return_after_cost,
    annualised_volatility_after_cost,
    sharpe_ratio_after_cost,
    max_drawdown_after_cost,
    win_rate_after_cost,
    total_trades,
    exposure,
    total_transaction_cost,
    total_slippage_cost,
    total_cost
FROM read_csv_auto('data/performance_summary.csv', header = true);

-- Optional dashboard-level table.
-- This table can be used by Tableau or other BI tools if needed.
CREATE OR REPLACE TABLE dashboard_data AS
SELECT
    *
FROM read_csv_auto('data/dashboard_data.csv', header = true);

-- Quick validation checks.
SELECT 'trade_performance' AS table_name, COUNT(*) AS row_count FROM trade_performance
UNION ALL
SELECT 'performance_summary' AS table_name, COUNT(*) AS row_count FROM performance_summary
UNION ALL
SELECT 'dashboard_data' AS table_name, COUNT(*) AS row_count FROM dashboard_data;
