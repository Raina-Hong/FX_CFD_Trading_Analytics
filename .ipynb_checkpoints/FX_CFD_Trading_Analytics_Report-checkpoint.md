# FX & CFD Trading Analytics, Risk Control & Data Governance Report

## 1. Executive Summary

This project builds an end-to-end trading analytics workflow for five FX and CFD instruments: **AUD/USD, EUR/USD, Gold, NASDAQ 100, and S&P 500**. The project starts from historical OHLCV market data, generates moving-average trading signals, simulates realistic trading frictions such as spread, slippage, and transaction costs, evaluates after-cost trading performance, and builds a dashboard for performance monitoring.

To make the project stronger than a standard backtesting exercise, an additional **data quality and technical risk assessment layer** was added. This layer validates market data integrity, return calculations, signal logic, transaction cost calculations, after-cost PnL consistency, and asset-level risk exposure. As a result, the project demonstrates not only trading strategy analysis, but also practical skills in **financial data analytics, risk control, data governance, SQL-based reporting, and dashboard communication**.

The final results show that the simple moving-average strategy performed best on **Gold**, with an after-cost cumulative return of approximately **79.7%** and a Sharpe ratio of approximately **0.98**. **NASDAQ 100** also produced a positive after-cost return of approximately **31.5%**, although with higher volatility and deeper drawdown. **AUD/USD** performed poorly, with an after-cost cumulative return of approximately **-31.6%** and a negative Sharpe ratio of approximately **-1.08**. The results suggest that the same trend-following logic behaves very differently across asset classes, and that transaction costs, volatility, and drawdown risk must be analysed before interpreting strategy performance.

---

## 2. Project Objective

The objective of this project is to create a practical trading analytics workflow that answers four key questions:

1. **Does the moving-average strategy generate positive after-cost returns across different FX and CFD assets?**
2. **How much do transaction costs, spread, and slippage reduce strategy performance?**
3. **Which assets show better risk-adjusted performance after costs?**
4. **Is the underlying trading data and calculation pipeline reliable enough for reporting and decision-making?**

This project is designed as a portfolio-ready analytics project for roles such as Trading Analyst, Quantitative Analyst, Market Data Analyst, Risk Analyst, Financial Data Analyst, Data Governance Analyst, and Trading Operations Analyst.

---

## 3. Data and Assets Covered

The project uses daily OHLCV market data for five instruments:

| Asset | Type | Role in Analysis |
|---|---|---|
| AUD/USD | FX pair | Currency trend-following performance |
| EUR/USD | FX pair | Currency trend-following performance |
| Gold | Commodity CFD | Safe-haven and commodity trend exposure |
| NASDAQ 100 | Equity index CFD | High-growth equity market exposure |
| S&P 500 | Equity index CFD | Broad US equity market exposure |

The raw dataset covers approximately **2021 to 2025**, with the processed backtest period starting after the rolling-window features become available. The main datasets include `raw_market_data.csv`, `processed_market_data.csv`, `trading_signals.csv`, `trade_performance.csv`, `dashboard_data.csv`, SQL-exported summary tables, and data quality and risk assessment outputs.

---

## 4. Methodology

### 4.1 Data Collection and Cleaning

The workflow begins by collecting daily OHLCV data, including Open, High, Low, Close, Volume, asset name, and ticker. The data is then cleaned and transformed into a structured time-series format.

Key cleaning steps include standardising date formats, sorting data by asset and date, removing rows that do not have enough rolling-window observations, calculating daily returns and log returns, creating rolling volatility and moving-average indicators, and saving processed datasets for repeatable analysis.

This step ensures that the trading strategy is not built directly on raw data, but on a cleaner and more analysis-ready dataset.

### 4.2 Feature Engineering

| Feature | Purpose |
|---|---|
| Daily return | Measures one-day price change |
| Log return | Alternative return representation for time-series analysis |
| 20-day moving average | Captures short-term trend |
| 50-day moving average | Captures medium-term trend |
| 20-day volatility | Measures recent price fluctuation |
| Signal | Indicates whether the strategy should enter the market |
| Position | Uses previous signal to avoid look-ahead bias |
| Turnover | Measures whether a trade occurs |
| Transaction cost | Captures spread-related trading cost |
| Slippage cost | Captures execution cost under volatility |
| After-cost return | Measures realised strategy return after trading frictions |

