drop table if exists train_new_sample;
select *
into train_new_sample
from
	train_new
where srch_id <= 100

/*
select count(*) from train_new_sample
select * from train_new_sample limit 100
*/