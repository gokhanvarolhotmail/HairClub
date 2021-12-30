/* CreateDate: 05/08/2010 14:53:03.407 , ModifyDate: 05/08/2010 14:53:03.407 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactSalesTransaction_DimClientMembership] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSalesTransaction_DimClientMembership]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSalesTransaction_DimClientMembership]()
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

 	SET @TableName = N'[bi_cms_dds].[FactSalesTransaction]'
  	SET @DimensionName = N'bi_cms_dds].[DimClientMembership]'
	SET @FieldName = N'[ClientMembershipKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ClientMembershipKey
		FROM [bi_health].[synHC_DDS_FactSalesTransaction]  WITH (NOLOCK)
		WHERE ClientMembershipKey NOT
		IN (
				SELECT SRC.ClientMembershipKey
				FROM [bi_health].[synHC_DDS_DimClientMembership] SRC WITH (NOLOCK)
			)

RETURN
END
GO
