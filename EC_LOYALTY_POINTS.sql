SELECT
    l."CUSTOMER_ID",
    c."PHONE",
    g."LOYALTY_CUSTOMER_GROUP_NAME",
    sum(l."POINT_0") AS "POINT_0",
    max(l."EXPIRED_DATE") AS "EXPIRED_DATE"
FROM
    "NetSuite"."LOYALTY_TRANSACTION" l
    LEFT JOIN "NetSuite"."CUSTOMERS" c ON l."CUSTOMER_ID" = c."CUSTOMER_ID"
    LEFT JOIN "NetSuite"."LOYALTY_CUSTOMER_GROUP" g ON g."LOYALTY_CUSTOMER_GROUP_ID" = c."LOYALTY_GROUP_ID"
WHERE
    l."IS_INACTIVE" :: text = 'F' :: text
    AND NOT (
        l."LOYALTY_TRANSACTION_ID" IN (
            SELECT
                DISTINCT "DELETED_RECORDS"."RECORD_ID"
            FROM
                "NetSuite"."DELETED_RECORDS"
            WHERE
                "DELETED_RECORDS"."CUSTOM_RECORD_TYPE" :: text ~~ '%Loyalty%' :: text
                OR "DELETED_RECORDS"."CUSTOM_RECORD_TYPE" :: text ~~ '%Loyatly%' :: text
        )
    )
GROUP BY
    l."CUSTOMER_ID",
    c."PHONE",
    g."LOYALTY_CUSTOMER_GROUP_NAME";
