/* CreateDate: 10/25/2011 09:55:23.500 , ModifyDate: 10/25/2011 10:20:13.603 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimClientMembership] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactHairSystemOrder_DimClientMembership]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimClientMembership]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0	10-25-11  KMurdoch       Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[FactHairSystemOrder]'
  	SET @DimensionName = N'bi_cms_dds].[DimClientMembership]'
	SET @FieldName = N'[ClientMembershipKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ClientMembershipKey
		FROM [bi_health].[synHC_DDS_FactHairSystemOrder]  WITH (NOLOCK)
		GROUP BY
			ClientMembershipKey
		HAVING ClientMembershipKey NOT
		IN (
				SELECT SRC.ClientMembershipKey
				FROM [bi_health].[synHC_DDS_DimClientMembership] SRC WITH (NOLOCK)
			)

RETURN
END
GO
