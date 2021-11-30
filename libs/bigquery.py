from google.cloud import bigquery

BQ_CLIENT = bigquery.Client()

def get(query: str) -> list[dict]:
    return [dict(row.items()) for row in BQ_CLIENT.query(query).result()]
