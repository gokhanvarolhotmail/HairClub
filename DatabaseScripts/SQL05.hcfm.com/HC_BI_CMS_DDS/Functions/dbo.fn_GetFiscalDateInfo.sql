/* CreateDate: 05/03/2010 12:17:24.260 , ModifyDate: 10/03/2019 22:52:21.980 */
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
