import importlib

from models.tables import Pipeline


def factory(table: str) -> Pipeline:
    try:
        return getattr(importlib.import_module(f"models.tables"), table)
    except (ImportError, AttributeError):
        raise ValueError(table)


def run(pipeline: Pipeline) -> dict:
    return pipeline()
