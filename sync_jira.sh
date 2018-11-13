#!/bin/bash

# https://confluence.atlassian.com/adminjiraserver071/backing-up-data-802592964.html

BUCKET=BUCKET_NAME
DB_DUMP=$(date +db_%Y%m%d.gz)
DATA_DIR_ZIP=$(date +data_%Y%m%d.tar.gz)

# For whatever reason, ~/.local/bin/aws s3 is ignoring the --expires option. expiration is controlled in the console
# ONE_MONTH_FROM_NOW=$(date -d "`date +%Y%m%d` +3 months" +"%Y-%m-%dT%H:%M:%SZ")

pg_dump -h localhost -U jira jira | gzip | ~/.local/bin/aws s3 cp - s3://$BUCKET/jira/temp/$DB_DUMP
tar -cv /var/atlassian/application-data/jira/data | gzip | ~/.local/bin/aws s3 cp - s3://$BUCKET/jira/temp/$DATA_DIR_ZIP

