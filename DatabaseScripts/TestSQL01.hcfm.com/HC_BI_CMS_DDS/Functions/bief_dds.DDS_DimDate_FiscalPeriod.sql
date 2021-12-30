/* CreateDate: 05/03/2010 12:17:24.163 , ModifyDate: 09/16/2019 09:33:49.903 */
GO
CREATE function [bief_dds].[DDS_DimDate_FiscalPeriod] (@fiscal_week as int)
returns int
as
begin
  declare @fiscal_period int
  -- Determine fiscal period based on 454 454 454 454 pattern.
  if @fiscal_week >= 1 and @fiscal_week <= 4
    set @fiscal_period = 1
  if @fiscal_week >= 5 and @fiscal_week <= 9
    set @fiscal_period = 2
  if @fiscal_week >= 10 and @fiscal_week <= 13
    set @fiscal_period = 3
  if @fiscal_week >= 14 and @fiscal_week <= 17
    set @fiscal_period = 4
  if @fiscal_week >= 18 and @fiscal_week <= 22
    set @fiscal_period = 5
  if @fiscal_week >= 23 and @fiscal_week <= 26
    set @fiscal_period = 6
  if @fiscal_week >= 27 and @fiscal_week <= 30
    set @fiscal_period = 7
  if @fiscal_week >= 31 and @fiscal_week <= 35
    set @fiscal_period = 8
  if @fiscal_week >= 36 and @fiscal_week <= 39
    set @fiscal_period = 9
  if @fiscal_week >= 40 and @fiscal_week <= 43
    set @fiscal_period = 10
  if @fiscal_week >= 44 and @fiscal_week <= 47
    set @fiscal_period = 11
  if @fiscal_week >= 48 and @fiscal_week <= 52
    set @fiscal_period = 12

  return @fiscal_period
end
GO
