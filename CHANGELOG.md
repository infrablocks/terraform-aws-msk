## Unreleased

BACKWARDS INCOMPATIBILITIES / NOTES:

* This module is now compatible with Terraform 1.3 and higher.
* This module is now compatible with the AWS provider version 4.22 or greater.
* The `cloud_watch_logs_enabled` variable has been renamed to
  `enable_cloudwatch_logging`.
* The `log_group_name` variable has been renamed to
  `cloudwatch_logging_log_group_name`.
* The `firehose_enabled` variable has been renamed to `enable_firehose_logging`.
* The `firehose_stream_name` variable has been renamed to
  `firehose_logging_stream_name`.
* The `s3_logs_enabled` variable has been renamed to `enable_s3_logging`.
* The `s3_logs_prefix` variable has been renamed to `s3_logging_object_prefix`.
* The `s3_logs_bucket_name` variable has been renamed to
  `s3_logging_bucket_name`.
* The `include_default_ingress_rule` variable has been changed from a "yes"/"no"
  value to a boolean one.
* The `include_default_egress_rule` variable has been changed from a "yes"/"no"
  value to a boolean one.

## 0.1.0 (May 27th, 2021)

BACKWARDS INCOMPATIBILITIES / NOTES:

* This module is now compatible with Terraform 0.14 and higher.

## 0.0.1 (January 4th, 2020)

* First version