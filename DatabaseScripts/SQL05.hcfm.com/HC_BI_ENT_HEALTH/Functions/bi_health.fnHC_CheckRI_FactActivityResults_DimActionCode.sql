/* CreateDate: 05/08/2010 11:52:23.470 , ModifyDate: 05/08/2010 15:17:27.347 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivityResults_DimActionCode] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivityResults_DimActionCode]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimActionCode]()
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
  	SET @DimensionName = N'[bi_mktg_dds].[DimActionCode]'
	SET @FieldName = N'[ActionCodeKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ActionCodeKey
		FROM [bi_health].[synHC_DDS_FactActivityResults]  WITH (NOLOCK)
		WHERE ActionCodeKey NOT
		IN (
				SELECT SRC.ActionCodeKey
				FROM [bi_health].[synHC_DDS_DimActionCode] SRC WITH (NOLOCK)
			)

RETURN
END
GO
