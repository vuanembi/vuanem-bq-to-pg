from typing import Callable
from libs.bigquery import get
from libs.pg import get_connection, copy

Pipeline = Callable[[], dict]


def bq_to_pg(schema: str) -> Callable[[str, str], Pipeline]:
    def run(query: str, table: str) -> Pipeline:
        def _run():
            data = get(query)
            with get_connection() as conn:
                with conn.cursor() as cur:
                    results = copy(schema, table, cur, data)
            return {
                "table": table,
                "output_rows": results.rowcount,
            }

        return _run

    return run


netsuite = bq_to_pg("NetSuite")
caresoft = bq_to_pg("Caresoft")

netsuite__classes = netsuite(
    f"SELECT * FROM OP_CDP.NetSuite__CLASSES",
    "NetSuite__CLASSES",
)
netsuite__customers3 = netsuite(
    f"SELECT * FROM OP_CDP.NetSuite__CUSTOMERS3",
    "NetSuite__CUSTOMERS3",
)
netsuite__items = netsuite(
    f"SELECT * FROM OP_CDP.NetSuite__ITEMS",
    "NetSuite__ITEMS",
)
netsuite__leads_logged = netsuite(
    f"SELECT * FROM OP_CDP.NetSuite__LEADS_LOGGED",
    "NetSuite__LEADS_LOGGED",
)
netsuite__locations = netsuite(
    f"SELECT * FROM OP_CDP.NetSuite__LOCATIONS",
    "NetSuite__LOCATIONS",
)
netsuite__rfm = netsuite(
    f"SELECT * FROM OP_CDP.NetSuite__RFM",
    "NetSuite__RFM",
)
netsuite__rfm_cx = netsuite(
    f"SELECT * FROM OP_CDP.NetSuite__RFM_CX",
    "NetSuite__RFM_CX",
)
caresoft_leads_telesales = caresoft(
    f"SELECT * FROM OP_CDP.CDP__LEADS_TELESALES",
    "CDP__LEADS_TELESALES",
)
caresoft_leads_telesales_source = caresoft(
    f"SELECT * FROM OP_CDP.CDP_LEADS_TELESALES_SOURCE",
    "CDP_LEADS_TELESALES_SOURCE",
)
caresoft_leads_tele_c2c = caresoft(
    f"""
    SELECT
        ticket_id,
        updated_at,
        created_at,
        Lead_type,
        TO_JSON_STRING(requester) AS requester,
        TO_JSON_STRING(ccs) AS ccs,
        TO_JSON_STRING(follows) AS follows,
        TO_JSON_STRING(comments) AS comments,
    FROM OP_CDP.CDP_LEADS_TELE_C2C
    """,
    "CDP_LEADS_TELE_C2C",
)
caresoft_leads_tele_coldlead = caresoft(
    f"""
    SELECT
        ticket_id,
        updated_at,
        created_at,
        Lead_type,
        customer_phone,
        customer_email,
        customer_name,
        TO_JSON_STRING(ccs) AS ccs,
        TO_JSON_STRING(follows) AS follows,
        TO_JSON_STRING(comments) AS comments,
        campaign_name,
    FROM OP_CDP.CDP_LEADS_TELE_COLDLEAD
    """,
    "CDP_LEADS_TELE_COLDLEAD",
)

netsuite__sales_order_lines = netsuite(
    f"SELECT * FROM OP_CDP.NetSuite__SalesOrderLines",
    "NetSuite__SalesOrderLines",
)
