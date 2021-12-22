/* CreateDate: 05/03/2010 12:17:24.180 , ModifyDate: 09/16/2019 09:33:49.903 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [bief_dds].[DDS_DimDate_FiscalWeek] (@date as datetime)
returns int
as
begin
  declare @year int, @cyear char(4), @fiscal_start_date datetime, @fiscal_week int

  set @year = datepart(yyyy, @date)
  set @cyear = convert(varchar, @year)

  -- Fiscal year starts on July 1.
  if @date >= convert(datetime, convert(varchar,@year)+'-07-01') -- after 7/1
    set @fiscal_start_date = convert(datetime, @cyear+'-07-01')
  else -- before 7/1
    set @fiscal_start_date = convert(datetime, convert(varchar,@year-1)+'-07-01')

  set @fiscal_week = ceiling((datediff(d, @fiscal_start_date, @date)+1)/7.0)
  if @fiscal_week = 53 set @fiscal_week = 52 -- for 8/31, last day in fiscal year

  return @fiscal_week
end
GO
