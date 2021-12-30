/* CreateDate: 05/12/2010 16:49:15.247 , ModifyDate: 05/13/2010 15:01:54.763 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimSalesOrderType] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimSalesOrderType]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimSalesOrderType]()
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrderTypen]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[SalesOrderTypeID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_lkpSalesOrderType] SRC
		WHERE src.[SalesOrderTypeID] NOT
		IN (
				SELECT DW.[SalesOrderTypeSSID]
				FROM [bi_health].[synHC_DDS_DimSalesOrderType] DW WITH (NOLOCK)
				)


RETURN
END
GO
