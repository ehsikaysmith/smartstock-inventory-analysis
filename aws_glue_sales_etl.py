
import sys

from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.context import SparkContext
from pyspark.sql import functions as F

# Initialize the AWS Glue job
args = getResolvedOptions(sys.argv, ["JOB_NAME"])

sc = SparkContext.getOrCreate()
glueContext = GlueContext(sc)
spark = glueContext.spark_session

job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# S3 input and output locations
INPUT_PATH = (
    "s3://smartstock-data-lake-2026-gh/raw/sales/sales.csv"
)
OUTPUT_PATH = (
    "s3://smartstock-data-lake-2026-gh/processed/sales/"
)

# Read the raw sales CSV
sales_df = (
    spark.read
    .option("header", "true")
    .option("inferSchema", "true")
    .csv(INPUT_PATH)
)

# Remove exact duplicate rows
sales_df = sales_df.dropDuplicates()

# Remove records with missing required fields
required_columns = [
    "sale_line_id",
    "order_id",
    "order_date",
    "product_id",
    "quantity",
    "unit_price",
    "unit_cost",
]

sales_df = sales_df.dropna(subset=required_columns)

# Exclude zero and negative quantities
sales_df = sales_df.filter(F.col("quantity") > 0)

# Write the cleaned data as Parquet
(
    sales_df.write
    .mode("overwrite")
    .format("parquet")
    .save(OUTPUT_PATH)
)

print("SmartStock sales ETL completed successfully.")

job.commit()
