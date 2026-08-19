SELECT
    category,
    billing_month,
    SUM(amount) AS total_spend
FROM transactions
GROUP BY category, billing_month
ORDER BY category, billing_month;