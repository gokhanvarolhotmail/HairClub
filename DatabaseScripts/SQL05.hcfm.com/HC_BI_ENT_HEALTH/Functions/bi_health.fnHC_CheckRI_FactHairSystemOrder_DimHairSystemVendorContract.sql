/* CreateDate: 10/25/2011 11:40:06.130 , ModifyDate: 10/25/2011 11:40:06.130 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimHairSystemVendorContract] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactHairSystemOrder_DimHairSystemVendorContract]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimHairSystemVendorContract]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0	10-25-11  KMurdoch      Initial Creation
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

 	SET @TableName = N'[bi_mktg_dds].[FactHairSystemOrder]'
  	SET @DimensionName = N'[bi_ent_dds].[DimHairSystemVendorContract]'
	SET @FieldName = N'[HairSystemVendorContractKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, HairSystemVendorContractKey
		FROM [bi_health].[synHC_DDS_FactHairSystemOrder]  WITH (NOLOCK)
		WHERE HairSystemVendorContractKey NOT
		IN (
				SELECT SRC.HairSystemVendorContractKey
				FROM [bi_health].[synHC_DDS_DimHairSystemVendorContract] SRC WITH (NOLOCK)
			)

RETURN
END
GO
