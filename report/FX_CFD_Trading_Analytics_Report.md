# FX & CFD Trading Performance Analytics Report

## 1. Executive Summary

I built a multi-asset trading analytics workflow to evaluate whether a simple trend-following strategy remained profitable after execution costs, and whether the underlying trading data was reliable enough for performance reporting. The analysis covers **AUD/USD, EUR/USD, Gold, NASDAQ 100, and S&P 500** from **2021 to 2025**, using daily OHLCV market data.

The workflow combines three parts: strategy performance analytics, data quality and technical risk assessment, and trade operations reconciliation. Python was used for data cleaning, signal generation, cost simulation, risk metrics, and exception checks. DuckDB/SQL was used to create reporting tables and asset-level summaries. Tableau was used to convert the results into a dashboard for business review.

The main finding is that the same moving-average strategy performed very differently across assets. **Gold was the strongest asset**, producing **79.7% cumulative return after cost** and a **0.98 Sharpe ratio**. **NASDAQ 100 also performed well**, with **31.5% cumulative return after cost**, but had the highest total execution cost and a larger drawdown. **AUD/USD performed poorly**, with **-31.6% cumulative return after cost** and a **-1.08 Sharpe ratio**.

From a business perspective, the strategy should not be applied uniformly across all instruments. Gold is the best candidate for further testing, NASDAQ 100 needs stronger drawdown and execution-cost controls, and AUD/USD should be excluded or redesigned under this strategy rule. The governance and reconciliation modules also show how performance analytics can be connected with operational risk monitoring, which is important for trading operations, risk, and financial data analyst roles.

---

## 2. Business Questions Addressed

This report is structured around four practical questions:

| Business Question | Analysis Performed | Output |
|---|---|---|
| Which assets generated the best after-cost performance? | Backtested a moving-average strategy across five instruments | Performance summary and cumulative return chart |
| How much did transaction cost and slippage reduce performance? | Simulated fixed transaction cost and volatility-linked slippage | Execution cost summary by asset |
| Can the data and calculations be trusted? | Validated schema, missing values, duplicates, OHLC logic, returns, signals, and PnL calculations | Data governance scorecard |
| What operational issues may occur after trades are generated? | Reconciled simulated internal trades against broker confirmations and settlement records | Exception reports and operations scorecard |

---

## 3. Data, Tools, and Methodology

### 3.1 Asset Coverage

The analysis covers five liquid FX and CFD-style instruments across currency, commodity, and equity index exposure.

| Asset | Market Type | Reason for Inclusion |
|---|---|---|
| AUD/USD | FX | Commodity-linked currency pair with different trend behaviour from EUR/USD |
| EUR/USD | FX | Highly liquid major FX pair |
| Gold | Commodity | Trend-sensitive safe-haven asset |
| NASDAQ 100 | Equity Index | High-growth, high-volatility equity index exposure |
| S&P 500 | Equity Index | Broad US equity market benchmark |

### 3.2 Tools Used

| Tool | How It Was Used |
|---|---|
| Python | End-to-end data processing, feature engineering, signal generation, cost simulation, risk metrics, and reconciliation logic |
| Pandas / NumPy | Time-series calculations, rolling indicators, grouped metrics, and exception flagging |
| DuckDB / SQL | Performance summaries, cost analysis, annual reporting tables, and dashboard-ready exports |
| Tableau | Stakeholder-facing dashboard for performance, drawdown, Sharpe ratio, cost, and slippage analysis |
| Matplotlib | Supporting charts for report validation |
| Jupyter Notebook | Reproducible analytical workflow split into three notebooks |

### 3.3 Notebook Structure

| Notebook | Purpose | Main Output |
|---|---|---|
| `01_end_to_end_trading_analytics.ipynb` | Builds the trading strategy, applies costs, calculates performance metrics, and exports dashboard data | `performance_summary.csv`, `trade_performance.csv`, SQL exports, dashboard dataset |
| `02_data_quality_risk_assessment.ipynb` | Checks data reliability, calculation consistency, and technical risk events | Governance summary and risk control outputs |
| `03_trade_operations_reconciliation.ipynb` | Simulates internal trades, broker confirmations, settlements, and exception monitoring | Trade exception reports, settlement exception reports, operations scorecard |

---

## 4. Strategy and Backtest Design

The trading rule is a simple moving-average crossover strategy:

