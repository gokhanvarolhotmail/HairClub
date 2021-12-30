/* CreateDate: 05/12/2010 17:55:42.340 , ModifyDate: 12/11/2012 15:45:25.993 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimActivityDemographic] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimActivityDemographic]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimActivityDemographic]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, MissingDate	datetime
					, RecordID varchar(150)
					, CreatedDate datetime
					, UpdateDate datetime
					)  AS
BEGIN



	DECLARE	  @TableName				varchar(150)	-- Name of table
			, @LSET						datetime
			, @MissingDate				datetime
			, @LatestExtract			datetime


 	SET @TableName = N'[bi_mktg_dds].[DimActivityDemographic]'
	SET @MissingDate = GETDATE()

    select @LatestExtract= [ExtractionEndRange] FROM HC_BI_MKTG_META.bief_meta.AuditDataPkgDetail with (nolock)
	 where Tablename=@TableName
	 AND DataPkgKey IN (SELECT MAX(DataPkgKey) FROM HC_BI_MKTG_META.bief_meta.AuditDataPkgDetail with (nolock)
	 where Tablename=@TableName AND IsLoaded=1)

	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(src.[activity_demographic_id] as varchar(150)) AS RecordID
			, src.[creation_date] AS CreatedDate
			, src.[updated_date] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_MKTG_cstd_activity_demographic] SRC
		WHERE coalesce(creation_date, @LatestExtract) <=  @LatestExtract
		AND src.[activity_demographic_id] NOT
		IN (
				SELECT DW.[ActivityDemographicSSID]
				FROM [bi_health].[synHC_DDS_DimActivityDemographic] DW WITH (NOLOCK)
				)


RETURN
END
GO
