/* CreateDate: 05/08/2010 12:37:39.423 , ModifyDate: 05/08/2010 12:37:39.423 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactLead_DimTimeOfDay_LeadCreationTime] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactLead_DimTimeOfDay_LeadCreationTime]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactLead_DimTimeOfDay_LeadCreationTime]()
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

 	SET @TableName = N'[bi_mktg_dds].[FactLead]'
  	SET @DimensionName = N'[bief_dds].[DimTimeOfDay]'
	SET @FieldName = N'[LeadCreationTimeKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, LeadCreationTimeKey
		FROM [bi_health].[synHC_DDS_FactLead]  WITH (NOLOCK)
		WHERE LeadCreationTimeKey NOT
		IN (
				SELECT SRC.TimeOfDayKey
				FROM [bi_health].[synHC_DDS_DimTimeOfDay] SRC WITH (NOLOCK)
			)

RETURN
END
GO
