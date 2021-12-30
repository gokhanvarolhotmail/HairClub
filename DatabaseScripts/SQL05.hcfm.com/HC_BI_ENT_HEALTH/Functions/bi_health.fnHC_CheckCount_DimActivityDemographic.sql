/* CreateDate: 05/03/2010 17:16:39.240 , ModifyDate: 05/13/2010 16:01:26.313 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckCount_DimActivityDemographic] ()
-----------------------------------------------------------------------
-- [fnHC_CheckCount_DimActivityDemographic]
--
--SELECT * FROM [bi_health].[fnHC_CheckCount_DimActivityDemographic]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, NumRecordsInSource bigint
					, NumRecordsInReplSource bigint
					, NumRecordsInWarehouse bigint
					)  AS
BEGIN



	DECLARE	  @NumRecordsInSource		bigint
			, @NumRecordsInSourceRepl	bigint
			, @NumRecordsInWarehouse	bigint
			, @TableName				varchar(150)	-- Name of table

 	SET @TableName = N'[bi_mktg_dds].[DimActivityDemographic]'

	SELECT @NumRecordsInSource = COUNT(*)
	FROM [bi_health].[synHC_OLTP_SRC_TBL_MKTG_cstd_activity_demographic] WITH (NOLOCK)

	SELECT @NumRecordsInSourceRepl = COUNT(*)
	FROM [bi_health].[synHC_SRC_TBL_MKTG_cstd_activity_demographic] WITH (NOLOCK)

	SELECT @NumRecordsInWarehouse = COUNT(*)
	FROM [bi_health].[synHC_DDS_DimActivityDemographic] DW WITH (NOLOCK)
	WHERE DW.[ActivityDemographicKey] <> -1

	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @NumRecordsInSource AS NumRecordsInSource
			, @NumRecordsInSourceRepl  AS NumRecordsInReplSource
			, @NumRecordsInWarehouse  AS NumRecordsInWarehouse


RETURN
END
GO
