/* CreateDate: 10/24/2011 13:03:32.730 , ModifyDate: 04/11/2014 09:12:19.743 */
GO
CREATE   FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimAppointment] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimAppointment]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimAppointment]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------   -----------  -------------------------------------
--  v1.0	10-24-11   KMurdoch     Initial Creation
--			04-11-14   KMurdoch	    Changed to Left outer join for speed
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, FieldKey bigint
					, FieldSSID varchar(150)
					)  AS
BEGIN



	DECLARE	 @TableName				varchar(150)	-- Name of table

 	SET @TableName = N'[bi_cms_dds].[DimAppointment]'

	INSERT INTO @tbl
		--SELECT --@TableName,
		--[AppointmentKey], [AppointmentSSID]
		--FROM [bi_health].[synHC_DDS_DimAppointment] WITH (NOLOCK)
		--WHERE [AppointmentSSID] NOT
		--IN (
		--		SELECT SRC.AppointmentGUID
		--		FROM [bi_health].[synHC_SRC_TBL_CMS_datAppointment] SRC WITH (NOLOCK)
		--		)
		--AND [AppointmentKey] <> -1
		SELECT @TableName,
		 [AppointmentKey], [AppointmentSSID]
		FROM [bi_health].[synHC_DDS_DimAppointment] DA WITH (NOLOCK)
			LEFT OUTER JOIN HairClubCMS.dbo.datAppointment APP
				ON DA.AppointmentSSID = APP.AppointmentGUID
		WHERE APP.AppointmentGUID IS NULL
				AND [AppointmentKey] <> -1


--select count(*) from [bi_health].[synHC_SRC_TBL_CMS_datAppointment]
--select count(*) from [bi_health].[synHC_DDS_DimAppointment]




RETURN
END
GO