### 4.3 Trading Signal Logic

The strategy uses a simple moving-average trend-following rule:

```text
If MA20 > MA50, signal = 1
Otherwise, signal = 0
```

The intuition is that when the short-term moving average is above the medium-term moving average, the asset may be in an upward trend, so the strategy enters a long position.

To avoid look-ahead bias, the project uses yesterday's signal to determine today's position. This is important because a realistic backtest should not use future information to make current trading decisions.

### 4.4 Transaction Cost and Slippage Simulation

A key improvement of this project is that it does not only calculate theoretical returns. It also simulates trading frictions:

- **Spread cost:** the cost of crossing the bid-ask spread when entering or exiting a position.
- **Transaction cost:** cost incurred when the position changes.
- **Slippage cost:** additional execution cost that increases under higher volatility.
- **Total cost:** transaction cost plus slippage cost.
- **After-cost return:** strategy return after deducting trading costs.

This makes the project more realistic because many simple backtests look profitable before costs but become less attractive after costs.

---

## 5. Performance Analysis

### 5.1 After-Cost Cumulative Return

| Asset | Cumulative Return Before Cost | Cumulative Return After Cost | Cost Impact |
|---|---:|---:|---:|
| AUD/USD | -29.9% | -31.6% | 1.6% |
| EUR/USD | 6.1% | 4.5% | 1.5% |
| Gold | 84.7% | 79.7% | 5.0% |
| NASDAQ 100 | 37.2% | 31.5% | 5.7% |
| S&P 500 | 15.4% | 11.9% | 3.5% |

**Gold** was the strongest asset in the backtest. It achieved the highest after-cost cumulative return, close to **79.7%**, and showed a strong upward performance trend especially toward the later part of the sample period.

**NASDAQ 100** also generated a positive after-cost return of approximately **31.5%**, but its path was more volatile. This means the strategy captured some upward trends, but investors would have experienced larger interim losses.

**S&P 500** delivered a positive but more moderate after-cost return of approximately **11.9%**.

**EUR/USD** was slightly positive after costs, with a return of approximately **4.5%**, suggesting that the strategy had limited effectiveness on this currency pair.

**AUD/USD** performed the worst, with an after-cost return of approximately **-31.6%**. This indicates that the simple trend-following rule did not work well for AUD/USD during the tested period.

### 5.2 Sharpe Ratio Analysis

The Sharpe ratio measures risk-adjusted performance. A higher Sharpe ratio means the strategy generated more return per unit of volatility.

| Asset | Sharpe Ratio After Cost | Interpretation |
|---|---:|---|
| Gold | 0.98 | Best risk-adjusted performance |
| NASDAQ 100 | 0.46 | Positive but moderate |
| S&P 500 | 0.26 | Weak positive risk-adjusted return |
| EUR/USD | 0.20 | Low but positive |
| AUD/USD | -1.08 | Poor risk-adjusted performance |

Gold had the strongest risk-adjusted result, with a Sharpe ratio close to **1.0**. This suggests that Gold not only produced the highest return, but also delivered the most attractive return relative to its volatility.

AUD/USD had a negative Sharpe ratio, which means the strategy generated negative return after adjusting for risk. This makes AUD/USD unsuitable for this specific moving-average strategy during the tested period.

### 5.3 Drawdown Analysis

Drawdown measures the largest peak-to-trough decline in the strategy's equity curve. It is important because a strategy can be profitable overall but still experience large losses during the holding period.

| Asset | Maximum Drawdown After Cost | Risk Interpretation |
|---|---:|---|
| AUD/USD | -33.2% | High drawdown risk |
| S&P 500 | -31.2% | High drawdown risk |
| NASDAQ 100 | -28.1% | Medium-to-high drawdown risk |
| Gold | -14.6% | Moderate drawdown risk |
| EUR/USD | -8.7% | Lower drawdown risk |

