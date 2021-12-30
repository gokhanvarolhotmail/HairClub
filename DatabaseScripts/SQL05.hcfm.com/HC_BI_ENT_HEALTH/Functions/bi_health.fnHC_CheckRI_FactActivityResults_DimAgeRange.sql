/* CreateDate: 05/08/2010 11:53:41.273 , ModifyDate: 05/08/2010 15:21:12.597 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivityResults_DimAgeRange] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivityResults_DimAgeRange]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimAgeRange]()
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
  	SET @DimensionName = N'[bi_ent_dds].[DimAgeRange]'
	SET @FieldName = N'[AgeRangeKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, AgeRangeKey
		FROM [bi_health].[synHC_DDS_FactActivityResults]  WITH (NOLOCK)
		WHERE AgeRangeKey NOT
		IN (
				SELECT SRC.AgeRangeKey
				FROM [bi_health].[synHC_DDS_DimAgeRange] SRC WITH (NOLOCK)
			)

RETURN
END
GO
