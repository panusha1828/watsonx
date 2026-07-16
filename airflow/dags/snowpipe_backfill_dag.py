"""
snowpipe_backfill_dag.py

Manually triggered DAG used to backfill Snowpipe loads when a pipe has been
paused or a batch of historical files needs to be (re)ingested. Not on a
schedule - triggered manually via the Airflow UI or CLI with a `file_prefix`
param.
"""

from datetime import datetime, timedelta

from airflow.decorators import dag, task
from airflow.models.param import Param
from airflow.providers.snowflake.hooks.snowflake import SnowflakeHook

DEFAULT_ARGS = {
    "owner": "data-engineering",
    "retries": 1,
    "retry_delay": timedelta(minutes=10),
}


@dag(
    dag_id="snowpipe_backfill",
    description="Manually-triggered backfill of a Snowpipe stage.",
    schedule=None,
    start_date=datetime(2025, 1, 1),
    catchup=False,
    default_args=DEFAULT_ARGS,
    params={
        "pipe_name": Param("ORDERS_PIPE", type="string"),
        "stage_name": Param("ORDERS_STAGE", type="string"),
    },
    tags=["retail360", "backfill", "manual"],
)
def snowpipe_backfill():

    @task
    def refresh_pipe(**context):
        pipe_name = context["params"]["pipe_name"]
        hook = SnowflakeHook(snowflake_conn_id="snowflake_retail360")
        hook.run(f"ALTER PIPE {pipe_name} REFRESH;")

    refresh_pipe()


snowpipe_backfill()
