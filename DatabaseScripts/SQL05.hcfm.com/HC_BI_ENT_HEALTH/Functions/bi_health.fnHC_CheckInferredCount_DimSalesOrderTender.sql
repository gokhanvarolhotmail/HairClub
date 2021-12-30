/* CreateDate: 05/12/2010 11:14:47.160 , ModifyDate: 12/11/2012 17:24:11.477 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimSalesOrderTender] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimSalesOrderTender]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimSalesOrderTender]()
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrderTender]'


	INSERT INTO @tbl
		SELECT @TableName, SalesOrderTenderKey, CAST(SalesOrderTenderSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimSalesOrderTender] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1 and SalesOrderTenderKey<>-1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimSalesOrderTender] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
