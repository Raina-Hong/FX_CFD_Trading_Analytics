# FX & CFD Trading Analytics Report

## 1. Executive Summary

This project builds an end-to-end trading analytics workflow for five FX and CFD instruments: **AUD/USD, EUR/USD, Gold, NASDAQ 100, and S&P 500**. The project combines **Python**, **SQL/DuckDB**, **Tableau**, and **data governance checks** to analyse trading performance after realistic execution costs, validate the reliability of the underlying data, and simulate a lightweight trade operations reconciliation process.

The project is designed to answer four practical business questions:

1. Which assets performed best after transaction costs and slippage?
2. How much did execution costs reduce strategy performance?
3. Can the market data, signal logic, return calculation, and after-cost PnL be trusted?
4. What operational exceptions may occur when internal trade records are reconciled against broker confirmations and settlement records?

The main result is that the same moving-average strategy produced very different outcomes across assets. **Gold performed best**, with an after-cost cumulative return of **79.7%** and a Sharpe ratio of **0.98**. **NASDAQ 100** also generated positive returns, with an after-cost cumulative return of **31.5%**, but it had the highest total execution cost and higher drawdown risk. **AUD/USD performed worst**, with an after-cost cumulative return of **-31.6%** and a Sharpe ratio of **-1.08**.

From a business perspective, the strategy should not be applied uniformly across all assets. Gold showed the strongest fit for this trend-following logic, while AUD/USD should be reviewed, adjusted, or excluded from the strategy universe. The project also shows how trading analytics can be extended beyond performance measurement into **risk control, reconciliation, exception monitoring, and stakeholder reporting**.

---

## 2. Project Objective

The purpose of this project is not only to test whether a simple strategy makes money. In a trading operations or financial data analytics environment, performance analysis also needs to consider execution cost, data quality, calculation reliability, and operational risk.

This project therefore covers three connected layers:

| Layer | Purpose | Main Output |
|---|---|---|
| Trading performance analytics | Evaluate strategy return, cost, drawdown, and risk-adjusted performance | `performance_summary.csv`, dashboard data |
| Data quality and risk control | Validate data integrity, signal logic, return calculation, and cost/PnL consistency | data governance scorecard and risk reports |
| Trade operations reconciliation | Simulate trade lifecycle controls across internal trades, broker confirmations, and settlement records | exception reports and operations scorecard |

This structure makes the project relevant to roles such as **Trading Operations Analyst**, **Financial Data Analyst**, **Risk Analyst**, and **Data Analyst in financial markets**.

---

## 3. Data Scope and Tools

### 3.1 Asset Universe

The project analyses five instruments across FX, commodity, and equity index exposure.

| Asset | Asset Class | Reason for Inclusion |
|---|---|---|
| AUD/USD | FX | Currency pair with commodity-linked behaviour |
| EUR/USD | FX | Highly liquid major currency pair |
| Gold | Commodity CFD | Trend-sensitive safe-haven asset |
| NASDAQ 100 | Equity Index CFD | High-growth, high-volatility index |
| S&P 500 | Equity Index CFD | Broad US equity market benchmark |

### 3.2 Tools Used

| Tool | Usage |
|---|---|
| Python | Data cleaning, feature engineering, signal generation, cost simulation, performance metrics |
| Pandas / NumPy | Time-series transformation, calculations, aggregation, reconciliation checks |
| DuckDB / SQL | Performance summaries, cost analysis, volatility analysis, dashboard-ready exports |
| Tableau | Stakeholder-facing dashboard and visual analytics |
| Matplotlib | Supporting charts for report and validation |
| Jupyter Notebook | Reproducible project workflow |

---

## 4. Analytical Workflow

The project is organised into three notebooks.

### 4.1 Notebook 01: End-to-End Trading Analytics

The first notebook creates the main trading analytics pipeline.

**What was done:**

1. Downloaded and structured OHLCV market data.
2. Calculated daily returns, log returns, rolling volatility, 20-day moving average, and 50-day moving average.
3. Generated trading signals using a moving-average crossover rule.
4. Shifted signals by one day to avoid look-ahead bias.
5. Simulated transaction costs and slippage.
6. Calculated after-cost strategy returns, cumulative returns, equity curve, drawdown, Sharpe ratio, win rate, and exposure.
7. Exported SQL-ready and Tableau-ready datasets.

