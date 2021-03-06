import os
import json
import uuid

from google.cloud import tasks_v2
from google.protobuf.duration_pb2 import Duration
from google import auth

_, PROJECT_ID = auth.default()
TASKS_CLIENT = tasks_v2.CloudTasksClient()


def create(payloads: list[str]) -> int:
    task_paths = (PROJECT_ID, "asia-southeast2", "bq-to-pg")
    tasks = [
        {
            "name": TASKS_CLIENT.task_path(
                *task_paths, task=f"{payload}-{uuid.uuid4()}"
            ),
            "dispatch_deadline": Duration().FromSeconds(530),  # type: ignore
            "http_request": {
                "http_method": tasks_v2.HttpMethod.POST,
                "url": os.getenv("PUBLIC_URL"),
                "oidc_token": {
                    "service_account_email": os.getenv("GCP_SA"),
                },
                "headers": {
                    "Content-type": "application/json",
                },
                "body": json.dumps({"table": payload}).encode(),
            },
        }
        for payload in payloads
    ]
    return len(
        [
            TASKS_CLIENT.create_task(
                request={
                    "parent": TASKS_CLIENT.queue_path(*task_paths),
                    "task": task,
                }
            )
            for task in tasks
        ]
    )
