/* CreateDate: 05/08/2010 12:06:34.160 , ModifyDate: 05/08/2010 12:06:34.160 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivityResults_DimDate_OriginalAppointmentDate] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivityResults_DimDate_OriginalAppointmentDate]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivityResults_DimDate_OriginalAppointmentDate]()
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
	SET @FieldName = N'[OriginalAppointmentDateKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, OriginalAppointmentDateKey
		FROM [bi_health].[synHC_DDS_FactActivityResults]  WITH (NOLOCK)
		WHERE OriginalAppointmentDateKey NOT
		IN (
				SELECT SRC.DateKey
				FROM [bi_health].[synHC_DDS_DimDate] SRC WITH (NOLOCK)
			)

RETURN
END
GO
