-- Example SQL Queries for Case Study
-- These demonstrate how the data can be used for the dbt models

-- =============================================================================
-- OPERATIONAL LAYER EXAMPLES
-- =============================================================================

-- ol_unified_ad_metrics: Normalize ad metrics across attribution windows
-- Best practice: Use 7d_click as default attribution window
SELECT
    am.campaign_id,
    am.client_id,
    c.client_name,
    cam.platform,
    am.report_date,
    am.attribution_window,
    am.spend_eur,
    am.impressions,
    am.clicks,
    am.conversions,
    am.ctr,
    am.cvr,
    am.cpa,
    am.roas,
    am.revenue_eur
FROM ad_metrics am
JOIN campaigns cam ON am.campaign_id = cam.campaign_id
JOIN clients c ON am.client_id = c.client_id
WHERE am.attribution_window = '7d_click'  -- Standard attribution window
ORDER BY am.report_date, am.campaign_id;

-- ol_client_projects_with_time: Join projects with time tracking
SELECT
    p.project_id,
    p.client_id,
    c.client_name,
    c.primary_industry,
    p.project_start_date,
    p.project_end_date,
    p.monthly_budget_eur,
    COUNT(DISTINCT tt.employee_id) as num_employees,
    SUM(tt.hours_worked) as total_hours,
    SUM(tt.cost_eur) as total_cost,
    SUM(CASE WHEN tt.is_productive THEN tt.hours_worked ELSE 0 END) as productive_hours,
    SUM(CASE WHEN tt.is_productive THEN tt.cost_eur ELSE 0 END) as productive_cost
FROM projects p
JOIN clients c ON p.client_id = c.client_id
LEFT JOIN time_tracking tt ON p.project_id = tt.project_id
GROUP BY p.project_id, p.client_id, c.client_name, c.primary_industry,
         p.project_start_date, p.project_end_date, p.monthly_budget_eur;

-- ol_campaign_profitability: Combine ad spend with internal costs
WITH campaign_spend AS (
    SELECT
        campaign_id,
        client_id,
        SUM(spend_eur) as total_ad_spend,
        SUM(revenue_eur) as total_revenue,
        SUM(conversions) as total_conversions
    FROM ad_metrics
    WHERE attribution_window = '7d_click'
    GROUP BY campaign_id, client_id
),
client_time_costs AS (
    SELECT
        client_id,
        SUM(cost_eur) as total_internal_cost,
        SUM(hours_worked) as total_hours
    FROM time_tracking
    WHERE is_productive = TRUE
    GROUP BY client_id
)
SELECT
    cs.campaign_id,
    cam.campaign_name,
    cs.client_id,
    c.client_name,
    cam.platform,
    cs.total_ad_spend,
    cs.total_revenue,
    cs.total_conversions,
    ctc.total_internal_cost,
    ctc.total_hours,
    (cs.total_ad_spend + COALESCE(ctc.total_internal_cost, 0)) as total_cost,
    cs.total_revenue - (cs.total_ad_spend + COALESCE(ctc.total_internal_cost, 0)) as gross_profit,
    CASE
        WHEN (cs.total_ad_spend + COALESCE(ctc.total_internal_cost, 0)) > 0
        THEN (cs.total_revenue - (cs.total_ad_spend + COALESCE(ctc.total_internal_cost, 0)))
             / (cs.total_ad_spend + COALESCE(ctc.total_internal_cost, 0)) * 100
        ELSE NULL
    END as profit_margin_pct
FROM campaign_spend cs
JOIN campaigns cam ON cs.campaign_id = cam.campaign_id
JOIN clients c ON cs.client_id = c.client_id
LEFT JOIN client_time_costs ctc ON cs.client_id = ctc.client_id;

-- =============================================================================
-- BUSINESS LAYER EXAMPLES
-- =============================================================================

-- bl_client_performance_dashboard: Main dashboard metrics by client
WITH client_ad_performance AS (
    SELECT
        client_id,
        COUNT(DISTINCT campaign_id) as num_campaigns,
        SUM(spend_eur) as total_spend,
        SUM(impressions) as total_impressions,
        SUM(clicks) as total_clicks,
        SUM(conversions) as total_conversions,
        SUM(revenue_eur) as total_revenue,
        AVG(ctr) as avg_ctr,
        AVG(cvr) as avg_cvr,
        AVG(cpa) as avg_cpa,
        AVG(roas) as avg_roas
    FROM ad_metrics
    WHERE attribution_window = '7d_click'
    GROUP BY client_id
),
client_resource_costs AS (
    SELECT
        client_id,
        SUM(hours_worked) as total_hours,
        SUM(cost_eur) as total_cost
    FROM time_tracking
    WHERE is_productive = TRUE
    GROUP BY client_id
),
client_social_performance AS (
    SELECT
        client_id,
        AVG(new_followers) as avg_daily_new_followers,
        AVG(engaged_users) as avg_daily_engaged_users,
        AVG(website_clicks) as avg_daily_website_clicks
    FROM social_metrics
    GROUP BY client_id
)
SELECT
    c.client_id,
    c.client_name,
    c.primary_industry,
    cap.num_campaigns,
    cap.total_spend as ad_spend,
    cap.total_revenue,
    cap.total_conversions,
    cap.avg_roas,
    cap.avg_cpa,
    crc.total_hours as internal_hours,
    crc.total_cost as internal_cost,
    (cap.total_spend + COALESCE(crc.total_cost, 0)) as total_investment,
    cap.total_revenue - (cap.total_spend + COALESCE(crc.total_cost, 0)) as net_profit,
    csp.avg_daily_new_followers,
    csp.avg_daily_engaged_users,
    csp.avg_daily_website_clicks
