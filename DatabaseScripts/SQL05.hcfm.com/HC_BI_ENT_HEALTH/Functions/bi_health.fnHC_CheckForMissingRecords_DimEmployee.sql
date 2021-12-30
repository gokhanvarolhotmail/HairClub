/* CreateDate: 05/12/2010 16:44:50.670 , ModifyDate: 05/13/2010 15:04:35.120 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimEmployee] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimEmployee]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimEmployee]()
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

 	SET @TableName = N'[bi_cms_dds].[DimEmployee]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[EmployeeGUID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_datEmployee] SRC
		WHERE src.[EmployeeGUID] NOT
		IN (
				SELECT DW.[EmployeeSSID]
				FROM [bi_health].[synHC_DDS_DimEmployee] DW WITH (NOLOCK)
				)


RETURN
END
GO
