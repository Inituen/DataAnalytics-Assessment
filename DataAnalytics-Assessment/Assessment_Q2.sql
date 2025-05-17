-- Q2.
WITH monthly_transactions AS (
    SELECT
        owner_id,
        ROUND(COUNT(id) / (TIMESTAMPDIFF(MONTH, MIN(transaction_date), MAX(transaction_date)) + 1), 2) AS avg_transactions_per_month -- Ensures proper rounding
    FROM savings_savingsaccount
    GROUP BY owner_id
),
categorized_customers AS (
    SELECT
        owner_id,
        avg_transactions_per_month,
        CASE
            WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
            WHEN avg_transactions_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM monthly_transactions
)
SELECT
    frequency_category,
    COUNT(owner_id) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month -- Ensures final result is rounded
FROM categorized_customers
GROUP BY frequency_category
ORDER BY avg_transactions_per_month DESC;