# FX & CFD Trading Performance Analytics

## Executive Summary

This project builds a multi-asset trading analytics workflow for **AUD/USD, EUR/USD, Gold, NASDAQ 100, and S&P 500**. The objective is to evaluate whether a simple trend-following strategy remains profitable after transaction costs and slippage, and to extend the analysis into data quality control and trade operations exception monitoring.

The project was developed using **Python, Pandas, NumPy, DuckDB/SQL, and Tableau**. Python was used to clean and transform market data, generate trading signals, simulate execution costs, calculate risk and performance metrics, and create reconciliation outputs. SQL was used to prepare analysis-ready summary tables. Tableau was used to convert the results into business-facing dashboards for performance review and operations monitoring.

The analysis shows that the moving-average strategy performed very differently across assets. **Gold was the strongest performer**, generating an after-cost cumulative return of **79.7%** and a Sharpe ratio of **0.98**. **NASDAQ 100** also produced a positive after-cost return of **31.5%**, but with higher drawdown and the highest execution cost. **AUD/USD was the weakest asset**, with an after-cost cumulative return of **-31.6%** and a Sharpe ratio of **-1.08**.

The trade operations module simulated **120 internal trades**, **115 broker confirmations**, and **115 settlement records**. Broker confirmation coverage reached **95.83%**, while settlement completion was only **61.74%**. The largest operational issue was **Settlement Not Completed**, with **44 cases**, showing that settlement monitoring would be the main follow-up priority in this simulated trade lifecycle.

Overall, the project demonstrates a complete trading analytics workflow: **strategy performance analysis, transaction cost modelling, data governance, SQL reporting, Tableau dashboarding, and trade operations reconciliation**.

---

## 1. Business Questions

This project was designed to answer four practical questions that would matter to a trading, risk, or operations team:

1. Which assets generated the strongest after-cost strategy performance?
2. How much did transaction costs and slippage reduce profitability?
3. Are the market data, signals, return calculations, and after-cost PnL reliable enough for reporting?
4. What trade lifecycle exceptions appear when internal trades are reconciled against broker confirmations and settlement records?

The goal is not only to show a backtest result, but also to demonstrate how trading data can be turned into a controlled, explainable, and stakeholder-ready analytics workflow.

---

## 2. Project Scope

### Asset Universe

| Asset | Asset Class | Purpose in Analysis |
|---|---|---|
| AUD/USD | FX | Major currency pair with commodity-linked behaviour |
| EUR/USD | FX | Highly liquid benchmark FX pair |
| Gold | Commodity CFD | Trend-sensitive safe-haven asset |
| NASDAQ 100 | Equity Index CFD | High-growth, high-volatility equity index |
| S&P 500 | Equity Index CFD | Broad US equity market benchmark |

### Tools and Methods

| Tool / Method | How It Was Used |
|---|---|
| Python | End-to-end data processing, strategy calculation, cost simulation, reconciliation logic |
| Pandas / NumPy | Time-series transformation, rolling indicators, returns, drawdown, Sharpe ratio, exception checks |
| DuckDB / SQL | Aggregated performance tables, cost summaries, dashboard-ready exports |
| Tableau | Interactive dashboard for trading performance and operations monitoring |
| Jupyter Notebook | Reproducible analysis workflow across three project modules |
| GitHub | Project documentation, source control, and portfolio presentation |

---

## 3. Project Workflow

The project is organised into three notebooks. Each notebook represents a different layer of a realistic trading analytics process.

### Notebook 01: End-to-End Trading Analytics

This notebook builds the core strategy and performance pipeline.

**What I did:**

- Collected and structured historical OHLCV market data for five assets.
- Calculated daily returns, log returns, rolling volatility, 20-day moving average, and 50-day moving average.
- Generated trading signals using a moving-average crossover rule.
- Shifted signals by one trading day to avoid look-ahead bias.
- Simulated transaction costs and volatility-linked slippage.
- Calculated after-cost returns, cumulative return, drawdown, Sharpe ratio, win rate, exposure, and trade count.
- Exported clean tables for SQL analysis and Tableau visualisation.

