/* Drop tables if they exist to prevent errors *********/
drop table if exists r_scores;

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
			lines
		group by
			cust_id
	)_	
)_

/*
select * from r_scores
*/	