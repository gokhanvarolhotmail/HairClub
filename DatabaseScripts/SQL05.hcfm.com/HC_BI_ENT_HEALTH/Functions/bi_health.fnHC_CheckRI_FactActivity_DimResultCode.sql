/* CreateDate: 05/08/2010 11:14:08.510 , ModifyDate: 05/08/2010 15:17:02.767 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivity_DimResultCode] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivity_DimResultCode]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimResultCode]()
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
  	SET @DimensionName = N'[bi_mktg_dds].[DimResultCode]'
	SET @FieldName = N'[ResultCodeKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ResultCodeKey
		FROM [bi_health].[synHC_DDS_FactActivity]  WITH (NOLOCK)
		WHERE ResultCodeKey NOT
		IN (
				SELECT SRC.ResultCodeKey
				FROM [bi_health].[synHC_DDS_DimResultCode] SRC WITH (NOLOCK)
			)

RETURN
END
GO
