/* CreateDate: 03/28/2011 11:17:15.193 , ModifyDate: 02/18/2013 19:04:02.453 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Clients_Abbreviated]
AS
SELECT     cfgCenter_1.CenterID, cfgCenter_1.CenterDescription, cfgCenter_1.CenterDescriptionFullCalc AS CenterName, datClient_1.ClientIdentifier,
                      datClient_1.ClientNumber_Temp, datClient_1.ClientGUID, datClient_1.FirstName, datClient_1.LastName,
                      datClient_1.ClientFullNameAltCalc AS ClientName, lkpGender_1.GenderID, lkpGender_1.GenderDescription AS Gender,
                      lkpGender_1.GenderDescriptionShort, datClient_1.DateOfBirth, datClient_1.AgeCalc AS Age, datClient_1.Address1 AS Address, datClient_1.City,
                      LTRIM(RTRIM(lkpState_1.StateDescriptionShort)) AS State, datClient_1.PostalCode AS Zip, lkpCountry_1.CountryID,
                      lkpCountry_1.CountryDescription AS Country, lkpCountry_1.CountryDescriptionShort, '(' + LEFT(datClient_1.Phone1, 3)
                      + ') ' + SUBSTRING(datClient_1.Phone1, 1, 3) + '-' + RIGHT(datClient_1.Phone1, 4) AS HomePhone, '(' + LEFT(datClient_1.Phone2, 3)
                      + ') ' + SUBSTRING(datClient_1.Phone2, 4, 3) + '-' + RIGHT(datClient_1.Phone2, 4) AS WorkPhone, datClient_1.Phone1 AS HomePhoneUnformatted,
                      datClient_1.Phone2 AS WorkPhoneUnformatted, LEFT(datClient_1.Phone1, 3) AS HphoneAC, datClient_1.EMailAddress,
                      datClient_1.TextMessageAddress, datClient_1.DoNotCallFlag, datClient_1.DoNotContactFlag, datClient_1.IsTaxExemptFlag, datClient_1.ContactID,
                      datClient_1.CreateUser, datClient_1.CreateDate, datClient_1.ARBalance,datclient_1.CurrentSurgeryClientMembershipGUID
FROM         datClient AS datClient_1 INNER JOIN
                      cfgCenter AS cfgCenter_1 ON datClient_1.CenterID = cfgCenter_1.CenterID INNER JOIN
                      lkpGender AS lkpGender_1 ON datClient_1.GenderID = lkpGender_1.GenderID INNER JOIN
                      lkpCountry AS lkpCountry_1 ON datClient_1.CountryID = lkpCountry_1.CountryID LEFT OUTER JOIN
                      lkpState AS lkpState_1 ON datClient_1.StateID = lkpState_1.StateID
where datClient_1.centerid like '[356]%'
GROUP BY cfgCenter_1.CenterID, cfgCenter_1.CenterDescription, cfgCenter_1.CenterDescriptionFullCalc, datClient_1.ClientIdentifier,
                      datClient_1.ClientNumber_Temp, datClient_1.ClientGUID, datClient_1.FirstName, datClient_1.LastName, datClient_1.ClientFullNameAltCalc,
                      lkpGender_1.GenderID, lkpGender_1.GenderDescription, lkpGender_1.GenderDescriptionShort, datClient_1.DateOfBirth, datClient_1.AgeCalc,
                      datClient_1.Address1, datClient_1.City, lkpState_1.StateDescriptionShort, datClient_1.PostalCode, lkpCountry_1.CountryID,
                      lkpCountry_1.CountryDescription, lkpCountry_1.CountryDescriptionShort, datClient_1.Phone1, datClient_1.Phone2, datClient_1.EMailAddress,
                      datClient_1.TextMessageAddress, datClient_1.DoNotCallFlag, datClient_1.DoNotContactFlag, datClient_1.IsTaxExemptFlag, datClient_1.ContactID,
                      datClient_1.CreateUser, datClient_1.CreateDate, datClient_1.ARBalance,datclient_1.CurrentSurgeryClientMembershipGUID
GO
