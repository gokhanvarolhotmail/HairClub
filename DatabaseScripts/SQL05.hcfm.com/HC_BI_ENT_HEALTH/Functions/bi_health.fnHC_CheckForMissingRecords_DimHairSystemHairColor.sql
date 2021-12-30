/* CreateDate: 10/24/2011 14:07:38.320 , ModifyDate: 10/24/2011 14:07:38.320 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemHairColor] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimHairSystemHairColor]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemHairColor]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemHairColor]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.HairSystemHairColorID as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemHairColor] SRC
		WHERE src.HairSystemHairColorID NOT
		IN (
				SELECT DW.HairSystemHairColorSSID
				FROM [bi_health].[synHC_DDS_DimHairSystemHairColor] DW WITH (NOLOCK)
				)


RETURN
END
GO