| Condition | Trading Action |
|---|---|
| 20-day moving average > 50-day moving average | Hold a long position |
| 20-day moving average <= 50-day moving average | Stay out of the market |

To avoid look-ahead bias, the signal was shifted by one trading day. This means the strategy uses yesterday's signal to decide today's position, rather than using information that would not have been available at execution time.

The backtest calculated both before-cost and after-cost returns. The after-cost return includes:

- fixed transaction cost on trading days;
- slippage cost linked to rolling 20-day volatility;
- turnover generated when the strategy enters or exits positions.

The final performance metrics include cumulative return, annualised return, annualised volatility, Sharpe ratio, maximum drawdown, win rate, exposure, total trades, transaction cost, slippage cost, and total execution cost.

---

## 5. Trading Performance Results

### 5.1 After-Cost Performance Summary

| Asset | Cumulative Return After Cost | Annualised Return After Cost | Sharpe Ratio After Cost | Max Drawdown After Cost | Win Rate | Total Trades |
|---|---:|---:|---:|---:|---:|---:|
| Gold | 79.7% | 13.0% | 0.98 | -14.6% | 35.3% | 25 |
| NASDAQ 100 | 31.5% | 5.9% | 0.46 | -28.1% | 35.9% | 25 |
| S&P 500 | 11.9% | 2.4% | 0.26 | -31.2% | 36.9% | 23 |
| EUR/USD | 4.5% | 0.9% | 0.20 | -8.7% | 20.0% | 31 |
| AUD/USD | -31.6% | -7.4% | -1.08 | -33.2% | 21.1% | 35 |

![Cumulative Return After Cost by Asset](../dashboard/cumulative_return_after_cost.png)

### 5.2 Interpretation

**Gold delivered the best risk-adjusted result.** It generated **79.7% cumulative return after cost** and the highest Sharpe ratio at **0.98**. Its maximum drawdown was **-14.6%**, which was materially lower than NASDAQ 100, S&P 500, and AUD/USD. This suggests that the moving-average rule captured stronger and more persistent trend behaviour in Gold than in the other assets.

**NASDAQ 100 was profitable but operationally more expensive.** It returned **31.5% after cost**, but its maximum drawdown reached **-28.1%** and its total execution cost was the highest in the asset universe. This is still a positive strategy result, but it would require closer monitoring of volatility, slippage, and position sizing before being used in a production-style setting.

**AUD/USD was not suitable for this strategy configuration.** It had the worst cumulative return at **-31.6%**, the weakest Sharpe ratio at **-1.08**, and the largest drawdown at **-33.2%**. It also had the highest number of trades, meaning the strategy traded more often without generating positive performance. This points to poor signal quality rather than only a cost issue.

**S&P 500 and EUR/USD were positive but not strong enough.** Both assets produced positive after-cost returns, but their Sharpe ratios were low. These assets may need additional filters, different moving-average windows, or volatility-based risk controls.

---

## 6. Execution Cost and Slippage Analysis

The analysis separated transaction cost and slippage cost to show where performance was being reduced by execution friction.

| Asset | Transaction Cost | Slippage Cost | Total Cost | Cost Impact | Total Trades |
|---|---:|---:|---:|---:|---:|
| NASDAQ 100 | 0.0075 | 0.0349 | 0.0424 | 5.69% | 25 |
| S&P 500 | 0.0058 | 0.0247 | 0.0304 | 3.46% | 23 |
| Gold | 0.0050 | 0.0222 | 0.0272 | 4.97% | 25 |
| AUD/USD | 0.0025 | 0.0211 | 0.0235 | 1.63% | 35 |
| EUR/USD | 0.0016 | 0.0130 | 0.0146 | 1.53% | 31 |

NASDAQ 100 had the highest cost drag. Its positive return after cost shows that the strategy signal was strong enough to remain profitable, but the cost profile would matter in live execution. Gold also absorbed a meaningful cost impact and still remained the top performer. By contrast, AUD/USD was already weak before considering costs, so reducing execution cost alone would not fix the strategy.

For a trading desk or operations team, this cost breakdown helps identify which assets require tighter execution monitoring, spread checks, and slippage review.

---

## 7. Data Quality and Risk Control Results

A separate data governance layer was added because performance results are only useful when the input data and calculations are reliable.

