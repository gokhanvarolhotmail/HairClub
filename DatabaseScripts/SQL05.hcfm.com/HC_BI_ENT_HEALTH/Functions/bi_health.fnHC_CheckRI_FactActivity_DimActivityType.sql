/* CreateDate: 05/08/2010 11:15:36.667 , ModifyDate: 05/08/2010 15:14:04.160 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivity_DimActivityType] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivity_DimActivityType]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimActivityType]()
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
  	SET @DimensionName = N'[bi_mktg_dds].[DimActivityType]'
	SET @FieldName = N'[ActivityTypeKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ActivityTypeKey
		FROM [bi_health].[synHC_DDS_FactActivity]  WITH (NOLOCK)
		WHERE ActivityTypeKey NOT
		IN (
				SELECT SRC.ActivityTypeKey
				FROM [bi_health].[synHC_DDS_DimActivityType] SRC WITH (NOLOCK)
			)

RETURN
END
GO
