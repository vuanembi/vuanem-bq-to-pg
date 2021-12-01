from libs.tasks import create

TABLES = [
    "netsuite__classes",
    "netsuite__customers3",
    "netsuite__items",
    "netsuite__leads_logged",
    "netsuite__locations",
    "netsuite__rfm",
    "netsuite__rfm_cx",
    "caresoft_leads_telesales",
    "caresoft_leads_telesales_source",
]


def create_tasks():
    return {
        "task": create(TABLES),
    }
