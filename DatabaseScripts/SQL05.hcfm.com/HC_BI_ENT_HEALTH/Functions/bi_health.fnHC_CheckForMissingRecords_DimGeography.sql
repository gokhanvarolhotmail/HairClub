/* CreateDate: 05/12/2010 18:18:49.820 , ModifyDate: 05/13/2010 15:10:59.097 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimGeography] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimGeography]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimGeography]()
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

 	SET @TableName = N'[bi_ent_dds].[DimGeography]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(src.[zip_code] as varchar(150)) AS RecordID
			, null AS CreatedDate
			, null AS UpdateDate
			--, src.[CreationDate] AS CreatedDate
			--, src.[LastUpdateDate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_MKTG_onca_zip] SRC
		WHERE src.[zip_code] NOT
		IN (
				SELECT DW.[PostalCode]
				FROM [bi_health].[synHC_DDS_DimGeography] DW WITH (NOLOCK)
				)


RETURN
END
GO
