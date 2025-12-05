# Marketing Analytics Case Study - Sample Data

This dataset contains anonymized sample data extracted from a real digital marketing agency's data warehouse. The data represents typical structures and patterns found in marketing analytics scenarios.

## Data Overview

### 1. Clients (`clients.csv`)
**Description:** Anonymized client information for a German digital marketing agency
- `client_id`: Unique identifier for each client
- `client_name`: Anonymized client name (Client_1, Client_2, etc.)
- `primary_industry`: Primary industry categorization with emojis
- `secondary_industry`: Optional secondary industry
- `country`: All clients are based in Germany

**Row Count:** ~180 records
**Business Context:** Diverse client portfolio across industries like Food & Beverage, Tech, Home & Living, Travel, Fashion, etc.

### 2. Employees (`employees.csv`) 
**Description:** Anonymized employee data with departmental structure
- `employee_id`: Unique employee identifier
- `employee_name`: Anonymized name (Employee_1, Employee_2, etc.) 
- `department_name`: Department (Paid Media, Paid Content, Strategy, Data & Analytics, etc.)
- `team_name`: Team code (PC, PE, CD, PD, etc.)
- `hourly_rate_eur`: Standardized hourly rates by department
  - Paid Media: €85/hour
  - Data & Analytics: €90/hour  
  - Strategy: €95/hour
  - Paid Content: €75/hour
  - Other: €80/hour
- `status`: All employees marked as 'Active'

**Row Count:** ~80 records
**Business Context:** Typical digital agency structure with specialized teams

### 3. Time Tracking (`time_tracking.csv`)
**Description:** Employee time tracking data
- `employee_id`: Links to employees table
- `employee_name`: Employee name
- `client_id`: Client identifier
- `client_name`: Client name
- `project_id`: Project identifier
- `report_date`: Date of work performed
- `hours_worked`: Hours logged (decimal format)
- `department_name`: Department name
- `cost_eur`: Calculated cost
- `is_productive`: Boolean flag

**Row Count:** ~1,000 records
**Date Range:** 2024
**Business Context:** Time allocation data from internal systems

### 4. Projects (`projects.csv`)
**Description:** Client project information
- `project_id`: Unique project identifier
- `client_id`: Links to clients table
- `client_name`: Anonymized client name
- `project_name`: Simplified as 'Main Campaign' (one project per client)
- `project_start_date`: Project start (2024-01-01)
- `project_end_date`: Project end (2024-12-31)
- `monthly_budget_eur`: Fixed at €5,000 for simplification

**Row Count:** ~184 records (one per client)
**Business Context:** Ongoing client campaigns and projects throughout 2024

### 5. Campaigns (`campaigns.csv`)
**Description:** Digital advertising campaign metadata
- `campaign_id`: Unique campaign identifier
- `account_id`: Account identifier
- `account_name`: Account name
- `campaign_name`: Anonymized campaign name
- `platform`: Advertising platform (Meta Ads, TikTok Ads, Google Ads, Pinterest Ads)
- `start_date`: Campaign creation date
- `campaign_status`: Campaign status (ACTIVE, PAUSED, ARCHIVED)
- `daily_budget_eur`: Daily budget in EUR

**Row Count:** ~120 records
**Date Range:** 2024
**Business Context:** Multi-platform advertising campaigns

### 6. Ad Performance Metrics (`ad_metrics.csv`)
**Description:** Daily advertising performance data with multiple attribution windows
- `campaign_id`: Links to campaigns table
- `client_id`: Links to clients table
- `client_name`: Anonymized client name
- `platform`: Advertising platform (Meta Ads, TikTok Ads, Google Ads, Pinterest Ads)
- `report_date`: Date of performance metrics
- `attribution_window`: Attribution model used
  - **1d_click**: 1-day click attribution
  - **7d_click**: 7-day click attribution
  - **28d_click**: 28-day click attribution
  - **1d_view**: 1-day view-through attribution
  - **7d_view**: 7-day view-through attribution
