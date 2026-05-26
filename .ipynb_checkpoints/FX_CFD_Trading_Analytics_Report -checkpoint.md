# FX & CFD Trading Analytics, Risk Control & Data Governance Report

## 1. Executive Summary

This project develops an end-to-end trading analytics workflow for five FX and CFD instruments: **AUD/USD, EUR/USD, Gold, NASDAQ 100, and S&P 500**. The workflow covers market data preparation, trading signal generation, transaction cost and slippage simulation, after-cost performance evaluation, SQL-based reporting, Tableau dashboard development, and data quality risk assessment.

The purpose of this project is not only to test whether a simple moving-average strategy is profitable. More importantly, it demonstrates how trading performance should be analysed in a realistic business environment, where analysts need to consider execution cost, drawdown risk, data quality, calculation reliability, and how results should be communicated to stakeholders.

The key finding is that the same strategy behaves very differently across asset classes. **Gold** achieved the strongest after-cost performance, with an after-cost cumulative return of approximately **79.7%** and a Sharpe ratio of approximately **0.98**. **NASDAQ 100** also produced positive performance, with an after-cost cumulative return of approximately **31.5%**, but it carried higher execution cost and drawdown risk. **AUD/USD** performed the worst, with an after-cost cumulative return of approximately **-31.6%** and a negative Sharpe ratio of approximately **-1.08**.

From a business perspective, the result suggests that the moving-average strategy should not be applied uniformly across all instruments. Gold appears to be the most suitable asset for this trend-following logic, while AUD/USD should be reviewed carefully or excluded from the current strategy universe. The risk control layer also shows that transaction costs and slippage materially reduce performance, especially for higher-volatility assets such as NASDAQ 100 and Gold.

---

## 2. Business Problem and Project Objective

In trading and financial data roles, performance analysis cannot stop at asking:

> Did the strategy make money?

A more professional trading analytics workflow should answer:

1. Which assets generated positive returns after transaction costs?
2. Which assets delivered better risk-adjusted performance?
3. How much did spread, slippage, and transaction costs reduce strategy returns?
4. Which assets had unacceptable drawdown or execution risk?
5. Can the data and calculations be reconciled and trusted?
6. How should the results be communicated to trading, risk, and business stakeholders?

This project was designed to answer these questions through a structured workflow combining **Python, SQL, Tableau, and data governance checks**.

The final output is a portfolio-ready project that demonstrates capabilities in:

- financial time-series analysis;
- trading strategy evaluation;
- transaction cost and slippage modelling;
- risk-adjusted performance analysis;
- SQL-based performance reporting;
- data quality and reconciliation controls;
- stakeholder-facing insight communication.

---

## 3. Assets and Data Scope

The project analyses five instruments across FX, commodities, and equity index CFDs.

| Asset | Asset Class | Analytical Purpose |
|---|---|---|
| AUD/USD | FX | Test strategy performance on a commodity-linked currency pair |
| EUR/USD | FX | Test strategy performance on a major liquid currency pair |
| Gold | Commodity CFD | Test trend-following behaviour on a safe-haven commodity |
| NASDAQ 100 | Equity Index CFD | Test performance on a high-growth, high-volatility index |
| S&P 500 | Equity Index CFD | Test performance on a broad US equity market index |

The workflow uses OHLCV market data and produces processed trading datasets, performance tables, SQL exports, dashboard-ready files, and data quality risk outputs.

---

## 4. Analytical Workflow

### 4.1 Data Preparation

The first stage cleans and structures the raw market data into an analysis-ready time-series dataset.

The main preparation steps include:

- standardising date formats;
- sorting observations by asset and date;
- calculating daily returns and log returns;
- creating rolling moving averages and volatility indicators;
- removing rows without sufficient rolling-window history;
- preparing asset-level time-series tables for backtesting and SQL analysis.

This step is important because trading analytics depends heavily on clean and correctly ordered time-series data. If dates, asset identifiers, or return calculations are inconsistent, the final performance metrics can become misleading.

### 4.2 Trading Signal Design

The strategy uses a simple moving-average trend-following rule:

```text
If 20-day moving average > 50-day moving average:
    signal = 1
Otherwise:
    signal = 0
```

