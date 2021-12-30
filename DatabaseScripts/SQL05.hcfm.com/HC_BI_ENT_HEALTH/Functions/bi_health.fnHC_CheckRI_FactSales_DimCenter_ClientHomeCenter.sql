/* CreateDate: 05/08/2010 15:03:48.107 , ModifyDate: 05/08/2010 15:03:48.107 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactSales_DimCenter_ClientHomeCenter] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSales_DimCenter_ClientHomeCenter]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSales_DimCenter_ClientHomeCenter]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, DimensionName varchar(150)
					, FieldName varchar(150)
					, FieldKey bigint
					)  AS
BEGIN



	DECLARE	  @TableName				varchar(150)	-- Name of table
			, @DimensionName			varchar(150)	-- Name of field
			, @FieldName				varchar(150)	-- Name of field

 	SET @TableName = N'[bi_cms_dds].[FactSales]'
  	SET @DimensionName = N'[bi_ent_dds].[DimCenter]'
	SET @FieldName = N'[ClientHomeCenterKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ClientHomeCenterKey
		FROM [bi_health].[synHC_DDS_FactSales]  WITH (NOLOCK)
		WHERE ClientHomeCenterKey NOT
		IN (
				SELECT SRC.CenterKey
				FROM [bi_health].[synHC_DDS_DimCenter] SRC WITH (NOLOCK)
			)

RETURN
END
GO
