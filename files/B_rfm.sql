/* Drop tables if they exist to prevent errors *********/
drop table if exists r_scores, f_scores, m_scores, rfm_scores;

/* Create r-scores */
select
	 *
	,ntile(5) OVER(order by age) as r
into r_scores	
from
(
	select
		 cust_id
		,most_recent
		,(cast('2008-01-01' as date) - most_recent) as age
	from
	(
		select
			 cust_id
			,max(order_date) as most_recent
		from
			lines_clean
		group by
			cust_id
	)_	
)_
;

/*
select * from r_scores
where cust_id = '56124323'
*/

/* Create f-scores */
select
	 *
	,ntile(5) over(order by orders desc) as f
into f_scores
from
(
	select 
		 cust_id
		,count(distinct ordernum) as orders
	from
		lines_clean
	group by 
		cust_id
)_;		
/*
select * from f_scores
where cust_id = '56124323'
*/

/* create m-scores */
select
	 *
	,ntile(5) over (order by avg_order_val desc) as m
into m_scores
from
(	
	select
		 cust_id
		,avg(order_val) as avg_order_val
	from
	(
		select
			 cust_id
			,ordernum
			,sum(line_dollars) as order_val
		from
			lines_clean
		group by
			 cust_id
			,ordernum
	)_
	group by
		cust_id
)_;
/*
select * from m_scores
where cust_id = '56124323'
*/		

select
	 bk.cust_id
	,bk.r
	,lk.f
	,lk2.m
	,(cast(bk.r as text) || lk.f || lk2.m) as rfm
into rfm_scores
from
	r_scores bk
left join
	f_scores lk
on bk.cust_id = lk.cust_id
left join
	m_scores lk2
on bk.cust_id = lk2.cust_id;

/*
select * from rfm_scores
*/



