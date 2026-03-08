/*
Question 3: Which payment channels have the highest fraud rate?
- Group transactions by payment_channel
- Count total transactions per channel
- Sum is_fraud per channel to get fraud volume
- Compute fraud_rate_percent = fraud_transactions / total_transactions
- Sort by fraud_rate_percent to rank channels from riskiest to safest
- Why? Helps users choose safer payment methods and helps analysts prioritize fraud controls per channel.
*/

SELECT
    payment_channel,
    COUNT(transaction_id) AS total_transactions,
    SUM(is_fraud::INTEGER) AS fraud_transactions,
    ROUND((SUM(is_fraud::INTEGER)::DECIMAL(10, 2) / COUNT(transaction_id)) * 100, 3) AS fraud_rate
FROM
    transactions
GROUP BY
    payment_channel
ORDER BY
    fraud_rate DESC;

/*
Key Insights:
Card Has the Highest Fraud Rate: Card transactions show the highest fraud rate (~1.728%), making it the riskiest channel in this dataset.
Bank Transfers Are Close Behind: bank_transfer is nearly tied with card (~1.726%), suggesting elevated risk that may require stronger verification/monitoring.
Wallet and UPI Are Slightly Lower: wallet (~1.702%) and upi (~1.686%) show marginally lower fraud rates, but still meaningful given their high volumes.
Rates Are Close Overall: The spread across channels is small (~1.686%–1.728%), meaning channel choice alone doesn’t eliminate risk—controls matter across all channels.
*/
