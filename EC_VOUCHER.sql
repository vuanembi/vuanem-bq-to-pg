 SELECT cc.code,
    cc.datesent,
    pc.startdate,
    pc.enddate,
    pc.name,
    pc.discounttype,
    pc.description,
    pc.lastmodifieddate AS promotion_lastmodifieddate,
    tp.lastmodifieddate AS tranpromotion_lastmodifieddate,
        CASE
            WHEN pc.discounttype::text = 'flat'::text THEN (pc.rate * 1.1::double precision)::integer::double precision
            ELSE pc.rate
        END AS discountrate,
        CASE
            WHEN tp.transaction IS NULL THEN 'No'::text
            ELSE 'Yes'::text
        END AS redeem_status
   FROM "NetSuite"."ns2_couponCode" cc
     JOIN "NetSuite"."ns2_promotionCode" pc ON pc.id = cc.promotion
     LEFT JOIN "NetSuite"."ns2_tranPromotion" tp ON tp.couponcode = cc.id;
