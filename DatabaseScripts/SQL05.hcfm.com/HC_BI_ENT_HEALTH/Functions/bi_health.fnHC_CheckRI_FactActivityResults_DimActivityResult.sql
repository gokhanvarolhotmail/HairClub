/* CreateDate: 05/08/2010 12:13:37.390 , ModifyDate: 05/08/2010 15:17:48.120 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivityResults_DimActivityResult] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivityResults_DimActivityResult]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimActivityResult]()
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
  	SET @DimensionName = N'[bi_mktg_dds].[DimActivityResult]'
	SET @FieldName = N'[ActivityResultKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ActivityResultKey
		FROM [bi_health].[synHC_DDS_FactActivityResults]  WITH (NOLOCK)
		WHERE ActivityResultKey NOT
		IN (
				SELECT SRC.ActivityResultKey
				FROM [bi_health].[synHC_DDS_DimActivityResult] SRC WITH (NOLOCK)
			)

RETURN
END
GO
