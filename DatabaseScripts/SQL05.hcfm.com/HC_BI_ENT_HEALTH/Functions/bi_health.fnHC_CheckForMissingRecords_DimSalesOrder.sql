/* CreateDate: 05/12/2010 16:42:35.107 , ModifyDate: 11/29/2012 15:24:17.497 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckForMissingRecords_DimSalesOrder] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_DimSalesOrder]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_DimSalesOrder]()
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrder]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[SalesOrderGUID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_datSalesOrder] SRC WITH (NOLOCK)
		WHERE src.[SalesOrderGUID] NOT
		IN (
				SELECT DW.[SalesOrderSSID]
				FROM [bi_health].[synHC_DDS_DimSalesOrder] DW WITH (NOLOCK)
				)


RETURN
END
GO
