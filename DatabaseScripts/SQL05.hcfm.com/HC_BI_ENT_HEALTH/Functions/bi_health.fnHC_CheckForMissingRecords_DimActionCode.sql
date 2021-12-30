/* CreateDate: 05/12/2010 17:44:54.157 , ModifyDate: 05/13/2010 15:07:50.103 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimActionCode] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimActionCode]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimActionCode]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimActionCode]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(src.[action_code] as varchar(150)) AS RecordID
			, null AS CreatedDate
			, null AS UpdateDate
			--, src.[creation_date] AS CreatedDate
			--, src.[updated_date] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_MKTG_onca_action] SRC
		WHERE src.[action_code] NOT
		IN (
				SELECT DW.[ActionCodeSSID]
				FROM [bi_health].[synHC_DDS_DimActionCode] DW WITH (NOLOCK)
				)


RETURN
END
GO
