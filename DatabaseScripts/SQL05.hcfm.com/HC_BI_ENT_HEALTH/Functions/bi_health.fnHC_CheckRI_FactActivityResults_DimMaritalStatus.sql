/* CreateDate: 05/08/2010 11:57:52.520 , ModifyDate: 05/08/2010 15:20:17.287 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivityResults_DimMaritalStatus] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivityResults_DimMaritalStatus]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimMaritalStatus]()
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
  	SET @DimensionName = N'[bi_ent_dds].[DimMaritalStatus]'
	SET @FieldName = N'[MaritalStatusKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, MaritalStatusKey
		FROM [bi_health].[synHC_DDS_FactActivityResults]  WITH (NOLOCK)
		WHERE MaritalStatusKey NOT
		IN (
				SELECT SRC.MaritalStatusKey
				FROM [bi_health].[synHC_DDS_DimMaritalStatus] SRC WITH (NOLOCK)
			)

RETURN
END
GO