**Strategy rule:**

| Condition | Signal |
|---|---|
| 20-day moving average > 50-day moving average | Buy / hold long position |
| 20-day moving average <= 50-day moving average | Stay out / no long exposure |

A one-day signal shift was applied so that the strategy only uses information available before the trading day.

### 4.2 Notebook 02: Data Quality and Risk Assessment

The second notebook validates whether the data and calculations can be trusted before using the outputs for analysis.

**Controls implemented:**

- schema validation;
- duplicate Date-Asset key check;
- missing value check on critical columns;
- OHLC integrity check;
- return recalculation and reconciliation;
- signal logic reconciliation;
- transaction cost and after-cost PnL reconciliation;
- technical risk event monitoring;
- governance recommendation output.

This turns the project from a simple backtest into a more professional workflow with data governance and auditability.

### 4.3 Notebook 03: Trade Operations Reconciliation

The third notebook simulates a lightweight trade operations workflow.

**What was done:**

1. Created simulated internal trade records from strategy-generated trade events.
2. Created broker confirmation records with controlled exceptions.
3. Created settlement records with simulated failed, pending, missing, and delayed settlements.
4. Reconciled internal trades against broker confirmations.
5. Reconciled confirmed trades against settlement records.
6. Generated detailed exception reports, asset-level exception summaries, and a trade operations scorecard.

This module demonstrates trade lifecycle awareness and exception monitoring, which are directly relevant to trading operations roles.

---

## 5. Trading Performance Results

### 5.1 After-Cost Performance Summary

| Asset | Cumulative Return After Cost | Annualised Return After Cost | Sharpe Ratio After Cost | Max Drawdown After Cost | Total Trades |
|---|---:|---:|---:|---:|---:|
| Gold | 79.7% | 13.0% | 0.98 | -14.6% | 25 |
| NASDAQ 100 | 31.5% | 5.9% | 0.46 | -28.1% | 25 |
| S&P 500 | 11.9% | 2.4% | 0.26 | -31.2% | 23 |
| EUR/USD | 4.5% | 0.9% | 0.20 | -8.7% | 31 |
| AUD/USD | -31.6% | -7.4% | -1.08 | -33.2% | 35 |

### 5.2 Key Findings

**Gold was the strongest asset in the strategy universe.**  
Gold achieved the highest after-cost cumulative return at **79.7%** and the highest Sharpe ratio at **0.98**. It also had a moderate maximum drawdown of **-14.6%**, making it the strongest risk-adjusted performer in this project.

**NASDAQ 100 generated strong positive returns but carried higher risk.**  
NASDAQ 100 returned **31.5%** after costs, but its maximum drawdown reached **-28.1%**. It also had the highest total execution cost among all assets, suggesting that the strategy may be profitable but needs tighter risk and cost monitoring.

**AUD/USD was unsuitable for this strategy setup.**  
AUD/USD produced an after-cost cumulative return of **-31.6%** and a Sharpe ratio of **-1.08**. Although it had the highest number of trades (**35**), its performance remained negative after costs, indicating that the moving-average rule did not capture useful trend behaviour for this asset.

**S&P 500 and EUR/USD were positive but weak.**  
S&P 500 and EUR/USD produced positive after-cost returns, but their Sharpe ratios were relatively low. These assets may require additional filters, different moving-average windows, or volatility-based position sizing before being considered for deployment.

---

## 6. Execution Cost and Slippage Analysis

The strategy includes both fixed transaction costs and volatility-linked slippage costs. This makes the analysis more realistic than a simple return-only backtest.

| Asset | Transaction Cost | Slippage Cost | Total Cost | Cost Impact |
|---|---:|---:|---:|---:|
| NASDAQ 100 | 0.0075 | 0.0349 | 0.0424 | 5.69% |
| S&P 500 | 0.0058 | 0.0247 | 0.0304 | 3.46% |
| Gold | 0.0050 | 0.0222 | 0.0272 | 4.97% |
| AUD/USD | 0.0025 | 0.0211 | 0.0235 | 1.63% |
| EUR/USD | 0.0016 | 0.0130 | 0.0146 | 1.53% |

