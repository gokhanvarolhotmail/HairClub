/* CreateDate: 05/12/2010 11:38:24.510 , ModifyDate: 05/13/2010 14:42:24.837 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimBusinessUnitBrand] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimBusinessUnitBrand]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimBusinessUnitBrand]()
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

 	SET @TableName = N'[bi_cms_dds].[DimBusinessUnitBrand]'


	INSERT INTO @tbl
		SELECT @TableName, BusinessUnitBrandKey, CAST(BusinessUnitBrandSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimBusinessUnitBrand] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimBusinessUnitBrand] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
