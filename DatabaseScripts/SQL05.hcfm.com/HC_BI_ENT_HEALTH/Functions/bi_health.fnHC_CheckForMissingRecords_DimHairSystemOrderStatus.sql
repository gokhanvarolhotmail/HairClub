/* CreateDate: 10/24/2011 14:20:35.800 , ModifyDate: 10/24/2011 14:20:35.800 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemOrderStatus] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimHairSystemOrderStatus]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemOrderStatus]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemOrderStatus]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.HairSystemOrderStatusID as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemOrderStatus] SRC
		WHERE src.HairSystemOrderStatusID NOT
		IN (
				SELECT DW.HairSystemOrderStatusSSID
				FROM [bi_health].[synHC_DDS_DimHairSystemOrderStatus] DW WITH (NOLOCK)
				)


RETURN
END
GO
