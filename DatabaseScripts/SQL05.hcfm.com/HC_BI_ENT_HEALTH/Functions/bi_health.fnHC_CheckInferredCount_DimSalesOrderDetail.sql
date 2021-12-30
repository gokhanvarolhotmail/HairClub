/* CreateDate: 05/12/2010 11:14:33.820 , ModifyDate: 12/11/2012 17:23:27.260 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimSalesOrderDetail] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimSalesOrderDetail]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimSalesOrderDetail]()
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrderDetail]'


	INSERT INTO @tbl
		SELECT @TableName, SalesOrderDetailKey, CAST(SalesOrderDetailSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimSalesOrderDetail] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1 and SalesOrderDetailKey<>-1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimSalesOrderDetail] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
