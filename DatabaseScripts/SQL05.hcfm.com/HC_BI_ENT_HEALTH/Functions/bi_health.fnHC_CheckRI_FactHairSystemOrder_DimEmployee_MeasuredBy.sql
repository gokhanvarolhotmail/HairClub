/* CreateDate: 10/25/2011 13:51:33.517 , ModifyDate: 04/11/2014 09:38:20.850 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimEmployee_MeasuredBy] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactHairSystemOrder_DimEmployee_MeasuredBy]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimEmployee_MeasuredBy]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0	10-24-11  KMurdoch     Initial Creation
--			04-11-14  KMurdoch     Changed to Left outer join for Speed
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

 	SET @TableName = N'[bi_cms_dds].[FactHairSystemOrder]'
  	SET @DimensionName = N'[bi_cms_dds].[DimEmployee]'
	SET @FieldName = N'[EmployeeKey]'


	INSERT INTO @tbl
		--SELECT --@TableName, @DimensionName, @FieldName,
		--	MeasurementsByEmployeeKey
		--FROM [bi_health].[synHC_DDS_FactHairSystemOrder]  WITH (NOLOCK)
		--WHERE MeasurementsByEmployeeKey NOT
		--IN (
		--		SELECT SRC.EmployeeKey
		--		FROM [bi_health].[synHC_DDS_DimEmployee] SRC WITH (NOLOCK)
		--	)

		SELECT @TableName, @DimensionName, @FieldName,
			MeasurementsByEmployeeKey
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactHairSystemOrder FHSO  WITH (NOLOCK)
			LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
				ON FHSO.MeasurementsByEmployeeKey = DE.EmployeeKey
		WHERE DE.EmployeeKey IS NULL

RETURN
END
GO
