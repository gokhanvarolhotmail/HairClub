/* CreateDate: 05/12/2010 17:48:41.967 , ModifyDate: 05/13/2010 15:11:56.273 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimSalesType] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimSalesType]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimSalesType]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimSalesType]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(src.[saletype_code] as varchar(150)) AS RecordID
			, null AS CreatedDate
			, null AS UpdateDate
			--, src.[creation_date] AS CreatedDate
			--, src.[updated_date] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_MKTG_csta_contact_saletype] SRC
		WHERE src.[saletype_code] NOT
		IN (
				SELECT DW.[SalesTypeSSID]
				FROM [bi_health].[synHC_DDS_DimSalesType] DW WITH (NOLOCK)
				)


RETURN
END
GO