**Strategy rule:**

| Condition | Position |
|---|---|
| 20-day moving average > 50-day moving average | Long |
| 20-day moving average <= 50-day moving average | Flat |

The one-day signal shift is important because it prevents the strategy from using information that would not have been available at the time of trading.

### Notebook 02: Data Quality and Risk Assessment

This notebook checks whether the analysis outputs can be trusted.

**What I did:**

- Checked required columns and schema consistency.
- Checked duplicate Date-Asset records.
- Checked missing values in critical fields.
- Validated OHLC price integrity.
- Recalculated returns and compared them with stored return fields.
- Reconciled trading signal logic against the stated moving-average rule.
- Reconciled transaction cost and after-cost PnL calculations.
- Flagged technical risk events and generated governance recommendations.

This part turns the project from a simple backtest into a controlled analytics process. It shows that the performance results are not only calculated, but also validated.

### Notebook 03: Trade Operations Reconciliation

This notebook simulates a trade lifecycle monitoring process.

**What I did:**

- Created simulated internal trade records from strategy-generated trades.
- Created broker confirmation records with controlled exceptions.
- Created settlement records with failed, pending, delayed, and missing settlement cases.
- Reconciled internal trades against broker confirmations.
- Reconciled broker-confirmed trades against settlement records.
- Generated trade exception reports, settlement exception reports, asset-level exception summaries, and an operations scorecard.

This module demonstrates how a trading analytics project can be extended into trading operations. It is especially relevant to roles involving broker confirmation, settlement monitoring, exception reporting, and operational risk control.

---

## 4. Trading Performance Results

### 4.1 After-Cost Performance Summary

| Asset | Cumulative Return After Cost | Annualised Return After Cost | Sharpe Ratio After Cost | Max Drawdown After Cost | Total Trades |
|---|---:|---:|---:|---:|---:|
| Gold | 79.7% | 13.0% | 0.98 | -14.6% | 25 |
| NASDAQ 100 | 31.5% | 5.9% | 0.46 | -28.1% | 25 |
| S&P 500 | 11.9% | 2.4% | 0.26 | -31.2% | 23 |
| EUR/USD | 4.5% | 0.9% | 0.20 | -8.7% | 31 |
| AUD/USD | -31.6% | -7.4% | -1.08 | -33.2% | 35 |

### 4.2 Key Findings

**Gold was the best-performing asset.**  
Gold generated the highest after-cost cumulative return at **79.7%** and the highest Sharpe ratio at **0.98**. Its maximum drawdown was **-14.6%**, which was lower than the drawdown of NASDAQ 100, S&P 500, and AUD/USD. This suggests that the trend-following signal worked best on Gold in this test period.

**NASDAQ 100 delivered positive returns but required stronger risk monitoring.**  
NASDAQ 100 produced an after-cost cumulative return of **31.5%**, but its maximum drawdown reached **-28.1%**. It also had the highest total execution cost among all assets. This means the strategy may be useful on NASDAQ 100, but only with stronger risk limits, cost monitoring, or volatility filters.

**AUD/USD was not suitable for the current strategy.**  
AUD/USD had the weakest result, with an after-cost cumulative return of **-31.6%** and a Sharpe ratio of **-1.08**. It also had the highest number of trades, which means the strategy traded frequently but failed to generate profitable signals after cost.

**S&P 500 and EUR/USD were positive but not strong enough.**  
Both assets produced positive returns, but their Sharpe ratios were low. They may require different moving-average windows, additional confirmation signals, or volatility-based position sizing before being considered for further use.

### Business Interpretation

The strategy should not be applied uniformly across all assets. The same signal rule created strong results for Gold, moderate results for NASDAQ 100, weak results for S&P 500 and EUR/USD, and negative results for AUD/USD. From a portfolio or trading desk perspective, this supports asset-level strategy selection rather than a one-size-fits-all approach.

---

## 5. Execution Cost and Slippage Analysis

