/* CreateDate: 10/25/2011 08:40:52.897 , ModifyDate: 10/25/2011 08:40:52.897 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemVendorContract] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimHairSystemVendorContract]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimHairSystemVendorContract]()
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemVendorContract]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.HairSystemVendorContractID as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpHairSystemVendorContract] SRC
		WHERE src.HairSystemVendorContractID NOT
		IN (
				SELECT DW.HairSystemVendorContractSSID
				FROM [bi_health].[synHC_DDS_DimHairSystemVendorContract] DW WITH (NOLOCK)
				)


RETURN
END
GO
