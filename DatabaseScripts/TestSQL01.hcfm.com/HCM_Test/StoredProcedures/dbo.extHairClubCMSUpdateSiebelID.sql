/* CreateDate: 11/10/2015 11:13:07.763 , ModifyDate: 11/10/2015 11:13:07.763 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				extHairClubCMSUpdateSiebelID
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

EXEC extHairClubCMSUpdateSiebelID
***********************************************************************/
CREATE PROCEDURE [dbo].[extHairClubCMSUpdateSiebelID]
(
	@ContactID VARCHAR(50),
	@SiebelID VARCHAR(50)
)
AS
SET XACT_ABORT ON

BEGIN TRANSACTION

-- Contact
UPDATE  oncd_contact
SET     cst_siebel_id = @SiebelID
,       updated_date = GETDATE()
WHERE   contact_id = @ContactID

IF @@ERROR <> 0
   BEGIN
         ROLLBACK TRANSACTION
         RETURN
   END

COMMIT TRANSACTION
GO
