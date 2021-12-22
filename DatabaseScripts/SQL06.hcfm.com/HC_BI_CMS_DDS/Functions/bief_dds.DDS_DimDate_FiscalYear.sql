create function [bief_dds].[DDS_DimDate_FiscalYear] (@date as datetime)
returns int
as
begin
	declare @fiscal_year int, @year int, @month int

	set @month = datepart(m, @date)
	set @year = datepart(yyyy, @date)

    -- Fiscal year starts on July 1.
    -- This will be different for each starting month
    -- if Apr 1 is start then between 1 and 3
    -- if Sep 1 is start then between 1 and 8
    -- if Nov 1 is start then between 1 and 10

	if @month between 1 and 6 set @fiscal_year = @year
	else set @fiscal_year = @year+1


  return @fiscal_year
end
