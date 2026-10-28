SmartStock: Sales and Inventory Analysis

Project Overview

SmartStock is a data analytics project that examines sales performance, product profitability, and inventory levels. The goal is to turn raw business data into actionable insights that can support better inventory management and business decisions.

Business Objectives

Analyse sales revenue, costs, profit, and profit margin.

Identify the products generating the highest profits.

Assess inventory levels and identify products requiring replenishment.

Recommend practical actions to improve stock management and business performance.

Tools and Technologies

Python — data analysis and data cleaning

Pandas — data manipulation and analysis

Matplotlib — data visualisation

Jupyter Notebook — analysis and documentation

GitHub — project version control and portfolio presentation

Datasets

The project uses three datasets:

sales.csv — sales transactions and related financial information.

products.csv — product information and cost details.

inventory.csv — stock levels and reorder information.

Key Findings

The cleaned sales analysis produced the following results:


Metric	Result

Total revenue	GH₵639,284.34

Total cost	GH₵449,064.33

Total profit	GH₵190,220.01

Profit margin	29.76%

Additional inventory analysis identified 44 units below reorder levels across the replenishment report, with five products listed for ordering.

The analysis also identified the top five products by profit, helping highlight products that contribute most to business profitability.

SQL Analysis

SQL analysis was performed using MySQL Workbench on the SmartStock dataset.

The analysis covered:

Overall sales revenue, cost, profit, and profit margin.

Sales performance and profitability by product.

Identification of the five most profitable products.

Inventory levels and products requiring replenishment.

Data quality checks for duplicate records, missing or invalid order dates, negative quantities, and sales records without matching products.

Data Quality Findings

The SQL checks identified:

5 duplicate sales record groups

3 sales records with missing or invalid order dates

1 sales record with a negative quantity

2 sales records without a matching product record

These findings highlight the importance of data quality checks before using sales data for business reporting and decision-making.

Tools Used

MySQL Workbench was used to execute the queries, inspect the tables, and analyze the SmartStock datasets.


Recommendations

Prioritise replenishment: Review the replenishment report and restock products with insufficient inventory.

Protect profitable products: Monitor the availability and performance of the highest-profit products.

Improve inventory monitoring: Review stock levels against reorder thresholds regularly.

Use data for planning: Combine sales performance and inventory insights when making purchasing decisions.

Project Structure

The project contains sales, product, and inventory datasets, alongside Jupyter notebooks documenting the analysis, findings, and recommendations.

Limitations

The findings are based on the available datasets. They describe the observed sales and inventory records and should not be interpreted as forecasts of future performance.

Conclusion

SmartStock demonstrates how Python-based data cleaning, exploratory analysis, and visualisation can transform raw sales and inventory data into practical business insights.

This project forms part of my data analytics portfolio as I continue developing my skills in Python, SQL, and cloud technologies.


## AWS Cloud Data Pipeline

### Overview

SmartStock was extended to demonstrate a cloud-based data engineering workflow using Amazon Web Services (AWS). The pipeline stores raw sales data in Amazon S3, processes and cleans it with AWS Glue, saves the output in Parquet format, and makes the processed data available for SQL analysis through Amazon Athena.

### Architecture

```text
Raw CSV Files
     |
     v
Amazon S3 — Raw Data
     |
     v
AWS Glue ETL Job
(smartstock-sales-etl)
     |
     v
Data Cleaning and Validation
     |
     v
Amazon S3 — Processed Data
(Parquet format)
     |
     v
AWS Glue Data Catalog
     |
     v
Amazon Athena
(SQL queries and validation)
```

### AWS Services Used

- **Amazon S3:** Stores the original CSV files and processed Parquet output in separate locations.
- **AWS Glue ETL:** Reads the raw sales data, removes exact duplicate rows, filters records with missing required fields, and excludes records with non-positive quantities.
- **AWS Glue Data Catalog:** Stores table metadata for querying the processed dataset.
- **Amazon Athena:** Executes SQL queries against the processed data stored in S3.

### Data Storage

The project uses the following S3 locations:

- Raw sales data: `s3://smartstock-data-lake-2026-gh/raw/sales/sales.csv`
- Processed sales data: `s3://smartstock-data-lake-2026-gh/processed/sales/`

The processed dataset is stored in Parquet format, a columnar file format suitable for analytical workloads.

### Validation Results

The processed dataset was queried successfully in Amazon Athena.

| Validation check | Result |
|---|---:|
| Raw sales rows | 1,205 |
| Processed sales rows | 1,194 |
| Unique sale-line IDs | 1,194 |
| Non-positive quantities | 0 |
| Total revenue | GH₵639,284.34 |
| Total cost | GH₵449,064.33 |
| Total profit | GH₵190,220.01 |
| Profit margin | 29.76% |

The processed row count, data-quality checks, and financial calculations were validated using Athena SQL queries. Revenue, cost, profit, and profit margin matched the results from the Python analysis.

### Technical Notes and Limitations

- The processed table uses column types compatible with the generated Parquet files. The `sale_line_id` and `order_date` columns are exposed as strings, while `quantity` is exposed as a bigint.
- The raw CSV tables remain separate from the processed Parquet table.
- The pipeline currently processes the sales dataset. The products and inventory datasets are catalogued separately and can be incorporated into future processing workflows.
- This is a portfolio project. The results demonstrate the tested workflow and should not be interpreted as evidence of production-scale performance or cost savings.
- AWS usage may incur charges depending on service usage and applicable credits or pricing.

### Future Improvements

- Automate pipeline execution and monitor job failures.
- Add automated data-quality checks and reconciliation between Python, SQL, and Athena results.
- Extend the ETL pipeline to process products and inventory data.
- Add cost monitoring and document the project's security and access-control configuration.
