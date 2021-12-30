/* CreateDate: 05/08/2010 11:33:21.000 , ModifyDate: 05/08/2010 15:13:53.197 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivity_DimActivity] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivity_DimActivity]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimActivity]()
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
  	SET @DimensionName = N'[bi_mktg_dds].[DimActivity]'
	SET @FieldName = N'[ActivityKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ActivityKey
		FROM [bi_health].[synHC_DDS_FactActivity]  WITH (NOLOCK)
		WHERE ActivityKey NOT
		IN (
				SELECT SRC.ActivityKey
				FROM [bi_health].[synHC_DDS_DimActivity] SRC WITH (NOLOCK)
			)

RETURN
END
GO