The financial logic is that when the short-term moving average is above the medium-term moving average, the asset may be in an upward trend. The strategy therefore enters a long position during these periods.

To avoid look-ahead bias, the model uses the previous day's signal as the current day's trading position. This ensures that the strategy does not use information that would not have been available at the time of trading.

### 4.3 Transaction Cost and Slippage Modelling

A major weakness of simple backtests is that they often report performance before costs. In real trading, execution frictions can significantly reduce returns.

This project simulates three key cost components:

| Cost Component | Meaning |
|---|---|
| Spread cost | Cost of crossing the bid-ask spread |
| Transaction cost | Cost incurred when the trading position changes |
| Slippage cost | Additional execution cost related to volatility and trading conditions |
| Total cost | Transaction cost plus slippage cost |
| After-cost return | Strategy return after deducting total trading cost |

This makes the analysis closer to a realistic trading performance review because it separates theoretical strategy return from actual implementable return.

### 4.4 SQL Reporting Layer

DuckDB SQL was used to query and aggregate the processed trading data.

The SQL layer produces:

- asset-level performance summaries;
- annual performance tables;
- transaction cost impact analysis;
- slippage and volatility summaries;
- dashboard-ready datasets.

This step demonstrates that the project is not only a Python notebook, but a repeatable analytics pipeline that can support reporting, monitoring, and business review.

### 4.5 Dashboard Development

The Tableau dashboard was built to present the most important performance and risk metrics in one place.

The dashboard includes:

- cumulative return after cost by asset;
- drawdown after cost by asset;
- Sharpe ratio after cost by asset;
- total execution cost by asset;
- average slippage versus 20-day volatility.

The dashboard is used as the stakeholder-facing layer of the project. It supports fast comparison across assets and helps identify which instruments performed well, which carried high risk, and where transaction costs had the strongest impact.

---

## 5. Performance Results

### 5.1 Cumulative Return After Cost

| Asset | Cumulative Return Before Cost | Cumulative Return After Cost | Cost Impact |
|---|---:|---:|---:|
| AUD/USD | -29.9% | -31.6% | 1.6% |
| EUR/USD | 6.1% | 4.5% | 1.5% |
| Gold | 84.7% | 79.7% | 5.0% |
| NASDAQ 100 | 37.2% | 31.5% | 5.7% |
| S&P 500 | 15.4% | 11.9% | 3.5% |

Gold was the strongest performer, delivering an after-cost cumulative return of approximately **79.7%**. This indicates that the moving-average strategy captured Gold's trend behaviour more effectively than the other assets in the sample.

NASDAQ 100 also generated a strong positive return of approximately **31.5%** after costs. However, its performance came with higher execution cost and drawdown risk, so the return should not be interpreted without considering risk.

S&P 500 produced a smaller but still positive after-cost return of approximately **11.9%**.

EUR/USD was only slightly positive after costs, suggesting that the strategy had limited effectiveness for this currency pair.

AUD/USD produced a negative after-cost cumulative return of approximately **-31.6%**, showing that the strategy was not suitable for this instrument during the tested period.

### 5.2 Risk-Adjusted Performance

| Asset | Sharpe Ratio After Cost | Interpretation |
|---|---:|---|
| Gold | 0.98 | Strongest risk-adjusted result |
| NASDAQ 100 | 0.46 | Positive but moderate |
| S&P 500 | 0.26 | Weak positive risk-adjusted return |
| EUR/USD | 0.20 | Low but positive |
| AUD/USD | -1.08 | Poor risk-adjusted performance |

Gold had the highest Sharpe ratio, close to **1.0**, which means it generated the best return per unit of volatility among the tested assets.

NASDAQ 100 had a positive Sharpe ratio, but it was much lower than Gold. This means that although NASDAQ 100 generated positive return, the return was less attractive after adjusting for volatility.

AUD/USD had a negative Sharpe ratio, meaning the strategy produced negative returns relative to its risk exposure.

### 5.3 Drawdown Risk

| Asset | Maximum Drawdown After Cost | Risk Interpretation |
|---|---:|---|
| AUD/USD | -33.2% | High drawdown risk |
| S&P 500 | -31.2% | High drawdown risk |
| NASDAQ 100 | -28.1% | Medium-to-high drawdown risk |
| Gold | -14.6% | Moderate drawdown risk |
| EUR/USD | -8.7% | Lower drawdown risk |

