# FX & CFD Trading Operations Analytics

A portfolio project that uses **Python, SQL, and Tableau** to analyse trading performance, validate data quality, and simulate trade operations reconciliation across FX, commodity, and equity index instruments.

**Instruments covered:** EUR/USD, AUD/USD, Gold, NASDAQ 100, S&P 500  
**Dashboard:** [View Tableau Dashboard](https://public.tableau.com/views/FX_CFD_Trading_Performance_Dashboard/FXCFDTradingPerformanceDashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)  
**Full report:** [`docs/FX_CFD_Trading_Analytics_Report.md`](docs/FX_CFD_Trading_Analytics_Report.md)

For detailed methodology, results, and business interpretation, see the full project report: `report/FX_CFD_Trading_Analytics_Report.md`.
---

## Project Overview

This project was designed to show how trading data can be collected, cleaned, analysed, validated, and monitored in a practical trading operations workflow.

The workflow has three parts:

1. **Trading Performance Analytics**  
   Builds a moving-average trading strategy, simulates transaction costs and slippage, and evaluates performance using return, drawdown, Sharpe ratio, turnover, and asset-level metrics.

2. **Data Quality & Risk Assessment**  
   Adds governance checks for schema consistency, missing values, duplicate records, OHLC integrity, return calculation, signal logic, transaction cost, and after-cost PnL reconciliation.

3. **Trade Operations Reconciliation**  
   Simulates internal trade records, broker confirmations, and settlement records, then flags missing confirmations, quantity mismatches, price discrepancies, PnL variances, failed settlements, pending settlements, and settlement delays.

---

## Tools & Skills

| Area | Tools / Skills |
|---|---|
| Programming | Python, Pandas, NumPy |
| SQL Analysis | DuckDB, SQL |
| Market Data | yfinance |
| Trading Analytics | Returns, turnover, drawdown, Sharpe ratio, transaction costs, slippage |
| Data Governance | Schema checks, missing value checks, duplicate checks, OHLC validation, reconciliation |
| Trading Operations | Broker confirmation checks, settlement monitoring, exception reporting |
| Visualisation | Tableau, Matplotlib |
| Version Control | Git, GitHub |

---

## Notebook Structure

| Notebook | What it does |
|---|---|
| `01_end_to_end_trading_analytics.ipynb` | Collects market data, creates trading signals, simulates costs, evaluates strategy performance, runs SQL analysis, and prepares Tableau-ready outputs. |
| `02_data_quality_risk_assessment.ipynb` | Checks whether the datasets and calculations are reliable, consistent, and auditable before using them for trading performance review. |
| `03_trade_operations_reconciliation.ipynb` | Simulates a trade lifecycle control process by reconciling internal trades against broker confirmations and settlement records. |

---

## Main Outputs

| Output Area | Example Files |
|---|---|
| Trading analytics | `trade_performance.csv`, `performance_summary.csv`, `dashboard_data.csv` |
| SQL reporting | `sql_performance_summary.csv`, `sql_cost_impact.csv`, `sql_annual_performance.csv` |
| Data governance | `schema_validation.csv`, `missing_value_summary.csv`, `return_reconciliation_summary.csv`, `data_quality_risk_scorecard.csv` |
| Trade operations | `internal_trades.csv`, `broker_confirmations.csv`, `settlement_records.csv`, `trade_exception_report.csv`, `trade_operations_scorecard.csv` |

Detailed methodology, findings, and interpretation are documented in the full project report.

---

## Why This Project Is Relevant

This project is relevant to **trading operations, financial data analytics, risk operations, and data analyst** roles because it combines market data analysis with practical controls used in trading environments:

- performance and cost analysis;
- SQL-based reporting;
- data quality validation;
- calculation reconciliation;
- broker confirmation and settlement exception monitoring;
- dashboard-ready stakeholder reporting.
> This project is for portfolio and educational purposes only. It is not financial advice.
