# Data Exploration Guide

This guide provides recommendations for exploring and understanding the case study data.

## Getting Started

The `/data` folder contains CSV files from various source systems. As with any real-world data integration project, we recommend starting with thorough data exploration and quality assessment before building production models.

## Recommended Exploration Steps

### 1. Initial Data Profiling

Start by understanding the basic structure and quality of each dataset:

```python
import pandas as pd

# Load and inspect each file
df = pd.read_csv('data/clients.csv')

# Basic profiling
print(f"Rows: {len(df)}")
print(f"Columns: {list(df.columns)}")
print(f"\nNull counts:\n{df.isna().sum()}")
print(f"\nData types:\n{df.dtypes}")
print(f"\nSample:\n{df.head()}")
```

**Questions to explore:**
- What is the row count for each file?
- Are there any NULL values? Where and how many?
- What are the primary keys?
- What are the foreign keys?

### 2. Relationship Validation

Understand how tables relate to each other:

```python
# Check foreign key relationships
campaigns = pd.read_csv('data/campaigns.csv')
clients = pd.read_csv('data/clients.csv')

# Check if all campaigns reference valid clients
# Note: Column names may vary by source system
```

**Questions to explore:**
- Do all foreign keys reference valid primary keys?
- Are there any orphaned records?
- Do different source systems use consistent naming conventions?

### 3. Data Quality Assessment

Look for common data quality issues:

```sql
-- Example checks in SQL or pandas:

-- Check for duplicates
SELECT column_name, COUNT(*)
FROM table
GROUP BY column_name
HAVING COUNT(*) > 1;

-- Check for outliers
SELECT MIN(metric), MAX(metric), AVG(metric)
FROM table;

-- Check for gaps in time series
-- (Are there missing dates?)
```

**Questions to explore:**
- Are there any duplicate records?
- Are there any statistical outliers?
- Are there gaps in time series data?
- Do string fields have consistent formatting (whitespace, case, etc.)?

### 4. Business Logic Validation

Validate assumptions about the business data:

**Questions to explore:**
- Do campaign start_dates align with when metrics actually start appearing?
- Does the sum of daily budgets make sense given actual spend?
- Are there logical relationships between related metrics (e.g., clicks <= impressions)?
- Can you trace a single client through all relevant tables?

## Common Data Integration Patterns

When working with data from multiple source systems, you may encounter:

### Naming Convention Differences
Different systems often use different terminology:
- CRM systems: "client", "customer", "account"
- Ad platforms: "account", "advertiser"
- Social platforms: "page", "profile"
- HR systems: "employee", "worker", "resource"

**Recommendation:** Create mapping tables or normalization logic in your Cleansing Layer.

### Incomplete Data
Real-world systems often have:
- NULL foreign keys (not all records are linked)
- Missing time periods (campaigns paused, data collection failures)
- Partial records (some optional fields not populated)

**Recommendation:** Document your handling strategy. Use COALESCE, default values, or filtering as appropriate for your use case.

### Data Quality Variations
Production data typically includes:
- Inconsistent formatting (whitespace, case sensitivity)
- Outliers or anomalies (tracking errors, test data)
- Schema evolution (fields added/changed over time)

**Recommendation:** Implement data quality checks and document exceptions.

## Sample Exploration Queries

### Explore Campaign Coverage
```sql
-- How many clients have campaigns?
SELECT
    COUNT(DISTINCT c.client_id) as total_clients,
    COUNT(DISTINCT cam.client_id) as clients_with_campaigns
FROM clients c
LEFT JOIN campaigns cam ON c.client_id = cam.client_id;
```

### Check Time Tracking Completeness
```sql
-- Are all time entries assigned to projects?
SELECT
    COUNT(*) as total_entries,
    COUNT(project_id) as entries_with_project,
    COUNT(*) - COUNT(project_id) as entries_without_project
FROM time_tracking;
```

### Validate Ad Metrics Continuity
```sql
-- Check for date gaps by campaign
SELECT
    campaign_id,
    MIN(report_date) as first_date,
    MAX(report_date) as last_date,
    COUNT(DISTINCT report_date) as days_with_data,
    DATEDIFF(MAX(report_date), MIN(report_date)) + 1 as expected_days
FROM ad_metrics
GROUP BY campaign_id
HAVING days_with_data < expected_days;
```

## Tips for the Case Study

1. **Document Assumptions**: As you discover data quality issues, document your assumptions and handling strategies.

2. **Use the Layer Architecture**:
   - **Cleansing Layer**: Normalize naming, handle NULLs, standardize formats
   - **Operational Layer**: Implement business logic, enrich data
   - **Business Layer**: Calculate KPIs on clean, trusted data

3. **Add Data Quality Tests**: Use dbt tests to ensure your transformations maintain data quality:
   ```yaml
   - unique
   - not_null
   - relationships
   - accepted_values
   - dbt_utils.expression_is_true
   ```

4. **Consider Performance**: For date spine joins and large aggregations, think about materialization strategies (table vs view).

5. **Think Like a Product Manager**:
   - What data quality issues would block analysis?
   - What should be fixed vs documented?
   - How would you communicate these issues to stakeholders?

## Getting Help

- See `/data/README.md` for dataset descriptions
- Check `scripts/verify_data_integrity.py` for basic integrity checks
- Review `scripts/example_queries.sql` for SQL patterns

## Next Steps

After exploration, you should:
1. Document key findings in your submission
2. Create a data quality report highlighting issues found
3. Implement handling strategies in your dbt models
4. Add appropriate tests to prevent regressions

Remember: **Perfect data doesn't exist.** Senior Data Product Managers are evaluated on how they identify, handle, and communicate data quality issues to stakeholders.

---

Good luck! 🚀
