/* CreateDate: 05/12/2010 11:17:23.270 , ModifyDate: 05/13/2010 14:54:04.177 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimSalesOrderType] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimSalesOrderType]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimSalesOrderType]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, FieldKey bigint
					, FieldSSID varchar(150)
					)  AS
BEGIN



	DECLARE	  @TableName				varchar(150)	-- Name of table

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrderType]'


	INSERT INTO @tbl
		SELECT @TableName, SalesOrderTypeKey, CAST(SalesOrderTypeSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimSalesOrderType] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimSalesOrderType] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
