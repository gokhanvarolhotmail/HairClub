/* CreateDate: 12/19/2006 13:51:56.480 , ModifyDate: 05/01/2010 14:48:10.763 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				spapp_NextDay_NoShows_InsertSent

VERSION:				v1.0

DESTINATION SERVER:		HCSQL3\SQL2005

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	OnContact

AUTHOR: 				Howard Abelow orig created in 2006

IMPLEMENTOR: 			Brian Kellman/HAbelow

DATE IMPLEMENTED: 		 8/13/2007

LAST REVISION DATE: 	 9/26/2007

==============================================================================
DESCRIPTION:	Used to export daily no shows.
==============================================================================

==============================================================================
NOTES: 	8/13/2007: Modified OnContacts version of spapp_NextDay_NoShows interface.
			9/26/2007 :HAbelow - Modified to select from staging table
==============================================================================

==============================================================================
SAMPLE EXECUTION: EXEC spapp_NextDay_NoShows_InsertSent
==============================================================================
*/

CREATE PROCEDURE [dbo].[spapp_NextDay_NoShows_InsertSent]

AS

INSERT INTO [hcmtbl_email_log] (
			[RecordID]
		,	[Email]
		,	[ApptDate]
		,	[ApptTime]
		,	[CenterName]
		,	[firstName]
		,	[lastName]
		,	[Gender]
		,	[Category]
		,	[EmailType]
		,	[Status]
		,	[Sendcount]

		)

	SELECT recordId
		,	email
		,	apptDate
		,	apptTime
		,	center
		,	firstName
		,	lastName
		,	gender
		,	creative
		,	[type]
		,	'SENT' as status
		,	sendcount
	FROM hcmtbl_Noshows_ToExport
GO