### 7.1 Dataset Inventory

| Dataset | Rows | Columns | Date Range | Assets | Duplicate Date-Asset Records |
|---|---:|---:|---|---:|---:|
| Raw market data | 6,362 | 8 | 2021-01-01 to 2025-12-30 | 5 | 0 |
| Processed market data | 6,117 | 13 | 2021-03-11 to 2025-12-30 | 5 | 0 |
| Trading signals | 6,117 | 16 | 2021-03-11 to 2025-12-30 | 5 | 0 |
| Trade performance | 6,117 | 27 | 2021-03-11 to 2025-12-30 | 5 | 0 |

### 7.2 Governance Control Summary

| Control Area | Result | Business Meaning |
|---|---|---|
| Schema validation | 0 failed required-column checks | Required fields were available for downstream analysis |
| Missing value check | 0 missing values in critical trading fields | Key return, position, cost, and drawdown fields were complete |
| Duplicate control | 0 duplicate Date-Asset records | No duplicate daily asset records affected the backtest |
| Return reconciliation | 0 return calculation mismatches | Returns were consistent with close-price movements |
| Signal governance | 0 signal logic mismatches | Generated signals matched the documented moving-average rule |
| Cost and PnL control | 0 cost/PnL reconciliation failures | After-cost returns were calculated consistently |
| Market data integrity | 76 OHLC price integrity issues | Some FX records require review before production use |
| Technical risk monitoring | 70 technical risk events | Extreme return and high-cost days were flagged for review |

### 7.3 Interpretation

The core calculation pipeline passed the main reconciliation checks. This means the strategy returns, signals, cost logic, and after-cost PnL were internally consistent.

The main data issue came from OHLC integrity checks. The assessment found **76 invalid OHLC records**, mainly in the FX data. These records did not break the workflow, but they should be flagged before using the dataset for production reporting or live strategy research. This is an important distinction: the backtest can run successfully, but data governance still identifies records that require review.

This part of the project demonstrates practical controls that a financial data or trading operations team would care about: schema checks, duplicate checks, calculation reconciliation, data integrity flags, and exception-ready outputs.

---

## 8. Trade Operations Reconciliation Results

The third notebook extended the project from strategy analytics into trade lifecycle monitoring. I generated a simulated internal trade blotter from strategy events, then created broker confirmation and settlement datasets with controlled exceptions.

### 8.1 Operations Dataset

| Dataset | Record Count | Purpose |
|---|---:|---|
| Internal trades | 120 | Simulated trades generated from strategy activity |
| Broker confirmations | 115 | External confirmation records used for trade matching |
| Settlement records | 115 | Settlement status records used to monitor completion and delays |

### 8.2 Trade Confirmation Exceptions

| Exception Type | Severity | Count |
|---|---|---:|
| Quantity Mismatch | High | 6 |
| Missing Broker Confirmation | High | 5 |
| Price Discrepancy | Medium | 5 |
| PnL Variance | Medium | 6 |

The broker confirmation coverage rate was **95.83%**. The trade exception rate was **18.33%**, driven by missing confirmations, quantity breaks, price discrepancies, and PnL variances.

### 8.3 Settlement Exceptions

| Exception Type | Severity | Count |
|---|---|---:|
| Settlement Not Completed | High | 44 |
| Missing Settlement Record | High | 5 |
| Settlement Delay | Medium | 5 |

The settlement completion rate was **61.74%**, while the settlement exception rate was **45.00%**. These exceptions were intentionally simulated to demonstrate the control logic, but the workflow mirrors how trading operations teams monitor breaks after trade execution.

### 8.4 Operations Scorecard

| Metric | Value |
|---|---:|
| Total Internal Trades | 120 |
| Total Broker Confirmations | 115 |
| Total Settlement Records | 115 |
| Trade Exception Count | 22 |
| Settlement Exception Count | 54 |
| Broker Confirmation Coverage | 95.83% |
| Settlement Completion Rate | 61.74% |
| Trade Exception Rate | 18.33% |
| Settlement Exception Rate | 45.00% |

### 8.5 Business Value

The reconciliation module shows how a strategy output can be monitored after execution. Instead of stopping at backtest performance, the workflow checks whether trades are confirmed, whether prices and quantities match, whether PnL is consistent, and whether settlements are completed on time.

