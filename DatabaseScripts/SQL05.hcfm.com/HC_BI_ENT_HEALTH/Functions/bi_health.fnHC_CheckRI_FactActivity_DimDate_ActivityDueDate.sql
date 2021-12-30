/* CreateDate: 05/08/2010 10:48:26.723 , ModifyDate: 05/08/2010 10:48:26.723 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactActivity_DimDate_ActivityDueDate] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactActivity_DimDate_ActivityDueDate]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactActivity_DimDate_ActivityDueDate]()
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
	SET @FieldName = N'[ActivityDueDateKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, ActivityDueDateKey
		FROM [bi_health].[synHC_DDS_FactActivity]  WITH (NOLOCK)
		WHERE ActivityDueDateKey NOT
		IN (
				SELECT SRC.DateKey
				FROM [bi_health].[synHC_DDS_DimDate] SRC WITH (NOLOCK)
			)

RETURN
END
GO
