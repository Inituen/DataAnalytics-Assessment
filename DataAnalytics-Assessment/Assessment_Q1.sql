-- Q1.
SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    savings.savings_count,
    investments.investment_count,
    ROUND((COALESCE(savings.total_savings, 0) + COALESCE(investments.total_investment, 0)) / 100, 2) AS total_deposits -- Convert from kobo to naira with rounding
FROM users_customuser u
LEFT JOIN (
    SELECT s.owner_id, COUNT(DISTINCT s.id) AS savings_count, SUM(s.confirmed_amount) AS total_savings
    FROM savings_savingsaccount s
    JOIN plans_plan p ON s.plan_id = p.id
    WHERE s.confirmed_amount > 0 AND p.is_regular_savings = 1
    GROUP BY s.owner_id
) AS savings ON u.id = savings.owner_id
LEFT JOIN (
    SELECT s.owner_id, COUNT(DISTINCT s.id) AS investment_count, SUM(s.confirmed_amount) AS total_investment
    FROM savings_savingsaccount s
    JOIN plans_plan p ON s.plan_id = p.id
    WHERE s.confirmed_amount > 0 AND p.is_a_fund = 1
    GROUP BY s.owner_id
) AS investments ON u.id = investments.owner_id
WHERE COALESCE(savings.savings_count, 0) > 0 
  AND COALESCE(investments.investment_count, 0) > 0
ORDER BY total_deposits DESC;