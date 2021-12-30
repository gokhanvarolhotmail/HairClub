/* CreateDate: 05/08/2010 12:10:21.893 , ModifyDate: 05/08/2010 15:19:14.100 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivityResults_DimSource] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivityResults_DimSource]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimSource]()
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
  	SET @DimensionName = N'[bi_mktg_dds].[DimSource]'
	SET @FieldName = N'[SourceKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, SourceKey
		FROM [bi_health].[synHC_DDS_FactActivityResults]  WITH (NOLOCK)
		WHERE SourceKey NOT
		IN (
				SELECT SRC.SourceKey
				FROM [bi_health].[synHC_DDS_DimSource] SRC WITH (NOLOCK)
			)

RETURN
END
GO
