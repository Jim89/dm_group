/* Clean up tables as needed *********/
drop table if exists email_first_half, email_second_half, cat_first_half, cat_second_half;
select *
into email_first_half
from
	contacts_clean
where contact_type = 'E'
and contact_date <= '2006-06-30';

/*
select * from email_first_half
*/

select *
into email_second_half
from
	contacts_clean
where contact_type = 'E'
and contact_date > '2006-06-30';
/*
select * from email_second_half
*/


select *
into cat_first_half
from
	contacts_clean
where contact_type = 'C'
and contact_date <= '2006-06-30';
/*
select * from cat_first_half
*/

select *
into cat_second_half
from
	contacts_clean
where contact_type = 'C'
and contact_date > '2006-06-30';
/*
select * from cat_second_half
*/