AUD/USD and S&P 500 had the deepest drawdowns. For AUD/USD, the drawdown is especially concerning because the asset also had a negative total return and negative Sharpe ratio. For S&P 500, the strategy still produced a positive final return, but the drawdown shows that the strategy carried significant interim risk.

Gold had a much better balance between return and drawdown. Although it experienced some drawdown, the final return and Sharpe ratio were strong enough to make it the best-performing asset in this project.

### 5.4 Execution Cost Analysis

| Asset | Total Transaction Cost | Total Slippage Cost | Total Cost |
|---|---:|---:|---:|
| NASDAQ 100 | 0.0075 | 0.0349 | 0.0424 |
| S&P 500 | 0.0058 | 0.0247 | 0.0304 |
| Gold | 0.0050 | 0.0222 | 0.0272 |
| AUD/USD | 0.0025 | 0.0211 | 0.0235 |
| EUR/USD | 0.0016 | 0.0130 | 0.0146 |

NASDAQ 100 had the highest total cost, mainly because its volatility-driven slippage cost was higher. This is consistent with the idea that high-volatility assets usually have higher execution risk.

EUR/USD had the lowest total execution cost, but low cost alone did not translate into strong returns. This shows that transaction cost is only one part of performance analysis. Signal quality, asset trend behaviour, and volatility also matter.

Gold had meaningful execution costs, but its return was high enough to absorb those costs. This makes Gold the strongest asset from both a performance and cost-adjusted perspective.

---

## 6. SQL-Based Performance Analysis

DuckDB SQL was used to produce structured trading performance summaries. This step makes the project closer to a real analytics workflow, where analysts often need to query tables, aggregate results, and export business-facing reports.

The SQL analysis covers asset-level performance summary, transaction cost impact by asset, annual strategy performance, slippage behaviour during high-volatility periods, and dashboard-ready output tables.

Using SQL adds value because it demonstrates that the project is not only a Python notebook, but also a repeatable analytical pipeline that can support reporting, monitoring, and dashboard development.

---

## 7. Dashboard Analysis

The Tableau dashboard summarises the key findings in a recruiter-friendly and stakeholder-friendly format.

The dashboard includes:

1. **Cumulative Return After Cost by Asset**: shows which assets generated the strongest realised return after transaction costs and slippage.
2. **Drawdown After Cost by Asset**: shows the depth and persistence of losses across assets.
3. **Sharpe Ratio After Cost by Asset**: compares risk-adjusted performance.
4. **Total Execution Cost by Asset**: shows which instruments were most affected by trading frictions.
5. **Average Slippage vs 20-Day Volatility**: shows the relationship between volatility and execution cost.

The dashboard makes the analysis easier to communicate. Instead of only showing raw tables, it helps explain which assets performed well, which assets had high risk, and how trading costs affected the final results.

---

## 8. Data Quality and Technical Risk Assessment

A separate data quality and technical risk notebook was added to upgrade this project from a simple backtest into a more complete trading analytics and governance project.

This notebook validates the reliability of the data and calculation pipeline through the following controls:

| Control Area | Purpose |
|---|---|
| Dataset inventory | Documents available datasets, rows, columns, date range, and asset coverage |
| Schema validation | Checks whether required fields exist before analysis |
| Missing value check | Detects missing values in critical columns |
| Duplicate key check | Ensures Date-Asset records are unique |
| OHLC integrity check | Flags invalid market price records |
| Date continuity check | Detects suspicious data gaps |
| Return reconciliation | Recalculates returns from Close price and compares with stored returns |
| Signal reconciliation | Verifies whether signal follows MA20 > MA50 rule |
| Cost/PnL reconciliation | Checks total cost and after-cost return calculations |
| Technical risk detection | Flags extreme returns, high-cost days, and severe drawdown periods |
| Risk scorecard | Converts issues into asset-level risk ratings |

### 8.1 Key Data Quality Results

| Control | Result |
|---|---:|
| Schema validation failures | 0 |
| Duplicate Date-Asset records | 0 |
| Missing critical values | 0 |
| Return reconciliation failures | 0 |
| Signal logic mismatches | 0 |
| Cost/PnL reconciliation failures | 0 |
| Suspicious date gaps | 0 |

