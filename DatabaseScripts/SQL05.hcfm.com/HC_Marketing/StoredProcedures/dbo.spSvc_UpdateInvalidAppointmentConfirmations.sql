/* CreateDate: 10/27/2016 11:38:01.930 , ModifyDate: 10/27/2016 11:38:01.930 */
GO
/***********************************************************************
PROCEDURE:				spSvc_UpdateInvalidAppointmentConfirmations
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
RELATED APP:			Message Media Text Message SSIS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/27/2016
------------------------------------------------------------------------
NOTES:

Updates the corresponding HairClubCMS appointment records to TxtInvalid confirmation type.
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_UpdateInvalidAppointmentConfirmations ''
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_UpdateInvalidAppointmentConfirmations]
(
	@SessionID NVARCHAR(100)
)
AS
BEGIN

UPDATE	a
SET		a.ConfirmationTypeID = ct.ConfirmationTypeID
,		a.LastUpdate = GETUTCDATE()
,		a.LastUpdateUser = 'CLText-HC'
FROM    SQL01.HairClubCMS.dbo.datAppointment a
        INNER JOIN datClientMessageLog cml
            ON cml.AppointmentGUID = a.AppointmentGUID
		INNER JOIN lkpTextMessageStatus tms
			ON tms.TextMessageStatusID = cml.TextMessageStatusID
		INNER JOIN SQL01.HairClubCMS.dbo.lkpConfirmationType ct
			ON ct.ConfirmationTypeDescriptionShort = 'TxtInvalid'
WHERE	cml.SessionGUID = @SessionID
		AND tms.TextMessageStatusDescriptionShort = 'DLVR-Fail'
		AND cml.ErrorCode = 'invalidRecipient'

END
GO
