#!/bin/bash

# https://confluence.atlassian.com/doc/production-backup-strategy-38797389.html

DB_DUMP=$(date +db_%Y%m%d%H%M.gz)
ATTACHMENTS_DIR_ZIP=$(date +attachments_%Y%m%d%H%M.tar.gz)
CFG_ZIP=$(date +cfg_%Y%m%d%H%M.tar.gz)

# For whatever reason, ~/.local/bin/aws s3 is ignoring the --expires option. expiration is controlled in the console
# ONE_MONTH_FROM_NOW=$(date -d "`date +%Y%m%d` +3 months" +"%Y-%m-%dT%H:%M:%SZ")

pg_dump -h localhost -U jira confluence | gzip | ~/.local/bin/aws s3 cp - s3://[BUCKET]/confluence/temp/$DB_DUMP
tar -cv /var/atlassian/application-data/confluence/attachments | gzip | ~/.local/bin/aws s3 cp - s3://[BUCKET]/confluence/temp/$ATTACHMENTS_DIR_ZIP
cat /var/atlassian/application-data/confluence/confluence.cfg.xml | gzip | ~/.local/bin/aws s3 cp - s3://[BUCKET]/confluence/temp/$CFG_ZIP

