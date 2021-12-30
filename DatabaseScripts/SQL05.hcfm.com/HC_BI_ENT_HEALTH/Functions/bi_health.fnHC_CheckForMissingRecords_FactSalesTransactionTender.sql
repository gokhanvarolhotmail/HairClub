/* CreateDate: 05/12/2010 16:33:21.393 , ModifyDate: 01/08/2013 15:59:10.487 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_FactSalesTransactionTender] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_FactSalesTransactionTender]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_FactSalesTransactionTender]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
--                    EKnapp       Add smarts to check latency
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, MissingDate	datetime
					, RecordID varchar(150)
					, CreatedDate datetime
					, UpdateDate datetime
					)  AS
BEGIN



	DECLARE	  @TableName				varchar(150)	-- Name of table
			, @MissingDate				datetime
			, @LatestExtract            datetime

 	SET @TableName = N'[bi_cms_dds].[FactSalesTransactionTender]'
	SET @MissingDate = GETDATE()

     select @LatestExtract = [ExtractionEndRange] FROM HC_BI_CMS_META.bief_meta.AuditDataPkgDetail with (nolock)
	 where Tablename=@TableName
	 AND DataPkgKey IN (SELECT MAX(DataPkgKey) FROM HC_BI_CMS_META.bief_meta.AuditDataPkgDetail with (nolock)
	 where Tablename=@TableName AND IsLoaded=1)

	 -- to compare to the Createdate which is UTC date, convert our @LatestExtract to UT
	 select @LatestExtract =
	  HC_BI_CMS_STAGE.bief_stage.[fn_CorporateToUTCDateTime](@LatestExtract)

	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[SalesOrderTenderGUID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_datSalesOrderTender] SRC WITH (NOLOCK)
				INNER JOIN [bi_health].[synHC_SRC_TBL_CMS_datSalesOrder] so WITH (NOLOCK)
					ON so.SalesOrderGUID = SRC.SalesOrderGUID
		WHERE src.CreateDate<@LatestExtract AND src.[SalesOrderTenderGUID] NOT
		IN (
				SELECT dso.[SalesOrderTenderSSID]
				FROM [bi_health].[synHC_DDS_FactSalesTransactionTender] DW WITH (NOLOCK)
				INNER JOIN [bi_health].[synHC_DDS_DimSalesOrderTender] dso WITH (NOLOCK)
					ON dso.SalesOrderTenderKey = DW.SalesOrderTenderKey
				)
		AND (CAST(so.IsClosedFlag AS INT) = 1 AND  CAST(so.IsVoidedFlag AS INT) = 0)


RETURN
END
GO
