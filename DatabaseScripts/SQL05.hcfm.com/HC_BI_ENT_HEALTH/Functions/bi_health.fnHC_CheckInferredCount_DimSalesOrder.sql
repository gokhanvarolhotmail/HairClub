/* CreateDate: 05/12/2010 11:14:18.483 , ModifyDate: 12/11/2012 17:22:56.240 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimSalesOrder] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimSalesOrder]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimSalesOrder]()
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrder]'


	INSERT INTO @tbl
		SELECT @TableName, SalesOrderKey, CAST(SalesOrderSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimSalesOrder] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1 and SalesOrderKey<>-1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimSalesOrder] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
