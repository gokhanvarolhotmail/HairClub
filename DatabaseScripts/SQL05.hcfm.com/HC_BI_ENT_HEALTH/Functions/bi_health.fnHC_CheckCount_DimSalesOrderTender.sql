/* CreateDate: 05/08/2010 15:57:22.367 , ModifyDate: 12/18/2012 13:49:10.537 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckCount_DimSalesOrderTender] ()
-----------------------------------------------------------------------
-- [fnHC_CheckCount_DimSalesOrderTender]
--
-- SELECT * FROM [bi_health].[fnHC_CheckCount_DimSalesOrderTender]()
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
			, @LatestExtract            datetime

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrderTender]'

	 -- when did we last load the DW?
         select @LatestExtract = [ExtractionEndRange] FROM HC_BI_CMS_META.bief_meta.AuditDataPkgDetail with (nolock)
	 where Tablename=@TableName
	 AND DataPkgKey IN (SELECT MAX(DataPkgKey) FROM HC_BI_CMS_META.bief_meta.AuditDataPkgDetail with (nolock)
	 where Tablename=@TableName AND IsLoaded=1)

	 -- to compare to the Createdate which is UTC date, convert our @LatestExtract to UT
	 select @LatestExtract =
	  HC_BI_CMS_STAGE.bief_stage.[fn_CorporateToUTCDateTime](@LatestExtract)

	SELECT @NumRecordsInSource = COUNT(*)
	FROM [bi_health].[synHC_OLTP_SRC_TBL_CMS_datSalesOrderTender] WITH (NOLOCK)
	WHERE CreateDate < = @LatestExtract

	SELECT @NumRecordsInSourceRepl = COUNT(*)
	FROM [bi_health].[synHC_SRC_TBL_CMS_datSalesOrderTender] WITH (NOLOCK)
	WHERE CreateDate < = @LatestExtract

	SELECT @NumRecordsInWarehouse = COUNT(*)
	FROM [bi_health].[synHC_DDS_DimSalesOrderTender] DW WITH (NOLOCK)
	WHERE DW.[SalesOrderTenderKey] <> -1

	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @NumRecordsInSource AS NumRecordsInSource
			, @NumRecordsInSourceRepl  AS NumRecordsInReplSource
			, @NumRecordsInWarehouse  AS NumRecordsInWarehouse


RETURN
END
GO
