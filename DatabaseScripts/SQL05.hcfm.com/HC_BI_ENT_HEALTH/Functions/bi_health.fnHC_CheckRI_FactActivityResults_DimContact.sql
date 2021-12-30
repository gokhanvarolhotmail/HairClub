/* CreateDate: 05/08/2010 11:53:56.860 , ModifyDate: 05/08/2010 15:18:22.693 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivityResults_DimContact] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivityResults_DimContact]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimContact]()
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
  	SET @DimensionName = N'[bi_mktg_dds].[DimContact]'
	SET @FieldName = N'[ContactKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ContactKey
		FROM [bi_health].[synHC_DDS_FactActivityResults]  WITH (NOLOCK)
		WHERE ContactKey NOT
		IN (
				SELECT SRC.ContactKey
				FROM [bi_health].[synHC_DDS_DimContact] SRC WITH (NOLOCK)
			)

RETURN
END
GO
