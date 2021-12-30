/* CreateDate: 09/26/2016 08:09:21.713 , ModifyDate: 09/26/2016 08:09:21.713 */
GO
/***********************************************************************
PROCEDURE:				[selNACHATransmissionProfile]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				MVT
IMPLEMENTOR: 			MVT
DATE IMPLEMENTED: 		09/15/2016
LAST REVISION DATE: 	09/15/2016
--------------------------------------------------------------------------------------------------------
NOTES: 	Return NACHA Transmission Profile based on the NACHAFileProfileID
		09/15/2016 - MVT Created Stored Proc

--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [selNACHATransmissionProfile] 1
***********************************************************************/
CREATE PROCEDURE [dbo].[selNACHATransmissionProfile]
		@NACHAFileProfileID int

AS
BEGIN
	-- Opens the symmetric key for use
	OPEN SYMMETRIC KEY NACHAProfileKey DECRYPTION BY CERTIFICATE NACHAProfileCert;

	SELECT np.NACHAFileProfileID
		  ,tp.[NACHATransmissionProfileID]
		  ,tp.[NACHATransmissionProtocolID]
		  ,p.[NACHATransmissionProtocolDescription]
		  ,p.[NACHATransmissionProtocolDescriptionShort]
		  ,tp.[NACHATransmissionProfileDescriptionShort]
		  ,tp.[NACHATransmissionProfileDescription]
		  ,tp.[HostName]
		  ,tp.[UserName]
		  ,CONVERT(nvarchar, DecryptByKey(tp.[Password])) AS [Password]
		  ,tp.[PortNumber]
		  ,tp.[SshHostKeyFingerprint]
		  ,tp.[DestinationUploadFolder]
		  ,tp.[IsActiveFlag]
	  FROM cfgNACHAFileProfile np
		INNER JOIN [dbo].[cfgNACHATransmissionProfile] tp ON tp.NACHATransmissionProfileID = np.NACHATransmissionProfileID
		INNER JOIN lkpNACHATransmissionProtocol p ON p.NACHATransmissionProtocolID = tp.NACHATransmissionProtocolID
	  WHERE np.NACHAFileProfileID = @NACHAFileProfileID

	CLOSE SYMMETRIC KEY NACHAProfileKey;
END
GO
