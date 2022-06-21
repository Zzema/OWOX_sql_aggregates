#delete from `project_name.dataset_name.Daily_Session` WHERE date>="2019-01-01" #Add project_name.dataset_name
INSERT INTO
  `project_name.dataset_name.Daily_Session` #Add project_name.dataset_name
  (sessionid,
  clientid,
  medium,
  source,
  campaign,
  device_cat,
  date,
  order_id,
  transactionRevenue,
  region,
  type_ip,
  user_id,
  owox_user_id,
  landing_page,
  device_ip,
  visit_number ,
  AdCost,
  hostname,
  session_time,
  time_start,
  count_pages,
  qty_detail_products,
  qty_add_products,
  qty_step_1
  )
SELECT    
    strim.sessionid sessionid,
    clientid,
    trafficsource.medium medium,
    trafficsource.source source,
    trafficsource.campaign campaign,
    strim.device.deviceCategory device_cat,       
    PARSE_DATE('%Y-%m-%d',  date) date,
    tr.transactionId order_id,
    tr.Revenue transactionRevenue,
     max(geonetwork.region)    region,
    case when max(hits.device.ip) IN ('192.168.1.1','192.168.1.2','192.168.1.3') then "Employees" #Allocating the ip address of employees
    # if you want to select bots separately, according to a certain criterion
    #when max(IF(hits.isEntrance=1 AND hits.pagePath='/',1,0))=1 and max(IF(hits.isExit=1 AND hits.pagePath='/personal/checkout/',1,0))=1 and max(trafficSource.source)='(direct)' and max(trafficSource.medium)='(none)' and max(totals.pageviews)=4 and max(strim.device.browser)='Chrome'
    #then "Боты"  
    else "Other" end type_ip,
    CAST(max(user.id) AS INT64) user_id,
    max(user.owoxid) owox_user_id,
    
    case when max(landingPage) is null then 
    max(    case when hits.isentrance=1 then 
    CASE
      WHEN STRPOS(hits.pagePath, 'utm')>0 THEN SUBSTR(hits.pagePath,0,STRPOS(hits.pagePath, 'utm')-2)
      WHEN STRPOS(hits.pagePath, '?q=')>0 THEN SUBSTR(hits.pagePath,0,STRPOS(hits.pagePath, '?q=')-1)
      WHEN STRPOS(hits.pagePath, 'sort=')>0 THEN SUBSTR(hits.pagePath,0,STRPOS(hits.pagePath, 'sort')-2)
      WHEN STRPOS(hits.pagePath, 'yclid')>0 THEN SUBSTR(hits.pagePath,0,STRPOS(hits.pagePath, 'yclid')-2)
      WHEN STRPOS(hits.pagePath, 'gclid=')>0 THEN SUBSTR(hits.pagePath,0,STRPOS(hits.pagePath, 'gclid')-2)
      WHEN STRPOS(hits.pagePath, '?_ga=')>0 THEN SUBSTR(hits.pagePath,0,STRPOS(hits.pagePath, '?_ga')-2)
      WHEN STRPOS(hits.pagePath, 'filter')>0 THEN hits.pagePath
    ELSE
    hits.pagePath end
    else null end)
    else max(landingPage) end 
    landingPage,
    max(hits.device.ip) device_ip,
    max(visitNumber) visit_number,
    case when ROW_NUMBER() OVER(PARTITION BY strim.sessionid 
                                 ORDER BY strim.sessionid ) =1 then MAX(trafficSource.attributedAdCost)*1.2 else 0 end AdCost, # 1.2 - НДС к расходам 20%
    max( hits.page.hostname) as hostname,
    max(hits.time)-min(hits.time) as session_time,
    min(hits.time) as time_start,
    max( totals.pageviews ) AS count_pages,
    sum(IF(hits.eCommerceAction.action_type='detail', 1, 0)) AS qty_detail_products,
    sum(if (hits.eCommerceAction.action_type='add', 1, 0)) qty_add_products,
    sum(IF(hits.eCommerceAction.action_type='checkout' and hits.eCommerceAction.step=1, 1, 0)) qty_step_1 #And others_steps if You have
  FROM
    `project_name.OWOXBI_Streaming.owoxbi_sessions_*` strim,  #Add project_name
    UNNEST(hits) AS hits
    left join(
#исключаю дублирование транзакций и объединяю с расчетом revenue
select transactionId,min(sessionid)sessionid, min(revenue) Revenue#, count(sessionid) 
from(
SELECT 
    CASE
      WHEN clientid IS NULL THEN "agr_sessionid"
    ELSE
    sessionid
  END
    sessionId,
    hits.transaction.transactionId transactionId,date,min(hits.time),
    SUM(product.productPrice*product.productQuantity) Revenue
  FROM
    `project_name.OWOXBI_Streaming.owoxbi_sessions_*`,
    UNNEST(hits) AS hits,  UNNEST (hits.product) AS product
  WHERE
    _TABLE_SUFFIX BETWEEN FORMAT_DATE("%Y%m%d",DATE_SUB(CURRENT_DATE, INTERVAL 6 day)) #"2021-02-01") 
    AND FORMAT_DATE("%Y%m%d",DATE_SUB(CURRENT_DATE, INTERVAL 1 day))                   # "2021-02-06") 
    AND hits.transaction.transactionId IS NOT NULL
  GROUP BY
    1,2,3
    order by 1)    group by 1
) tr
  on tr.sessionId=strim.sessionId
  WHERE
    _TABLE_SUFFIX BETWEEN FORMAT_DATE("%Y%m%d",DATE_SUB(CURRENT_DATE, INTERVAL 6 day)) #"2021-02-01") 
    AND FORMAT_DATE("%Y%m%d", DATE_SUB(CURRENT_DATE, INTERVAL 1 day)) #"2021-02-06") 

  GROUP BY
    1,    2,    3,4,5,6,7,8,9
    order by 9 desc
