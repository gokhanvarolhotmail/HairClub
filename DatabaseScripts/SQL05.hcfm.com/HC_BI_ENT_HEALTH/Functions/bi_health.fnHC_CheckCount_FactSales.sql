/* CreateDate: 05/08/2010 16:31:33.710 , ModifyDate: 01/08/2013 16:00:39.877 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckCount_FactSales] ()
-----------------------------------------------------------------------
-- [fnHC_CheckCount_FactSales]
--
-- SELECT * FROM [bi_health].[fnHC_CheckCount_FactSales]()
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

 	SET @TableName = N'[bi_cms_dds].[FactSales]'

	 -- when did we last load the DW?
     select @LatestExtract = [ExtractionEndRange] FROM HC_BI_cms_META.bief_meta.AuditDataPkgDetail with (nolock)
	 where Tablename=@TableName
	 AND DataPkgKey IN (SELECT MAX(DataPkgKey) FROM HC_BI_cms_META.bief_meta.AuditDataPkgDetail with (nolock)
	 where Tablename=@TableName AND IsLoaded=1)

	 -- to compare to the Createdate which is UTC date, convert our @LatestExtract to UT
	 select @LatestExtract =
	  HC_BI_CMS_STAGE.bief_stage.[fn_CorporateToUTCDateTime](@LatestExtract)

	SELECT @NumRecordsInSource = COUNT(*)
	FROM [bi_health].[synHC_OLTP_SRC_TBL_CMS_datSalesOrder] SRC WITH (NOLOCK)
	WHERE (CAST(SRC.IsClosedFlag AS INT) = 1 AND  CAST(SRC.IsVoidedFlag AS INT) = 0)
	AND SRC.CreateDate <  @LatestExtract

	SELECT @NumRecordsInSourceRepl = COUNT(*)
	FROM [bi_health].[synHC_SRC_TBL_CMS_datSalesOrder] SRC WITH (NOLOCK)
	WHERE (CAST(SRC.IsClosedFlag AS INT) = 1 AND  CAST(SRC.IsVoidedFlag AS INT) = 0)
	AND SRC.CreateDate <  @LatestExtract

	SELECT @NumRecordsInWarehouse = COUNT(*)
	FROM [bi_health].[synHC_DDS_FactSales] DW WITH (NOLOCK)

	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @NumRecordsInSource AS NumRecordsInSource
			, @NumRecordsInSourceRepl  AS NumRecordsInReplSource
			, @NumRecordsInWarehouse  AS NumRecordsInWarehouse


RETURN
END
GO
