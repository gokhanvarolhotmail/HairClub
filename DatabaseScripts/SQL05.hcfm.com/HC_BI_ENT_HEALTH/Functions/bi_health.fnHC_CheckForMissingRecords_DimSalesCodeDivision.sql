/* CreateDate: 05/12/2010 16:47:42.570 , ModifyDate: 05/13/2010 15:02:58.963 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimSalesCodeDivision] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimSalesCodeDivision]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimSalesCodeDivision]()
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesCodeDivision]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[SalesCodeDivisionID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpSalesCodeDivision] SRC
		WHERE src.[SalesCodeDivisionID] NOT
		IN (
				SELECT DW.[SalesCodeDivisionSSID]
				FROM [bi_health].[synHC_DDS_DimSalesCodeDivision] DW WITH (NOLOCK)
				)


RETURN
END
GO
