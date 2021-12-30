/* CreateDate: 05/03/2010 17:05:44.430 , ModifyDate: 12/11/2012 15:32:12.507 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckCount_DimContactEmail] ()
-----------------------------------------------------------------------
-- [fnHC_CheckCount_DimContactEmail]
--
--SELECT * FROM [bi_health].[fnHC_CheckCount_DimContactEmail]()
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
			, @LatestExtract				datetime

 	SET @TableName = N'[bi_mktg_dds].[DimContactEmail]'

	 -- when did we last load the DW?
	 select @LatestExtract= [ExtractionEndRange] FROM HC_BI_MKTG_META.bief_meta.AuditDataPkgDetail with (nolock)
	 where Tablename=@TableName
	 AND DataPkgKey IN (SELECT MAX(DataPkgKey) FROM HC_BI_MKTG_META.bief_meta.AuditDataPkgDetail with (nolock)
	 where Tablename=@TableName AND IsLoaded=1)

	SELECT @NumRecordsInSource = COUNT(*)
	FROM [bi_health].[synHC_OLTP_SRC_TBL_MKTG_oncd_contact_email] WITH (NOLOCK)
	WHERE  coalesce(creation_date, @LatestExtract) <=  @LatestExtract

	SELECT @NumRecordsInSourceRepl = COUNT(*)
	FROM [bi_health].[synHC_SRC_TBL_MKTG_oncd_contact_email] WITH (NOLOCK)
	WHERE  coalesce(creation_date, @LatestExtract) <=  @LatestExtract

	SELECT @NumRecordsInWarehouse = COUNT(*)
	FROM [bi_health].[synHC_DDS_DimContactEmail] DW WITH (NOLOCK)
	WHERE DW.[ContactEmailKey] <> -1

	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @NumRecordsInSource AS NumRecordsInSource
			, @NumRecordsInSourceRepl  AS NumRecordsInReplSource
			, @NumRecordsInWarehouse  AS NumRecordsInWarehouse


RETURN
END
GO
