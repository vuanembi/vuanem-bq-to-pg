 WITH product_group AS (
         SELECT c."CLASS_ID",
                CASE
                    WHEN c."CLASS_ID" = 1307 OR c."FULL_NAME"::text ~~ '11-Mattress/ Đệm%'::text THEN '11-Mattress/ Đệm'::character varying
                    WHEN c."CLASS_ID" = 1344 OR c."FULL_NAME"::text ~~ '12-Bed Linen%'::text THEN '12-Bed Linen/Chăn ga'::character varying
                    WHEN (c."CLASS_ID" = ANY (ARRAY[1244, 1262, 1261, 1246, 1226, 508, 514, 2031, 2035])) OR c."FULL_NAME"::text ~~ '13-Accessories%'::text THEN '13-Accessories/ Phụ kiện'::character varying
                    WHEN c."FULL_NAME"::text ~~ '6-Bed frame%'::text OR c."FULL_NAME"::text ~~ '14-Bed Frame%'::text THEN '14-Bed Frame/ Giường'::character varying
                    WHEN c."FULL_NAME"::text ~~ '5-Raw Material%'::text OR c."FULL_NAME"::text ~~ '15-Raw Material%'::text THEN '15-Raw Material/Nguyên vật liệu'::character varying
                    WHEN c."FULL_NAME"::text ~~ '4-Furniture%'::text OR c."FULL_NAME"::text ~~ '16-Furniture%'::text THEN
                    CASE
                        WHEN c."CLASS_ID" = ANY (ARRAY[1254, 1251, 1252, 128, 127, 129]) THEN '16-Furniture/ Nội thất'::text
                        ELSE '14-Bed Frame/ Giường'::text
                    END::character varying
                    ELSE c."FULL_NAME"
                END AS product_group
           FROM "NetSuite"."CLASSES" c
          WHERE c."ISINACTIVE"::text = 'No'::text
          ORDER BY c."CLASS_ID"
        )
 SELECT alltime."PRODUCT_CODE",
    alltime.product_group,
    alltime.net_amount,
    alltime.item_count,
    dense_rank() OVER (PARTITION BY alltime.product_group ORDER BY alltime.net_amount DESC) AS rank_
   FROM ( SELECT items."PRODUCT_CODE",
            p.product_group,
            - sum(transaction_lines."NET_AMOUNT") AS net_amount,
            - sum(transaction_lines."ITEM_COUNT") AS item_count
           FROM "NetSuite"."TRANSACTIONS" transactions
             JOIN "NetSuite"."TRANSACTION_LINES" transaction_lines ON transaction_lines."TRANSACTION_ID" = transactions."TRANSACTION_ID"
             JOIN "NetSuite"."ITEMS" items ON transaction_lines."ITEM_ID" = items."ITEM_ID"
             LEFT JOIN product_group p ON items."CLASS_ID" = p."CLASS_ID"
          WHERE transactions."TRANSACTION_TYPE"::text = 'Sales Order'::text AND date_part('day'::text, CURRENT_DATE::timestamp with time zone - transactions."TRANDATE") <= 3::double precision AND transactions."STATUS"::text <> 'Closed'::text AND transactions."TRANSACTION_NUMBER" IS NOT NULL AND items."DISPLAYNAME" IS NOT NULL AND (transaction_lines."ACCOUNT_ID" IN ( SELECT "ACCOUNTS"."ACCOUNT_ID"
                   FROM "NetSuite"."ACCOUNTS"
                  WHERE "ACCOUNTS"."HEADER_0"::text = 'Net Revenue'::text))
          GROUP BY items."PRODUCT_CODE", p.product_group) alltime
  WHERE alltime.net_amount > 0::numeric;