These results show that the main trading pipeline is internally consistent. Returns can be reconciled from price data, signals follow the documented strategy rule, and cost/PnL calculations are consistent.

### 8.2 OHLC Market Data Integrity

The OHLC price integrity check found **76 issues** in total:

| Asset | OHLC Issues | Interpretation |
|---|---:|---|
| AUD/USD | 46 | Requires price data review |
| EUR/USD | 30 | Requires price data review |
| Gold | 0 | No OHLC issues detected |
| NASDAQ 100 | 0 | No OHLC issues detected |
| S&P 500 | 0 | No OHLC issues detected |

The OHLC issues mainly occurred in AUD/USD and EUR/USD, where some High or Low prices were inconsistent with Open, Close, or other intraday price fields. These records should be flagged before using the affected price fields in downstream trading analysis.

This finding is valuable because it shows that the project does not blindly trust input data. It actively checks whether market data is reliable before interpreting performance.

### 8.3 Technical Risk Events

The technical risk monitoring layer flagged **70 technical risk events** for review. These events mainly include extreme return days and high-cost trading days.

| Asset | Extreme Return Days | High-Cost Days | Worst Drawdown |
|---|---:|---:|---:|
| AUD/USD | 12 | 2 | -33.2% |
| EUR/USD | 13 | 2 | -8.7% |
| Gold | 12 | 2 | -14.6% |
| NASDAQ 100 | 10 | 2 | -28.1% |
| S&P 500 | 13 | 2 | -31.2% |

Extreme return days are not necessarily data errors. They may reflect real market movements. However, they should be reviewed because extreme values can strongly affect backtest results, risk metrics, and model interpretation.

High-cost days are also important because trading costs can increase during volatile or illiquid market conditions. Monitoring these days helps connect market risk with execution risk.

### 8.4 Asset-Level Risk Scorecard

The final risk scorecard separates **data quality risk** from **performance risk**.

| Asset | Data Quality Risk Score | Data Quality Risk Level | Performance Risk Level | Interpretation |
|---|---:|---|---|---|
| AUD/USD | 258 | Medium | High | Data quality issues and poor strategy performance |
| EUR/USD | 180 | Medium | Low | Data quality issues but lower drawdown risk |
| S&P 500 | 30 | Low | High | Clean data but high drawdown exposure |
| Gold | 28 | Low | Low | Strongest overall profile |
| NASDAQ 100 | 24 | Low | Medium | Positive returns but meaningful drawdown risk |

This scorecard is important because it shows that **data quality risk and trading performance risk are different concepts**.

For example, S&P 500 had low data quality risk because no OHLC issues were detected, but it had high performance risk due to deep drawdown. AUD/USD had both medium data quality risk and high performance risk, making it the asset that requires the most careful review.

---

## 9. Key Findings

### Finding 1: Gold was the strongest asset for this strategy

Gold achieved the highest after-cost cumulative return and the strongest Sharpe ratio. The strategy appears to have captured Gold's trend behaviour more effectively than the FX pairs and equity indices.

### Finding 2: AUD/USD performed poorly despite relatively low execution cost

AUD/USD had a negative cumulative return, negative Sharpe ratio, and the deepest drawdown. This shows that low transaction cost does not guarantee good strategy performance. Signal effectiveness and asset behaviour are more important.

### Finding 3: NASDAQ 100 had strong return but high cost and drawdown risk

NASDAQ 100 generated positive after-cost performance, but it also had the highest total execution cost and a large drawdown. This suggests that high-growth equity index exposure can produce strong returns, but the strategy needs better risk control.

### Finding 4: Transaction costs materially reduced returns

All assets had lower returns after transaction costs and slippage. The cost impact was especially visible for Gold, NASDAQ 100, and S&P 500. This confirms the importance of evaluating strategies after realistic trading frictions.

### Finding 5: The pipeline passed major governance controls

The project passed schema validation, missing value checks, duplicate key checks, return reconciliation, signal reconciliation, and cost/PnL reconciliation. This strengthens the credibility of the results.

### Finding 6: AUD/USD and EUR/USD require market data review

