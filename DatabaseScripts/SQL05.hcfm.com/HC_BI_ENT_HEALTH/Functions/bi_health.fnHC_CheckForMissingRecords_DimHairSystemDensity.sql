/* CreateDate: 10/24/2011 13:40:10.530 , ModifyDate: 10/24/2011 13:40:10.530 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemDensity] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimHairSystemDensity]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemDensity]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemDensity]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.HairSystemDensityID as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemDensity] SRC
		WHERE src.HairSystemDensityID NOT
		IN (
				SELECT DW.HairSystemDensitySSID
				FROM [bi_health].[synHC_DDS_DimHairSystemDensity] DW WITH (NOLOCK)
				)


RETURN
END
GO
