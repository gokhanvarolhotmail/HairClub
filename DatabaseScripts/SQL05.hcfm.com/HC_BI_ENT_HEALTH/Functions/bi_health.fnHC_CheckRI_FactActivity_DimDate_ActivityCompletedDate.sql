/* CreateDate: 05/08/2010 10:45:34.900 , ModifyDate: 05/08/2010 11:10:44.900 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivity_DimDate_ActivityCompletedDate] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivity_DimDate_ActivityDate]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimDate_ActivityCompletedDate]()
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
	SET @FieldName = N'[ActivityCompletedDateKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ActivityCompletedDateKey
		FROM [bi_health].[synHC_DDS_FactActivity]  WITH (NOLOCK)
		WHERE ActivityCompletedDateKey NOT
		IN (
				SELECT SRC.DateKey
				FROM [bi_health].[synHC_DDS_DimDate] SRC WITH (NOLOCK)
			)

RETURN
END
GO
