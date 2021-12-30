/* CreateDate: 05/12/2010 16:47:22.613 , ModifyDate: 05/13/2010 15:03:13.673 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimSalesCodeDepartment] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimSalesCodeDepartment]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimSalesCodeDepartment]()
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesCodeDepartment]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[SalesCodeDepartmentID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpSalesCodeDepartment] SRC
		WHERE src.[SalesCodeDepartmentID] NOT
		IN (
				SELECT DW.[SalesCodeDepartmentSSID]
				FROM [bi_health].[synHC_DDS_DimSalesCodeDepartment] DW WITH (NOLOCK)
				)


RETURN
END
GO
