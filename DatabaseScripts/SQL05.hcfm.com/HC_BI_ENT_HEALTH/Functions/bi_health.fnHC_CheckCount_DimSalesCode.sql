/* CreateDate: 05/08/2010 15:56:18.330 , ModifyDate: 05/13/2010 16:12:24.813 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckCount_DimSalesCode] ()
-----------------------------------------------------------------------
-- [fnHC_CheckCount_DimSalesCode]
--
-- SELECT * FROM [bi_health].[fnHC_CheckCount_DimSalesCode]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    cfge      Author     Description
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesCode]'

	SELECT @NumRecordsInSource = COUNT(*)
	FROM [bi_health].[synHC_OLTP_SRC_TBL_CMS_cfgSalesCode] WITH (NOLOCK)

	SELECT @NumRecordsInSourceRepl = COUNT(*)
	FROM [bi_health].[synHC_SRC_TBL_CMS_cfgSalesCode] WITH (NOLOCK)

	SELECT @NumRecordsInWarehouse = COUNT(*)
	FROM [bi_health].[synHC_DDS_DimSalesCode] DW WITH (NOLOCK)
	WHERE DW.[SalesCodeKey] <> -1

	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @NumRecordsInSource AS NumRecordsInSource
			, @NumRecordsInSourceRepl  AS NumRecordsInReplSource
			, @NumRecordsInWarehouse  AS NumRecordsInWarehouse


RETURN
END
GO
