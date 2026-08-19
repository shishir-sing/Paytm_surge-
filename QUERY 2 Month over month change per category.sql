WITH monthly_totals AS (
    SELECT
        category,
        billing_month,
        SUM(amount) AS total_spend
    FROM transactions
    GROUP BY category, billing_month
),
with_prior AS (
    SELECT
        category,
        billing_month,
        total_spend,
        LAG(total_spend) OVER (
            PARTITION BY category
            ORDER BY billing_month
        ) AS prior_month_spend
    FROM monthly_totals
)
SELECT
    category,
    billing_month,
    total_spend,
    prior_month_spend,
    ROUND(
        (total_spend - prior_month_spend) * 100.0 / prior_month_spend, 1
    ) AS pct_change
FROM with_prior
WHERE prior_month_spend IS NOT NULL
ORDER BY category, billing_month;