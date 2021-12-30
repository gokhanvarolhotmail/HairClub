/* CreateDate: 05/08/2010 11:16:09.887 , ModifyDate: 05/08/2010 15:16:50.933 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivity_DimCenter] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivity_DimCenter]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimCenter]()
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

 	SET @TableName = N'[bi_mktg_dds].[FactActivity]'
  	SET @DimensionName = N'[bi_mktg_dds].[DimCenter]'
	SET @FieldName = N'[CenterKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, CenterKey
		FROM [bi_health].[synHC_DDS_FactActivity]  WITH (NOLOCK)
		WHERE CenterKey NOT
		IN (
				SELECT SRC.CenterKey
				FROM [bi_health].[synHC_DDS_DimCenter] SRC WITH (NOLOCK)
			)

RETURN
END
GO