The backtest includes transaction costs and slippage, so the performance results are closer to a realistic trading environment than a return-only strategy test.

| Asset | Transaction Cost | Slippage Cost | Total Cost | Cost Impact |
|---|---:|---:|---:|---:|
| NASDAQ 100 | 0.0075 | 0.0349 | 0.0424 | 5.69% |
| S&P 500 | 0.0058 | 0.0247 | 0.0304 | 3.46% |
| Gold | 0.0050 | 0.0222 | 0.0272 | 4.97% |
| AUD/USD | 0.0025 | 0.0211 | 0.0235 | 1.63% |
| EUR/USD | 0.0016 | 0.0130 | 0.0146 | 1.53% |

### Key Findings

- **NASDAQ 100 had the highest total execution cost**, at **0.0424**, mainly driven by slippage.
- **Gold still performed strongly after cost**, which means its signal strength was large enough to absorb the simulated execution drag.
- **EUR/USD had the lowest total cost**, but low cost alone did not translate into strong profitability.
- **AUD/USD remained negative despite lower cost impact**, showing that the main issue was signal quality rather than execution cost.

### Business Interpretation

Execution cost analysis helps identify whether poor performance is caused by weak signals or expensive execution. In this project, AUD/USD performed poorly even though its cost impact was not the highest, so the strategy logic itself needs review for that asset. NASDAQ 100 was profitable but expensive to trade, so it would require tighter execution monitoring in a real trading workflow.

---

## 6. Data Quality and Risk Control Results

The data quality module was used to check whether the inputs and calculations were reliable enough for reporting.

### 6.1 Dataset Inventory

| Dataset | Rows | Columns | Date Range | Assets | Duplicate Rows |
|---|---:|---:|---|---:|---:|
| Raw market data | 6,362 | 8 | 2021-01-01 to 2025-12-30 | 5 | 0 |
| Processed market data | 6,117 | 13 | 2021-03-11 to 2025-12-30 | 5 | 0 |
| Trading signals | 6,117 | 16 | 2021-03-11 to 2025-12-30 | 5 | 0 |
| Trade performance | 6,117 | 27 | 2021-03-11 to 2025-12-30 | 5 | 0 |

### 6.2 Control Results

| Control Area | Result |
|---|---:|
| Required-column validation failures | 0 |
| Duplicate Date-Asset records | 0 |
| Return calculation mismatches | 0 |
| Signal logic mismatches | 0 |
| Cost and PnL reconciliation failures | 0 |
| OHLC price integrity issues | 76 |
| Technical risk events flagged | 70 |

### Business Interpretation

The return, signal, cost, and PnL reconciliation checks passed with **0 mismatches**, which supports the reliability of the calculated strategy results. However, the OHLC validation detected **76 price integrity issues**, mainly requiring review before using the data in production reporting or live trading analysis.

This section demonstrates that the project does not treat data as automatically reliable. It includes checks that would help reduce reporting risk, identify questionable records, and support a more auditable analytics process.

---

## 7. Trade Operations Reconciliation Results

The trade operations module simulates what happens after strategy trades are generated. It checks whether internal trades are confirmed by the broker and whether confirmed trades are successfully settled.

### 7.1 Operations Scorecard

| Metric | Value |
|---|---:|
| Total Internal Trades | 120 |
| Total Broker Confirmations | 115 |
| Total Settlement Records | 115 |
| Broker Confirmation Coverage | 95.83% |
| Settlement Completion Rate | 61.74% |
| Trade Exception Count | 22 |
| Settlement Exception Count | 54 |
| Trade Exception Rate | 18.33% |
| Settlement Exception Rate | 45.00% |

### 7.2 Trade Confirmation Exceptions

| Exception Type | Severity | Count |
|---|---|---:|
| PnL Variance | Medium | 6 |
| Quantity Mismatch | High | 6 |
| Missing Broker Confirmation | High | 5 |
| Price Discrepancy | Medium | 5 |

### 7.3 Settlement Exceptions

