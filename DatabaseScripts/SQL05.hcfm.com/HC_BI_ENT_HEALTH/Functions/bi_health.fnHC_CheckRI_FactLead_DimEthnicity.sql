/* CreateDate: 05/08/2010 12:39:52.817 , ModifyDate: 05/08/2010 14:48:33.883 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactLead_DimEthnicity] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactLead_DimEthnicity]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactLead_DimEthnicity]()
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
  	SET @DimensionName = N'[bi_ent_dds].[DimEthnicity]'
	SET @FieldName = N'[EthnicityKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, EthnicityKey
		FROM [bi_health].[synHC_DDS_FactLead]  WITH (NOLOCK)
		WHERE EthnicityKey NOT
		IN (
				SELECT SRC.EthnicityKey
				FROM [bi_health].[synHC_DDS_DimEthnicity] SRC WITH (NOLOCK)
			)

RETURN
END
GO
