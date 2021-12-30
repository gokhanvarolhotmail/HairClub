/* CreateDate: 10/24/2011 13:57:57.353 , ModifyDate: 04/10/2014 15:03:40.253 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckRI_FactAppointmentDetail_DimAppointment] ()
-----------------------------------------------------------------------
-- [fnHC_CheckRI_FactAppointmentDetail_DimAppointment]
--
--SELECT * FROM [bi_health].[fnHC_CheckRI_FactAppointmentDetail_DimAppointment]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0	10-24-11  KMurdoch     Initial Creation
--			04-10-14  KMurdoch     Changed to Left outer join - Speed Issues
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

 	SET @TableName = N'[bi_cms_dds].[FactAppointmentDetail]'
  	SET @DimensionName = N'[bi_cms_dds].[DimAppointment]'
	SET @FieldName = N'[AppointmentKey]'


	INSERT INTO @tbl
		--SELECT @TableName, @DimensionName, @FieldName, AppointmentKey
		--FROM [bi_health].[synHC_DDS_FactAppointmentDetail]  WITH (NOLOCK)
		--WHERE AppointmentKey NOT
		--IN (
		--		SELECT SRC.AppointmentKey
		--		FROM [bi_health].[synHC_DDS_DimAppointment] SRC WITH (NOLOCK)
		--	)

		SELECT @TableName, @DimensionName, @FieldName, DA.AppointmentKey
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentDetail FAD  WITH (NOLOCK)
			LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment DA
				ON DA.AppointmentKey = FAD.AppointmentKey
		WHERE DA.AppointmentKey IS NULL

RETURN
END
GO
