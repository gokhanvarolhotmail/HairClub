/* CreateDate: 05/08/2010 12:40:07.493 , ModifyDate: 05/08/2010 14:48:53.287 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactLead_DimGender] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactLead_DimGender]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactLead_DimGender]()
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
  	SET @DimensionName = N'[bi_ent_dds].[DimGender]'
	SET @FieldName = N'[GenderKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, GenderKey
		FROM [bi_health].[synHC_DDS_FactLead]  WITH (NOLOCK)
		WHERE GenderKey NOT
		IN (
				SELECT SRC.GenderKey
				FROM [bi_health].[synHC_DDS_DimGender] SRC WITH (NOLOCK)
			)

RETURN
END
GO
