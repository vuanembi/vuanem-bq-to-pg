 SELECT pp."PHONE_NUMBER" AS "PHONE",
    'NS_Sms'::text AS "TYPE",
    pp."SEND_TIME_DATETIME" AS "SEND_TIME",
    pp."COUPON_CODES" AS "COUPON_CODE",
    ''::text AS "CAMPAIGN_CARESOFT",
    pr.name AS "PROMOTION_NAME",
    date(pr.startdate) AS "PR_START_DATE",
    date(pr.enddate) AS "PR_END_DATE",
    pr.discounttype,
        CASE
            WHEN pr.discounttype::text = 'flat'::text THEN (pr.rate * 1.1::double precision)::integer::double precision
            ELSE pr.rate
        END AS discountrate,
    pr.promotiontype,
        CASE
            WHEN tp.transaction IS NOT NULL THEN 'Yes'::text
            ELSE 'No'::text
        END AS "REDEEM_STATUS",
    tp.transaction,
    s."TRANID",
    s."TRANDATE",
    sum(s."NET_AMOUNT") AS so
   FROM "NetSuite"."PROMOTION_SMS_INTEGRATION" pp
     LEFT JOIN "NetSuite"."ns2_couponCode" cc ON pp."COUPON_CODES"::text = cc.code::text
     LEFT JOIN "NetSuite"."ns2_promotionCode" pr ON pr.id = cc.promotion
     LEFT JOIN "NetSuite"."ns2_tranPromotion" tp ON tp.couponcode = cc.id
     LEFT JOIN "NetSuite"."NetSuite__SalesOrderLines" s ON tp.transaction = s."TRANSACTION_ID"
  GROUP BY pp."PHONE_NUMBER", 'NS_Sms'::text, pp."SEND_TIME_DATETIME", pp."COUPON_CODES", ''::text, pr.name, (date(pr.startdate)), (date(pr.enddate)), (
        CASE
            WHEN tp.transaction IS NOT NULL THEN 'Yes'::text
            ELSE 'No'::text
        END), s."TRANID", tp.transaction, s."TRANDATE", pr.discounttype, pr.rate, pr.promotiontype;
