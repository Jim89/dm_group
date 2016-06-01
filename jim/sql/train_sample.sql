drop table if exists train_sample;
select * 
into train_sample
from 
	train 
where random() < 0.03
limit 0.03*37670293;

/*
select * from train_sample
select count(*) from train_sample;
select 0.03*37670293

*/