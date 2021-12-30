/* CreateDate: 10/24/2011 13:38:14.197 , ModifyDate: 11/29/2012 15:27:17.037 */
GO
CREATE   FUNCTION [bi_health].[fnHC_CheckForMissingRecords_FactAppointmentDetail] ()
-----------------------------------------------------------------------
-- [fnHC_CheckForMissingRecords_FactAppointmentDetail]
--
--SELECT * FROM [bi_health].[fnHC_CheckForMissingRecords_FactAppointmentDetail]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0	10/24/11  KMurdoch     Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, MissingDate	datetime
					, RecordID varchar(150)
					, CreatedDate datetime
					, UpdateDate datetime
					)  AS
BEGIN



	DECLARE	  @TableName				varchar(150)	-- Name of table
			, @MissingDate				datetime

 	SET @TableName = N'[bi_cms_dds].[FactAppointmentDetail]'
	SET @MissingDate = GETDATE()


	INSERT INTO @tbl
		SELECT @TableName AS TableName
			, @MissingDate AS MissingDate
			, CAST(SRC.[AppointmentGUID] as varchar(150)) AS RecordID
			, SRC.[CreateDate] AS CreatedDate
			, SRC.[LastUpdate] AS UpdateDate
		FROM [bi_health].[synHC_SRC_TBL_CMS_datAppointment] SRC WITH (NOLOCK)
		WHERE src.[AppointmentGUID] NOT
		IN (
				SELECT DA.[AppointmentSSID]
				FROM [bi_health].[synHC_DDS_FactAppointmentDetail] DW WITH (NOLOCK)
				INNER JOIN [bi_health].[synHC_DDS_DimAppointment] DA
				on DW.AppointmentKey = DA.AppointmentKey
				)


RETURN
END
GO
