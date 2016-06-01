drop table if exists train;
create table train (
date_time 	text
,site_name 	int
,posa_continent 	int
,user_location_country 	int
,user_location_region 	int
,user_location_city 	int
,orig_destination_distance 	float
,user_id 	int
,is_mobile 	int
,is_package 	int
,channel 	int
,srch_ci 	text
,srch_co 	text
,srch_adults_cnt int
,srch_children_cnt int
,srch_rm_cnt 	int
,srch_destination_id 	int
,srch_destination_type_id 	int
,hotel_continent 	int
,hotel_country 	int
,hotel_market 	int
,is_booking 	int
,cnt 	bigint
,hotel_cluster 	int
)

COPY train
FROM
	'C:\Users\Jleach1\Documents\icl\dm\data\train.csv'
WITH CSV HEADER