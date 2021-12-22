/* CreateDate: 11/10/2015 11:13:07.793 , ModifyDate: 11/10/2015 11:13:07.793 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				extHairClubCMSGetSiebelID
DESTINATION SERVER:		SQL03
DESTINATION DATABASE:	HCM
AUTHOR:					Mike Tovbin
IMPLEMENTOR:			Mike Tovbin
DATE IMPLEMENTED:		11/10/2015
------------------------------------------------------------------------
NOTES: Updates Siebel ID on the Contact

11/10/2015 - MT - Created
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extHairClubCMSGetSiebelID
***********************************************************************/
CREATE PROCEDURE [dbo].[extHairClubCMSGetSiebelID]
(
	@ContactID VARCHAR(50),
	@SiebelID VARCHAR(50) OUTPUT
)
AS

BEGIN

	SELECT @SiebelID = cst_siebel_id
		FROM oncd_contact
		WHERE contact_id = @ContactID

END
GO
