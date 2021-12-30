/* CreateDate: 05/13/2010 12:50:06.570 , ModifyDate: 05/13/2010 15:04:47.853 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimDoctorRegion] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimDoctorRegion]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimDoctorRegion]()
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

 	SET @TableName = N'[bi_ent_dds].[DimDoctorRegion]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[DoctorRegionID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpDoctorRegion] SRC
		WHERE src.[DoctorRegionID] NOT
		IN (
				SELECT DW.[DoctorRegionSSID]
				FROM [bi_health].[synHC_DDS_DimDoctorRegion] DW WITH (NOLOCK)
				)


RETURN
END
GO