### Business Interpretation

Execution cost materially changed the strategy results. NASDAQ 100 had the highest total cost and the largest cost impact, which means execution quality would be important if this strategy were used in a real trading environment. Gold still performed strongly after cost, which suggests that its trend-following signal was strong enough to absorb the simulated cost drag.

For trading operations and risk teams, this type of analysis helps identify where execution cost, spread, and slippage may reduce strategy profitability and where desk-level monitoring should be prioritised.

---

## 7. Data Quality and Risk Control Results

The data quality assessment checked whether the datasets and calculations were reliable enough for reporting.

### 7.1 Dataset Inventory

| Dataset | Rows | Columns | Date Range | Assets | Duplicate Rows |
|---|---:|---:|---|---:|---:|
| Raw market data | 6,362 | 8 | 2021-01-01 to 2025-12-30 | 5 | 0 |
| Processed market data | 6,117 | 13 | 2021-03-11 to 2025-12-30 | 5 | 0 |
| Trading signals | 6,117 | 16 | 2021-03-11 to 2025-12-30 | 5 | 0 |
| Trade performance | 6,117 | 27 | 2021-03-11 to 2025-12-30 | 5 | 0 |

### 7.2 Control Results

| Control Area | Result |
|---|---|
| Schema validation | 0 datasets failed required-column checks |
| Duplicate control | 0 duplicate Date-Asset records detected |
| Return reconciliation | 0 return calculation mismatches detected |
| Signal governance | 0 signal logic mismatches detected |
| Cost and PnL control | 0 cost/PnL reconciliation failures detected |
| Market data integrity | 76 OHLC price integrity issues detected |
| Technical risk monitoring | 70 technical risk events flagged for review |

### Business Interpretation

The reconciliation checks confirmed that return calculations, signal logic, transaction cost calculations, and after-cost PnL logic were internally consistent. This improves confidence that the performance results are not caused by calculation errors.

The main issue identified was market data integrity. The OHLC check detected **76 price integrity issues**, mainly in the FX datasets. These records should be flagged before production reporting or live trading analysis. The project therefore shows how data quality controls can reduce reporting risk and improve confidence in trading analytics outputs.

---

## 8. Trade Operations Reconciliation Results

The trade operations module simulated a small trade lifecycle control process using:

- **120 internal trades**;
- **115 broker confirmations**;
- **115 settlement records**.

### 8.1 Trade Confirmation Exceptions

| Exception Type | Severity | Count |
|---|---|---:|
| PnL Variance | Medium | 6 |
| Quantity Mismatch | High | 6 |
| Missing Broker Confirmation | High | 5 |
| Price Discrepancy | Medium | 5 |

The internal trade records achieved **95.83% broker confirmation coverage**, with **5 missing broker confirmations**.

### 8.2 Settlement Exceptions

| Exception Type | Severity | Count |
|---|---|---:|
| Settlement Not Completed | High | 44 |
| Missing Settlement Record | High | 5 |
| Settlement Delay | Medium | 5 |

The settlement completion rate was **61.74%**, and the settlement exception rate was **45.00%** in the simulated dataset.

### 8.3 Operations Scorecard

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

### Business Interpretation

This module demonstrates how trading operations teams can monitor the full trade lifecycle after strategy execution. The exception reports identify missing confirmations, quantity mismatches, price discrepancies, PnL variance, failed settlements, pending settlements, and settlement delays.

In a real trading environment, this type of exception monitoring helps teams:

- detect trade breaks earlier;
- reduce operational risk;
- improve broker and settlement follow-up;
- support auditability;
- provide structured exception reports to traders, operations teams, and risk stakeholders.

The exceptions in this module are intentionally simulated to demonstrate the control logic and reporting workflow.

---

## 9. Dashboard and Stakeholder Reporting

The Tableau dashboard was designed to communicate the trading performance results in a business-facing format.

### Dashboard Components

