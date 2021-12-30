/* CreateDate: 10/24/2011 14:25:34.630 , ModifyDate: 10/24/2011 14:25:34.630 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemRecession] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimHairSystemRecession]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemRecession]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemRecession]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.HairSystemRecessionID as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemRecession] SRC
		WHERE src.HairSystemRecessionID NOT
		IN (
				SELECT DW.HairSystemRecessionSSID
				FROM [bi_health].[synHC_DDS_DimHairSystemRecession] DW WITH (NOLOCK)
				)


RETURN
END
GO
