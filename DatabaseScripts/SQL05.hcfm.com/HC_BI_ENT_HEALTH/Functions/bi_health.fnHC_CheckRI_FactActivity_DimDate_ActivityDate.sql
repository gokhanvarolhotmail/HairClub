/* CreateDate: 05/08/2010 10:37:09.033 , ModifyDate: 05/08/2010 10:40:30.073 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivity_DimDate_ActivityDate] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivity_DimDate_ActivityDate]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimDate_ActivityDate]()
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
  	SET @DimensionName = N'[bief_dds].[DimDate]'
	SET @FieldName = N'[ActivityDateKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ActivityDateKey
		FROM [bi_health].[synHC_DDS_FactActivity]  WITH (NOLOCK)
		WHERE ActivityDateKey NOT
		IN (
				SELECT SRC.DateKey
				FROM [bi_health].[synHC_DDS_DimDate] SRC WITH (NOLOCK)
			)

RETURN
END
GO
