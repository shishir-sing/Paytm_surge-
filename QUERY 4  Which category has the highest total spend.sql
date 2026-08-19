SELECT * FROM bill_tracker.transactions;SELECT
    category,
    SUM(amount) AS total_6mo_spend
FROM transactions
GROUP BY category
ORDER BY total_6mo_spend DESC
LIMIT 1;