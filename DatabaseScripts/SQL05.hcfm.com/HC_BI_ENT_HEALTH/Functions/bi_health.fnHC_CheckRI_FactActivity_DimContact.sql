/* CreateDate: 05/08/2010 11:16:44.137 , ModifyDate: 05/08/2010 15:16:37.533 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivity_DimContact] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivity_DimContact]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimContact]()
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

 	SET @TableName = N'[bi_mktg_dds].[FactActivity]'
  	SET @DimensionName = N'[bi_mktg_dds].[DimContact]'
	SET @FieldName = N'[ContactKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ContactKey
		FROM [bi_health].[synHC_DDS_FactActivity]  WITH (NOLOCK)
		WHERE ContactKey NOT
		IN (
				SELECT SRC.ContactKey
				FROM [bi_health].[synHC_DDS_DimContact] SRC WITH (NOLOCK)
			)

RETURN
END
GO
