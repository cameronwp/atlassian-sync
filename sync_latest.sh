#!/bin/bash

# copy newest files to latest position to avoid expiration

DB_DUMP=$(date +db_%Y%m%d%H%M.gz)
ATTACHMENTS_DIR_ZIP=$(date +attachments_%Y%m%d%H%M.tar.gz)
CFG_ZIP=$(date +cfg_%Y%m%d%H%M.tar.gz)
DATA_DIR_ZIP=$(date +data_%Y%m%d%H%M.tar.gz)

aws s3 cp s3://[BUCKET]/confluence/temp/$DB_DUMP s3://[BUCKET]/confluence/latest_db.gz
aws s3 cp s3://[BUCKET]/confluence/temp/$ATTACHMENTS_DIR_ZIP s3://[BUCKET]/confluence/latest_attachments.tar.gz
aws s3 cp s3://[BUCKET]/confluence/temp/$CFG_ZIP s3://[BUCKET]/confluence/latest_cfg.tar.gz
aws s3 cp s3://[BUCKET]/jira/temp/$DB_DUMP s3://[BUCKET]/jira/latest_db.gz
aws s3 cp s3://[BUCKET]/jira/temp/$DATA_DIR_ZIP s3://[BUCKET]/jira/latest_data.tar.gz