| Dashboard View | Purpose |
|---|---|
| Cumulative Return After Cost by Asset | Compare long-term strategy performance across assets |
| Drawdown After Cost by Asset | Identify downside risk and recovery patterns |
| Sharpe Ratio After Cost by Asset | Compare risk-adjusted performance |
| Total Execution Cost by Asset | Identify assets with higher cost drag |
| Average Slippage vs 20-Day Volatility | Show the relationship between volatility and execution cost |

### Example Dashboard

![FX & CFD Trading Performance Dashboard](../dashboard/FX_CFD_Trading_Performance_Dashboard.png)

### Business Value

The dashboard allows stakeholders to quickly identify:

- which assets performed best after cost;
- which assets had unacceptable drawdowns;
- where execution cost was highest;
- which assets may need further review before being used in a trading strategy.

This turns the notebook outputs into a format suitable for trading, risk, operations, or business stakeholders.

---

## 10. Overall Business Recommendations

Based on the analysis, the main recommendations are:

1. **Prioritise Gold for further strategy testing.**  
   Gold produced the strongest after-cost return and Sharpe ratio, making it the best candidate for further parameter testing and robustness checks.

2. **Review NASDAQ 100 execution cost and drawdown risk.**  
   NASDAQ 100 generated positive returns, but its execution cost and drawdown were high. It may require volatility filters, position sizing rules, or stop-loss controls.

3. **Avoid applying the strategy uniformly across all assets.**  
   The strategy performed poorly on AUD/USD and only weakly on EUR/USD and S&P 500. Each asset should be evaluated separately rather than applying the same rule across the full universe.

4. **Maintain data governance before performance reporting.**  
   Schema checks, missing value checks, OHLC validation, return reconciliation, and signal reconciliation should be run before relying on the results.

5. **Use exception monitoring for trade lifecycle control.**  
   Internal trade records should be reconciled against broker confirmations and settlement records to detect operational issues before they create financial or reporting risk.

---

## 11. Limitations and Next Steps

This project is designed as a portfolio analytics project rather than a production trading system.

### Limitations

- The strategy uses a simple moving-average crossover rule.
- The project does not include short-selling logic.
- Transaction cost and slippage assumptions are simulated.
- Trade operations exceptions are simulated for demonstration purposes.
- The analysis does not include live order book data, broker execution records, or real settlement data.
- The results should not be interpreted as investment advice.

### Next Steps

Future improvements could include:

- testing different moving-average windows;
- adding volatility filters or regime detection;
- adding position sizing and risk limits;
- comparing the strategy against buy-and-hold benchmarks;
- using walk-forward validation;
- connecting the exception monitoring workflow to a dashboard;
- adding automated alerting for high-severity trade exceptions.

---

## 12. Skills Demonstrated

This project demonstrates the following skills:

| Skill Area | Evidence in Project |
|---|---|
| Financial data analysis | Multi-asset return, volatility, drawdown, Sharpe ratio, and cost analysis |
| Python analytics | Data cleaning, feature engineering, signal generation, backtesting, reconciliation |
| SQL analytics | DuckDB queries for performance, cost, volatility, and dashboard exports |
| Trading operations | Broker confirmation reconciliation, settlement exception monitoring, operations scorecard |
| Data governance | Schema validation, missing value control, duplicate checks, calculation reconciliation |
| Dashboarding | Tableau dashboard for stakeholder-facing performance reporting |
| Business communication | Clear recommendations based on quantified trading, cost, risk, and operations results |

---

## 13. Final Conclusion

This project shows how a trading analytics workflow can be extended beyond basic strategy testing. The analysis evaluates after-cost performance, identifies execution cost impact, validates data quality, reconciles key calculations, and simulates trade operations exception monitoring.

The strongest business insight is that **Gold was the best-performing asset under the current strategy**, while **AUD/USD was not suitable for the same moving-average logic**. The project also demonstrates that trading analytics should be supported by governance and reconciliation controls, because profitable-looking results are only useful when the underlying data, calculations, and trade lifecycle records can be trusted.

Overall, the project presents a complete workflow across **trading performance analysis, risk control, data governance, SQL reporting, Tableau visualisation, and trade operations reconciliation**.
