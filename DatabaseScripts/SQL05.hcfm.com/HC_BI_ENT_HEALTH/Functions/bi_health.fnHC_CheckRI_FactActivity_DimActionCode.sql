/* CreateDate: 05/08/2010 11:13:01.147 , ModifyDate: 05/08/2010 15:13:41.900 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivity_DimActionCode] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivity_DimActionCode]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimActionCode]()
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
  	SET @DimensionName = N'[bi_mktg_dds].[DimActionCode]'
	SET @FieldName = N'[ActionCodeKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ActionCodeKey
		FROM [bi_health].[synHC_DDS_FactActivity]  WITH (NOLOCK)
		WHERE ActionCodeKey NOT
		IN (
				SELECT SRC.ActionCodeKey
				FROM [bi_health].[synHC_DDS_DimActionCode] SRC WITH (NOLOCK)
			)

RETURN
END
GO