| Exception Type | Severity | Count |
|---|---|---:|
| Settlement Not Completed | High | 44 |
| Missing Settlement Record | High | 5 |
| Settlement Delay | Medium | 5 |

### 7.4 Key Findings

**Broker confirmation coverage was high, but not complete.**  
Out of **120 internal trades**, **115 broker confirmations** were available. This produced broker confirmation coverage of **95.83%**. The missing confirmations would need follow-up because unconfirmed trades can create booking, exposure, and reporting issues.

**Settlement was the main operational risk area.**  
The settlement completion rate was **61.74%**, and the settlement exception rate was **45.00%**. The largest exception type was **Settlement Not Completed**, with **44 cases**. This indicates that the most important operational follow-up would be settlement status monitoring.

**High-severity exceptions dominated the exception population.**  
The dashboard identified **60 high-severity exceptions** and **16 medium-severity exceptions**. High-severity exceptions included missing broker confirmations, quantity mismatches, missing settlement records, and incomplete settlements. These issues should be reviewed before lower-priority price discrepancies or settlement delays.

### Business Interpretation

This module shows how trading analytics can connect to post-trade controls. In a real trading operations environment, the same workflow could help operations teams detect missing confirmations, quantity breaks, price discrepancies, PnL variances, missing settlement records, failed settlements, and delayed settlements.

The business value is that exception monitoring helps teams prioritise follow-up, reduce operational risk, improve auditability, and provide clearer reporting to traders, operations managers, and risk stakeholders.

---

## 8. Tableau Dashboards

Two Tableau dashboards were created to communicate the results in a business-facing format.

### 8.1 Dashboard 1: FX & CFD Trading Performance Dashboard

