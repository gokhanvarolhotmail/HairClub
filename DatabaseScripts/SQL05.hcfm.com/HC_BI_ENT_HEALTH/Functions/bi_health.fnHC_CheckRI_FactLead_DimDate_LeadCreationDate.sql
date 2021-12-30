/* CreateDate: 05/08/2010 12:35:44.777 , ModifyDate: 05/08/2010 12:35:44.777 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactLead_DimDate_LeadCreationDate] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactLead_DimDate_LeadCreationDate]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactLead_DimDate_LeadCreationDate]()
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
  	SET @DimensionName = N'[bief_dds].[DimDate]'
	SET @FieldName = N'[LeadCreationDateKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, LeadCreationDateKey
		FROM [bi_health].[synHC_DDS_FactLead]  WITH (NOLOCK)
		WHERE LeadCreationDateKey NOT
		IN (
				SELECT SRC.DateKey
				FROM [bi_health].[synHC_DDS_DimDate] SRC WITH (NOLOCK)
			)

RETURN
END
GO
