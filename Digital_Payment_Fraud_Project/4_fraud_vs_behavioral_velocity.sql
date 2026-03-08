/*
Question 4: How do behavioral signals (transaction velocity) relate to fraud?
- Use a CTE to isolate the behavioral/velocity fields relevant to fraud:
    - txn_count_1h (burst activity)
    - txn_count_24h (short-term transaction intensity)
    - failed_txn_count_24h (possible testing or brute-force attempts)
- Compare fraudulent vs legitimate transactions by grouping on is_fraud.
- Use AVG() to quantify the typical behavioral differences between legitimate and fraudulent transactions.
- Filter out NULL values to ensure accurate averages.
- Why? Transaction velocity is a classic fraud signal. Sudden spikes in activity or repeated failed attempts often indicate suspicious behavior.

Notes on Using a CTE:
Improved Query Readability and Structure:
The CTE separates the data preparation step (selecting the behavioral velocity features) from the analysis step (calculating averages by fraud status). This improves readability and makes the query logic easier to follow.

Easier to Extend the Analysis Later:
If additional features, filters, or joins are required later (for example device risk, payment channel, or geographic signals), they can be added inside the CTE without modifying the final aggregation query.

Although Not Essential in This Case:
In this specific example, the CTE is not strictly required because the calculation is relatively simple and could be done in a single query. However, it is still worth demonstrating the use of a CTE because it shows good SQL structuring practices and makes the analysis easier to scale or extend later.
*/

WITH velocity_analysis AS (
    SELECT
        txn_count_1h,
        txn_count_24h,
        failed_txn_count_24h,
        is_fraud
    FROM transactions
)

SELECT
    is_fraud,
    ROUND(AVG(txn_count_1h), 2) AS avg_txn_1h,
    ROUND(AVG(txn_count_24h), 2) AS avg_txn_24h,
    ROUND(AVG(failed_txn_count_24h), 2) AS avg_failed_txn_24h
FROM 
    velocity_analysis
WHERE
    txn_count_1h IS NOT NULL
    AND txn_count_24h IS NOT NULL
    AND failed_txn_count_24h IS NOT NULL
GROUP BY is_fraud
ORDER BY is_fraud;

/*
Here’s the breakdown of how transaction velocity relates to fraud:
Higher Transaction Burst Activity: Fraudulent transactions show a slightly higher average number of transactions within 1 hour compared to legitimate activity, suggesting fraud tends to occur in short bursts.

Higher Daily Transaction Intensity: Fraud cases have a much higher average number of transactions within 24 hours, indicating increased short-term activity in compromised or fraudulent accounts.

More Failed Transaction Attempts: Fraudulent activity also shows roughly double the failed transaction attempts within 24 hours, which may reflect attackers testing systems or credentials before successful fraud.

Behavioral Red Flags: These patterns reinforce why fraud detection systems often monitor transaction velocity, activity spikes, and repeated failures as key behavioral indicators of suspicious activity.
*/