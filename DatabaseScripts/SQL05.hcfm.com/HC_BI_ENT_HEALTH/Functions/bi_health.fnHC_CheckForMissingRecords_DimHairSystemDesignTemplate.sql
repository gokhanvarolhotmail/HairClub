/* CreateDate: 10/24/2011 13:56:03.783 , ModifyDate: 10/24/2011 13:56:03.783 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemDesignTemplate] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimHairSystemDesignTemplate]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemDesignTemplate]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemDesignTemplate]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.HairSystemDesignTemplateID as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemDesignTemplate] SRC
		WHERE src.HairSystemDesignTemplateID NOT
		IN (
				SELECT DW.HairSystemDesignTemplateSSID
				FROM [bi_health].[synHC_DDS_DimHairSystemDesignTemplate] DW WITH (NOLOCK)
				)


RETURN
END
GO
