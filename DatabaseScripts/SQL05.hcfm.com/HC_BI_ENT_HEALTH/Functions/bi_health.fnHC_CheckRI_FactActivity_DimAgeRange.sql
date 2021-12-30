/* CreateDate: 05/08/2010 11:15:55.470 , ModifyDate: 05/08/2010 15:14:30.647 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivity_DimAgeRange] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivity_DimAgeRange]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimAgeRange]()
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
  	SET @DimensionName = N'[bi_ent_dds].[DimAgeRange]'
	SET @FieldName = N'[AgeRangeKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, AgeRangeKey
		FROM [bi_health].[synHC_DDS_FactActivity]  WITH (NOLOCK)
		WHERE AgeRangeKey NOT
		IN (
				SELECT SRC.AgeRangeKey
				FROM [bi_health].[synHC_DDS_DimAgeRange] SRC WITH (NOLOCK)
			)

RETURN
END
GO