- `spend_eur`: Daily ad spend in EUR
- `impressions`: Total ad impressions
- `clicks`: Total clicks on ads
- `conversions`: Total conversions/purchases attributed
- `cpm`: Cost per mille (thousand impressions)
- `ctr`: Click-through rate (%)
- `cvr`: Conversion rate (%)
- `cpc`: Cost per click
- `cpa`: Cost per acquisition/conversion
- `revenue_eur`: Revenue generated from conversions
- `roas`: Return on ad spend (revenue / spend)

**Row Count:** ~9,000 records (daily data × campaigns × attribution windows)
**Date Range:** Throughout 2024
**Business Context:** Comprehensive paid advertising performance with multiple attribution models for accurate performance measurement

### 7. Social Media Metrics (`social_metrics.csv`)
**Description:** Daily social media performance metrics from Instagram and Facebook
- `page_id`: Page identifier
- `page_name`: Page name
- `campaign_id`: Campaign identifier (where applicable)
- `report_date`: Date of metrics
- `platform`: Social media platform (Instagram, Facebook)
- `engaged_users`: Number of users who engaged with content
- `new_followers`: Daily new followers gained
- `total_followers`: Total follower count
- `impressions`: Total impressions
- `organic_impressions`: Organic impressions
- `profile_views`: Number of profile views
- `website_clicks`: Clicks to website

**Row Count:** 500 records
**Date Range:** January 2024 - April 2024
**Business Context:** Social media performance metrics

## Data Quality Notes

### Anonymization Process
- All client names replaced with Client_X format
- All employee names replaced with Employee_X format  
- Campaign names genericized
- Email addresses and personal identifiers removed
- Budgets and rates standardized/randomized

### Data Relationships
```
clients (1) ←→ (M) projects
clients (1) ←→ (M) campaigns
clients (1) ←→ (M) social_metrics

projects (1) ←→ (M) time_tracking

campaigns (1) ←→ (M) ad_metrics
campaigns (1) ←→ (M) social_metrics (for correlation analysis)

employees (1) ←→ (M) time_tracking

clients.client_id = PRIMARY KEY (source of truth for client data)
```

### Data Notes
- This dataset represents anonymized production data from multiple source systems
- Standard data quality assessment and profiling is recommended before building production models
- Consider exploring the data thoroughly to understand relationships and potential quality issues

## Business Questions for Analysis

### Operational Efficiency
1. Which departments have the highest utilization rates?
2. What is the average cost per client across different industries?
3. How does time allocation vary by employee department?

### Client Analysis  
1. Which clients generate the most revenue (hours × rates)?
2. What is the distribution of work across different industries?
3. Which clients have the most active campaigns?

### Resource Planning
1. How many hours per month does each department allocate to clients?
2. What is the ratio of productive vs non-productive time?
3. Which employees work on the most diverse client portfolio?

### Campaign Performance
1. How are advertising budgets distributed across platforms?
2. Which platforms are most popular for different client types?
3. What is the relationship between project budgets and campaign activity?

## Technical Implementation Suggestions

### dbt Layer Structure
- **Integration Layer (IL):** Raw CSV ingestion
- **Cleansing Layer (CL):** Data standardization and type casting  
- **Operational Layer (OL):** Business logic and joins
- **Business Layer (BL):** KPIs and aggregated metrics

### Key Metrics to Calculate
- Client lifetime value (based on time spent)
- Department utilization rates
- Average project profitability
- Campaign-to-time allocation ratios
- Industry performance benchmarks

### Data Quality Tests
- Referential integrity between tables
- Non-null constraints on key fields
- Date range validations
- Positive value constraints on hours/costs
- Unique key constraints

## Usage Instructions

1. Load CSV files into your preferred data warehouse (BigQuery recommended)
2. Create dbt models following the suggested layer structure
3. Implement data quality tests
4. Build analytical models for the business questions above
5. Create documentation using dbt docs

This dataset provides a realistic foundation for demonstrating modern data engineering and analytics capabilities in a marketing agency context.