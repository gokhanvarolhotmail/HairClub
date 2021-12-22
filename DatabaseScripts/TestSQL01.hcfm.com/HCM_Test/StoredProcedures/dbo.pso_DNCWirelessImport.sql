/* CreateDate: 03/22/2016 11:02:44.663 , ModifyDate: 03/23/2016 10:41:27.580 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MJW - Workwise, LLC
-- Create date: 2016-01-26
-- Description:	Import DNC/Wireless scrub and update phone states
-- =============================================
CREATE PROCEDURE [dbo].[pso_DNCWirelessImport]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	UPDATE d
		SET
		dnc_flag = 	CASE WHEN
				(c1.is_wireless = 'N' AND c1.active = 'Y') OR
				(c2.is_wireless = 'N' AND c2.active = 'Y') OR
				(c3.is_wireless = 'N' AND c3.active = 'Y') OR
				(c4.is_wireless = 'N' AND c4.active = 'Y') OR
				(c5.is_wireless = 'N' AND c5.active = 'Y') OR
				(c6.is_wireless = 'N' AND c6.active = 'Y') OR
				(c7.is_wireless = 'N' AND c7.active = 'Y') OR
				(c8.is_wireless = 'N' AND c8.active = 'Y') OR
				(c9.is_wireless = 'N' AND c9.active = 'Y') OR
				(c10.is_wireless = 'N' AND c10.active = 'Y')
				THEN 'Y'
			ELSE
				'N'
			END,
		wireless_flag = 	CASE WHEN
				(c1.is_wireless = 'Y' AND c1.active = 'Y') OR
				(c2.is_wireless = 'Y' AND c2.active = 'Y') OR
				(c3.is_wireless = 'Y' AND c3.active = 'Y') OR
				(c4.is_wireless = 'Y' AND c4.active = 'Y') OR
				(c5.is_wireless = 'Y' AND c5.active = 'Y') OR
				(c6.is_wireless = 'Y' AND c6.active = 'Y') OR
				(c7.is_wireless = 'Y' AND c7.active = 'Y') OR
				(c8.is_wireless = 'Y' AND c8.active = 'Y') OR
				(c9.is_wireless = 'Y' AND c9.active = 'Y') OR
				(c10.is_wireless = 'Y' AND c10.active = 'Y')
				THEN 'Y'
			ELSE
				'N'
			END,
		nxx_flag = 	CASE WHEN
				c1.dnc_code = 'NXX' OR
				c2.dnc_code = 'NXX' OR
				c3.dnc_code = 'NXX' OR
				c4.dnc_code = 'NXX' OR
				c5.dnc_code = 'NXX' OR
				c6.dnc_code = 'NXX' OR
				c7.dnc_code = 'NXX' OR
				c8.dnc_code = 'NXX' OR
				c9.dnc_code = 'NXX' OR
				c10.dnc_code = 'NXX'
				THEN 'Y'
			ELSE
				'N'
			END,
			dnc_wireless_codes = RTRIM(ISNULL(s.field_1,'')) + '|' +
								 RTRIM(ISNULL(s.field_2,'')) + '|' +
								 RTRIM(ISNULL(s.field_3,'')) + '|' +
								 RTRIM(ISNULL(s.field_4,'')) + '|' +
								 RTRIM(ISNULL(s.field_5,'')) + '|' +
								 RTRIM(ISNULL(s.field_6,'')) + '|' +
								 RTRIM(ISNULL(s.field_7,'')) + '|' +
								 RTRIM(ISNULL(s.field_8,'')) + '|' +
								 RTRIM(ISNULL(s.field_9,'')) + '|' +
								 RTRIM(ISNULL(s.field_10,''))
	FROM cstd_phone_dnc_wireless_import_staging s
	INNER JOIN cstd_phone_dnc_wireless_job_detail d ON d.phonenumber = s.phonenumber AND d.phone_dnc_wireless_job_id = s.ExportID
	LEFT OUTER JOIN csta_dnc c1 ON c1.dnc_code = s.field_1
	LEFT OUTER JOIN csta_dnc c2 ON c2.dnc_code = s.field_2
	LEFT OUTER JOIN csta_dnc c3 ON c3.dnc_code = s.field_3
	LEFT OUTER JOIN csta_dnc c4 ON c4.dnc_code = s.field_4
	LEFT OUTER JOIN csta_dnc c5 ON c5.dnc_code = s.field_5
	LEFT OUTER JOIN csta_dnc c6 ON c6.dnc_code = s.field_6
	LEFT OUTER JOIN csta_dnc c7 ON c7.dnc_code = s.field_7
	LEFT OUTER JOIN csta_dnc c8 ON c8.dnc_code = s.field_8
	LEFT OUTER JOIN csta_dnc c9 ON c9.dnc_code = s.field_9
	LEFT OUTER JOIN csta_dnc c10 ON c10.dnc_code = s.field_10

	INSERT INTO cstd_phone_dnc_wireless (phone_dnc_wireless_id, phonenumber, creation_date, created_by_user_code)
	SELECT NEWID(), phonenumber, GETDATE(), 'WIRELESS_SCRUB'
		FROM cstd_phone_dnc_wireless_import_staging s WHERE NOT EXISTS (SELECT 1 FROM cstd_phone_dnc_wireless dw1 WHERE phonenumber = s.phonenumber)

	UPDATE dw SET
		ebr_dnc_flag = d.dnc_flag,
		ebr_dnc_date = CASE WHEN dw.ebr_dnc_flag IS NULL OR dw.ebr_dnc_flag <> d.dnc_flag THEN GETDATE() ELSE ebr_dnc_date END,
		wireless_flag = d.wireless_flag,
		wireless_date = CASE WHEN dw.wireless_flag IS NULL OR dw.wireless_flag <> d.wireless_flag THEN GETDATE() ELSE wireless_date END,
		updated_date = CASE WHEN dw.wireless_flag IS NULL OR dw.wireless_flag <> d.wireless_flag OR dw.ebr_dnc_flag IS NULL OR dw.ebr_dnc_flag <> d.dnc_flag THEN GETDATE() ELSE updated_date END,
		updated_by_user_code = CASE WHEN dw.wireless_flag IS NULL OR dw.wireless_flag <> d.wireless_flag OR dw.ebr_dnc_flag IS NULL OR dw.ebr_dnc_flag <> d.dnc_flag THEN 'WIRELESS_SCRUB' ELSE updated_by_user_code END,
		last_vendor_update = GETDATE()
	FROM cstd_phone_dnc_wireless dw
	INNER JOIN cstd_phone_dnc_wireless_job_detail d ON d.phonenumber = dw.phonenumber
	INNER JOIN cstd_phone_dnc_wireless_import_staging s ON s.phonenumber = d.phonenumber AND s.ExportID = d.phone_dnc_wireless_job_id


	--Wireless Processing
	UPDATE cp SET
		phone_type_code = 'CELL',
		updated_date = GETDATE(),
		updated_by_user_code = 'WIRELESS_SCRUB'
	FROM oncd_contact_phone cp
	INNER JOIN cstd_phone_dnc_wireless_job_detail d ON d.phonenumber = cp.cst_full_phone_number
	INNER JOIN cstd_phone_dnc_wireless_import_staging s ON s.phonenumber = d.phonenumber AND s.ExportID = d.phone_dnc_wireless_job_id
	LEFT OUTER JOIN onca_phone_type pt ON pt.phone_type_code = cp.phone_type_code
	WHERE ISNULL(pt.cst_is_cell_phone,'N') = 'N' AND cp.phone_type_code <> 'SKIP'
		AND d.wireless_flag = 'Y'

	UPDATE cp SET
		phone_type_code = 'HOME',
		updated_date = GETDATE(),
		updated_by_user_code = 'WIRELESS_SCRUB'
	FROM oncd_contact_phone cp
	INNER JOIN cstd_phone_dnc_wireless_job_detail d ON d.phonenumber = cp.cst_full_phone_number
	INNER JOIN cstd_phone_dnc_wireless_import_staging s ON s.phonenumber = d.phonenumber AND s.ExportID = d.phone_dnc_wireless_job_id
	LEFT OUTER JOIN onca_phone_type pt ON pt.phone_type_code = cp.phone_type_code
	WHERE ISNULL(pt.cst_is_cell_phone,'N') = 'Y' AND cp.phone_type_code <> 'SKIP'
		AND cp.phone_type_code <> 'CELL' --to be commented out afther NeuStar subscription MJW 2016-01-27
		AND d.wireless_flag = 'N'


	UPDATE h SET
		import_date = GETDATE(),
		imported_by_user_code = 'WIRELESS_SCRUB'
	FROM cstd_phone_dnc_wireless_job h
	INNER JOIN (SELECT DISTINCT ExportId FROM cstd_phone_dnc_wireless_import_staging) s ON s.ExportID = h.phone_dnc_wireless_job_id
END
GO
