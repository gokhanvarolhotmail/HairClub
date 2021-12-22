CREATE VIEW [dbo].[vw_Clients]
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
,       [cfgMembership].[MembershipDescription] AS 'Membership'
,       [cfgMembership].[MembershipDescriptionShort] AS 'MembershipShort'
,       CONVERT(VARCHAR(11), [datClientMembership].[BeginDate], 101) AS 'MembershipStartDate'
,       CONVERT(VARCHAR(11), [datClientMembership].[EndDate], 101) AS 'MembershipEndDate'
,       [lkpClientMembershipStatus].[ClientMembershipStatusID]
,       [lkpClientMembershipStatus].[ClientMembershipStatusDescription]
,       [lkpClientMembershipStatus].[ClientMembershipStatusDescriptionShort]
,       [datClientMembership].[ContractPrice] AS 'ContractPrice'
,       [datClientMembership].[ContractPaidAmount] AS 'ContractPaid'
,       SUM(CASE WHEN [datClientMembershipAccum].[AccumulatorID] IN ( 12 ) THEN [datClientMembershipAccum].[TotalAccumQuantity]
                 ELSE 0
            END) AS 'TotalGrafts'
,       SUM(CASE WHEN [datClientMembershipAccum].[AccumulatorID] IN ( 12 ) THEN [datClientMembershipAccum].[UsedAccumQuantity]
                 ELSE 0
            END) AS 'UsedGrafts'
,       SUM(CASE WHEN [datClientMembershipAccum].[AccumulatorID] IN ( 3 ) THEN [datClientMembershipAccum].[AccumMoney]
                 ELSE 0
            END) AS 'ARBalance'
,       ( [datClientMembership].[ContractPrice] - [datClientMembership].[ContractPaidAmount] ) AS 'ContractBalance'
,       MAX(CASE WHEN [datClientMembershipAccum].[AccumulatorID] IN ( 13 ) THEN [datClientMembershipAccum].[AccumDate]
                 ELSE ''
            END) AS 'LastApplicationDate'
,       MAX(CASE WHEN [datClientMembershipAccum].[AccumulatorID] IN ( 15 ) THEN [datClientMembershipAccum].[AccumDate]
                 ELSE ''
            END) AS 'LastCheckupDate'
,       MAX(CASE WHEN [datClientMembershipAccum].[AccumulatorID] IN ( 16 ) THEN [datClientMembershipAccum].[AccumDate]
                 ELSE ''
            END) AS 'LastServiceDate'
,       MAX(CASE WHEN [datClientMembershipAccum].[AccumulatorID] IN ( 7 ) THEN [datClientMembershipAccum].[AccumDate]
                 ELSE ''
            END) AS 'LastPaymentDate'
,       MAX(CASE WHEN [datClientMembershipAccum].[AccumulatorID] IN ( 6 ) THEN [datClientMembershipAccum].[AccumDate]
                 ELSE ''
            END) AS 'NextAppointmentDate'
,       [datClient].[DoNotCallFlag]
,       [datClient].[DoNotContactFlag]
,       [datClient].[IsTaxExemptFlag]
,       [datClientMembership].[IsActiveFlag]
,		[datClient].[ContactID]
FROM    [datClient]
        INNER JOIN [cfgCenter]
          ON [datClient].[CenterID] = [cfgCenter].[CenterID]
        INNER JOIN [datClientMembership]
          ON [datClient].[ClientGUID] = [datClientMembership].[ClientGUID]
        INNER JOIN [lkpClientMembershipStatus]
          ON [datClientMembership].[ClientMembershipStatusID] = [lkpClientMembershipStatus].[ClientMembershipStatusID]
        INNER JOIN [cfgMembership]
          ON [datClientMembership].[MembershipID] = [cfgMembership].[MembershipID]
        LEFT OUTER JOIN [datClientMembershipAccum]
          ON [datClientMembership].[ClientMembershipGUID] = [datClientMembershipAccum].[ClientMembershipGUID]
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
,       [cfgMembership].[MembershipDescription]
,       [cfgMembership].[MembershipDescriptionShort]
,       [datClientMembership].[BeginDate]
,       [datClientMembership].[EndDate]
,       [lkpClientMembershipStatus].[ClientMembershipStatusID]
,       [lkpClientMembershipStatus].[ClientMembershipStatusDescription]
,       [lkpClientMembershipStatus].[ClientMembershipStatusDescriptionShort]
,       [datClientMembership].[ContractPrice]
,       [datClientMembership].[ContractPaidAmount]
,       [datClient].[DoNotCallFlag]
,       [datClient].[DoNotContactFlag]
,       [datClient].[IsTaxExemptFlag]
,       [datClientMembership].[IsActiveFlag]
,		[datClient].[ContactID]



--GO
