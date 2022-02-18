/****** Object:  View [dbo].[VWLead_20220214]    Script Date: 2/18/2022 8:28:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWLead_20220214]
AS With dimLead_CTE as
         (SELECT LeadKey
               , LeadCreatedDate                         LeadCreatedDateUTC
               , dateadd(mi, datepart(tz, CONVERT(datetime, LeadCreatedDate) AT TIME ZONE 'Eastern Standard Time'),
                         LeadCreatedDate)                LeadCreatedDateEST
               , createdDateKey
               , a.LeadId
               , a.LeadFirstName                         LeadName
               , LeadLastName                            LeadLastName
               , LeadFullName                            LeadFullName
               , a.LeadEmail
               , a.LeadPhone
               , a.LeadMobilephone
               , OriginalCampaignKey
               , isnull(geographykey, -1) as             geographykey
               , isnull(centerkey, -1)    as             centerkey
               , LeadCreatedDate
               , LeadFirstName
               , LeadLastActivityDate
               , Isactive
               , Isvalid
               , Isdeleted
               , IsConsultFormComplete
               , LeadStatus
               , SourceKey
               , OriginalCommMethodkey
               , LeadSource
               , CreateUser
               , LeadExternalId
               , LastActivityDateKey
               , LeadBirthday
               , datediff(year, LeadBirthday, getdate()) Age
               , GCLID
               , LeadLanguage
               , LeadGender
               , LeadEthnicity
               , NorwoodScale
               , LudwigScale
               , LeadMaritalStatus
               , LeadOccupation
               , DoNotContact
               , DoNotCall
               , DoNotText
               , DoNotEmail
               , DoNotMail
               , OriginalCampaignId
               , convertedaccountid
               , LeadPostalCode
               , isduplicatebyemail
               , isduplicatebyname
               , a.accountid
          FROM dimlead a
          WHERE dateadd(mi, datepart(tz, CONVERT(datetime, LeadCreatedDate) AT TIME ZONE 'Eastern Standard Time'),
                        LeadCreatedDate) >= CONVERT(date, dateadd(d, -(day(getdate() - 1)), getdate()), 106)

          UNION ALL

          SELECT LeadKey
               , LeadCreatedDate                         LeadCreatedDateUTC
               , dateadd(mi, datepart(tz, CONVERT(datetime, LeadCreatedDate) AT TIME ZONE 'Eastern Standard Time'),
                         LeadCreatedDate)                LeadCreatedDateEST
               , createdDateKey
               , a.LeadId
               , a.LeadFirstName                         LeadName
               , LeadLastName                            LeadLastName
               , LeadFullName                            LeadFullName
               , a.LeadEmail
               , a.LeadPhone
               , a.LeadMobilephone
               , OriginalCampaignKey
               , isnull(geographykey, -1) as             geographykey
               , isnull(centerkey, -1)    as             centerkey
               , LeadCreatedDate
               , LeadFirstName
               , LeadLastActivityDate
               , Isactive
               , Isvalid
               , Isdeleted
               , IsConsultFormComplete
               , LeadStatus
               , SourceKey
               , OriginalCommMethodkey
               , LeadSource
               , CreateUser
               , LeadExternalId
               , LastActivityDateKey
               , LeadBirthday
               , datediff(year, LeadBirthday, getdate()) Age
               , GCLID
               , LeadLanguage
               , LeadGender
               , LeadEthnicity
               , NorwoodScale
               , LudwigScale
               , LeadMaritalStatus
               , LeadOccupation
               , DoNotContact
               , DoNotCall
               , DoNotText
               , DoNotEmail
               , DoNotMail
               , OriginalCampaignId
               , convertedaccountid
               , LeadPostalCode
               , 0
               , 0
               , a.accountid
          FROM FactLeadTracking a
             WHERE dateadd(mi, datepart(tz, CONVERT(datetime, LeadCreatedDate) AT TIME ZONE 'Eastern Standard Time'),
                        LeadCreatedDate) < CONVERT(date, dateadd(d, -(day(getdate() - 1)), getdate()), 106)
         )

select LeadKey
     , LeadCreatedDate                          LeadCreatedDateUTC
     , dateadd(mi, datepart(tz, CONVERT(datetime, LeadCreatedDate) AT TIME ZONE 'Eastern Standard Time'),
               LeadCreatedDate)                 LeadCreatedDateEST
     , a.createdDateKey
     , a.LeadId
     , a.LeadFirstName                          LeadName
     , LeadLastName                             LeadLastName
     , LeadFullName                             LeadFullName
     , a.LeadEmail
     , a.LeadPhone
     , a.LeadMobilephone
     , LeadBirthday
     , datediff(year, LeadBirthday, getdate())  Age
     , k.Centerkey
     , k.[CenterID]
     , k.[CenterPayGroupID]
     , k.[CenterDescription]
     , k.[Address1]
     , k.[Address2]
     , k.[Address3]
     , k.[CenterGeographykey]
     , k.[CenterPostalCode]
     , k.[CenterPhone1]
     , k.[CenterPhone2]
     , k.[CenterPhone3]
     , k.[Phone1TypeID]
     , k.[Phone2TypeID]
     , k.[Phone3TypeID]
     , k.[IsActiveFlag]
     , k.[CreateDate]
     , k.[LastUpdate]
     , k.[UpdateStamp]
     , k.[CenterNumber]
     , k.[CenterOwnershipID]
     , k.[CenterOwnershipSortOrder]
     , k.[CenterOwnershipDescription]
     , k.[CenterOwnershipDescriptionShort]
     , k.[OwnerLastName]
     , k.[OwnerFirstName]
     , k.[CorporateName]
     , k.[OwnershipAddress1]
     , k.[CenterTypeID]
     , k.[CenterTypeSortOrder]
     , k.[CenterTypeDescription]
     , k.[CenterTypeDescriptionShort]
     , isnull(b.CampaignKey, -1)                OriginalCampaignKey
     , b.CampaignName                           OriginalCampaignName
     , b.SourceCode                             Originalsourcecode
     , b.CampaignType                           OriginalCampaignType
     , b.CampaignMedia                          OriginalCampaignMedia
     , b.CampaignSource                         OriginalCampaignOrigin
     , b.CampaignLocation                       OriginalcampaignLocation
     , ''                                       OriginalCampaignFormat
     , LeadLastActivityDate
     , LastActivityDateKey
     , e.country                                LeadCountry
     , cg.country                               CenterCountry
     , cg.DMADescription
     , cg.DMACode
     , cg.DMAMarketRegion
     , cg.Geographykey
     , e.[NameOfCityOrORG]                      LeadCity
     , e.[FullNameOfStateOrTerritory]           LeadState
     , a.Isactive
     , a.Isvalid
     , a.IsConsultFormComplete
     , LeadStatus
     , a.IsDeleted
     , isnull(ag.AgencyKey, -1)                 Agencykey
     , ag.AgencyName
     , isnull(a.SourceKey, -1)                  SourceKey
     , sc.SourceName
     , isnull(a.[OriginalCommMethodkey], -1)    OriginalComMethodKey
     , case
           when lower(b.[CampaignName]) like '%leads-ads%' then 'Facebook'
           when lower(b.[CampaignName]) like '%gleam%' then 'Gleam Form'
           when b.[SourceCode] like 'DGEMAECOMECOM14000%' then 'Shopify'
           when lower(sc.SourceName) in ('call', 'phone', 'call center') then 'Phone Call'
           when lower(sc.SourceName) in ('bosref', 'other-bos') then 'Bosley API'
           when b.[SourceCode] like 'DGPDSFACEIMAD14097%' then 'Facebook Messenger'
           when lower(sc.SourceName) in ('web form') and b.SourceCode not like 'DGEMAECOMECOM14000%' and
                lower(b.[CampaignName]) not like '%leads-ads%' and lower(b.[CampaignName]) not like '%gleam%'
               then 'Appt Form'
           when (a.LeadSource is null and lower(a.CreateUser) = 'bosleyintegration@hairclub.com') or
                sc.SourceName = 'Bosref' then 'Bosley API'
           when lower(sc.SourceName) in ('web chat', 'hairbot', 'hairclub app') then sc.SourceName
           else 'Other'
    end                                         MarketingSource
     , LeadExternalId
     , a.GCLID
     , a.LeadLanguage
     , a.LeadGender
     , a.LeadEthnicity
     , a.NorwoodScale
     , a.LudwigScale
     , a.LeadMaritalStatus
     , a.LeadOccupation
     , a.DoNotContact
     , a.DoNotCall
     , a.DoNotText
     , a.DoNotEmail
     , a.DoNotMail
     , a.OriginalCampaignId
     , a.convertedaccountid
     , LeadPostalCode
     , LeadSource
     , LeadFirstName
     , [TimeOfDayKey]                        as TimeOfDayESTKey
     , isduplicatebyemail
     , isduplicatebyname
     , isnull(a.LeadId, d.AccountExternalId) as LeadIdExternal
     , a.LeadExternalId                      as 'RealExternalId'
FROM DimLead_CTE a
         LEFT JOIN dimCampaign b on a.originalcampaignkey = b.campaignkey
    --left join dimdate d on a.lead_createddate=d.datekey
         LEFT JOIN dimgeography e on a.geographykey = e.geographykey
         LEFT JOIN dimCenter k on a.centerkey = k.centerkey
         LEFT JOIN dimgeography cg on k.Centergeographykey = cg.geographykey
         LEFT JOIN dimAgency Ag on b.AgencyKey = ag.AgencyKey
         LEFT JOIN dimSource sc on a.sourceKey = sc.sourcekey
         LEFT JOIN [dbo].[DimTimeOfDay] dt on dt.[Time24] = convert(time, LeadCreatedDateEST)
         LEFT JOIN dimaccount d on a.accountid = d.accountid;
GO
