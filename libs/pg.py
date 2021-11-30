import os
import io
import csv

import psycopg2


def get_connection() -> psycopg2.connection:
    return psycopg2.connect(
        host=os.getenv("PG_HOST"),
        dbname="postgres",
        user=os.getenv("PG_UID"),
        password=os.getenv("PG_PWD"),
    )


def dump_csv(rows: list[dict], columns: list[str]) -> io.StringIO:
    output_io = io.StringIO()
    csv_writer = csv.DictWriter(output_io, columns)
    csv_writer.writeheader()
    csv_writer.writerows(rows)
    output_io.seek(0)
    return output_io


def copy(
    schema: str,
    table: str,
    cur: psycopg2.cursor,
    rows: list[dict],
) -> psycopg2.cursor:
    columns = [i for i in rows[0].keys()]
    column_names = ",".join(columns)
    copy_stmt = f'COPY "{schema}"."{table}" ({column_names}) FROM STDIN WITH (FORMAT CSV, HEADER TRUE)'
    cur.copy_expert(copy_stmt, dump_csv(rows, columns))
    return cur
