# OWOX_sql_aggregates
SQL templates for aggregate tables

<h2>Daily_session structure:</h2>

|    | Field name          | Type       | Mode     | Description                                                                                                                                                                                                                                                               |
|----|---------------------|------------|----------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1  | sessionid           | STRING     | NULLABLE | An identifier for this session. Formed from the clientId and timestamp values.                                                                                                                                                                                            |
| 2  | clientid            | STRING     | NULLABLE | This anonymously identifies a particular user, device, or browser instance. For the web, this is generally stored as a first-party cookie with a two-year expiration. For mobile apps, this is randomly generated for each particular instance of an application install. |
| 3  | medium              | STRING     | NULLABLE | The medium of the traffic source from the utm_medium URL parameter. Could be "organic", "cpc", "referral" etc.                                                                                                                                                            |
| 4  | source              | STRING     | NULLABLE | The source of the traffic source. Could be the name of the search engine, the referring hostname, or a value of the utm_source URL parameter.                                                                                                                             |
| 5  | campaign            | STRING     | NULLABLE | The campaign value. Usually set by the utm_campaign URL parameter.                                                                                                                                                                                                        |
| 6  | device_cat          | STRING     | NULLABLE | Desktop/Mobile/Tablet/Other in https://support.owox.com/hc/en-us/articles/360036638274                                                                                                                                                                                    |
| 7  | date                | DATE       | NULLABLE | date                                                                                                                                                                                                                                                                      |
| 8  | order_id            | STRING     | NULLABLE | If We have transaction, here we have transaction_id                                                                                                                                                                                                                       |
| 9  | transactionRevenue  | FLOAT      | NULLABLE | Revenue of transaction                                                                                                                                                                                                                                                    |
| 10 | region              | STRING     | NULLABLE | The region from which sessions originate, derived from IP addresses                                                                                                                                                                                                       |
| 11 | type_ip             | STRING     | NULLABLE | employee ip/ bots/ other sessions for filter                                                                                                                                                                                                                              |
| 12 | user_id             | BIGNUMERIC | NULLABLE | Overridden User ID                                                                                                                                                                                                                                                        |
| 13 | owox_user_id        | STRING     | NULLABLE | Additional user identifier that lets you track audience overlapping across domains without sending the Client ID parameter.                                                                                                                                               |
| 14 | landing_page        | STRING     | NULLABLE | A URL address of the first hit in the session without any query parameters such as UTM tags. This field helps unite the same landing pages from the sessions with different sources.                                                                                      |
| 15 | device_ip           | STRING     | NULLABLE | ip address                                                                                                                                                                                                                                                                |
| 16 | visit_number        | INTEGER    | NULLABLE | The session number for this user. If this is the first session, then this is set to 1                                                                                                                                                                                     |
| 17 | AdCost              | FLOAT      | NULLABLE | When one or more tags are unknown, the total session cost is attributed evenly between the sessions according to the known tags                                                                                                                                           |
| 18 | hostname            | STRING     | NULLABLE | The hostname of the URL                                                                                                                                                                                                                                                   |
| 19 | session_time        | INTEGER    | NULLABLE | max(hits.time)-min(hits.time)                                                                                                                                                                                                                                             |
| 20 | time_start          | INTEGER    | NULLABLE |                                                                                                                                                                                                                                                                           |
| 21 | count_pages         | INTEGER    | NULLABLE | qty of pageviews                                                                                                                                                                                                                                                          |
| 22 | qty_detail_products | INTEGER    | NULLABLE | count views of product page (hits.eCommerceAction.action_type='detail' )                                                                                                                                                                                                  |
| 23 | qty_add_products    | INTEGER    | NULLABLE | count products add to cart (hits.eCommerceAction.action_type='add')                                                                                                                                                                                                       |
| 24 | qty_step_1          | INTEGER    | NULLABLE | first step of ckeckout (hits.eCommerceAction.action_type='checkout' and hits.eCommerceAction.step=1)                                                                                                                                                                      |
<h2>Daily_Result structure:</h2>
|    | Field name         | Type    | Description |
|----|--------------------|---------|-------------|
| 1  | medium             | STRING  |             |
| 2  | source             | STRING  |             |
| 3  | device_cat         | STRING  |             |
| 4  | ses_region         | STRING  |             |
| 5  | campaign           | STRING  |             |
| 6  | date               | DATE    |             |
| 7  | hostname           | STRING  |             |
| 8  | type_ad            | STRING  |             |
| 9  | type_traffic       | STRING  |             |
| 10 | traffic            | INTEGER |             |
| 11 | transactionId      | STRING  |             |
| 12 | order_source       | INTEGER |             |
| 13 | revenue            | FLOAT   |             |
| 14 | cost               | INTEGER |             |
| 15 | ses_time           | INTEGER |             |
| 16 | pages              | INTEGER |             |
| 17 | bounces            | INTEGER |             |
| 18 | if_detail_products | INTEGER |             |
| 19 | if_add_products    | INTEGER |             |
| 20 | if_qty_step_1      | INTEGER |             |
