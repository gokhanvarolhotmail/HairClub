/* CreateDate: 10/24/2011 13:59:23.527 , ModifyDate: 10/24/2011 13:59:23.527 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemFrontalDensity] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimHairSystemFrontalDensity]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemFrontalDensity]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemFrontalDensity]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.HairSystemFrontalDensityID as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemFrontalDensity] SRC
		WHERE src.HairSystemFrontalDensityID NOT
		IN (
				SELECT DW.HairSystemFrontalDensitySSID
				FROM [bi_health].[synHC_DDS_DimHairSystemFrontalDensity] DW WITH (NOLOCK)
				)


RETURN
END
GO