Drawdown analysis shows that return alone is not enough to evaluate strategy quality.

AUD/USD had both negative final return and deep drawdown, making it the weakest asset in this project.

S&P 500 had positive final return, but its drawdown exceeded **30%**, which means stakeholders should not treat it as a low-risk strategy.

Gold had the best balance between return and drawdown. Its drawdown was meaningfully lower than AUD/USD, NASDAQ 100, and S&P 500, while its final return was the highest.

### 5.4 Execution Cost Analysis

| Asset | Total Transaction Cost | Total Slippage Cost | Total Cost |
|---|---:|---:|---:|
| NASDAQ 100 | 0.0075 | 0.0349 | 0.0424 |
| S&P 500 | 0.0058 | 0.0247 | 0.0304 |
| Gold | 0.0050 | 0.0222 | 0.0272 |
| AUD/USD | 0.0025 | 0.0211 | 0.0235 |
| EUR/USD | 0.0016 | 0.0130 | 0.0146 |

NASDAQ 100 had the highest total execution cost, mainly driven by slippage. This is consistent with the fact that higher-volatility assets tend to have higher execution risk.

EUR/USD had the lowest total cost, but its after-cost return was still weak. This shows that low cost does not automatically lead to strong strategy performance. A good trading strategy needs both effective signal generation and manageable execution cost.

Gold had meaningful execution cost, but its return was high enough to absorb those costs. This makes Gold the strongest asset from a cost-adjusted perspective.

---

## 6. Data Quality and Technical Risk Assessment

To upgrade the project from a simple backtest to a more professional analytics workflow, a dedicated data quality and technical risk assessment notebook was added.

The goal of this layer is to answer:

> Can stakeholders trust the data, signals, and PnL calculations behind the trading results?

### 6.1 Governance Controls Applied

| Control | Purpose |
|---|---|
| Dataset inventory | Documents available datasets, columns, rows, date range, and asset coverage |
| Schema validation | Checks whether required fields exist |
| Missing value check | Detects missing values in critical fields |
| Duplicate key check | Ensures each Date-Asset record is unique |
| OHLC integrity check | Flags invalid price relationships such as High below Close |
| Date gap check | Detects suspicious time-series gaps |
| Return reconciliation | Recalculates returns from Close price |
| Signal reconciliation | Checks whether signals follow the MA20 > MA50 rule |
| Cost/PnL reconciliation | Validates total cost and after-cost return calculations |
| Technical risk detection | Flags extreme returns, high-cost days, and drawdown exposure |
| Risk scorecard | Converts data and risk issues into asset-level ratings |

### 6.2 Core Validation Results

| Control | Result |
|---|---:|
| Schema validation failures | 0 |
| Duplicate Date-Asset records | 0 |
| Missing critical values | 0 |
| Return reconciliation failures | 0 |
| Signal logic mismatches | 0 |
| Cost/PnL reconciliation failures | 0 |
| Suspicious date gaps | 0 |

These results show that the main calculation pipeline is internally consistent. The returns, signals, transaction costs, slippage costs, and after-cost PnL can be reconciled and explained.

This is important from a stakeholder perspective because trading results should not be presented unless the calculation process is traceable and auditable.

### 6.3 OHLC Price Integrity Issues

The OHLC integrity check identified **76 market data issues**.

| Asset | OHLC Issues | Interpretation |
|---|---:|---|
| AUD/USD | 46 | Requires market data review |
| EUR/USD | 30 | Requires market data review |
| Gold | 0 | No OHLC issues detected |
| NASDAQ 100 | 0 | No OHLC issues detected |
| S&P 500 | 0 | No OHLC issues detected |

The issues were mainly found in AUD/USD and EUR/USD. These records may indicate inconsistent High, Low, Open, or Close prices.

The correct business interpretation is not to immediately delete these records. Instead, they should be flagged for review and compared with another data source if the strategy were used in a production environment.

### 6.4 Technical Risk Events

The technical risk monitoring layer flagged **70 technical risk events** for review.

