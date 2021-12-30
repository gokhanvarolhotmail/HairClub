/* CreateDate: 05/08/2010 12:38:55.907 , ModifyDate: 05/08/2010 14:50:11.877 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactLead_DimSource] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactLead_DimSource]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactLead_DimSource]()
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

 	SET @TableName = N'[bi_mktg_dds].[FactLead]'
  	SET @DimensionName = N'[bi_mktg_dds].[DimSource]'
	SET @FieldName = N'[SourceKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, SourceKey
		FROM [bi_health].[synHC_DDS_FactLead]  WITH (NOLOCK)
		WHERE SourceKey NOT
		IN (
				SELECT SRC.SourceKey
				FROM [bi_health].[synHC_DDS_DimSource] SRC WITH (NOLOCK)
			)

RETURN
END
GO
