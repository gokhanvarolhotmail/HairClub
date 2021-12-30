/* CreateDate: 05/08/2010 11:55:58.850 , ModifyDate: 05/08/2010 15:20:53.920 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivityResults_DimEthnicity] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivityResults_DimEthnicity]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimEthnicity]()
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
  	SET @DimensionName = N'[bi_ent_dds].[DimEthnicity]'
	SET @FieldName = N'[EthnicityKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, EthnicityKey
		FROM [bi_health].[synHC_DDS_FactActivityResults]  WITH (NOLOCK)
		WHERE EthnicityKey NOT
		IN (
				SELECT SRC.EthnicityKey
				FROM [bi_health].[synHC_DDS_DimEthnicity] SRC WITH (NOLOCK)
			)

RETURN
END
GO
