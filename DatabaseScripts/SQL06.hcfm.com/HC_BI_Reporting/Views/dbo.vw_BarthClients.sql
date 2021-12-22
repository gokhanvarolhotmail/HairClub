CREATE VIEW [dbo].[vw_BarthClients]
AS
SELECT  CNTR.CenterSSID AS 'CenterSSID'
,       CNTR.CenterDescriptionNumber AS 'CenterDescription'
,		CON.ContactSSID AS 'LeadID'
,       CLT.ClientIdentifier AS 'ClientIdentifier'
,       CLT.ClientNumber_Temp
,       CLT.ClientLastName AS 'LastName'
,       CLT.ClientFirstName AS 'FirstName'
,       REPLACE(CLT.ClientAddress1, ',', ' ') AS 'Address1'
,       REPLACE(CLT.ClientAddress2, ',', ' ') AS 'Address2'
,       REPLACE(CLT.City, ',', ' ') AS 'City'
,       CLT.StateProvinceDescriptionShort AS 'State'
,       CLT.PostalCode AS 'ZipCode'
,       CLT.ClientPhone1 AS 'HomePhoneNumber'
,       CLT.ClientPhone2 AS 'WorkPhoneNumber'
,		CLT.ClientEMailAddress AS 'EmailAddress'
,       DG.GenderSSID AS 'GenderSSID'
,       CLT.ClientDateOfBirth AS 'Birthday'
,       DM.MembershipKey AS 'MembershipKey'
,       DM.MembershipSSID AS 'MembershipSSID'
,       DM.MembershipDescription AS 'Membership'
,       DM.MembershipDescriptionShort
,       CM.ClientMembershipIdentifier
,       CM.ClientMembershipKey AS 'ClientMembershipKey'
,       [dbo].[GetCurrentClientMembershipKey](CLT.ClientKey) AS 'CurrentClientMembershipKey'
,       CM.ClientMembershipBeginDate AS 'MembershipBeginDate'
,       CM.ClientMembershipEndDate AS 'MembershipEndDate'
,       CM.ClientMembershipMonthlyFee AS 'MonthlyFee'
,       CLT.ClientARBalance
,       0 AS 'Prepaid'
,       SUM(CASE WHEN DCMA.AccumulatorSSID IN ( 3 ) THEN DCMA.AccumMoney
                 ELSE 0
            END) AS 'Balance'
,       0 AS 'Credit_Limit'
,       SUM(CASE WHEN DCMA.AccumulatorSSID IN ( 8 ) THEN DCMA.TotalAccumQuantity
                 ELSE 0
            END) AS 'SystemsAvailable'
,       SUM(CASE WHEN DCMA.AccumulatorSSID IN ( 8 ) THEN DCMA.UsedAccumQuantity
                 ELSE 0
            END) AS 'SystemsUsed'
,       SUM(CASE WHEN DCMA.AccumulatorSSID IN ( 9 ) THEN DCMA.TotalAccumQuantity
                 ELSE 0
            END) AS 'ServicesAvailable'
,       SUM(CASE WHEN DCMA.AccumulatorSSID IN ( 9 ) THEN DCMA.UsedAccumQuantity
                 ELSE 0
            END) AS 'ServicesUsed'
,       SUM(CASE WHEN DCMA.AccumulatorSSID IN ( 10 ) THEN DCMA.TotalAccumQuantity
                 ELSE 0
            END) AS 'SolutionsAvailable'
,       SUM(CASE WHEN DCMA.AccumulatorSSID IN ( 10 ) THEN DCMA.UsedAccumQuantity
                 ELSE 0
            END) AS 'SolutionsUsed'
,       SUM(CASE WHEN DCMA.AccumulatorSSID IN ( 11 ) THEN DCMA.TotalAccumQuantity
                 ELSE 0
            END) AS 'ProductKitsAvailable'
,       SUM(CASE WHEN DCMA.AccumulatorSSID IN ( 11 ) THEN DCMA.UsedAccumQuantity
                 ELSE 0
            END) AS 'ProductKitsUsed'
,       MIN(CASE WHEN DCMA.AccumulatorSSID IN ( 16 ) THEN DCMA.[AccumDate]
                 ELSE ''
            END) AS 'FirstServiceDate'
,       MAX(CASE WHEN DCMA.AccumulatorSSID IN ( 16 ) THEN DCMA.[AccumDate]
                 ELSE ''
            END) AS 'LastServiceDate'
,       MIN(T.FirstVisit) AS 'FirstVisit'
FROM    HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CNTR
            ON CLT.CenterSSID = CNTR.CenterSSID
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
            ON CNTR.RegionKey = DR.RegionKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
            ON CLT.ClientSSID = CM.ClientSSID
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
            ON CM.MembershipKey = DM.MembershipKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimGender DG
            ON CLT.GenderSSID = DG.GenderKey
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembershipAccum DCMA
            ON CM.ClientMembershipSSID = DCMA.ClientMembershipSSID
        LEFT OUTER JOIN ( SELECT    T.Center
                          ,         T.client_no
                          ,         MIN(T.[Date]) AS 'FirstVisit'
                          FROM      [HCSQL2\SQL2005].INFOSTORE.dbo.Transactions T
                                    INNER JOIN [HCSQL2\SQL2005].HCFMDirectory.dbo.tblCenter TC
                                        ON T.Center = TC.Center_Num
                          WHERE     TC.Center_Num LIKE '[78]%'
                                    AND TC.RegionID = 32
                          GROUP BY  T.Center
                          ,         T.client_no
                        ) T
            ON CLT.CenterSSID = T.Center
               AND CLT.ClientNumber_Temp = T.client_no
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact CON
			ON CON.ContactKey = CLT.contactkey
WHERE   CLT.CenterSSID LIKE '[78]%'
        AND DR.RegionSSID = 6
GROUP BY CM.ClientMembershipIdentifier
,       CM.ClientMembershipKey
,       CNTR.CenterSSID
,       CNTR.CenterDescriptionNumber
,		CON.ContactSSID
,       CLT.ClientKey
,       CLT.ClientIdentifier
,       CLT.ClientNumber_Temp
,       CLT.ClientLastName
,       CLT.ClientFirstName
,       CLT.ClientAddress1
,       CLT.ClientAddress2
,       CLT.City
,       CLT.StateProvinceDescriptionShort
,       CLT.PostalCode
,       CLT.ClientPhone1
,       CLT.ClientPhone2
,		CLT.ClientEMailAddress
,       DG.GenderSSID
,       CLT.ClientDateOfBirth
,       DM.MembershipDescriptionShort
,       DM.MembershipDescription
,       DM.MembershipKey
,       DM.MembershipSSID
,       CM.ClientMembershipBeginDate
,       CM.ClientMembershipEndDate
,       CM.ClientMembershipMonthlyFee
,       CLT.ClientARBalance
