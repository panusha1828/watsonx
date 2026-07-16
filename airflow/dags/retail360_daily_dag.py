"""
retail360_daily_dag.py

Nightly orchestration DAG for the Retail360 Analytics platform.

Flow:
  1. Wait for Snowpipe to finish loading the day's files (sensor on RAW row counts)
  2. Run dbt seed (idempotent, cheap - keeps CI-parity seeds fresh in prod too)
  3. Run dbt run (staging -> intermediate -> marts)
  4. Run dbt test
  5. Trigger Power BI dataset refresh
  6. Alert on any failure via Slack

Owner: Data Engineering
"""

from datetime import datetime, timedelta

from airflow.decorators import dag, task
from airflow.providers.snowflake.hooks.snowflake import SnowflakeHook
from airflow.providers.slack.notifications.slack import send_slack_notification

DEFAULT_ARGS = {
    "owner": "data-engineering",
    "retries": 2,
    "retry_delay": timedelta(minutes=5),
}

SNOWFLAKE_CONN_ID = "snowflake_retail360"
DBT_PROJECT_DIR = "/opt/dbt/retail360_analytics"


def on_failure_alert(context):
    send_slack_notification(
        slack_conn_id="slack_data_eng_alerts",
        text=f":red_circle: retail360_daily_dag failed: task {context['task_instance'].task_id}",
    )(context)


@dag(
    dag_id="retail360_daily",
    description="Nightly dbt run for Retail360 Analytics (RAW -> STAGING -> INTERMEDIATE -> MARTS)",
    schedule="0 2 * * *",
    start_date=datetime(2025, 1, 1),
    catchup=False,
    default_args=DEFAULT_ARGS,
    on_failure_callback=on_failure_alert,
    tags=["retail360", "dbt", "production"],
)
def retail360_daily():

    @task
    def check_raw_row_counts():
        """Sanity check that Snowpipe loaded data before we run dbt."""
        hook = SnowflakeHook(snowflake_conn_id=SNOWFLAKE_CONN_ID)
        result = hook.get_first(
            "select count(*) from raw.orders where _loaded_at >= dateadd(hour, -26, current_timestamp())"
        )
        row_count = result[0] if result else 0
        if row_count == 0:
            raise ValueError("No new rows landed in RAW.ORDERS in the last 26 hours - aborting run.")
        return row_count

    @task.bash
    def dbt_seed():
        return f"cd {DBT_PROJECT_DIR} && dbt seed --target prod"

    @task.bash
    def dbt_run():
        return f"cd {DBT_PROJECT_DIR} && dbt run --target prod"

    @task.bash
    def dbt_test():
        return f"cd {DBT_PROJECT_DIR} && dbt test --target prod"

    @task
    def trigger_powerbi_refresh():
        # TODO(R360-041): move Power BI refresh call to a proper Airflow
        # provider operator instead of this placeholder task.
        import requests

        # Placeholder - actual refresh triggered via Power BI REST API
        # using a service principal stored in Airflow connections.
        pass

    row_count = check_raw_row_counts()
    seed = dbt_seed()
    run = dbt_run()
    test = dbt_test()
    refresh = trigger_powerbi_refresh()

    row_count >> seed >> run >> test >> refresh


retail360_daily()
