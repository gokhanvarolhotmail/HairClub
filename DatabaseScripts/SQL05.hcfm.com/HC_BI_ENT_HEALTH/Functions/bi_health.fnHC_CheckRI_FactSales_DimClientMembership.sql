/* CreateDate: 05/08/2010 14:53:12.760 , ModifyDate: 05/08/2010 14:53:12.760 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactSales_DimClientMembership] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSales_DimClientMembership]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSales_DimClientMembership]()
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

 	SET @TableName = N'[bi_cms_dds].[FactSales]'
  	SET @DimensionName = N'bi_cms_dds].[DimClientMembership]'
	SET @FieldName = N'[ClientMembershipKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ClientMembershipKey
		FROM [bi_health].[synHC_DDS_FactSales]  WITH (NOLOCK)
		WHERE ClientMembershipKey NOT
		IN (
				SELECT SRC.ClientMembershipKey
				FROM [bi_health].[synHC_DDS_DimClientMembership] SRC WITH (NOLOCK)
			)

RETURN
END
GO
