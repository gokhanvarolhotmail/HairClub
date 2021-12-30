/* CreateDate: 05/12/2010 15:29:42.243 , ModifyDate: 01/08/2013 15:58:43.490 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_FactSales] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_FactSales]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_FactSales]()
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

 	SET @TableName = N'[bi_cms_dds].[FactSales]'
	SET @MissingDate = GETDATE()

    select @LatestExtract = [ExtractionEndRange] FROM HC_BI_CMS_META.bief_meta.AuditDataPkgDetail with (nolock)
	 where Tablename=@TableName
	 AND DataPkgKey IN (SELECT MAX(DataPkgKey) FROM HC_BI_CMS_META.bief_meta.AuditDataPkgDetail with (nolock)
	 where Tablename=@TableName AND IsLoaded=1)

	 -- to compare to the Createdate which is UTC date, convert our @LatestExtract to UTC
	 select @LatestExtract =
	  HC_BI_CMS_STAGE.bief_stage.[fn_CorporateToUTCDateTime](@LatestExtract)

	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST([SalesOrderGUID] as varchar(150)) AS RecordID
			, [CreateDate] AS CreatedDate
			, [LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_datSalesOrder] SRC WITH (NOLOCK)
		WHERE src.CreateDate<@LatestExtract AND src.[SalesOrderGUID] NOT
		IN (
				SELECT dso.[SalesOrderSSID]
				FROM [bi_health].[synHC_DDS_FactSales] DW WITH (NOLOCK)
				LEFT OUTER JOIN [bi_health].[synHC_DDS_DimSalesOrder] dso WITH (NOLOCK)
					ON dso.SalesOrderKey = DW.SalesOrderKey
				)
		AND (CAST(SRC.IsClosedFlag AS INT) = 1 AND  CAST(SRC.IsVoidedFlag AS INT) = 0)


RETURN
END
GO
