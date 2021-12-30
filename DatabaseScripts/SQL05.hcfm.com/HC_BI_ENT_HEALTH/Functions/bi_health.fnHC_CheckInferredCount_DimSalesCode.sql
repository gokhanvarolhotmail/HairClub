/* CreateDate: 05/12/2010 11:13:23.880 , ModifyDate: 05/13/2010 14:51:55.213 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimSalesCode] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimSalesCode]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimSalesCode]()
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesCode]'


	INSERT INTO @tbl
		SELECT @TableName, SalesCodeKey, CAST(SalesCodeSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimSalesCode] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimSalesCode] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
