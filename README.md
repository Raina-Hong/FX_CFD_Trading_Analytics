# FX & CFD Trading Analytics, Risk Control & Data Governance

## Project Overview

This project is an end-to-end **trading analytics, risk control, and data governance** case study for FX, commodity, and equity index markets.

The project started as a trading performance analytics workflow, but it has been extended beyond a standard backtest. In addition to generating trading signals and evaluating after-cost returns, the project now includes a dedicated **data quality and technical risk assessment layer** to validate whether the market data, signal logic, transaction cost calculations, slippage assumptions, and after-cost PnL outputs are reliable and auditable.

The final workflow combines:

- **Python** for market data collection, cleaning, feature engineering, signal generation, backtesting, cost simulation, risk checks, and visualisation;
- **DuckDB SQL** for repeatable trading performance and execution cost analysis;
- **Tableau** for stakeholder-facing dashboard reporting;
- **Data governance controls** for schema validation, missing value checks, duplicate key checks, OHLC integrity testing, reconciliation, and asset-level risk scoring.

**Interactive Dashboard:** [View Tableau Dashboard](https://public.tableau.com/views/FX_CFD_Trading_Performance_Dashboard/FXCFDTradingPerformanceDashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

> This project is for educational and portfolio demonstration purposes only. It is not financial advice and is not intended to be used as a production trading system.

---

## Business Objective

A trading strategy may appear profitable in a simple backtest, but the result can change significantly after accounting for spread, slippage, transaction costs, data quality issues, and drawdown risk.

This project answers three groups of questions.

### 1. Trading Analytics

- Which assets delivered the strongest after-cost performance?
- How did cumulative return, annualised return, volatility, Sharpe ratio, win rate, exposure, turnover, and maximum drawdown differ across assets?
- Did the moving-average strategy behave differently across FX, commodity, and equity index markets?

### 2. Execution Cost and Risk Control

- How much did spread, transaction cost, and slippage reduce strategy returns?
- Which assets had higher execution costs?
- How did volatility affect slippage and trading cost?
- Which assets showed deeper drawdown exposure?

### 3. Data Governance and Technical Risk

- Are the datasets structurally complete and ready for downstream analysis?
- Are there missing values or duplicate Date-Asset records?
- Do OHLC price fields follow basic market data integrity rules?
- Can daily returns be reconciled from Close prices?
- Does the stored trading signal match the documented MA20/MA50 strategy rule?
- Are total costs and after-cost strategy returns calculated consistently?
- Which assets should be flagged for data quality or performance risk review?

The goal is to demonstrate not only backtesting ability, but also the type of control mindset required in trading analytics, risk operations, market data analysis, and financial data governance roles.

---

## Assets Covered

Historical daily OHLCV data is downloaded using `yfinance`.

| Asset | Ticker | Asset Class |
|---|---:|---|
| EUR/USD | `EURUSD=X` | FX |
| AUD/USD | `AUDUSD=X` | FX |
| Gold Futures | `GC=F` | Commodity |
| NASDAQ 100 | `^NDX` | Equity Index |
| S&P 500 | `^GSPC` | Equity Index |

The final dataset includes daily price data, returns, rolling volatility, moving averages, trading signals, strategy returns, transaction costs, slippage costs, cumulative returns, drawdowns, and governance outputs.

---

## End-to-End Workflow

```text
Raw Market Data
      ↓
Data Cleaning & Feature Engineering
      ↓
Moving-Average Signal Generation
      ↓
Position Lagging to Avoid Look-Ahead Bias
      ↓
Before-Cost Strategy Return Calculation
      ↓
Spread, Transaction Cost & Slippage Simulation
      ↓
After-Cost PnL and Drawdown Calculation
      ↓
Performance Metrics and SQL Analysis
      ↓
Data Quality & Technical Risk Assessment
      ↓
Tableau Dashboard and Governance Outputs
```

---

## Methodology

### 1. Market Data Collection and Preparation

The first notebook downloads daily OHLCV data and transforms it into a clean, analysis-ready time-series dataset.

Key features include:

- daily return;
- log return;
- 20-day and 50-day moving averages;
- 20-day rolling volatility;
- asset-level identifiers;
- cleaned and standardised Date-Asset records.

### 2. Trading Signal Generation

The strategy uses a simple moving-average trend-following rule:

```python
signal = 1 if ma_20 > ma_50 else 0
position = signal.shift(1)
strategy_return_before_cost = position * daily_return
```

The one-day position lag is used to reduce look-ahead bias. This means today's strategy return is based on yesterday's signal, not information from the same day.

### 3. Transaction Cost and Slippage Simulation

The project models three forms of trading friction.

| Cost Component | Description |
|---|---|
| Spread Cost | Estimated bid-ask spread paid when entering or exiting a position |
| Transaction Cost | Fixed trading cost applied when turnover occurs |
| Slippage Cost | Additional execution cost that increases with volatility |
| Total Cost | Combined execution cost deducted from strategy return |

After-cost return is calculated as:

```text
strategy_return_after_cost = strategy_return_before_cost - total_cost
```

This step is important because backtests that ignore execution costs may overstate strategy profitability.

### 4. Performance Evaluation

The project evaluates each asset using common trading and risk metrics.

| Metric | Purpose |
|---|---|
| Cumulative Return After Cost | Measures total compounded strategy performance after execution costs |
| Annualised Return | Converts average return into yearly return |
| Annualised Volatility | Measures return variability and risk |
| Sharpe Ratio | Measures risk-adjusted return |
| Maximum Drawdown | Measures worst peak-to-trough loss |
| Win Rate | Measures percentage of profitable trading days |
| Exposure | Measures percentage of time invested in the market |
| Turnover | Measures position changes and trading activity |
| Total Execution Cost | Measures total cost from spread, transaction cost, and slippage |

---

## Data Quality & Technical Risk Assessment

A second notebook, `data_quality_risk_assessment.ipynb`, was added to turn the project from a simple backtest into a more complete **trading analytics and governance workflow**.

This notebook validates whether the outputs from the trading analytics pipeline are reliable enough for interpretation and reporting.

### Governance Checks Implemented

| Control Area | Check Performed | Why It Matters |
|---|---|---|
| Dataset Inventory | Records dataset size, columns, date range, and asset coverage | Provides traceability of data assets |
| Schema Validation | Checks whether required fields exist in each dataset | Prevents downstream logic from running on incomplete tables |
| Missing Value Check | Identifies missing values in critical fields | Protects return, signal, cost, and PnL calculations |
| Duplicate Key Check | Checks duplicate Date-Asset records | Prevents double counting and distorted performance metrics |
| OHLC Integrity Check | Validates Open, High, Low, Close relationships | Flags market data anomalies before analysis |
| Date Coverage Check | Reviews suspicious gaps in trading dates | Helps monitor data continuity |
| Return Reconciliation | Recalculates returns from Close prices | Confirms stored returns are mathematically consistent |
| Signal Logic Reconciliation | Recomputes MA20/MA50 signals | Confirms signal outputs match documented strategy logic |
| Cost and PnL Reconciliation | Checks total cost and after-cost return formulas | Confirms execution cost and PnL calculations are auditable |
| Technical Risk Detection | Flags extreme return days and high-cost trading days | Supports risk monitoring and review |
| Asset-Level Scorecard | Assigns data quality and performance risk levels | Summarises governance findings for stakeholders |

### Data Governance Findings

The data quality assessment produced the following key findings:

- All datasets passed schema validation.
- No missing values were detected in critical fields.
- No duplicate Date-Asset records were found.
- No suspicious date coverage gaps were identified.
- Return reconciliation checks passed across all assets.
- Signal logic reconciliation confirmed that the stored signals matched the MA20/MA50 rule.
- Cost and PnL reconciliation confirmed that total cost and after-cost returns were calculated consistently.
- 76 OHLC price integrity issues were flagged, mainly from AUD/USD and EUR/USD.
- 70 technical risk events were flagged for review, including extreme return days and high-cost trading days.
- AUD/USD showed medium data quality risk and high performance risk.
- S&P 500 showed low data quality risk but high performance risk due to drawdown exposure.

This distinction is important: **data quality risk and trading performance risk are not the same**. An asset can have clean data but still produce poor risk-adjusted performance, while another asset can have stronger strategy performance but require data quality review.

---

## SQL-Based Trading Analysis

DuckDB SQL is used to perform repeatable analysis on the processed trading outputs.

| SQL File | Purpose |
|---|---|
| `create_tables.sql` | Loads CSV outputs into DuckDB tables |
| `analysis_queries.sql` | Runs performance, cost, annual return, and volatility analysis |

The SQL layer answers questions such as:

- Which asset delivered the strongest after-cost risk-adjusted performance?
- Which asset had the highest total execution cost?
- How did annual performance change across assets?
- How did high-volatility periods affect slippage and trading costs?

Example SQL query:

```sql
SELECT
    asset,
    ROUND(cumulative_return_after_cost, 4) AS cumulative_return_after_cost,
    ROUND(annualised_return_after_cost, 4) AS annualised_return_after_cost,
    ROUND(sharpe_ratio_after_cost, 4) AS sharpe_ratio_after_cost,
    ROUND(max_drawdown_after_cost, 4) AS max_drawdown_after_cost
FROM performance_summary
ORDER BY sharpe_ratio_after_cost DESC;
```

---

## Tableau Dashboard

The Tableau dashboard presents the trading analytics results in a stakeholder-friendly format.

Dashboard components include:

- cumulative return after cost by asset;
- drawdown after cost by asset;
- Sharpe ratio after cost by asset;
- total execution cost by asset;
- average slippage versus 20-day volatility.

**Interactive dashboard:** [View on Tableau Public](https://public.tableau.com/views/FX_CFD_Trading_Performance_Dashboard/FXCFDTradingPerformanceDashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

The dashboard highlights how strategy performance changes after execution costs and helps compare return, drawdown, and cost exposure across asset classes.

---

## Key Findings

### 1. Gold delivered the strongest after-cost performance

Gold had the strongest after-cost cumulative return and the highest Sharpe ratio among the tested assets. This suggests that the moving-average rule was more effective in capturing trend behaviour in gold during the sample period.

### 2. NASDAQ 100 performed well but had higher execution cost exposure

NASDAQ 100 generated positive after-cost performance, but it also showed higher execution cost exposure. This demonstrates why cost analysis is necessary alongside return analysis.

### 3. AUD/USD performed poorly under this strategy

AUD/USD had negative after-cost performance and high drawdown exposure. It was also flagged for OHLC data quality review, making it the asset requiring the most careful interpretation.

### 4. Trading costs reduced returns across all assets

After-cost returns were lower than before-cost returns for every asset. This confirms that ignoring spread, slippage, and transaction costs can make a strategy look more profitable than it really is.

### 5. Data governance checks improved the reliability of the analysis

The governance notebook confirmed that return calculations, signal logic, cost formulas, and after-cost PnL calculations were internally consistent. It also identified specific OHLC price integrity issues, turning the project into a more realistic analytics and control workflow.

---

## Project Structure

```text
FX_CFD_Trading_Analytics/
├── README.md
├── requirements.txt
├── data/
│   ├── raw_market_data.csv
│   ├── processed_market_data.csv
│   ├── trading_signals.csv
│   ├── trade_performance.csv
│   ├── performance_summary.csv
│   └── dashboard_data.csv
├── data_quality_risk_outputs/
│   ├── dataset_inventory.csv
│   ├── schema_validation.csv
│   ├── missing_value_summary.csv
│   ├── duplicate_key_summary.csv
│   ├── ohlc_integrity_summary.csv
│   ├── date_gap_summary.csv
│   ├── return_reconciliation_summary.csv
│   ├── signal_logic_reconciliation.csv
│   ├── cost_pnl_reconciliation_summary.csv
│   ├── technical_risk_event_summary.csv
│   ├── data_quality_risk_scorecard.csv
│   ├── governance_recommendations.csv
│   └── data_quality_risk_score_by_asset.png
├── notebooks/
│   ├── end_to_end_trading_analytics.ipynb
│   └── data_quality_risk_assessment.ipynb
├── sql/
│   ├── create_tables.sql
│   └── analysis_queries.sql
├── dashboard/
│   ├── FX_CFD_Trading_Performance_Dashboard.png
│   ├── cumulative_return_after_cost.png
│   └── FX_CFD_Trading_Performance_Dashboard.twbx
└── reports/
    └── FX_CFD_Trading_Analytics_Report.pdf
```

---

## How to Run

### 1. Clone the repository

```bash
git clone <your-repository-url>
cd FX_CFD_Trading_Analytics
```

### 2. Install dependencies

```bash
pip install -r requirements.txt
```

### 3. Run the trading analytics notebook

```text
notebooks/end_to_end_trading_analytics.ipynb
```

This notebook generates cleaned market data, trading signals, performance outputs, SQL-ready CSV files, and dashboard data.

### 4. Run the data quality and technical risk notebook

```text
notebooks/data_quality_risk_assessment.ipynb
```

This notebook generates governance outputs, reconciliation summaries, technical risk events, and the asset-level risk scorecard.

### 5. Run SQL scripts with DuckDB

From the project root:

```bash
duckdb notebooks/trading_analytics.duckdb < sql/create_tables.sql
duckdb notebooks/trading_analytics.duckdb < sql/analysis_queries.sql
```

### 6. Open the Tableau dashboard

```text
dashboard/FX_CFD_Trading_Performance_Dashboard.twbx
```

---

## Skills Demonstrated

### Financial and Quantitative Analysis

- Financial time-series analysis
- Moving-average signal generation
- Backtesting logic and look-ahead bias control
- Return, volatility, Sharpe ratio, drawdown, exposure, turnover, and win rate analysis
- Transaction cost and slippage simulation
- Execution cost impact analysis
- Technical risk event monitoring

### Data Analytics and Engineering

- Python data processing with Pandas and NumPy
- Repeatable notebook-based analytics workflow
- DuckDB SQL analysis
- CSV output generation for downstream reporting
- Tableau dashboard preparation
- Data validation and reconciliation controls

### Data Governance and Risk Control

- Dataset inventory and auditability
- Schema validation
- Missing value and duplicate key checks
- OHLC market data integrity checks
- Return calculation reconciliation
- Signal logic reconciliation
- Cost and after-cost PnL reconciliation
- Asset-level data quality and performance risk scorecard
- Governance recommendations for review and monitoring

---

## Limitations

This project is designed for analytics and portfolio demonstration purposes. It has several limitations:

- The strategy is a simple long-only moving-average strategy and does not include short selling.
- Spread, slippage, and transaction costs are simulated rather than sourced from real broker execution records.
- The backtest does not include leverage, margin requirements, overnight financing, tax, or funding costs.
- Strategy parameters are fixed and are not optimised through walk-forward testing.
- Daily data is used, so the project does not capture intraday execution dynamics.
- OHLC issues are flagged for governance review, but this project does not replace a professional market data vendor validation process.

---

## Future Improvements

Potential extensions include:

- Add long-short strategy logic and compare it with the current long-only approach.
- Test multiple moving-average windows such as 10/50, 20/100, and 50/200.
- Add benchmark comparison against buy-and-hold returns.
- Add volatility targeting, stop-loss, or drawdown control rules.
- Use real bid-ask spread and tick-level data for more realistic execution modelling.
- Build automated data quality alerts for OHLC anomalies and reconciliation failures.
- Extend the risk scorecard into a Tableau governance dashboard.
- Add unit tests for return, signal, cost, and PnL calculation functions.

---

## Portfolio Value

This project demonstrates a complete workflow that goes beyond a beginner-level backtest. It shows the ability to:

- build an end-to-end trading analytics pipeline;
- evaluate after-cost trading performance;
- use SQL for repeatable financial data analysis;
- communicate results through Tableau;
- validate data quality and calculation logic;
- identify market data issues and technical risk events;
- translate technical checks into governance findings.

It is suitable for roles related to trading analytics, quant analytics, financial data analysis, market data operations, risk analytics, data governance, and business/data analyst positions in financial services.

---

## Disclaimer

This project is for educational and portfolio demonstration purposes only. It is not financial advice, investment advice, or a production trading system.