| Asset | Extreme Return Days | High-Cost Days | Worst Drawdown |
|---|---:|---:|---:|
| AUD/USD | 12 | 2 | -33.2% |
| EUR/USD | 13 | 2 | -8.7% |
| Gold | 12 | 2 | -14.6% |
| NASDAQ 100 | 10 | 2 | -28.1% |
| S&P 500 | 13 | 2 | -31.2% |

Extreme return days are not necessarily data errors. They may represent real market movements. However, they should be reviewed because they can materially affect return, volatility, Sharpe ratio, and drawdown calculations.

High-cost days are also important because they indicate periods where execution cost became unusually large compared with the asset's normal cost level.

### 6.5 Asset-Level Risk Scorecard

| Asset | Data Quality Risk Score | Data Quality Risk Level | Performance Risk Level | Interpretation |
|---|---:|---|---|---|
| AUD/USD | 258 | Medium | High | Data quality issues and poor strategy performance |
| EUR/USD | 180 | Medium | Low | Data quality issues but lower performance risk |
| S&P 500 | 30 | Low | High | Clean data but high drawdown exposure |
| Gold | 28 | Low | Low | Strongest overall profile |
| NASDAQ 100 | 24 | Low | Medium | Positive return with meaningful drawdown risk |

The risk scorecard separates **data quality risk** from **performance risk**.

This distinction is important. For example, S&P 500 had low data quality risk but high performance risk because of its deep drawdown. AUD/USD had both data quality issues and weak performance, so it requires the most careful review.

---

## 7. Stakeholder Communication

This section explains how I would communicate the project findings to different stakeholders.

### 7.1 Communication to a Trading Team

For a trading team, I would focus on strategy performance, risk-adjusted return, drawdown, and whether the signal is worth further development.

Suggested wording:

> The moving-average strategy performed best on Gold, with the highest after-cost return and the strongest Sharpe ratio. NASDAQ 100 also generated positive returns, but its higher execution cost and larger drawdown suggest that risk controls would need to be improved before scaling the strategy. AUD/USD underperformed materially, so I would not recommend using the current signal on AUD/USD without further signal redesign or additional filters.

Key trading message:

- Gold is the strongest candidate for further strategy testing.
- NASDAQ 100 has return potential but needs tighter risk control.
- AUD/USD should be excluded or redesigned under the current strategy logic.

### 7.2 Communication to a Risk Manager

For a risk manager, I would focus less on return and more on drawdown, volatility, execution cost, and technical risk events.

Suggested wording:

> The strategy shows meaningful drawdown risk in AUD/USD, S&P 500, and NASDAQ 100. Although S&P 500 and NASDAQ 100 generated positive final returns, their drawdowns indicate that the strategy may expose the portfolio to large interim losses. I would recommend adding volatility-based position sizing, drawdown limits, and stress testing before considering production use.

Key risk message:

- Positive return does not mean acceptable risk.
- Drawdown limits should be added.
- High-volatility assets need execution cost and slippage monitoring.
- Technical risk events should be reviewed before relying on the backtest.

### 7.3 Communication to a Data Governance or Operations Team

For a data governance or operations team, I would focus on data reliability, reconciliation, and auditability.

Suggested wording:

> The main calculation pipeline passed schema validation, missing value checks, duplicate key checks, return reconciliation, signal reconciliation, and cost/PnL reconciliation. However, the OHLC integrity check identified 76 market data issues, mainly in AUD/USD and EUR/USD. These records should be flagged and reviewed against an alternative data vendor before the results are used for formal reporting.

Key governance message:

- The calculation pipeline is internally consistent.
- AUD/USD and EUR/USD have OHLC data quality issues.
- Data issues should be flagged, documented, and reconciled.
- The project includes an auditable control layer rather than relying only on backtest outputs.

### 7.4 Communication to a Business Stakeholder

For a non-technical stakeholder, I would avoid technical details and focus on business meaning.

Suggested wording:

> The analysis shows that the strategy is not equally effective across all assets. Gold delivered the strongest performance after trading costs, while AUD/USD performed poorly. The analysis also shows that trading costs and drawdowns can materially change how attractive a strategy looks. Before using this type of strategy in practice, we should focus on the assets where the signal is stronger, apply risk limits, and review the data quality issues found in the FX datasets.

Key business message:

