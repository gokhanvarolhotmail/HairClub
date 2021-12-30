/* CreateDate: 05/08/2010 12:41:30.323 , ModifyDate: 05/08/2010 14:49:48.553 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactLead_DimOccupation] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactLead_DimOccupation]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactLead_DimOccupation]()
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
  	SET @DimensionName = N'[bi_ent_dds].[DimOccupation]'
	SET @FieldName = N'[OccupationKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, OccupationKey
		FROM [bi_health].[synHC_DDS_FactLead]  WITH (NOLOCK)
		WHERE OccupationKey NOT
		IN (
				SELECT SRC.OccupationKey
				FROM [bi_health].[synHC_DDS_DimOccupation] SRC WITH (NOLOCK)
			)

RETURN
END
GO
