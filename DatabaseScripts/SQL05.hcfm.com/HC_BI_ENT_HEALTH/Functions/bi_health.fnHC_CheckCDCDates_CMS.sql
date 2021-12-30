/* CreateDate: 10/27/2011 13:07:11.253 , ModifyDate: 10/27/2011 13:08:08.973 */
GO
CREATE  FUNCTION [bi_health].[fnHC_CheckCDCDates_CMS](@SrcTableName varchar(100), @DataFlowTableName varchar(100))
-----------------------------------------------------------------------
-- [fnHC_CheckCDCDates_CMS]
--
--SELECT * FROM [bi_health].[fnHC_CheckCDCDates_CMS]('dbo_datClient','[bi_cms_dds].[DimClient]')
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0	10-27-11  EKnapp       Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
 					, MinCDCDate datetime
					, DataFlowDate datetime
					, [Status] varchar(50)
					)  AS
BEGIN


 declare @MinCDCDate as datetime
 select @MinCDCDate= [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_min_lsn](@SrcTableName))

 INSERT INTO @tbl
	(TableName
	,MinCDCDate
	,DataFlowDate
	,[Status])
 SELECT
	@DataFlowTableName,
	@MinCDCDate,
	LSET,
	case when LSET<@MinCDCDate then 'Bad' else 'Good' end
 FROM [HC_BI_CMS_STAGE].[bief_stage].[_DataFlow]
 WHERE TableName=@DataFlowTableName

RETURN
END
GO
