#DELETE FROM `spry-compound-139714.Reports_Svod.Daily_Campaign3_Result` WHERE true
#INSERT INTO `spry-compound-139714.Reports_Svod.Daily_Campaign3_Result`  ( medium, source, device_cat, ses_region, campaign, date, hostname, ses_type, traffic, transactionId, order_source, revenue, cost, ses_time, pages, bounces, if_detail_products, if_add_products, if_qty_step_1)
--type_ses,type_ad

SELECT
  medium,
  ses.source source,
  ses.device_cat device_cat,
  ses.ses_region AS ses_region,
  ses.campaign,
  date,
  hostname,
  case when campaign like '%brand_poisk%' or (campaign like '%brand%' and campaign like '%search%') then 'Брендовые Поиск'
                when campaign like '%category%' and (campaign like '%poisk%' or campaign like '%search%') then 'Категории Поиск'
                when campaign like '%category%' and campaign like '%rsya%'  then 'Категории РСЯ'
                when campaign like '%vendor%' and (campaign like '%poisk%' or campaign like '%search%') then 'Вендоры Поиск' 
                when campaign like '%remarketing%' or campaign like '%retageting%' then 'Ремаркетинг'
                when campaign like '%vendor%' and campaign like '%rsya%'  then 'Вендоры РСЯ'
                when campaign like '%display%'  then 'КМС'
                when campaign like '%merchant%' then 'Торговая'
                when source='criteo' then 'Ремаркетинг'
                else 'other' end type_ad,
  type as type_traffic,
  COUNT(ses.sessionid) traffic,
  transactionId,
  null order_source,
  SUM(transactionRevenue) revenue,
  cast(SUM(AdCost) as int64) cost,
  SUM(IF(time >1800, 1800, time)) ses_time,
  sum(count_pages) pages,
  sum(IF(count_pages <2 and time<15, 1, 0)) as bounces,
  sum(if (qty_detail_products>0,1,0)) if_detail_products,
  sum(if (qty_add_products>0,1,0)) if_add_products,
  sum(if (qty_step_1>0,1,0)) if_qty_step_1
FROM (SELECT
    case when clientid is null then "agr_sessionid" else ses.sessionid end sessionId,
    type,
    date,
     case when device_cat not in ('desktop','mobile','tablet') then 'desktop' else device_cat end device_cat,
    CASE
      WHEN tmp5.region IS NOT NULL THEN tmp5.region_new
      ELSE 'Other_Regions'
    END ses_region,
    CASE
      WHEN tmp3.source_new IS NOT NULL THEN tmp3.source_new
      WHEN tmp4.source_new IS NOT NULL THEN tmp4.source_new
      ELSE ses.source
    END source,
    CASE
      WHEN tmp3.campaign_new IS NOT NULL THEN tmp3.campaign_new
      ELSE ses.campaign
    END campaign,
    CASE
      WHEN tmp2.medium_new IS NULL THEN ses.medium
      ELSE tmp2.medium_new
    END medium,
    max( hostname) as hostname,
    ses.order_id transactionId,
    #tmp10.order_id as order_id,
    ses.transactionRevenue transactionRevenue,
    round(MAX(ses.Adcost), 2) AdCost,
    session_time as time,
    max(count_pages) AS count_pages,
    IF(max(count_pages) <2 and max(session_time)<15, 1, 0) as bounces,
    max(qty_detail_products) AS qty_detail_products,
    max(qty_add_products) qty_add_products,
    max(qty_step_1) qty_step_1   
    
    
  FROM `vipavenue-6f9d1.Reports_Reg.Daily_Session` ses
        
   

  LEFT JOIN (SELECT * FROM `vipavenue-6f9d1`.`Dictionary.campaign_old_new` ) tmp
  ON   tmp.medium=ses.medium  AND tmp.source=ses.source   AND tmp.campaign_old=ses.campaign
  LEFT JOIN (SELECT * FROM `vipavenue-6f9d1`.`Dictionary.medium_old_medium_new` ) tmp2
  ON   tmp2.medium_old=ses.medium
  LEFT JOIN (SELECT * FROM `vipavenue-6f9d1`.`Dictionary.source_old_campaign_new` ) tmp3
  ON   tmp3.source_old=ses.source
  LEFT JOIN (SELECT * FROM `vipavenue-6f9d1`.`Dictionary.source_old_source_new` ) tmp4
  ON   tmp4.source_old=ses.source
  LEFT JOIN (SELECT region, region_new FROM `vipavenue-6f9d1`.`Dictionary.Regions` ) tmp5
  ON tmp5.region=ses.region

WHERE date >= '2021-05-28' #DATE_SUB(CURRENT_DATE, INTERVAL 6 day)

  GROUP BY
    clientid, sessionId, date, device_cat, ses_region, source, campaign, medium, transactionId, order_id, transactionRevenue, type, session_time) ses
    GROUP BY
    medium,  source, device_cat, ses_region, campaign, date, hostname, transactionId, order_source, type_traffic, type_ad
  ORDER BY
   6,
   9 DESC
