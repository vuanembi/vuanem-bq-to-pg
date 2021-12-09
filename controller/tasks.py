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
    "caresoft_leads_tele_c2c",
    "caresoft_leads_tele_coldlead",
    "netsuite__sales_order_lines",
]


def create_tasks():
    return {
        "task": create(TABLES),
    }
