/* CreateDate: 10/25/2011 08:35:22.677 , ModifyDate: 10/25/2011 08:35:22.677 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemType] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimHairSystemType]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemType]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemType]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.HairSystemTypeID as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemType] SRC
		WHERE src.HairSystemTypeID NOT
		IN (
				SELECT DW.HairSystemTypeSSID
				FROM [bi_health].[synHC_DDS_DimHairSystemType] DW WITH (NOLOCK)
				)


RETURN
END
GO
