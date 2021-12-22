/* CreateDate: 10/17/2007 08:55:07.807 , ModifyDate: 05/01/2010 14:48:10.950 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAPP_DeletePhantomConfirm]
	(	@contact_Id varchar(10) = 'ABR3303714'
	  ,	@Action_Code varchar(10) = 'CONFIRM'
	)
AS

/***********************************************************************

PROCEDURE:				spAPP_DeletePhantomConfirm

VERSION:				v1.0

DESTINATION SERVER:		HCSQL3\SQL2005

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	Oncontact

AUTHOR: 				Brian Kellman

IMPLEMENTOR: 			Brian Kellman

DATE IMPLEMENTED: 		10/11/2007

LAST REVISION DATE: 	10/11/2007

--------------------------------------------------------------------------------------------------------
NOTES: 	Deletes phantom CONFIRM Activities
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC spAPP_DeletePhantomConfirm 'ABR3303714','CONFIRM'


***********************************************************************/


DELETE  OCE from Oncd_Contact_email OCE INNER JOIN oncd_activity_contact OAC
	ON OCE.Contact_ID = OAC.contact_ID 	INNER JOIN oncd_activity OA
	ON OAC.activity_ID = OA.activity_id
	WHERE OAC.contact_id = @contact_ID
	AND OA.action_code = @Action_Code

DELETE  OCC from oncd_contact_company OCC INNER JOIN oncd_activity_contact OAC
	ON OCC.Contact_ID = OAC.contact_ID 	INNER JOIN oncd_activity OA
	ON OAC.activity_ID = OA.activity_id
	WHERE OAC.contact_id = @contact_ID
	AND OA.action_code = @Action_Code

DELETE  OCP from oncd_contact_phone OCP INNER JOIN oncd_activity_contact OAC
	ON OCP.Contact_ID = OAC.contact_ID 	INNER JOIN oncd_activity OA
	ON OAC.activity_ID = OA.activity_id
	WHERE OAC.contact_id = @contact_ID
	AND OA.action_code = @Action_Code

DELETE  OCS from oncd_contact_source OCS INNER JOIN oncd_activity_contact OAC
	ON OCS.Contact_ID = OAC.contact_ID 	INNER JOIN oncd_activity OA
	ON OAC.activity_ID = OA.activity_id
	WHERE OAC.contact_id = @contact_ID
	AND OA.action_code = @Action_Code

DELETE  OCU from oncd_contact_user OCU INNER JOIN oncd_activity_contact OAC
	ON OCU.Contact_ID = OAC.contact_ID 	INNER JOIN oncd_activity OA
	ON OAC.activity_ID = OA.activity_id
	WHERE OAC.contact_id = @contact_ID
	AND OA.action_code = @Action_Code

DELETE  OCA from oncd_contact_address OCA INNER JOIN oncd_activity_contact OAC
	ON OCA.Contact_ID = OAC.contact_ID 	INNER JOIN oncd_activity OA
	ON OAC.activity_ID = OA.activity_id
	WHERE OAC.contact_id = @contact_ID
	AND OA.action_code = @Action_Code


DELETE OC
FROM oncd_contact OC INNER JOIN oncd_activity_contact OAC
	ON OC.contact_ID = OAC.contact_ID INNER JOIN oncd_activity OA
	ON OAC.activity_ID = OA.activity_id
	WHERE OAC.contact_id = @contact_ID
	AND OA.action_code = @Action_Code
GO