The OHLC integrity check identified 76 issues, mainly in AUD/USD and EUR/USD. These records should be reviewed before the results are used for serious investment or trading decisions.

---

## 10. Limitations

This project is designed as an educational and portfolio project, so it has several limitations:

1. **Simple strategy logic**: The strategy only uses a moving-average crossover rule. It does not include more advanced signals such as momentum filters, volatility regimes, macro indicators, or machine learning features.
2. **Long-only strategy**: The strategy enters long positions or stays out of the market. It does not short assets during downtrends.
3. **Simplified transaction cost model**: Spread and slippage are simulated using assumptions. In real trading, execution cost depends on broker pricing, order size, liquidity, latency, and market conditions.
4. **No position sizing model**: The strategy does not dynamically adjust position size based on volatility, risk budget, or drawdown.
5. **No walk-forward optimisation**: The moving-average parameters are fixed. The project does not test whether the parameters remain stable across different market regimes.
6. **Data quality issues require external validation**: The OHLC issues are flagged by rule-based checks, but they would require comparison with another data vendor before deciding whether to correct or remove the records.

---

## 11. Recommendations for Improvement

Future improvements could include:

1. **Add risk-based position sizing**: Use volatility targeting or fixed-risk allocation to reduce drawdown.
2. **Test additional signals**: Add momentum, breakout, RSI, MACD, or volatility-regime filters.
3. **Add short-side logic**: Allow the strategy to short assets when MA20 < MA50, then compare long-only versus long-short performance.
4. **Perform walk-forward testing**: Split the dataset into training and testing periods to evaluate whether parameters are robust.
5. **Improve cost simulation**: Use asset-specific spread assumptions, variable slippage, and stress scenarios.
6. **Add automated data quality rules**: Convert the data quality checks into reusable validation functions or a scheduled pipeline.
7. **Build a risk monitoring dashboard**: Add data quality risk score, technical risk events, and drawdown alerts to the Tableau dashboard.

---

## 12. Skills Demonstrated

### Python and Data Analysis

- Data cleaning with Pandas and NumPy
- Time-series feature engineering
- Return, volatility, moving average, drawdown, and Sharpe ratio calculation
- Backtesting logic implementation
- Transaction cost and slippage simulation
- Data quality validation

### SQL and Data Reporting

- DuckDB-based analytical querying
- Asset-level performance aggregation
- Cost impact analysis
- Annual performance reporting
- Exporting dashboard-ready datasets

### Financial and Quantitative Analysis

- Trend-following strategy design
- After-cost performance evaluation
- Risk-adjusted return analysis
- Drawdown analysis
- Execution cost interpretation
- Asset-level performance comparison

### Risk Control and Data Governance

- Schema validation
- Missing value and duplicate record checks
- OHLC price integrity validation
- Return reconciliation
- Trading signal reconciliation
- Cost and PnL reconciliation
- Technical risk event detection
- Asset-level risk scorecard design

### Visualisation and Communication

- Tableau dashboard design
- Performance chart interpretation
- Stakeholder-facing insight summary
- Business-style reporting

---

## 13. Final Conclusion

This project shows how a trading analytics workflow can be extended beyond basic backtesting. The initial workflow evaluates a moving-average strategy across FX pairs, Gold, and equity index CFDs. The extended workflow adds transaction cost modelling, slippage analysis, SQL-based reporting, dashboard visualisation, and a data governance layer.

The main analytical conclusion is that **Gold was the best-performing asset**, delivering the highest after-cost cumulative return and the strongest risk-adjusted performance. **NASDAQ 100** also performed positively but carried higher execution cost and drawdown risk. **AUD/USD** performed poorly and showed both weak trading performance and data quality issues.

The main professional value of the project is that it demonstrates an end-to-end capability: collecting and cleaning financial data, building trading signals, simulating realistic costs, evaluating performance, validating data quality, reconciling calculations, identifying technical risk events, and communicating findings through a dashboard and report.

Therefore, the project is not only a simple strategy backtest. It is a complete **trading analytics, risk control, and data governance project** that can be used as a portfolio project for financial data, trading operations, risk analytics, and quantitative analyst roles.
