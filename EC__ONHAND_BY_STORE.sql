 SELECT "left"(l."STORE_NAME"::text, 5) AS store_code,
    c."PRODUCT_CODE" AS sku,
    sum(i."ON_HAND_COUNT") AS on_hand_count
   FROM "NetSuite"."ITEM_LOCATION_MAP" i
     LEFT JOIN "NetSuite"."LOCATIONS" l ON i."LOCATION_ID" = l."LOCATION_ID"
     LEFT JOIN "NetSuite"."ITEMS" c ON c."ITEM_ID" = i."ITEM_ID"
  WHERE i."ON_HAND_COUNT" > 0
  GROUP BY ("left"(l."STORE_NAME"::text, 5)), c."PRODUCT_CODE";
