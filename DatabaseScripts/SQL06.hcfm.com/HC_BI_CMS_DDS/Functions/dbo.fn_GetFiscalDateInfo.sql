/* CreateDate: 03/17/2022 11:57:10.670 , ModifyDate: 03/17/2022 11:57:10.670 */
GO
CREATE FUNCTION [dbo].[fn_GetFiscalDateInfo] (@Date datetime)
-----------------------------------------------------------------------
-- [[fn_GetFiscalInfo]] retrieves the Fiscal Date Info
-----------------------------------------------------------------------
--         Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

RETURNS @tblFiscal table(
	[FiscalYear] [smallint] NOT NULL ,
	[FiscalWeek] [smallint] NOT NULL ,
	[FiscalMonth] [smallint] NOT NULL ,
	[FiscalPeriod] [smallint] NOT NULL ,
	[FiscalQuarter] [smallint] NOT NULL
	)
BEGIN

	DECLARE @FullDate DateTime
	SET @FullDate = @Date

	DECLARE @FiscalYear smallint
	DECLARE @FiscalWeek smallint
	DECLARE @FiscalMonth smallint
	DECLARE @FiscalPeriod smallint
	DECLARE @FiscalQuarter smallint


		-- Fiscal Year begins July 1
		SET @FiscalYear = dbo.DDS_DimDate_FiscalYear(@FullDate)
		SET @FiscalWeek = dbo.DDS_DimDate_FiscalWeek(@FullDate)
		SET @FiscalMonth = dbo.[DDS_DimDate_FiscalMonth](@FullDate)
		SET @FiscalPeriod = dbo.[DDS_DimDate_FiscalPeriod](@FiscalWeek)
		SET @FiscalQuarter = FLOOR(@FiscalPeriod / 3.0 + 0.9)

	INSERT INTO @tblFiscal
	SELECT  @FiscalYear
		  , @FiscalWeek
		  , @FiscalMonth
		  , @FiscalPeriod
		  , @FiscalQuarter

	RETURN
END
GO
