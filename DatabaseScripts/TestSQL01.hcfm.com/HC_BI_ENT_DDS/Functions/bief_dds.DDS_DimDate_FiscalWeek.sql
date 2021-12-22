/* CreateDate: 05/03/2010 12:08:48.907 , ModifyDate: 02/11/2014 14:25:09.123 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
	02/11/2014 - MB - Changed function to return actual week as the fiscal week.  Fiscal period now mirrors the calendar.
*/

CREATE function [bief_dds].[DDS_DimDate_FiscalWeek] (@date as datetime)
returns int
as
begin
  declare @year int, @cyear char(4), @fiscal_start_date datetime, @fiscal_week int

  set @year = datepart(yyyy, @date)
  set @cyear = convert(varchar, @year)

  -- Fiscal year starts on July 1.
  --if @date >= convert(datetime, convert(varchar,@year)+'-07-01') -- after 7/1
  --  set @fiscal_start_date = convert(datetime, @cyear+'-07-01')
  --else -- before 7/1
  --  set @fiscal_start_date = convert(datetime, convert(varchar,@year-1)+'-07-01')

	set @fiscal_start_date = convert(datetime, @cyear+'-01-01')

  set @fiscal_week = ceiling((datediff(d, @fiscal_start_date, @date)+1)/7.0)
  if @fiscal_week = 53 set @fiscal_week = 52 -- for 8/31, last day in fiscal year

  return @fiscal_week
end
GO
