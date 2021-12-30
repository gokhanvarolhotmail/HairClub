/* CreateDate: 05/12/2010 17:50:32.490 , ModifyDate: 05/13/2010 15:10:43.427 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimEmployeeSalesRep] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimEmployeeSalesRep]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimEmployeeSalesRep]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimEmployee]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(src.[user_code] as varchar(150)) AS RecordID
			, null AS CreatedDate
			, null AS UpdateDate
			--, src.[creation_date] AS CreatedDate
			--, src.[updated_date] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_MKTG_onca_user] SRC
		WHERE src.[user_code] NOT
		IN (
				SELECT DW.[EmployeeSSID]
				FROM [bi_health].[synHC_DDS_DimEmployeeSalesRep] DW WITH (NOLOCK)
				)


RETURN
END
GO
