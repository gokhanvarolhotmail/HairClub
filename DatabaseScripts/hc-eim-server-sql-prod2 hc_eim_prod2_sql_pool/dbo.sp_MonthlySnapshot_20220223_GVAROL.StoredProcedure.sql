/****** Object:  StoredProcedure [dbo].[sp_MonthlySnapshot_20220223_GVAROL]    Script Date: 3/23/2022 10:16:58 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 倀刀伀䌀 嬀搀戀漀崀⸀嬀猀瀀开䴀漀渀琀栀氀礀匀渀愀瀀猀栀漀琀开㈀　㈀㈀　㈀㈀㌀开䜀嘀䄀刀伀䰀崀 䄀匀ഀ
਍ഀ
insert into FactLeadTracking (LeadKey, LeadId, LeadFirstName, LeadLastname, LeadFullName, LeadBirthday, LeadAddress,਍                              䤀猀䄀挀琀椀瘀攀Ⰰ 䤀猀䌀漀渀猀甀氀琀䘀漀爀洀䌀漀洀瀀氀攀琀攀Ⰰ 䤀猀瘀愀氀椀搀Ⰰ 䰀攀愀搀䔀洀愀椀氀Ⰰ 䰀攀愀搀倀栀漀渀攀Ⰰ 䰀攀愀搀䴀漀戀椀氀攀倀栀漀渀攀Ⰰഀ
                              NorwoodScale, LudwigScale, HairLossInFamily, HairLossProductUsed, HairLossSpot,਍                              䜀攀漀最爀愀瀀栀礀䬀攀礀Ⰰ 䰀攀愀搀倀漀猀琀愀氀䌀漀搀攀Ⰰ 䔀琀栀渀椀挀椀琀礀䬀攀礀Ⰰ 䰀攀愀搀䔀琀栀渀椀挀椀琀礀Ⰰ 䜀攀渀搀攀爀䬀攀礀Ⰰ 䰀攀愀搀䜀攀渀搀攀爀Ⰰഀ
                              CenterKey, CenterNumber, LanguageKey, LeadLanguage, StatusKey, LeadStatus,਍                              䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀Ⰰ 䌀爀攀愀琀攀搀䐀愀琀攀䬀攀礀Ⰰ 䌀爀攀愀琀攀搀吀椀洀攀䬀攀礀Ⰰ 䰀攀愀搀䰀愀猀琀䄀挀琀椀瘀椀琀礀䐀愀琀攀Ⰰഀ
                              LastActivityDateKey, LastActivityTimekey, DISCStyle, LeadMaritalStatus, LeadConsultReady,਍                              䌀漀渀猀甀氀琀愀琀椀漀渀䘀漀爀洀刀攀愀搀礀Ⰰ 䤀猀䐀攀氀攀琀攀搀Ⰰ 䐀漀一漀琀䌀愀氀氀Ⰰ 䐀漀一漀琀䌀漀渀琀愀挀琀Ⰰ 䐀漀一漀琀䔀洀愀椀氀Ⰰ 䐀漀一漀琀䴀愀椀氀Ⰰഀ
                              DoNotText, CreateUser, UpdateUser, City, State, MaritalStatusKey, LeadSource, SourceKey,਍                              伀爀椀最椀渀愀氀䌀漀洀洀䴀攀琀栀漀搀欀攀礀Ⰰ 刀攀挀攀渀琀䌀漀洀洀䴀攀琀栀漀搀䬀攀礀Ⰰ 䌀漀洀洀甀渀椀挀愀琀椀漀渀䴀攀琀栀漀搀Ⰰ 䤀猀嘀愀氀椀搀䰀攀愀搀一愀洀攀Ⰰഀ
                              IsValidLeadLastName, IsValidLeadFullName, IsValidLeadPhone, IsValidLeadMobilePhone,਍                              䤀猀嘀愀氀椀搀䰀攀愀搀䔀洀愀椀氀Ⰰ 刀攀瘀椀攀眀一攀攀搀攀搀Ⰰ 䌀漀渀瘀攀爀琀攀搀䌀漀渀琀愀挀琀䤀搀Ⰰ 䌀漀渀瘀攀爀琀攀搀䄀挀挀漀甀渀琀䤀搀Ⰰഀ
                              ConvertedOpportunityId, ConvertedDate, LastModifiedDate, SourceSystem, DWH_CreatedDate,਍                              䐀圀䠀开䰀愀猀琀唀瀀搀愀琀攀䐀愀琀攀Ⰰ 䰀攀愀搀䔀砀琀攀爀渀愀氀䤀䐀Ⰰ 匀攀爀瘀椀挀攀吀攀爀爀椀琀漀爀礀䤀䐀Ⰰ 伀爀椀最椀渀愀氀䌀愀洀瀀愀椀最渀䤀搀Ⰰഀ
                              OriginalCampaignKey, AccountID, LeadOccupation, OriginalCampaignSource, GCLID,਍                              刀攀愀氀䌀爀攀愀琀攀搀䐀愀琀攀⤀ഀ
select leadkey,਍       氀攀愀搀椀搀Ⰰഀ
       leadfirstname,਍       氀攀愀搀氀愀猀琀渀愀洀攀Ⰰഀ
       leadfullname,਍       氀攀愀搀戀椀爀琀栀搀愀礀Ⰰഀ
       leadaddress,਍       椀猀愀挀琀椀瘀攀Ⰰഀ
       isconsultformcomplete,਍       椀猀瘀愀氀椀搀Ⰰഀ
       leademail,਍       氀攀愀搀瀀栀漀渀攀Ⰰഀ
       leadmobilephone,਍       渀漀爀眀漀漀搀猀挀愀氀攀Ⰰഀ
       ludwigscale,਍       栀愀椀爀氀漀猀猀椀渀昀愀洀椀氀礀Ⰰഀ
       hairlossproductused,਍       栀愀椀爀氀漀猀猀猀瀀漀琀Ⰰഀ
       geographykey,਍       氀攀愀搀瀀漀猀琀愀氀挀漀搀攀Ⰰഀ
       ethnicitykey,਍       氀攀愀搀攀琀栀渀椀挀椀琀礀Ⰰഀ
       genderkey,਍       氀攀愀搀最攀渀搀攀爀Ⰰഀ
       centerkey,਍       挀攀渀琀攀爀渀甀洀戀攀爀Ⰰഀ
       languagekey,਍       氀攀愀搀氀愀渀最甀愀最攀Ⰰഀ
       statuskey,਍       氀攀愀搀猀琀愀琀甀猀Ⰰഀ
       leadcreateddate,਍       挀爀攀愀琀攀搀搀愀琀攀欀攀礀Ⰰഀ
       createdtimekey,਍       氀攀愀搀氀愀猀琀愀挀琀椀瘀椀琀礀搀愀琀攀Ⰰഀ
       lastactivitydatekey,਍       氀愀猀琀愀挀琀椀瘀椀琀礀琀椀洀攀欀攀礀Ⰰഀ
       discstyle,਍       氀攀愀搀洀愀爀椀琀愀氀猀琀愀琀甀猀Ⰰഀ
       leadconsultready,਍       挀漀渀猀甀氀琀愀琀椀漀渀昀漀爀洀爀攀愀搀礀Ⰰഀ
       isdeleted,਍       搀漀渀漀琀挀愀氀氀Ⰰഀ
       donotcontact,਍       搀漀渀漀琀攀洀愀椀氀Ⰰഀ
       donotmail,਍       搀漀渀漀琀琀攀砀琀Ⰰഀ
       createuser,਍       甀瀀搀愀琀攀甀猀攀爀Ⰰഀ
       city,਍       猀琀愀琀攀Ⰰഀ
       maritalstatuskey,਍       氀攀愀搀猀漀甀爀挀攀Ⰰഀ
       sourcekey,਍       漀爀椀最椀渀愀氀挀漀洀洀洀攀琀栀漀搀欀攀礀Ⰰഀ
       recentcommmethodkey,਍       挀漀洀洀甀渀椀挀愀琀椀漀渀洀攀琀栀漀搀Ⰰഀ
       isvalidleadname,਍       椀猀瘀愀氀椀搀氀攀愀搀氀愀猀琀渀愀洀攀Ⰰഀ
       isvalidleadfullname,਍       椀猀瘀愀氀椀搀氀攀愀搀瀀栀漀渀攀Ⰰഀ
       isvalidleadmobilephone,਍       椀猀瘀愀氀椀搀氀攀愀搀攀洀愀椀氀Ⰰഀ
       reviewneeded,਍       挀漀渀瘀攀爀琀攀搀挀漀渀琀愀挀琀椀搀Ⰰഀ
       convertedaccountid,਍       挀漀渀瘀攀爀琀攀搀漀瀀瀀漀爀琀甀渀椀琀礀椀搀Ⰰഀ
       converteddate,਍       氀愀猀琀洀漀搀椀昀椀攀搀搀愀琀攀Ⰰഀ
       sourcesystem,਍       搀眀栀开挀爀攀愀琀攀搀搀愀琀攀Ⰰഀ
       dwh_lastupdatedate,਍       氀攀愀搀攀砀琀攀爀渀愀氀椀搀Ⰰഀ
       serviceterritoryid,਍       漀爀椀最椀渀愀氀挀愀洀瀀愀椀最渀椀搀Ⰰഀ
       originalcampaignkey,਍       愀挀挀漀甀渀琀椀搀Ⰰഀ
       leadoccupation,਍       漀爀椀最椀渀愀氀挀愀洀瀀愀椀最渀猀漀甀爀挀攀Ⰰഀ
       gclid,਍       爀攀愀氀挀爀攀愀琀攀搀搀愀琀攀ഀ
from DimLead਍眀栀攀爀攀 洀漀渀琀栀⠀挀漀渀瘀攀爀琀⠀搀愀琀攀Ⰰ 搀愀琀攀愀搀搀⠀洀椀Ⰰ 搀愀琀攀瀀愀爀琀⠀琀稀Ⰰഀ
                                               CONVERT(datetime, LeadCreatedDate) AT TIME ZONE਍                                               ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ 䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀⤀⤀⤀ 㴀ഀ
      month(dateadd(day,  -1, getdate()))਍  愀渀搀 礀攀愀爀⠀挀漀渀瘀攀爀琀⠀搀愀琀攀Ⰰ 搀愀琀攀愀搀搀⠀洀椀Ⰰ 搀愀琀攀瀀愀爀琀⠀琀稀Ⰰഀ
                                              CONVERT(datetime, LeadCreatedDate) AT TIME ZONE਍                                              ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ 䰀攀愀搀䌀爀攀愀琀攀搀䐀愀琀攀⤀⤀⤀ 㴀ഀ
      year(dateadd(day,  -1, getdate()))਍ഀ
਍椀渀猀攀爀琀 椀渀琀漀 䘀愀挀琀伀瀀瀀漀爀琀甀渀椀琀礀吀爀愀挀欀椀渀最 ⠀䘀愀挀琀䐀愀琀攀Ⰰ 䘀愀挀琀䐀愀琀攀欀攀礀Ⰰ 伀瀀瀀漀爀琀甀渀椀琀礀䤀搀Ⰰ 䰀攀愀搀䬀攀礀Ⰰ 䰀攀愀搀䤀搀Ⰰ 䄀挀挀漀甀渀琀䬀攀礀Ⰰ 䄀挀挀漀甀渀琀䤀搀Ⰰഀ
                                     OpportunityName, OpportunityDescription, StatusKey, OpportunityStatus, CampaignKey,਍                                     伀瀀瀀漀爀琀甀渀椀琀礀䌀愀洀瀀愀椀最渀Ⰰ 䌀氀漀猀攀䐀愀琀攀Ⰰ 䌀氀漀猀攀䐀愀琀攀䬀攀礀Ⰰ 䌀爀攀愀琀攀搀䐀愀琀攀Ⰰ 䌀爀攀愀琀攀搀唀猀攀爀䬀攀礀Ⰰഀ
                                     CreatedById, LastModifiedDate, UpdateUserKey, LastModifiedById, LossReasonKey,਍                                     伀瀀瀀漀爀琀甀渀椀琀礀䰀漀猀猀刀攀愀猀漀渀Ⰰ 䤀猀䐀攀氀攀琀攀搀Ⰰ 䤀猀䌀氀漀猀攀搀Ⰰ 䤀猀圀漀渀Ⰰ 伀瀀瀀漀爀琀甀渀椀琀礀刀攀昀攀爀爀愀氀䌀漀搀攀Ⰰഀ
                                     OpportunitySourceCode, OpportunitySolutionOffered, ExternalTaskId, BeBackFlag,਍                                     䌀攀渀琀攀爀䬀攀礀Ⰰ 䌀攀渀琀攀爀一甀洀戀攀爀Ⰰ 䤀猀伀氀搀Ⰰ 䄀洀洀漀甀渀琀⤀ഀ
select factdate,਍       昀愀挀琀搀愀琀攀欀攀礀Ⰰഀ
       opportunityid,਍       氀攀愀搀欀攀礀Ⰰഀ
       leadid,਍       愀挀挀漀甀渀琀欀攀礀Ⰰഀ
       accountid,਍       漀瀀瀀漀爀琀甀渀椀琀礀渀愀洀攀Ⰰഀ
       opportunitydescription,਍       猀琀愀琀甀猀欀攀礀Ⰰഀ
       opportunitystatus,਍       挀愀洀瀀愀椀最渀欀攀礀Ⰰഀ
       opportunitycampaign,਍       挀氀漀猀攀搀愀琀攀Ⰰഀ
       closedatekey,਍       挀爀攀愀琀攀搀搀愀琀攀Ⰰഀ
       createduserkey,਍       挀爀攀愀琀攀搀戀礀椀搀Ⰰഀ
       lastmodifieddate,਍       甀瀀搀愀琀攀甀猀攀爀欀攀礀Ⰰഀ
       lastmodifiedbyid,਍       氀漀猀猀爀攀愀猀漀渀欀攀礀Ⰰഀ
       opportunitylossreason,਍       椀猀搀攀氀攀琀攀搀Ⰰഀ
       isclosed,਍       椀猀眀漀渀Ⰰഀ
       opportunityreferralcode,਍       漀瀀瀀漀爀琀甀渀椀琀礀猀漀甀爀挀攀挀漀搀攀Ⰰഀ
       opportunitysolutionoffered,਍       攀砀琀攀爀渀愀氀琀愀猀欀椀搀Ⰰഀ
       bebackflag,਍       挀攀渀琀攀爀欀攀礀Ⰰഀ
       centernumber,਍       椀猀漀氀搀Ⰰഀ
       ammount਍昀爀漀洀 䘀愀挀琀伀瀀瀀漀爀琀甀渀椀琀礀ഀ
where month(convert(date, dateadd(mi, datepart(tz,਍                                               䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ 䘀愀挀琀䐀愀琀攀⤀ 䄀吀 吀䤀䴀䔀 娀伀一䔀ഀ
                                               'Eastern Standard Time'), FactDate))) =਍      洀漀渀琀栀⠀搀愀琀攀愀搀搀⠀搀愀礀Ⰰ  ⴀ㄀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀⤀ഀ
  and year(convert(date, dateadd(mi, datepart(tz,਍                                              䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ 䘀愀挀琀䐀愀琀攀⤀ 䄀吀 吀䤀䴀䔀 娀伀一䔀ഀ
                                              'Eastern Standard Time'), FactDate))) = year(dateadd(day,  -1, getdate()))਍ഀ
਍䤀一匀䔀刀吀 椀渀琀漀 䘀愀挀琀䄀瀀瀀漀椀渀琀洀攀渀琀吀爀愀挀欀椀渀最 ⠀䘀愀挀琀䐀愀琀攀Ⰰ 䘀愀挀琀吀椀洀攀䬀攀礀Ⰰ 䘀愀挀琀䐀愀琀攀䬀攀礀Ⰰ 䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀Ⰰ 䄀瀀瀀漀椀渀琀洀攀渀琀吀椀洀攀䬀攀礀Ⰰഀ
                                     AppointmentDateKey, LeadKey, LeadId, AccountKey, AccountId, ContactKey, ContactId,਍                                     倀愀爀攀渀琀刀攀挀漀爀搀吀礀瀀攀Ⰰ 圀漀爀欀吀礀瀀攀䬀攀礀Ⰰ 圀漀爀欀吀礀瀀攀䤀搀Ⰰ 䄀挀挀漀甀渀琀䄀搀搀爀攀猀猀Ⰰ 䄀挀挀漀甀渀琀䌀椀琀礀Ⰰഀ
                                     AccountState, AccountPostalCode, AccountCountry, GeographyKey,਍                                     䄀瀀瀀漀椀渀琀洀攀渀琀䐀攀猀挀爀椀瀀琀椀漀渀Ⰰ 䄀瀀瀀漀椀渀琀洀攀渀琀匀琀愀琀甀猀Ⰰ 䌀攀渀琀攀爀䬀攀礀Ⰰ 匀攀爀瘀椀挀攀吀攀爀爀椀琀漀爀礀䤀搀Ⰰഀ
                                     CenterNumber, AppointmentTypeKey, AppointmentType, AppointmentCenterType,਍                                     䔀砀琀攀爀渀愀氀䤀搀Ⰰ 匀攀爀瘀椀挀攀䄀瀀瀀漀椀渀琀洀攀渀琀Ⰰ 䴀攀攀琀椀渀最倀氀愀琀昀漀爀洀䬀攀礀Ⰰ 䴀攀攀琀椀渀最倀氀愀琀昀漀爀洀䤀搀Ⰰഀ
                                     MeetingPlatform, DWH_LoadDate, DWH_LastUpdateDate, ParentRecordId, AppointmentId,਍                                     䔀砀琀攀爀渀愀氀吀愀猀欀䤀搀Ⰰ 匀琀愀琀甀猀䬀攀礀Ⰰ 䌀愀渀挀攀氀氀愀琀椀漀渀刀攀愀猀漀渀Ⰰ 䈀攀䈀愀挀欀䘀氀愀最Ⰰ 伀氀搀匀琀愀琀甀猀Ⰰഀ
                                     AppoinmentStatusCategory, IsDeleted, IsOld, OpportunityId, OpportunityStatus,਍                                     伀瀀瀀漀爀琀甀渀椀琀礀䐀愀琀攀Ⰰ 伀瀀瀀漀爀琀甀渀椀琀礀刀攀昀攀爀爀愀氀䌀漀搀攀Ⰰ 伀瀀瀀漀爀琀甀渀椀琀礀刀攀昀攀爀爀愀氀䌀漀搀攀䔀砀瀀椀爀愀琀椀漀渀䐀愀琀攀Ⰰഀ
                                     OpportunityAmount)਍猀攀氀攀挀琀 䘀愀挀琀䐀愀琀攀Ⰰഀ
       FactTimeKey,਍       䘀愀挀琀䐀愀琀攀䬀攀礀Ⰰഀ
       AppointmentDate,਍       䄀瀀瀀漀椀渀琀洀攀渀琀吀椀洀攀䬀攀礀Ⰰഀ
       AppointmentDateKey,਍       䰀攀愀搀䬀攀礀Ⰰഀ
       LeadId,਍       䄀挀挀漀甀渀琀䬀攀礀Ⰰഀ
       AccountId,਍       䌀漀渀琀愀挀琀䬀攀礀Ⰰഀ
       ContactId,਍       倀愀爀攀渀琀刀攀挀漀爀搀吀礀瀀攀Ⰰഀ
       WorkTypeKey,਍       圀漀爀欀吀礀瀀攀䤀搀Ⰰഀ
       AccountAddress,਍       䄀挀挀漀甀渀琀䌀椀琀礀Ⰰഀ
       AccountState,਍       䄀挀挀漀甀渀琀倀漀猀琀愀氀䌀漀搀攀Ⰰഀ
       AccountCountry,਍       䜀攀漀最爀愀瀀栀礀䬀攀礀Ⰰഀ
       AppointmentDescription,਍       䄀瀀瀀漀椀渀琀洀攀渀琀匀琀愀琀甀猀Ⰰഀ
       CenterKey,਍       匀攀爀瘀椀挀攀吀攀爀爀椀琀漀爀礀䤀搀Ⰰഀ
       CenterNumber,਍       䄀瀀瀀漀椀渀琀洀攀渀琀吀礀瀀攀䬀攀礀Ⰰഀ
       AppointmentType,਍       䄀瀀瀀漀椀渀琀洀攀渀琀䌀攀渀琀攀爀吀礀瀀攀Ⰰഀ
       ExternalId,਍       匀攀爀瘀椀挀攀䄀瀀瀀漀椀渀琀洀攀渀琀Ⰰഀ
       MeetingPlatformKey,਍       䴀攀攀琀椀渀最倀氀愀琀昀漀爀洀䤀搀Ⰰഀ
       MeetingPlatform,਍       䐀圀䠀开䰀漀愀搀䐀愀琀攀Ⰰഀ
       DWH_LastUpdateDate,਍       倀愀爀攀渀琀刀攀挀漀爀搀䤀搀Ⰰഀ
       AppointmentId,਍       䔀砀琀攀爀渀愀氀吀愀猀欀䤀搀Ⰰഀ
       StatusKey,਍       䌀愀渀挀攀氀氀愀琀椀漀渀刀攀愀猀漀渀Ⰰഀ
       BeBackFlag,਍       伀氀搀匀琀愀琀甀猀Ⰰഀ
       AppoinmentStatusCategory,਍       䤀猀䐀攀氀攀琀攀搀Ⰰഀ
       IsOld,਍       伀瀀瀀漀爀琀甀渀椀琀礀䤀搀Ⰰഀ
       OpportunityStatus,਍       伀瀀瀀漀爀琀甀渀椀琀礀䐀愀琀攀Ⰰഀ
       OpportunityReferralCode,਍       伀瀀瀀漀爀琀甀渀椀琀礀刀攀昀攀爀爀愀氀䌀漀搀攀䔀砀瀀椀爀愀琀椀漀渀䐀愀琀攀Ⰰഀ
       OpportunityAmmount਍昀爀漀洀 䘀愀挀琀䄀瀀瀀漀椀渀琀洀攀渀琀ഀ
where month(convert(date, dateadd(mi, datepart(tz,਍                                               䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ 䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀⤀ 䄀吀 吀䤀䴀䔀 娀伀一䔀ഀ
                                               'Eastern Standard Time'), AppointmentDate))) =਍      洀漀渀琀栀⠀搀愀琀攀愀搀搀⠀搀愀礀Ⰰ  ⴀ㄀Ⰰ 最攀琀搀愀琀攀⠀⤀⤀⤀ഀ
  and year(convert(date, dateadd(mi, datepart(tz,਍                                              䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ 䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀⤀ 䄀吀 吀䤀䴀䔀 娀伀一䔀ഀ
                                              'Eastern Standard Time'), AppointmentDate))) = year(dateadd(day,  -1, getdate()))਍䜀伀ഀഀ
