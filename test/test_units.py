from unittest.mock import Mock

import pytest

from main import main
from controller.tasks import TABLES

def run(data):
    return main(Mock(get_json=Mock(return_value=data), args=data))

@pytest.mark.parametrize(
        "table",
        TABLES,
    )
def test_pipelines(table):
    res = run({
        "table": table,
    })
    assert res['output_rows'] > 0

def test_tasks():
    res = run({
        "task": "bq-to-pg",
    })
    assert res['task'] > 0
