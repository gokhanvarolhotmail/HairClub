/* CreateDate: 05/08/2010 11:17:25.417 , ModifyDate: 05/08/2010 15:14:57.853 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivity_DimGender] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivity_DimGender]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimGender]()
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
  	SET @DimensionName = N'[bi_ent_dds].[DimGender]'
	SET @FieldName = N'[GenderKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, GenderKey
		FROM [bi_health].[synHC_DDS_FactActivity]  WITH (NOLOCK)
		WHERE GenderKey NOT
		IN (
				SELECT SRC.GenderKey
				FROM [bi_health].[synHC_DDS_DimGender] SRC WITH (NOLOCK)
			)

RETURN
END
GO
