/* CreateDate: 05/08/2010 12:32:11.390 , ModifyDate: 05/08/2010 14:47:55.257 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactLead_DimContact] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactLead_DimContact]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactLead_DimContact]()
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
  	SET @DimensionName = N'[bi_mktg_dds].[DimContact]'
	SET @FieldName = N'[ContactKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ContactKey
		FROM [bi_health].[synHC_DDS_FactLead]  WITH (NOLOCK)
		WHERE ContactKey NOT
		IN (
				SELECT SRC.ContactKey
				FROM [bi_health].[synHC_DDS_DimContact] SRC WITH (NOLOCK)
			)

RETURN
END
GO
