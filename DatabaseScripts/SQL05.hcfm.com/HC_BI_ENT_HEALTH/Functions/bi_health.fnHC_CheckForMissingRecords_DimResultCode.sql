/* CreateDate: 05/12/2010 17:45:13.667 , ModifyDate: 05/13/2010 15:11:19.773 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimResultCode] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimResultCode]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimResultCode]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimResultCode]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(src.[result_code] as varchar(150)) AS RecordID
			, null AS CreatedDate
			, null AS UpdateDate
			--, src.[creation_date] AS CreatedDate
			--, src.[updated_date] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_MKTG_onca_result] SRC
		WHERE src.[result_code] NOT
		IN (
				SELECT DW.[ResultCodeSSID]
				FROM [bi_health].[synHC_DDS_DimResultCode] DW WITH (NOLOCK)
				)


RETURN
END
GO
