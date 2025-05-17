-- Q3
WITH last_transactions AS (
    SELECT
        plan_id,
        owner_id,
        DATE(MAX(transaction_date)) AS last_transaction_date -- Convert datetime to date
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY plan_id, owner_id
)
SELECT
    lt.plan_id,
    lt.owner_id,
    CASE
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Unknown'
    END AS type,
    lt.last_transaction_date, -- Now stores only the date portion
    DATEDIFF(CURRENT_DATE, lt.last_transaction_date) AS inactivity_days
FROM last_transactions lt
JOIN plans_plan p ON lt.plan_id = p.id
WHERE DATEDIFF(CURRENT_DATE, lt.last_transaction_date) > 365
ORDER BY inactivity_days DESC;