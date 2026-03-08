/*
Question: Which customers are associated with the highest number of fraudulent transactions?
- Aggregate transaction activity at the customer level to identify individuals linked to fraud.
- Count the total number of transactions per customer to understand overall activity levels.
- Calculate how many of those transactions were fraudulent by summing the fraud indicator.
- Compute the total amount involved in fraudulent transactions for each customer.
- Filter to include only customers with at least one fraud case to focus on suspicious behavior.
- Why? Helps analysts identify high-risk customers, prioritize fraud investigations, and detect potential repeat fraud patterns.
*/

SELECT
    customer_id,
    COUNT(*) AS total_transactions,
    SUM(is_fraud::INT) AS fraud_count,
    ROUND(SUM(transaction_amount), 0) AS total_fraud_amount
FROM
    transactions
GROUP BY
    customer_id
HAVING
    SUM(is_fraud::INT) > 0 
ORDER BY
    fraud_count DESC
LIMIT 100;

/*
Key Insights:
High-Risk Customers Identified: Some customers appear multiple times with fraudulent transactions, indicating potential repeat fraud behavior or compromised accounts.
Fraud Often Occurs Within Active Accounts: Many customers with fraud have relatively high total transaction counts, suggesting that fraud can occur within otherwise active accounts.
Financial Impact Varies: Total fraud amounts differ significantly across customers, indicating that some fraud cases involve much larger financial exposure.
Investigation Prioritization: Ranking customers by fraud count helps fraud teams focus on accounts that may require monitoring, investigation, or intervention.
*/