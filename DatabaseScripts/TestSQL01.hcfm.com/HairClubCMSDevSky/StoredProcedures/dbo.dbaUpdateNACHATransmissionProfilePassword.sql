/* CreateDate: 09/26/2016 08:09:21.773 , ModifyDate: 09/26/2016 08:09:21.773 */
GO
/***********************************************************************
PROCEDURE:				[dbaUpdateNACHATransmissionProfilePassword]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				MVT
IMPLEMENTOR: 			MVT
DATE IMPLEMENTED: 		09/20/2016
LAST REVISION DATE: 	09/20/2016
--------------------------------------------------------------------------------------------------------
NOTES: 	Encrypts password and stores it in the cfgNACHATransmissionProfile table.
		09/20/2016 - MVT Created Stored Proc

--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [dbaUpdateNACHATransmissionProfilePassword] 1, 'NewPassword', 'sa'
***********************************************************************/
CREATE PROCEDURE [dbo].[dbaUpdateNACHATransmissionProfilePassword]
		@NACHATransmissionProfileID int,
		@Password nvarchar(200),
		@User nvarchar(25)

AS
BEGIN

	-- Opens the symmetric key for use
	OPEN SYMMETRIC KEY NACHAProfileKey DECRYPTION BY CERTIFICATE NACHAProfileCert;

	UPDATE ntp SET
		[Password] = EncryptByKey (Key_GUID('NACHAProfileKey'), @Password),
		[LastUpdate] = GETUTCDATE(),
		[LastUpdateUser] = @User
	FROM cfgNACHATransmissionProfile ntp
	WHERE ntp.NACHATransmissionProfileID = @NACHATransmissionProfileID

	CLOSE SYMMETRIC KEY NACHAProfileKey;
END
GO
