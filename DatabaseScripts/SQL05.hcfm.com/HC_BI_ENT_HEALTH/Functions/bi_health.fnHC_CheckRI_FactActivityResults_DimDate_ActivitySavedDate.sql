/* CreateDate: 05/08/2010 12:05:37.517 , ModifyDate: 05/08/2010 12:05:37.517 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivityResults_DimDate_ActivitySavedDate] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivityResults_DimDate_ActivitySavedDate]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimDate_ActivitySavedDate]()
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
  	SET @DimensionName = N'[bief_dds].[DimDate]'
	SET @FieldName = N'[ActivitySavedDateKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ActivitySavedDateKey
		FROM [bi_health].[synHC_DDS_FactActivityResults]  WITH (NOLOCK)
		WHERE ActivitySavedDateKey NOT
		IN (
				SELECT SRC.DateKey
				FROM [bi_health].[synHC_DDS_DimDate] SRC WITH (NOLOCK)
			)

RETURN
END
GO
