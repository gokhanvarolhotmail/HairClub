/* CreateDate: 12/20/2006 12:53:27.347 , ModifyDate: 06/20/2014 08:58:37.727 */
GO
/*
==============================================================================

PROCEDURE:				spapp_NextDay_NoShows

VERSION:				v1.0

DESTINATION SERVER:		HCSQL3\SQL2005

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	OnContact

AUTHOR: 				Howard Abelow orig created in 2006

IMPLEMENTOR: 			Brian Kellman/HAbelow

DATE IMPLEMENTED: 		 8/13/2007

LAST REVISION DATE: 	 8/12/2007

==============================================================================
DESCRIPTION:	Used to export daily no shows.
==============================================================================

==============================================================================
NOTES: 	8/13/2007: Modified OnContacts version of spapp_NextDay_NoShows interface.
			9/26/2007 :HAbelow - Modified to keep signature of old export
			6/12/2014 KMurdoch Added Trim to Center description
			6/19/2014 KMurdoch Added Trim to email Description
==============================================================================

==============================================================================
SAMPLE EXECUTION: EXEC spapp_NextDay_NoShows  '6/19/2014'
==============================================================================
*/
CREATE PROCEDURE [dbo].[spapp_NextDay_NoShows]
		@apptDate dateTime
AS

SET NOCOUNT ON

DECLARE @NoShows TABLE(
		[recordId] VARCHAR (10)
	,	[firstName] VARCHAR (50)
	,	[lastName] VARCHAR (50)
	,	[email] VARCHAR (50)
	,	[center] VARCHAR (50)
	,	[apptDate] VARCHAR (50)
	,	[apptTime] VARCHAR (50)
	,	[gender] VARCHAR (50)
	,	[creative] VARCHAR (50)
	,	[type] VARCHAR (50)
	,	[sendcount] INT
	,	[centerid] INT
	,	[langtype] CHAR(2)

)

/*First get the data into a temp table*/
INSERT INTO @NoShows
SELECT
		info.[contact_id] AS recordid
	,	RTRIM([first_name]) AS firstname
	,	RTRIM([last_name]) AS lastname
	,	LEFT(RTRIM([email]),50) AS email
	,	LEFT(RTRIM(company.[company_name_1]),25) AS center
	,	CONVERT(varchar(20), a.due_date, 107) AS 'appt_date'
	,	LTRIM(RIGHT(RTRIM(CONVERT(varchar(20), CAST(a.start_time AS smalldatetime), 100)),7)) AS 'appt_time'
	,	[cst_gender_code] AS gender
	,	'NS1' AS 'creative'
	,	'NOSHOW' AS 'type'
	,	1 AS 'sendcount'
	,	CASE WHEN ISNULL([alt_center], 0) > 0 THEN [alt_center] ELSE [territory] END AS centerid
	,	dbo.GETTYPECODE(info.[cst_language_code], info.[cst_gender_code]) as 'langtype'
FROM
		[lead_info] info
	INNER JOIN [oncd_company] company
		ON CASE WHEN ISNULL([alt_center], 0) > 0 THEN [alt_center] ELSE [territory] END = company.[cst_center_number]
	INNER JOIN [oncd_activity_contact] ac
		ON info.[contact_id] = ac.[contact_id]
	INNER JOIN [oncd_activity] a
		ON ac.[activity_id] = a.[activity_id]
WHERE
	a.[action_code] = 'APPOINT'
	AND a.[result_code]=  'NOSHOW'
	AND a.[due_date] =  @apptDate
	AND LEN(info.[email]) > 0
	AND info.email IS NOT NULL



	INSERT INTO [hcmtbl_Noshows_ToExport] (
		[recordId],
		[firstName],
		[lastName],
		[email],
		[center],
		[apptDate],
		[apptTime],
		[gender],
		[creative],
		[type],
		[sendcount],
		[centerid],
		[langtype]
	)
	SELECT
			[recordId]
		,	[firstName]
		,	[lastName]
		,	[email]
		,	[center]
		,	[apptDate]
		,	[apptTime]
		,	[gender]
		,	[creative]
		,	[type]
		,	[sendcount]
		,	[centerid]
		,	[langtype]
	 FROM
			@NoShows
GO
