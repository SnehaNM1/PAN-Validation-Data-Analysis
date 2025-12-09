-- Create table
create table Pan_tb(
	PAN_NUMBERS TEXT
);

-- List all tables in the current database
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE';

select * from Pan_tb;

-- Data Cleaning
-- NULL Values
select * from Pan_tb 
where pan_numbers IS NULL

-- Duplicates
select pan_numbers , count(*) from
pan_tb group by pan_numbers having count(*)>1

-- Handle leading/trailing spaces
select * from pan_tb
where pan_numbers <> trim(pan_numbers)

-- Correct letter case
select * from pan_tb
where pan_numbers <> upper(pan_numbers)

-- Cleaned PAN Numbers
select DISTINCT upper(trim(pan_numbers)) from Pan_tb 
where pan_numbers IS NOT NULL
AND trim(pan_numbers) <>''

-- PAN Format Validation
-- User Defined Function
-- TO Check the adjacent values
CREATE OR REPLACE FUNCTION fn_adjacent_char(p_str text)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
	BEGIN
		-- function logic
		for i in 1 .. (length(p_str)-1)
		loop
			if substring(p_str, i , 1) = substring(p_str, i+1 , 1)
			then 
			return TRUE;
			end if;
		end loop;
RETURN FALSE;

END;
$$

select fn_adjacent_char('ZZWER') 

-- Function to check sequence
CREATE OR REPLACE FUNCTION fn_sequence_char(p_str text)
RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
	BEGIN
		-- function logic
		for i in 1 .. (length(p_str)-1)
		loop
			if ascii(substring(p_str, i+1 , 1)) -ascii(substring(p_str, i , 1)) <>1
			then 
			return FALSE;
			end if;
		end loop;
RETURN TRUE;

END;
$$

select fn_sequence_char('ABCD')

-- Regular expression to check the format/structure of the PAN - ABCDX3245O
select * from pan_tb
where pan_numbers ~ '^[A-Z]{5}[0-9]{4}[A-Z]{1}$'

-- Validate the PAN numbers
create or replace view view_pans as(
		with cleaned_pan as (
				select DISTINCT upper(trim(pan_numbers)) as pan_numbers from Pan_tb 
				where pan_numbers IS NOT NULL
				AND trim(pan_numbers) <>''
		),
			valid_pan as (
							select * from cleaned_pan
							where fn_adjacent_char(pan_numbers) = FALSE
							AND fn_sequence_char(substring(pan_numbers,1,5)) = FALSE
							AND fn_sequence_char(substring(pan_numbers,6,4)) = FALSE
							AND pan_numbers ~ '^[A-Z]{5}[0-9]{4}[A-Z]{1}$'
							)
		select cln.pan_numbers,
			case when vld.pan_numbers IS NOT NULL
			then 'VALID'
			else 'IN VALID'
			END as status
		from 
		cleaned_pan cln
		LEFT JOIN valid_pan vld ON cln.pan_numbers = vld.pan_numbers
)

-- Summary
select count(*)filter (where status = 'VALID') as Total_Valid_PAN,
		count(*)filter (where status = 'IN VALID') as Total_Invalid_PAN
from view_pans
