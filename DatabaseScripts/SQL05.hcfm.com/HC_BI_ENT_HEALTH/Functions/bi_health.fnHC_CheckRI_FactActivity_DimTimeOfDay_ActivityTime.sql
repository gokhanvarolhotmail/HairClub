/* CreateDate: 05/08/2010 11:21:27.833 , ModifyDate: 05/08/2010 11:21:27.833 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivity_DimTimeOfDay_ActivityTime] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivity_DimTimeOfDay_ActivityTime]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimTimeOfDay_ActivityTime]()
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
  	SET @DimensionName = N'[bief_dds].[DimTimeOfDay]'
	SET @FieldName = N'[ActivityTimeKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ActivityTimeKey
		FROM [bi_health].[synHC_DDS_FactActivity]  WITH (NOLOCK)
		WHERE ActivityTimeKey NOT
		IN (
				SELECT SRC.TimeOfDayKey
				FROM [bi_health].[synHC_DDS_DimTimeOfDay] SRC WITH (NOLOCK)
			)

RETURN
END
GO
