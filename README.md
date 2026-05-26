# FX & CFD Trading Analytics, Risk Control & Data Governance

## Project Summary

This project is an end-to-end trading analytics portfolio project covering FX, commodity, and equity index markets. It evaluates a moving-average trading strategy, simulates transaction costs and slippage, analyses after-cost performance, and adds a dedicated data quality and technical risk assessment layer.

The goal is to show not only basic backtesting, but also the ability to build a reliable trading analytics workflow with risk control and data governance checks.

**Tableau Dashboard:** [View Dashboard](https://public.tableau.com/views/FX_CFD_Trading_Performance_Dashboard/FXCFDTradingPerformanceDashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

**Detailed Report:** For a more detailed explanation of the methodology, results, risk interpretation, and stakeholder communication, please see [FX_CFD_Trading_Analytics_Report.md](docs/FX_CFD_Trading_Analytics_Report.md).

> This project is for portfolio and educational purposes only. It is not financial advice.

---

## What This Project Demonstrates

- Built a Python-based trading analytics pipeline for EUR/USD, AUD/USD, Gold, NASDAQ 100, and S&P 500.
- Generated moving-average trading signals using MA20 and MA50 rules.
- Calculated strategy returns, cumulative returns, volatility, Sharpe ratio, win rate, turnover, exposure, and maximum drawdown.
- Simulated spread, transaction cost, and slippage to evaluate after-cost performance.
- Used DuckDB SQL to analyse trading performance, cost impact, and asset-level risk metrics.
- Built a Tableau dashboard for stakeholder-facing trading performance monitoring.
- Added a data governance notebook to validate data quality, signal logic, cost calculation, and after-cost PnL consistency.

---

## Tech Stack

| Area | Tools |
|---|---|
| Data Processing | Python, Pandas, NumPy |
| Market Data | yfinance |
| SQL Analysis | DuckDB, SQL |
| Risk & Performance Analytics | Sharpe Ratio, Drawdown, Volatility, Turnover, Slippage, Transaction Cost |
| Data Governance | Schema Validation, Missing Value Checks, Duplicate Checks, OHLC Integrity, Reconciliation |
| Visualisation | Matplotlib, Tableau |
| Version Control | Git, GitHub |

---

## Project Workflow

```text
Raw Market Data
      ↓
Data Cleaning & Feature Engineering
      ↓
Moving-Average Signal Generation
      ↓
Transaction Cost & Slippage Simulation
      ↓
After-Cost Trading Performance Analysis
      ↓
SQL-Based Performance Review
      ↓
Data Quality & Technical Risk Assessment
      ↓
Tableau Dashboard Reporting
```

---

## Data Governance & Risk Control Layer

A dedicated notebook, `data_quality_risk_assessment.ipynb`, was created to make the project more realistic and auditable.

It checks:

- whether required columns exist across all datasets;
- whether critical fields contain missing values;
- whether duplicate Date-Asset records exist;
- whether OHLC price fields follow market data integrity rules;
- whether daily returns can be reconciled from close prices;
- whether trading signals match the documented MA20/MA50 logic;
- whether transaction cost, slippage, and after-cost PnL calculations are consistent;
- whether assets show abnormal returns, high-cost trading days, or severe drawdown exposure.

This turns the project from a simple backtest into a trading analytics, risk control, and data governance case study.

---

## Key Outputs

| Output | Description |
|---|---|
| `end_to_end_trading_analytics.ipynb` | Main trading analytics workflow |
| `data_quality_risk_assessment.ipynb` | Data quality and technical risk assessment |
| `trade_performance.csv` | Asset-level strategy performance data |
| `dashboard_data.csv` | Final dataset used for dashboard reporting |
| `data_quality_risk_scorecard.csv` | Asset-level data quality and risk scorecard |
| Tableau Dashboard | Interactive performance and risk monitoring dashboard |

---

## Key Findings

- The strategy performance varies significantly across FX, commodity, and equity index markets.
- Transaction costs and slippage reduce realised returns and can materially affect strategy profitability.
- Drawdown analysis highlights that strong cumulative returns do not always mean lower risk.
- Data quality checks identified OHLC integrity issues in some FX data, showing the importance of market data validation.
- Return, signal, cost, and after-cost PnL reconciliation checks passed, supporting the reliability of the analytics pipeline.
- The final scorecard separates data quality risk from trading performance risk, which is important for financial data and trading operations roles.

---

## Skills Demonstrated

- Financial time-series analysis
- Trading performance analytics
- Transaction cost and slippage modelling
- Risk-adjusted return evaluation
- Data cleaning and feature engineering
- SQL-based analytical reporting
- Data governance and reconciliation controls
- Dashboard design and stakeholder communication

---

