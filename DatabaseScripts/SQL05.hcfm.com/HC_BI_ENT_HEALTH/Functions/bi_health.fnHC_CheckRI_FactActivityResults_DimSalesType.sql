/* CreateDate: 05/08/2010 12:00:35.490 , ModifyDate: 05/08/2010 15:19:02.900 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivityResults_DimSalesType] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivityResults_DimSalesType]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimSalesType]()
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

 	SET @TableName = N'[bi_mktg_dds].[FactActivityResults]'
  	SET @DimensionName = N'[bi_mktg_dds].[DimSalesType]'
	SET @FieldName = N'[SalesTypeKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, SalesTypeKey
		FROM [bi_health].[synHC_DDS_FactActivityResults]  WITH (NOLOCK)
		WHERE SalesTypeKey NOT
		IN (
				SELECT SRC.SalesTypeKey
				FROM [bi_health].[synHC_DDS_DimSalesType] SRC WITH (NOLOCK)
			)

RETURN
END
GO
