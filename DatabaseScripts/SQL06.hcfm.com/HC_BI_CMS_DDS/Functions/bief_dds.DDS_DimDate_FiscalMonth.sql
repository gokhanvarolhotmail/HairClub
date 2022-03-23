/* CreateDate: 03/17/2022 11:57:10.087 , ModifyDate: 03/17/2022 11:57:10.087 */
GO
create function [bief_dds].[DDS_DimDate_FiscalMonth] (@date as datetime)
returns int
as
begin
	declare @fiscal_month int, @year int, @month int

	set @month = datepart(m, @date)
	set @year = datepart(yyyy, @date)

    -- Fiscal year starts on July 1.
    -- This will be different for each starting month
    -- if Jan 1 is start then between 1 and 1   +0 and -0
    -- if Feb 1 is start then between 1 and 1   +11 and -1
    -- if Mar 1 is start then between 1 and 2   +10 and -2
    -- if Apr 1 is start then between 1 and 3   +9 and -3
    -- if May 1 is start then between 1 and 4   +8 and -4
    -- if Jun 1 is start then between 1 and 5   +7 and -5
    -- if Jul 1 is start then between 1 and 6   +6 and -6
    -- if Aug 1 is start then between 1 and 7   +5 and -7
    -- if Sep 1 is start then between 1 and 8   +4 and -8
    -- if Oct 1 is start then between 1 and 9   +3 and -9
    -- if Nov 1 is start then between 1 and 10  +2 and -10
    -- if Dec 1 is start then between 1 and 11  +1 and -11

	if @month between 1 and 6 set @fiscal_month = @month + 6
	else set @fiscal_month = @month - 6


  return @fiscal_month
end
GO
