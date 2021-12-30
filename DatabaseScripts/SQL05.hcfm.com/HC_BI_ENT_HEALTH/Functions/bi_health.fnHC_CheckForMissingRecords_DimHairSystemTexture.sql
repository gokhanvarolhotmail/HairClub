/* CreateDate: 10/24/2011 16:45:19.147 , ModifyDate: 10/24/2011 16:45:19.147 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemTexture] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimHairSystemTexture]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemTexture]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemTexture]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.HairSystemCurlID as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemTexture] SRC
		WHERE src.HairSystemCurlID NOT
		IN (
				SELECT DW.HairSystemTextureSSID
				FROM [bi_health].[synHC_DDS_DimHairSystemTexture] DW WITH (NOLOCK)
				)


RETURN
END
GO
