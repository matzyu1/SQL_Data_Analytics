/*
Question 5: Which merchants have the highest fraud rates?
- Use a CTE to first summarize transaction activity at the merchant level.
- Count DISTINCT transaction_id to calculate the total number of transactions per merchant.
- Sum the fraud indicator (is_fraud) to determine the total number of fraudulent transactions per merchant.
- In the final query, compute the fraud rate as total_fraud / total_transactions.
- Use NULLIF() to prevent division-by-zero errors.
- Filter merchants with more than 50 transactions to avoid misleading fraud rates from very small sample sizes.
- Sort results by fraud_rate in descending order to identify the highest-risk merchants.
- Why? Helps analysts detect merchants that may be associated with suspicious activity, weak fraud controls, or targeted fraud attacks.

Notes on Using a CTE:
The CTE separates the data preparation step (aggregating merchant-level transaction and fraud counts) from the final calculation of fraud rates, improving query readability.

Again, Although a CTE isn’t strictly required for this, it is still useful for organizing the query clearly and making the analysis easier to expand if additional merchant-level metrics are added later.
*/

WITH merchant_fraud_analysis AS (
    SELECT
        merchant_id,
        COUNT(DISTINCT transaction_id) AS total_transactions,
        SUM(is_fraud :: INT) AS total_fraud
    FROM 
        transactions
    GROUP BY merchant_id
)
SELECT
    merchant_id,
    ROUND(total_fraud::DECIMAL / NULLIF(total_transactions, 0), 4) AS fraud_rate
FROM
    merchant_fraud_analysis
WHERE 
    total_transactions > 50
ORDER BY
    fraud_rate DESC
LIMIT 10;

/*
Here’s the breakdown of merchants with the highest fraud rates:

High-Risk Merchants Identified: The top merchants in this analysis have fraud rates ranging from roughly 7.8% to 10.9%, significantly higher than typical overall fraud rates in transaction datasets.

Consistent Fraud Patterns Across Multiple Merchants: Several merchants share similar fraud rates (~8–9%), suggesting certain merchant environments or categories may attract similar fraud behavior.

Filtering Improves Reliability: By only including merchants with more than 50 transactions, the analysis avoids inflated fraud rates that could occur with very small transaction counts.

Operational Insight for Fraud Monitoring: Merchants with unusually high fraud rates can be flagged for further investigation, enhanced monitoring, or additional fraud prevention controls.
*/

