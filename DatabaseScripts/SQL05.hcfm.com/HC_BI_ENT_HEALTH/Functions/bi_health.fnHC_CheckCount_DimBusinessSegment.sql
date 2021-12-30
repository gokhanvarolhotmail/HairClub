/* CreateDate: 05/08/2010 16:01:48.907 , ModifyDate: 05/13/2010 16:09:00.690 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckCount_DimBusinessSegment] ()
-----------------------------------------------------------------------
-- [fnHC_CheckCount_DimBusinessSegment]
--
--SELECT * FROM [bi_health].[fnHC_CheckCount_DimBusinessSegment]()
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

 	SET @TableName = N'[bi_ent_dds].[DimBusinessSegment]'

	SELECT @NumRecordsInSource = COUNT(*)
	FROM [bi_health].[synHC_OLTP_SRC_TBL_CMS_lkpBusinessSegment] WITH (NOLOCK)

	SELECT @NumRecordsInSourceRepl = COUNT(*)
	FROM [bi_health].[synHC_SRC_TBL_CMS_lkpBusinessSegment] WITH (NOLOCK)

	SELECT @NumRecordsInWarehouse = COUNT(*)
	FROM [bi_health].[synHC_DDS_DimBusinessSegment] DW WITH (NOLOCK)
	WHERE DW.[BusinessSegmentKey] <> -1

	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @NumRecordsInSource AS NumRecordsInSource
			, @NumRecordsInSourceRepl  AS NumRecordsInReplSource
			, @NumRecordsInWarehouse  AS NumRecordsInWarehouse


RETURN
END
GO
