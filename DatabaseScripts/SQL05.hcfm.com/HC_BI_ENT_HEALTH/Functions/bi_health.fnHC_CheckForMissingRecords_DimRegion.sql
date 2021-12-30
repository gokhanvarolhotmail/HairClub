/* CreateDate: 05/13/2010 12:50:35.413 , ModifyDate: 05/13/2010 15:04:01.247 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimRegion] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimRegion]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimRegion]()
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
			, @MissingDate				datetime

 	SET @TableName = N'[bi_ent_dds].[DimRegion]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[RegionID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpRegion] SRC
		WHERE src.[RegionID] NOT
		IN (
				SELECT DW.[RegionSSID]
				FROM [bi_health].[synHC_DDS_DimRegion] DW WITH (NOLOCK)
				)


RETURN
END
GO