FROM clients c
LEFT JOIN client_ad_performance cap ON c.client_id = cap.client_id
LEFT JOIN client_resource_costs crc ON c.client_id = crc.client_id
LEFT JOIN client_social_performance csp ON c.client_id = csp.client_id
ORDER BY net_profit DESC;

-- bl_resource_utilization: Employee and department utilization
SELECT
    e.employee_id,
    e.employee_name,
    e.department_name,
    e.hourly_rate_eur,
    COUNT(DISTINCT tt.client_id) as num_clients,
    COUNT(DISTINCT tt.project_id) as num_projects,
    SUM(tt.hours_worked) as total_hours,
    SUM(CASE WHEN tt.is_productive THEN tt.hours_worked ELSE 0 END) as billable_hours,
    SUM(tt.cost_eur) as total_cost,
    CASE
        WHEN SUM(tt.hours_worked) > 0
        THEN SUM(CASE WHEN tt.is_productive THEN tt.hours_worked ELSE 0 END)
             / SUM(tt.hours_worked) * 100
        ELSE NULL
    END as utilization_rate_pct
FROM employees e
LEFT JOIN time_tracking tt ON e.employee_id = tt.employee_id
GROUP BY e.employee_id, e.employee_name, e.department_name, e.hourly_rate_eur
ORDER BY utilization_rate_pct DESC;

-- bl_monthly_campaign_cohorts: Monthly performance cohorts
SELECT
    DATE_TRUNC('month', CAST(am.report_date AS DATE)) as cohort_month,
    am.client_id,
    c.client_name,
    c.primary_industry,
    COUNT(DISTINCT am.campaign_id) as num_campaigns,
    SUM(am.spend_eur) as monthly_spend,
    SUM(am.conversions) as monthly_conversions,
    SUM(am.revenue_eur) as monthly_revenue,
    AVG(am.roas) as avg_roas,
    AVG(am.cpa) as avg_cpa
FROM ad_metrics am
JOIN clients c ON am.client_id = c.client_id
WHERE am.attribution_window = '7d_click'
GROUP BY DATE_TRUNC('month', CAST(am.report_date AS DATE)),
         am.client_id, c.client_name, c.primary_industry
ORDER BY cohort_month, monthly_revenue DESC;

-- =============================================================================
-- ADVANCED ANALYSIS EXAMPLES
-- =============================================================================

-- Paid/Organic Correlation: Does paid spend drive organic social growth?
WITH daily_paid AS (
    SELECT
        client_id,
        CAST(report_date AS DATE) as date,
        SUM(spend_eur) as daily_spend,
        SUM(impressions) as daily_impressions
    FROM ad_metrics
    WHERE attribution_window = '7d_click'
    GROUP BY client_id, CAST(report_date AS DATE)
),
daily_organic AS (
    SELECT
        client_id,
        CAST(report_date AS DATE) as date,
        SUM(new_followers) as daily_new_followers,
        SUM(engaged_users) as daily_engaged_users,
        AVG(total_followers) as avg_total_followers
    FROM social_metrics
    GROUP BY client_id, CAST(report_date AS DATE)
)
SELECT
    dp.client_id,
    c.client_name,
    dp.date,
    dp.daily_spend,
    dp.daily_impressions,
    do.daily_new_followers,
    do.daily_engaged_users,
    do.avg_total_followers
FROM daily_paid dp
JOIN daily_organic do ON dp.client_id = do.client_id AND dp.date = do.date
JOIN clients c ON dp.client_id = c.client_id
ORDER BY dp.date, dp.client_id;

-- Attribution Window Comparison: How do metrics differ by window?
SELECT
    campaign_id,
    SUM(CASE WHEN attribution_window = '1d_click' THEN conversions ELSE 0 END) as conv_1d_click,
    SUM(CASE WHEN attribution_window = '7d_click' THEN conversions ELSE 0 END) as conv_7d_click,
    SUM(CASE WHEN attribution_window = '28d_click' THEN conversions ELSE 0 END) as conv_28d_click,
    SUM(CASE WHEN attribution_window = '1d_view' THEN conversions ELSE 0 END) as conv_1d_view,
    SUM(CASE WHEN attribution_window = '7d_view' THEN conversions ELSE 0 END) as conv_7d_view,
    AVG(CASE WHEN attribution_window = '7d_click' THEN roas ELSE NULL END) as roas_7d_click,
    AVG(CASE WHEN attribution_window = '28d_click' THEN roas ELSE NULL END) as roas_28d_click
FROM ad_metrics
GROUP BY campaign_id
HAVING SUM(CASE WHEN attribution_window = '7d_click' THEN conversions ELSE 0 END) > 10
ORDER BY conv_7d_click DESC;