**Interactive Dashboard:** [FX & CFD Trading Performance Dashboard](https://public.tableau.com/views/Dashboard1FXCFDTradingPerformanceDashboard/FXCFDTradingPerformanceDashboard?:language=zh-CN&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

![FX & CFD Trading Performance Dashboard](dashboard/tableau/FX_CFD_Trading_Performance_Dashboard.png)


This dashboard focuses on strategy performance after transaction costs. It includes:

- cumulative return after cost by asset;
- drawdown after cost by asset;
- Sharpe ratio after cost by asset;
- total execution cost by asset;
- average slippage versus 20-day volatility.

**What the dashboard shows:**

- Gold was the strongest asset, with the highest cumulative return and Sharpe ratio.
- AUD/USD had the weakest performance and the lowest Sharpe ratio.
- NASDAQ 100 had strong positive returns but also high execution cost and drawdown.
- Higher-volatility assets tended to show higher slippage costs.

**Business value:**  
This dashboard helps stakeholders compare asset-level strategy performance, identify where risk-adjusted performance is strongest, and understand how execution cost and volatility affect trading results.

### 8.2 Dashboard 2: Trade Operations Reconciliation & Exception Monitoring

**Interactive Dashboard:** [View on Tableau Public](https://public.tableau.com/views/Dashboard2TradeOperationsReconciliationExceptionMonitoring_17799001041320/TradeOperationsMonitoring?:language=zh-CN&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

![Trade Operations Reconciliation & Exception Monitoring Dashboard](dashboard/tableau/Trade_Operations_Monitoring.png)

![Trade Operations Reconciliation & Exception Monitoring](dashboard/tableau/Trade_Operations_Monitoring.png)

This dashboard focuses on post-trade operations monitoring. It includes:

- broker confirmation coverage;
- settlement completion rate;
- trade exception rate;
- settlement exception rate;
- exception count by type;
- exception severity breakdown;
- exception stage by asset;
- trade-level exception detail table.

**What the dashboard shows:**

- The workflow monitored **120 internal trades**.
- Broker confirmation coverage was **95.83%**.
- Settlement completion rate was **61.74%**.
- Trade exception rate was **18.33%**.
- Settlement exception rate was **45.00%**.
- **Settlement Not Completed** was the largest exception type, with **44 cases**.
- High-severity exceptions accounted for **60** out of **76** total exceptions.
- AUD/USD and NASDAQ 100 had the highest total exception counts in the asset-level monitoring view.

**Business value:**  
This dashboard helps operations teams identify unresolved trade breaks, prioritise high-severity exceptions, and monitor whether issues are concentrated in trade confirmation or settlement. It turns reconciliation outputs into a practical monitoring view that can support broker follow-up, settlement review, and operational risk reporting.

---

## 9. Business Recommendations

Based on the results, the main recommendations are:

1. **Prioritise Gold for further strategy testing.**  
   Gold had the strongest after-cost return and the highest Sharpe ratio. It should be the first asset for additional robustness checks, parameter testing, and benchmark comparison.

2. **Review NASDAQ 100 execution cost and drawdown risk.**  
   NASDAQ 100 produced positive returns, but with high execution cost and large drawdown. It may require volatility filters, position sizing rules, or stricter risk limits.

3. **Do not apply the same moving-average rule across all assets.**  
   AUD/USD performed poorly, while Gold performed strongly. The strategy should be evaluated and tuned by asset rather than applied uniformly.

4. **Keep data quality controls before reporting performance.**  
   Return, signal, cost, and PnL reconciliation checks help ensure the output is reliable. OHLC integrity checks should be reviewed before production use.

5. **Use exception monitoring to support trade lifecycle control.**  
   Missing confirmations, quantity mismatches, incomplete settlements, and missing settlement records should be prioritised because they can create booking, exposure, settlement, and reporting risk.

---

## 10. Limitations

This project is designed as a portfolio and analytics demonstration rather than a production trading system.

Main limitations:

- The strategy uses a simple moving-average crossover rule.
- The project only tests long/flat positioning and does not include short selling.
- Transaction costs and slippage are simulated assumptions.
- Trade operations exceptions are simulated for demonstration purposes.
- The project does not use live broker execution records, order book data, or real settlement data.
- Results should not be interpreted as investment advice.

---

## 11. Next Steps

Possible improvements include:

- test alternative moving-average windows;
- add volatility filters and regime detection;
- compare against buy-and-hold benchmarks;
- add position sizing and portfolio-level risk limits;
- use walk-forward validation;
- add automated exception alerts for high-severity trade breaks;
- extend the reconciliation module with ageing analysis and unresolved exception tracking.

---

## 12. Skills Demonstrated

| Skill Area | Evidence in This Project |
|---|---|
| Financial analytics | Return, volatility, drawdown, Sharpe ratio, cost impact, after-cost performance |
| Quantitative strategy testing | Moving-average signal generation, signal shift, backtesting, exposure analysis |
| Python data analysis | Data cleaning, feature engineering, aggregation, reconciliation, export automation |
| SQL analytics | DuckDB queries for performance summaries and dashboard-ready datasets |
| Data governance | Schema checks, duplicate checks, OHLC validation, return and signal reconciliation |
| Trading operations | Broker confirmation matching, settlement monitoring, exception classification |
| Tableau dashboarding | Interactive dashboards for performance review and operations monitoring |
| Business communication | Clear findings, quantified results, and stakeholder-oriented recommendations |

---

## Final Conclusion

This project shows how a trading analytics workflow can go beyond a basic backtest. It evaluates after-cost performance, measures execution cost impact, validates data quality, and simulates trade operations reconciliation.

The strongest strategy result came from **Gold**, which achieved **79.7%** after-cost cumulative return and a Sharpe ratio of **0.98**. The weakest result came from **AUD/USD**, which produced **-31.6%** after-cost cumulative return and a Sharpe ratio of **-1.08**. These results show that strategy performance is asset-dependent and should not be assumed to generalise across all instruments.

The operations module adds another layer of business value by showing how internal trades can be reconciled against broker confirmations and settlement records. The main operational risk was settlement-related, especially **Settlement Not Completed**, which appeared **44 times**. This demonstrates how trading analytics can support not only performance evaluation, but also operational control, exception monitoring, and risk reporting.

