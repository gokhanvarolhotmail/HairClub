/* CreateDate: 05/08/2010 11:59:06.260 , ModifyDate: 05/08/2010 11:59:06.260 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivityResults_DimTimeOfDay_ActivityStartTime] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivityResults_DimTimeOfDay_ActivityStartTime]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimTimeOfDay_ActivityStartTime]()
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
  	SET @DimensionName = N'[bief_dds].[DimTimeOfDay]'
	SET @FieldName = N'[ActivityStartTimeKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ActivityStartTimeKey
		FROM [bi_health].[synHC_DDS_FactActivityResults]  WITH (NOLOCK)
		WHERE ActivityStartTimeKey NOT
		IN (
				SELECT SRC.TimeOfDayKey
				FROM [bi_health].[synHC_DDS_DimTimeOfDay] SRC WITH (NOLOCK)
			)

RETURN
END
GO
