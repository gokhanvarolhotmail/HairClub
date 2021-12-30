/* CreateDate: 05/13/2010 12:49:07.347 , ModifyDate: 05/13/2010 15:06:22.327 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimBusinessUnitBrand] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimBusinessUnitBrand]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimBusinessUnitBrand]()
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

 	SET @TableName = N'[bi_ent_dds].[DimBusinessUnitBrand]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[BusinessUnitBrandID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpBusinessUnitBrand] SRC
		WHERE src.[BusinessUnitBrandID] NOT
		IN (
				SELECT DW.[BusinessUnitBrandSSID]
				FROM [bi_health].[synHC_DDS_DimBusinessUnitBrand] DW WITH (NOLOCK)
				)


RETURN
END
GO