For a trading operations team, this type of reporting supports faster break detection, clearer exception prioritisation, broker follow-up, settlement monitoring, and audit-ready documentation.

---

## 9. Tableau Dashboard

The Tableau dashboard was designed for stakeholder review. It summarises the trading performance and execution-quality results in one view.

![FX & CFD Trading Performance Dashboard](../dashboard/FX_CFD_Trading_Performance_Dashboard.png)

The dashboard includes:

| View | Purpose |
|---|---|
| Cumulative Return After Cost by Asset | Compares long-term strategy performance |
| Drawdown After Cost by Asset | Shows downside risk and recovery patterns |
| Sharpe Ratio After Cost by Asset | Compares risk-adjusted performance |
| Total Execution Cost by Asset | Identifies assets with higher cost drag |
| Average Slippage vs 20-Day Volatility | Links volatility conditions with execution cost |

The dashboard helps a non-technical stakeholder quickly see that Gold was the strongest asset, AUD/USD was the weakest, and NASDAQ 100 required closer cost and drawdown monitoring.

---

## 10. Business Recommendations

### 10.1 Strategy Deployment Review

Gold should be prioritised for further testing because it produced the best combination of cumulative return, Sharpe ratio, and drawdown. The next step would be to test parameter robustness, compare against buy-and-hold, and run walk-forward validation.

NASDAQ 100 should remain on the watchlist, but only with stronger risk controls. Its return was attractive, but the drawdown and execution cost profile were meaningfully higher than Gold.

AUD/USD should not be deployed under the current rule. The strategy traded frequently and still produced negative after-cost performance, which suggests weak signal quality for this instrument.

### 10.2 Risk and Operations Controls

Before using the analytics output for formal reporting, OHLC integrity issues should be reviewed and flagged. The data quality checks should remain part of the regular workflow because they reduce the risk of reporting incorrect performance.

The trade reconciliation process should be used as a standard post-trade control. Missing confirmations, quantity mismatches, price discrepancies, PnL variances, settlement failures, and settlement delays should be reported through a structured exception file or dashboard.

---

## 11. Limitations and Next Steps

This project is a portfolio analytics and operations-monitoring project, not a live trading system.

Current limitations:

- the strategy uses only a simple long-only moving-average rule;
- transaction cost and slippage assumptions are simulated;
- broker confirmations and settlement records are simulated;
- the analysis does not use live order book data or real broker execution reports;
- the results are for analytical demonstration and should not be treated as investment advice.

Recommended next steps:

- test alternative moving-average windows;
- add volatility filters or regime detection;
- compare results against buy-and-hold benchmarks;
- add position sizing and stop-loss rules;
- run walk-forward validation;
- connect trade exception outputs to Tableau;
- add automated alerts for high-severity reconciliation breaks.

---

## 12. Skills Demonstrated

| Skill Area | Evidence from Project |
|---|---|
| Financial market analytics | Multi-asset return, volatility, drawdown, Sharpe ratio, win rate, exposure, and cost analysis |
| Python data analysis | Data cleaning, feature engineering, signal generation, cost modelling, backtesting, and exception detection |
| SQL analytics | DuckDB queries for performance summaries, cost impact, annual performance, and dashboard exports |
| Data governance | Schema validation, duplicate checks, missing value checks, OHLC integrity checks, return reconciliation, and PnL reconciliation |
| Trading operations | Internal trade, broker confirmation, settlement reconciliation, exception reporting, and operations scorecard |
| Tableau dashboarding | Stakeholder-facing visualisation of return, drawdown, Sharpe ratio, execution cost, and slippage behaviour |
| Business communication | Translating technical results into asset selection, cost monitoring, risk control, and operations recommendations |

---

## 13. Final Conclusion

The project produced a complete trading analytics workflow covering strategy performance, execution cost, data quality, and trade operations controls. The strongest result came from **Gold**, which generated **79.7% cumulative return after cost** with a **0.98 Sharpe ratio**. **NASDAQ 100** was also profitable but required closer cost and drawdown monitoring. **AUD/USD** was not suitable under the current strategy design.

The broader business value is that the workflow does more than calculate returns. It also checks whether the data is trustworthy, whether costs are correctly applied, whether calculations reconcile, and whether post-trade exceptions can be identified. That makes the project relevant for financial data analytics, trading operations, risk reporting, and dashboard-based stakeholder communication.
