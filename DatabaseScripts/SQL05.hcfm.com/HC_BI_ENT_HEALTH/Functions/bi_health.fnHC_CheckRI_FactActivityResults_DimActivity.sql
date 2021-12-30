/* CreateDate: 05/08/2010 11:52:59.673 , ModifyDate: 05/08/2010 15:17:37.787 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivityResults_DimActivity] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivityResults_DimActivity]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimActivity]()
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
  	SET @DimensionName = N'[bi_mktg_dds].[DimActivity]'
	SET @FieldName = N'[ActivityKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ActivityKey
		FROM [bi_health].[synHC_DDS_FactActivityResults]  WITH (NOLOCK)
		WHERE ActivityKey NOT
		IN (
				SELECT SRC.ActivityKey
				FROM [bi_health].[synHC_DDS_DimActivity] SRC WITH (NOLOCK)
			)

RETURN
END
GO
