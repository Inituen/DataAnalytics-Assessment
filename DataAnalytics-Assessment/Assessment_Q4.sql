-- Q4.
WITH tenure AS (
    SELECT
        id AS customer_id,
         CONCAT(first_name, ' ', last_name) AS name,
        TIMESTAMPDIFF(MONTH, date_joined, CURRENT_DATE) AS tenure_months
    FROM users_customuser
), 
transactions AS (
    SELECT
        owner_id AS customer_id,
        COUNT(id) AS total_transactions,
        SUM(confirmed_amount) / 100 AS total_transaction_value_naira
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY owner_id
)
SELECT
    t.customer_id,
    t.name,
    t.tenure_months,
    tr.total_transactions,
    ROUND((tr.total_transaction_value_naira / NULLIF(t.tenure_months, 0)) * 12 * 0.001, 2) AS estimated_clv_naira -- Ensure division safety & round result
FROM tenure t
JOIN transactions tr ON t.customer_id = tr.customer_id
WHERE t.tenure_months > 0
ORDER BY estimated_clv_naira DESC;