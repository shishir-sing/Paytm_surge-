WITH monthly_totals AS (
    SELECT category, billing_month, SUM(amount) AS total_spend
    FROM transactions
    GROUP BY category, billing_month
),
with_prior AS (
    SELECT
        category,
        billing_month,
        total_spend,
        LAG(total_spend) OVER (PARTITION BY category ORDER BY billing_month) AS prior_month_spend
    FROM monthly_totals
),
pct_changes AS (
    SELECT
        category,
        billing_month,
        total_spend,
        prior_month_spend,
        (total_spend - prior_month_spend) * 1.0 / prior_month_spend AS pct_change
    FROM with_prior
    WHERE prior_month_spend IS NOT NULL
)
SELECT
    category,
    billing_month,
    total_spend,
    ROUND(pct_change * 100, 1) AS pct_change,
    CASE
        WHEN ABS(pct_change) > 0.20 THEN 'Surge'
        ELSE 'Normal'
    END AS flag
FROM pct_changes
ORDER BY billing_month, category;