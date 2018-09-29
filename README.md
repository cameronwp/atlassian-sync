# Sync Atlassian server files with s3

See [Jira backup suggestions](https://confluence.atlassian.com/adminjiraserver071/backing-up-data-802592964.html) and [Confluence backup suggestions](https://confluence.atlassian.com/doc/production-backup-strategy-38797389.html)

Copies all files needed to restore Jira and Confluence. Files are saved to a "temporary" location and a "latest" location. Recommend setting s3 settings so that any files with a `temp` prefix expire at some later date to avoid being charged for storing old files. But the latest version should never disappear, so `sync_latest.sh` will move a "temp" file to a non-temp location to avoid expiration. Technically, you should be able to do this with the `--expires` flag, but in testing the flag did not seem to have an effect (and I gave up trying after about 5 mins because you can just as easily use the s3 console to get the same effect).

## Dependencies

* `pg_dump` (part of the `postgres-client` package)
  * use a `.pgpass` file to store db creds
* awscli - [instructions](https://docs.aws.amazon.com/cli/latest/userguide/installing.html)
  * make sure to `aws configure` with creds for a user who can access s3

## Usage

Make sure you replace `[BUCKET]` in the scripts with the name of your s3 bucket.

The easiest thing to do is move these scripts to a crontab.

1. Copy files to a location like `/etc/cron.d/`
2. `crontab -e`

Current crontab configuration:

```sh
00 01 * * * /etc/cron.d/sync_jira.sh
00 01 * * * /etc/cron.d/sync_confluence.sh
# wait a bit to make sure s3 has the newest uploads before trying to copy them
00 02 * * * /etc/cron.d/sync_latest.sh
```

These scripts are set to run at 1am, 1am, and 2am.

## Troubleshooting

If you cannot read the Jira and Confluence home dirs, make sure they have the right permissions. See [here](https://confluence.atlassian.com/jirakb/how-to-fix-jira-directories-permission-in-linux-829048437.html). You may(?) need to add yourself to the `jira` and `confluence` groups? Maybe?

