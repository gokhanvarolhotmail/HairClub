/* CreateDate: 10/24/2011 14:26:27.000 , ModifyDate: 04/11/2014 09:26:03.580 */
GO
CREATE   FUNCTION [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimDates_DateKey] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactHairSystemOrder_DimDate]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactHairSystemOrder_DimDates_DateKey]()
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
  	SET @DimensionName = N'[bief_dds].[DimDate]'
	SET @FieldName = N'[OrderDateKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, HairSystemOrderDateKey
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactHairSystemOrder FHSO  WITH (NOLOCK)
			LEFT OUTER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FHSO.HairSystemOrderDateKey = DD.DateKey
		WHERE DD.DATEKEY IS NULL

	SET @FieldName = N'[DueDateKey]'


	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName,
		HairSystemDueDateKey
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactHairSystemOrder FHSO  WITH (NOLOCK)
			LEFT OUTER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FHSO.HairSystemDueDateKey = DD.DateKey
		WHERE DD.DATEKEY IS NULL


	SET @FieldName = N'[AllocationDateKey]'

	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, HairSystemAllocationDateKey
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactHairSystemOrder FHSO  WITH (NOLOCK)
			LEFT OUTER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FHSO.HairSystemAllocationDateKey = DD.DateKey
		WHERE DD.DATEKEY IS NULL


	SET @FieldName = N'[ReceivedDateKey]'

	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, HairSystemReceivedDateKey
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactHairSystemOrder FHSO  WITH (NOLOCK)
			LEFT OUTER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FHSO.HairSystemReceivedDateKey = DD.DateKey
		WHERE DD.DATEKEY IS NULL

	SET @FieldName = N'[ShippedDateKey]'

	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, HairSystemShippedDateKey
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactHairSystemOrder FHSO  WITH (NOLOCK)
			LEFT OUTER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FHSO.HairSystemShippedDateKey = DD.DateKey
		WHERE DD.DATEKEY IS NULL

	SET @FieldName = N'[AppliedDateKey]'

	INSERT INTO @tbl
		SELECT @TableName, @DimensionName, @FieldName, HairSystemAppliedDateKey
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactHairSystemOrder FHSO  WITH (NOLOCK)
			LEFT OUTER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FHSO.HairSystemAppliedDateKey = DD.DateKey
		WHERE DD.DATEKEY IS NULL


RETURN
END
GO
