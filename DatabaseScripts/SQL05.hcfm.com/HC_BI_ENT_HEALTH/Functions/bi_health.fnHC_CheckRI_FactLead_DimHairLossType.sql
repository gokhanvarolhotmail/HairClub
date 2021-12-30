/* CreateDate: 05/08/2010 12:40:22.033 , ModifyDate: 05/08/2010 14:49:08.923 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactLead_DimHairLossType] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactLead_DimHairLossType]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactLead_DimHairLossType]()
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
  	SET @DimensionName = N'[bi_ent_dds].[DimHairLossType]'
	SET @FieldName = N'[HairLossTypeKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, HairLossTypeKey
		FROM [bi_health].[synHC_DDS_FactLead]  WITH (NOLOCK)
		WHERE HairLossTypeKey NOT
		IN (
				SELECT SRC.HairLossTypeKey
				FROM [bi_health].[synHC_DDS_DimHairLossType] SRC WITH (NOLOCK)
			)

RETURN
END
GO
