/* CreateDate: 05/08/2010 11:23:18.720 , ModifyDate: 05/08/2010 15:15:20.223 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivity_DimMaritalStatus] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivity_DimMaritalStatus]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimMaritalStatus]()
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
  	SET @DimensionName = N'[bi_ent_dds].[DimMaritalStatus]'
	SET @FieldName = N'[MaritalStatusKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, MaritalStatusKey
		FROM [bi_health].[synHC_DDS_FactActivity]  WITH (NOLOCK)
		WHERE MaritalStatusKey NOT
		IN (
				SELECT SRC.MaritalStatusKey
				FROM [bi_health].[synHC_DDS_DimMaritalStatus] SRC WITH (NOLOCK)
			)

RETURN
END
GO
