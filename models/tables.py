from libs.bigquery import get
from libs.pg import get_connection, copy

def bq_to_pg(query, schema, table):
    data = get(query)
    with get_connection() as conn:
        with conn.cursor() as cur:
            results = copy(schema, table, cur, data)
    results

