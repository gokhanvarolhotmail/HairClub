/* CreateDate: 03/28/2011 11:17:26.893 , ModifyDate: 02/18/2013 19:04:02.523 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Clients_CreateDate]
AS
SELECT  [cfgCenter].[CenterID]
,       [cfgCenter].[CenterDescription]
,       [cfgCenter].[CenterDescriptionFullCalc] AS 'CenterName'
,       [datClient].[ClientIdentifier]
,       [datClient].[ClientNumber_Temp]
,       [datClient].[ClientGUID]
,       [datClient].[FirstName]
,       [datClient].[LastName]
,       [datClient].[ClientFullNameAltCalc] AS 'ClientName'
,       [lkpGender].[GenderID]
,       [lkpGender].[GenderDescription] AS 'Gender'
,       [lkpGender].[GenderDescriptionShort]
,       [datClient].[DateOfBirth]
,       [datClient].[AgeCalc] AS 'Age'
,       [datClient].[Address1] AS 'Address'
,       [datClient].[City]
,       LTRIM(RTRIM([lkpState].[StateDescriptionShort])) AS 'State'
,       [datClient].[PostalCode] AS 'Zip'
,       [lkpCountry].[CountryID]
,       [lkpCountry].[CountryDescription] AS 'Country'
,       [lkpCountry].[CountryDescriptionShort]
,       '(' + LEFT([datClient].[Phone1], 3) + ') ' + SUBSTRING([datClient].[Phone1], 1, 3) + '-' + RIGHT([datClient].[Phone1], 4) AS 'HomePhone'
,       '(' + LEFT([datClient].[Phone2], 3) + ') ' + SUBSTRING([datClient].[Phone2], 4, 3) + '-' + RIGHT([datClient].[Phone2], 4) AS 'WorkPhone'
,		[datClient].[Phone1] as HomePhoneUnformatted
,		[datClient].[Phone2] as WorkPhoneUnformatted
,		LEFT([datClient].PHONE1,3) AS HphoneAC
,       [datClient].[EMailAddress]
,       [datClient].[TextMessageAddress]
,       [datClient].[DoNotCallFlag]
,       [datClient].[DoNotContactFlag]
,       [datClient].[IsTaxExemptFlag]
,		[datClient].[ContactID]
,		[datClient].[CreateDate]

FROM    [datClient]
        INNER JOIN [cfgCenter]
          ON [datClient].[CenterID] = [cfgCenter].[CenterID]
         INNER JOIN [lkpGender]
          ON [datClient].[GenderID] = [lkpGender].[GenderID]
        INNER JOIN [lkpCountry]
          ON [datClient].[CountryID] = [lkpCountry].[CountryID]
        LEFT OUTER JOIN [lkpState]
          ON [datClient].[StateID] = [lkpState].[StateID]
WHERE datclient.centerid like '[356]%'
GROUP BY [cfgCenter].[CenterID]
,       [cfgCenter].[CenterDescription]
,       [cfgCenter].[CenterDescriptionFullCalc]
,       [datClient].[ClientIdentifier]
,       [datClient].[ClientNumber_Temp]
,       [datClient].[ClientGUID]
,       [datClient].[FirstName]
,       [datClient].[LastName]
,       [datClient].[ClientFullNameAltCalc]
,       [lkpGender].[GenderID]
,       [lkpGender].[GenderDescription]
,       [lkpGender].[GenderDescriptionShort]
,       [datClient].[DateOfBirth]
,       [datClient].[AgeCalc]
,       [datClient].[Address1]
,       [datClient].[City]
,       [lkpState].[StateDescriptionShort]
,       [datClient].[PostalCode]
,       [lkpCountry].[CountryID]
,       [lkpCountry].[CountryDescription]
,       [lkpCountry].[CountryDescriptionShort]
,       [datClient].[Phone1]
,       [datClient].[Phone2]
,       [datClient].[EMailAddress]
,       [datClient].[TextMessageAddress]
,       [datClient].[DoNotCallFlag]
,       [datClient].[DoNotContactFlag]
,       [datClient].[IsTaxExemptFlag]
,		[datClient].[ContactID]
,		[datClient].[CreateDate]
GO
