/* CreateDate: 10/24/2011 14:10:26.800 , ModifyDate: 10/24/2011 14:10:26.800 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemHairLength] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimHairSystemHairLength]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemHairLength]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemHairLength]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.HairSystemHairLengthID as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemHairLength] SRC
		WHERE src.HairSystemHairLengthID NOT
		IN (
				SELECT DW.HairSystemHairLengthSSID
				FROM [bi_health].[synHC_DDS_DimHairSystemHairLength] DW WITH (NOLOCK)
				)


RETURN
END
GO
