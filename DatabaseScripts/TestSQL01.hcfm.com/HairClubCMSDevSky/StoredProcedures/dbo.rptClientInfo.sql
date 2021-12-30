/* CreateDate: 12/17/2015 16:44:05.560 , ModifyDate: 12/18/2015 09:41:08.283 */
GO
/*===============================================================================================
 Procedure Name:            rptClientInfo
 Procedure Description:     This report is used by Legal for client information in the webpage for ClientDigitalFile
 Created By:				Rachelen Hut
 Date Created:              06/18/13
 Destination Server:        SQL01
 Destination Database:      HairclubCMS
 Related Application:       cONEct!
================================================================================================
**NOTES**

================================================================================================
Sample Execution:
EXEC rptClientInfo 105270 --Arthur Whalen  283 - Cincinnati
================================================================================================*/

CREATE PROCEDURE [dbo].[rptClientInfo]
	@ClientIdentifier INT
AS
BEGIN


SELECT  ClientIdentifier
     , CenterID
     , FirstName
     , ISNULL(MiddleName,'na') AS 'MiddleName'
     , LastName
     , CASE WHEN GenderID = 1 THEN 'Male' ELSE 'Female' END AS 'Gender'
     , ISNULL(CAST(DateOfBirth AS NVARCHAR(12)),'na') AS 'DateOfBirth'
     , ClientFullNameCalc
FROM dbo.datClient
WHERE ClientIdentifier = @ClientIdentifier





END
GO
