/* CreateDate: 05/08/2010 14:36:08.780 , ModifyDate: 05/08/2010 14:36:08.780 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactSalesTransactionTender_DimMembership] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactSalesTransactionTender_DimMembership]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactSalesTransactionTender_DimMembership]()
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

 	SET @TableName = N'[bi_cms_dds].[FactSalesTransactionTender]'
  	SET @DimensionName = N'[bief_dds].[DimMembership]'
	SET @FieldName = N'[MembershipKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, MembershipKey
		FROM [bi_health].[synHC_DDS_FactSalesTransactionTender]  WITH (NOLOCK)
		WHERE MembershipKey NOT
		IN (
				SELECT SRC.MembershipKey
				FROM [bi_health].[synHC_DDS_DimMembership] SRC WITH (NOLOCK)
			)

RETURN
END
GO
