/* CreateDate: 11/28/2006 09:58:57.753 , ModifyDate: 05/01/2010 14:48:11.123 */
GO
/*
==============================================================================

PROCEDURE:				spapp_BarthHourlyLeads

VERSION:				v1.0

DESTINATION SERVER:		HCSQL3\SQL2005

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	OnContact

AUTHOR: 				Originally Written in old CMS - MArlon Burrell

IMPLEMENTOR: 			Brian Kellman

DATE IMPLEMENTED: 		 8/10/2007

LAST REVISION DATE: 	 10/2/2007 HAbelow

==============================================================================
DESCRIPTION:	Use to populate a FTP file for the Barth centers hourly leads
==============================================================================

==============================================================================
NOTES: 	8/10/2007: Modified OnContacts version of spapp_BarthHourlyLeads to match original interface.
			10/2/2007: Simplified with Lead_info view
			03/31/2008: KRM - changed hcfmdirectory to hcsql2\sql2005
==============================================================================

==============================================================================
SAMPLE EXECUTION: EXEC spapp_BarthHourlyLeads
==============================================================================
*/
CREATE PROCEDURE [dbo].[spapp_BarthHourlyLeads] AS

DECLARE @StartDay DATETIME
DECLARE @EndDay DATETIME
DECLARE @BarthId INT

SET NOCOUNT ON

SET @StartDay = CONVERT(VARCHAR(11), GETDATE(), 121) + '00:00:00'
SET @EndDay = GETDATE()

SET @BarthId  = 1

DECLARE @BarthCenters TABLE(
	Center VARCHAR(3)
,	CenterName VARCHAR(50)
	)
INSERT INTO @BarthCenters
	SELECT [Center_Num] , [Center]
		FROM [HCSQL2\SQL2005].HCFMDirectory.dbo.[tblCenter]  tblCenter
		WHERE tblCenter.[OwnerId] = @BarthId
			AND  tblCenter.[Center_Num] > 700--Barth


SELECT
		bc.Center + ' - ' + bc.CenterName  AS 'Center'
,		lead_info.contact_id AS 'RecordID' --'Contact ID'
,		RTRIM (lead_info.last_name) AS 'Last_Name'
,		RTRIM (lead_info.first_name)AS 'First_Name'
,		RTRIM (lead_info.address_line_1) AS 'Address_1'
,		RTRIM (lead_info.address_line_2) AS 'Address_2'
,		RTRIM (lead_info.city) AS 'Address_3' --'City'
,		RTRIM (lead_info.state_code) AS 'State'
,		RTRIM (lead_info.zip_code) AS 'Zip'
,		LEFT(lead_info.area_code,3) + '-' +
			CASE WHEN LEN(lead_info.phone_number) > 7
			THEN LEFT(lead_info.phone_number,3) + '-' + SUBSTRING(lead_info.phone_number,5,4)
			ELSE 	SUBSTRING(lead_info.phone_number,1,3) + '-' + SUBSTRING(lead_info.phone_number,4,4) END as 'Phone'
,		LEFT(lead_info.creation_date,11) AS 'Create_Date'
,		RIGHT(lead_info.creation_date,7) AS 'Create_Time'
,		dbo.ENTRYPOINT (lead_info.created_by_user_code) AS 'Source_type'
,		[oncd_contact_source].source_code AS 'Source_Name'
FROM lead_info
	INNER JOIN @BarthCenters bc
		ON CASE WHEN lead_info.alt_center IS NULL OR LEN(LTRIM(lead_info.alt_center)) = 0 THEN lead_info.territory 	ELSE 	lead_info.alt_center 	END =
			bc.Center
	INNER JOIN [oncd_contact_source]
		ON [lead_info].[contact_id] = [oncd_contact_source].[contact_id]
WHERE
	lead_info.creation_date BETWEEN @StartDay AND @EndDay
ORDER BY
	bc.Center
GO
