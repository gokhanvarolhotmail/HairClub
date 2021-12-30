/* CreateDate: 10/24/2011 14:17:34.397 , ModifyDate: 10/24/2011 14:17:34.397 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemMatrixColor] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimHairSystemMatrixColor]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemMatrixColor]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemMatrixColor]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.HairSystemMatrixColorID as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemMatrixColor] SRC
		WHERE src.HairSystemMatrixColorID NOT
		IN (
				SELECT DW.HairSystemMatrixColorSSID
				FROM [bi_health].[synHC_DDS_DimHairSystemMatrixColor] DW WITH (NOLOCK)
				)


RETURN
END
GO
