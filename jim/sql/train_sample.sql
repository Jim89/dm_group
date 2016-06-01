drop table if exists train_sample;
select * 
into train_sample
from 
	train 
where random() < 0.01 
limit 0.1*37670293;

/*
select * from train_sample
select count(*) from train_sample;
*/