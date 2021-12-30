/* CreateDate: 10/24/2011 14:28:47.507 , ModifyDate: 10/24/2011 14:28:47.507 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemStyle] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimHairSystemStyle]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemStyle]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemStyle]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.HairSystemStyleID as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemStyle] SRC
		WHERE src.HairSystemStyleID NOT
		IN (
				SELECT DW.HairSystemStyleSSID
				FROM [bi_health].[synHC_DDS_DimHairSystemStyle] DW WITH (NOLOCK)
				)


RETURN
END
GO
