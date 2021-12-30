/* CreateDate: 10/24/2011 14:09:29.497 , ModifyDate: 04/10/2014 15:17:24.470 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactAppointmentEmployee_DimEmployee] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactAppointmentEmployee_DimEmployee]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactAppointmentEmployee_DimEmployee]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0	10-24-11  KMurdoch     Initial Creation
--			04-10-14  KMurdoch     Changed to Left outer join - Speed Items
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

 	SET @TableName = N'[bi_cms_dds].[FactAppointmentEmployee]'
  	SET @DimensionName = N'[bi_cms_dds].[DimEmployee]'
	SET @FieldName = N'[EmployeeKey]'


	INSERT INTO @tbl
		--SELECT @TableName, @DimensionName, @FieldName, AppointmentKey
		--FROM [bi_health].[synHC_DDS_FactAppointmentEmployee]  WITH (NOLOCK)
		--WHERE EmployeeKey NOT
		--IN (
		--		SELECT SRC.EmployeeKey
		--		FROM [bi_health].[synHC_DDS_DimEmployee] SRC WITH (NOLOCK)
		--	)


		SELECT @TableName, @DimensionName, @FieldName, AppointmentKey
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentEmployee FAE WITH (NOLOCK)
			LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE
				ON DE.EmployeeKey = FAE.EmployeeKey
		WHERE de.EmployeeKey IS NULL
RETURN
END
GO