- Do not apply the same trading rule blindly to every asset.
- Gold is the best-performing asset in this analysis.
- AUD/USD is not suitable under the current rule.
- Cost, drawdown, and data quality must be considered before decision-making.

---

## 8. Business Recommendations

Based on the analysis, I would make the following recommendations.

### Recommendation 1: Prioritise Gold for further testing

Gold showed the strongest after-cost return and Sharpe ratio. It should be the first asset selected for deeper testing, including walk-forward validation and alternative parameter testing.

### Recommendation 2: Do not use the current strategy on AUD/USD without redesign

AUD/USD had negative after-cost return, negative Sharpe ratio, deep drawdown, and OHLC data quality issues. The current moving-average strategy is not suitable for AUD/USD without further investigation.

### Recommendation 3: Add risk controls for NASDAQ 100 and S&P 500

NASDAQ 100 and S&P 500 showed positive returns, but both had meaningful drawdown risk. Risk controls such as volatility targeting, stop-loss rules, or maximum drawdown limits should be tested.

### Recommendation 4: Review FX market data quality before formal reporting

AUD/USD and EUR/USD had OHLC integrity issues. These records should be compared against another market data provider before using the results in a formal trading or risk report.

### Recommendation 5: Improve execution cost modelling

The current cost model captures spread, transaction cost, and volatility-driven slippage, but real execution costs may vary by broker, liquidity, market session, and order size. Future work should include more granular cost assumptions.

---

## 9. Limitations

This project has several limitations.

1. **Simple strategy logic**  
   The strategy only uses a 20-day and 50-day moving-average rule. It does not include additional filters such as momentum, volatility regime, macro indicators, or machine learning signals.

2. **Long-only position design**  
   The strategy only enters long positions or stays out of the market. It does not test short-selling during downtrends.

3. **Simplified execution cost assumptions**  
   Transaction cost and slippage are simulated. In real trading, execution cost depends on liquidity, broker pricing, order size, latency, and market conditions.

4. **No dynamic position sizing**  
   The project does not adjust position size based on volatility, risk budget, or drawdown.

5. **No walk-forward validation**  
   The moving-average parameters are fixed. Future work should test whether the parameters remain robust across different market regimes.

6. **Data quality issues require external validation**  
   The OHLC issues are flagged by rule-based checks, but external data comparison would be needed before deciding whether to correct or remove the affected records.

---

## 10. Skills Demonstrated

This project demonstrates the following skills.

### Financial Analytics

- Return calculation
- Volatility analysis
- Sharpe ratio calculation
- Drawdown analysis
- After-cost performance evaluation
- Trading cost interpretation

### Quantitative and Trading Analysis

- Moving-average signal design
- Backtesting logic
- Look-ahead bias prevention
- Transaction cost simulation
- Slippage modelling
- Asset-level performance comparison

### Data Analysis and Engineering

- Python data cleaning with Pandas and NumPy
- Time-series feature engineering
- SQL aggregation with DuckDB
- Dashboard-ready dataset preparation
- Reproducible notebook workflow

### Risk Control and Data Governance

- Schema validation
- Missing value checks
- Duplicate key checks
- OHLC price integrity validation
- Return reconciliation
- Signal logic reconciliation
- Cost and PnL reconciliation
- Technical risk event detection
- Asset-level risk scorecard design

### Stakeholder Communication

- Translating technical metrics into business insights
- Explaining risk-adjusted performance
- Communicating data quality issues
- Making actionable recommendations for trading, risk, and business teams

---

## 11. Final Conclusion

This project shows how a simple trading strategy can be analysed in a professional way. Instead of only reporting backtest returns, the workflow evaluates performance after transaction costs, compares risk-adjusted returns, analyses drawdown, monitors execution cost, validates data quality, reconciles calculations, and translates the results into stakeholder-facing recommendations.

The strongest result came from Gold, which delivered the highest after-cost return and the best Sharpe ratio. NASDAQ 100 also showed positive performance but required stronger risk control because of higher cost and drawdown. AUD/USD performed poorly and also had data quality issues, making it unsuitable under the current strategy design.

The main value of this project is that it combines **trading analytics, risk control, data governance, SQL reporting, Tableau visualisation, and business communication**. This makes it stronger than a standard backtesting project and more relevant to real-world financial data, trading operations, risk analytics, and quantitative analyst roles.
