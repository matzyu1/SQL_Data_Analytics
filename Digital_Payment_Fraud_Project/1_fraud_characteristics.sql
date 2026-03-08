/*
Question 1: Which transaction characteristics are most common in fraudulent transactions?
- Filter the dataset to only fraudulent transactions (is_fraud = 1)
- Group fraud transactions by key “characteristic” fields:
    - payment_channel (how the transaction was made)
    - device_type (where it was made)
    - is_international (cross-border risk)
- Count fraud occurrences per combination to see which patterns appear most frequently
- Calculate average transaction amount to understand typical fraud amounts per pattern
- Why? Helps users and analysts recognize what fraudulent transactions *usually* look like.
*/

SELECT
    payment_channel,
    device_type,
    is_international,
    COUNT(*) AS fraud_count,
    ROUND(AVG(transaction_amount), 2) AS avg_fraud_amount
FROM
    transactions
WHERE
    is_fraud = TRUE
GROUP BY
    payment_channel,
    device_type,
    is_international
ORDER BY
    fraud_count DESC;

/*
Here’s the breakdown of the most common characteristics in fraudulent transactions:
Mobile + Card Fraud Dominates: Card payments made on mobile devices account for the highest number of fraud cases (2,062), indicating that mobile card transactions are the most common fraud pattern.
Digital Payments Are Frequently Targeted: UPI and wallet transactions on mobile devices also appear frequently among fraud cases, highlighting increased fraud exposure in mobile digital payment ecosystems.
Domestic Fraud Is More Common: Most fraud transactions occur in domestic transactions rather than international ones, although international fraud still appears across multiple payment channels.
Consistent Fraud Amount Range: The average fraud transaction amount generally falls between ~$2,100 and ~$2,400, suggesting a typical fraud transaction size regardless of payment method or device.

