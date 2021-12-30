/* CreateDate: 10/24/2011 13:32:25.320 , ModifyDate: 10/24/2011 13:32:25.320 */
GO
create    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_FactAppointmentDetail] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_FactAppointmentDetail]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_FactAppointmentDetail]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0	10-24-11  KMurdoch     Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, FieldKey bigint
					, FieldSSID varchar(150)
					)  AS
BEGIN



	DECLARE	 @TableName				varchar(150)	-- Name of table

 	SET @TableName = N'[bi_cms_dds].[FactAppointmentDetail]'

	INSERT INTO @tbl
		SELECT @TableName, DW.[AppointmentKey], ''
		FROM [bi_health].[synHC_DDS_FactAppointmentDetail] DW WITH (NOLOCK)
		LEFT OUTER JOIN [bi_health].[synHC_DDS_DimAppointment] da WITH (NOLOCK)
		ON da.AppointmentKey = DW.[AppointmentKey]
		WHERE da.[AppointmentSSID] NOT
		IN (
				SELECT SRC.AppointmentGUID
				FROM [bi_health].[synHC_SRC_TBL_CMS_datAppointment] SRC WITH (NOLOCK)

			)







RETURN
END
GO
