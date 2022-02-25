/****** Object:  View [dbo].[vwFactActivityResults]    Script Date: 2/22/2022 9:20:30 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀搀戀漀崀⸀嬀瘀眀䘀愀挀琀䄀挀琀椀瘀椀琀礀刀攀猀甀氀琀猀崀ഀഀ
AS SELECT ਍ऀऀ䌀䄀匀吀⠀搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ琀⸀嬀䄀挀琀椀瘀椀琀礀䐀愀琀攀崀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ琀⸀嬀䄀挀琀椀瘀椀琀礀䐀愀琀攀崀⤀ 䄀匀 䐀䄀吀䔀⤀ 愀猀 倀愀爀琀椀琀椀漀渀䐀愀琀攀ഀഀ
		,d2.[DateKey] AS ActivityResultDateKey਍ऀऀⰀ✀ⴀ㄀✀ 䄀匀 䄀挀琀椀瘀椀琀礀刀攀猀甀氀琀䬀攀礀ഀഀ
		,dt2.[TimeOfDayKey] AS ActivityResultTimeKey਍ऀऀⰀ✀ⴀ㄀✀ 䄀匀 䄀挀琀椀瘀椀琀礀䬀攀礀ഀഀ
		,NULL AS ActivityDateKey਍ऀऀⰀ一唀䰀䰀 䄀匀 䄀挀琀椀瘀椀琀礀吀椀洀攀䬀攀礀ഀഀ
		,d2.[DateKey] AS ActivityCompletedDateKey਍ऀऀⰀ搀琀㈀⸀嬀吀椀洀攀伀昀䐀愀礀䬀攀礀崀 䄀匀 䄀挀琀椀瘀椀琀礀䌀漀洀瀀氀攀琀攀搀吀椀洀攀䬀攀礀ഀഀ
		,d.[DateKey] AS ActivityDueDateKey਍ऀऀⰀ搀琀⸀嬀吀椀洀攀伀昀䐀愀礀䬀攀礀崀 䄀匀 䄀挀琀椀瘀椀琀礀匀琀愀爀琀吀椀洀攀䬀攀礀ഀഀ
		,CAST(dateadd(mi,datepart(tz,CONVERT(datetime,t.[ActivityDate])    AT TIME ZONE 'Eastern Standard Time'),t.[ActivityDate]) AS DATE) AS OriginalAppointmentDateKey਍ऀऀⰀ搀㌀⸀嬀䐀愀琀攀䬀攀礀崀 䄀匀 䄀挀琀椀瘀椀琀礀匀愀瘀攀搀䐀愀琀攀䬀攀礀ഀഀ
		,dt3.[TimeOfDayKey] AS ActivitySavedTimeKey਍ऀऀⰀ搀氀⸀氀攀愀搀欀攀礀 䄀匀 䌀漀渀琀愀挀琀䬀攀礀ഀഀ
		,dl.centerkey AS CenterKey਍ऀऀⰀ✀ⴀ㄀✀ 䄀匀 匀愀氀攀猀吀礀瀀攀䬀攀礀ഀഀ
		,dl.sourceKey AS SourceKey਍ऀऀⰀ✀ⴀ㄀✀ 䄀匀 䄀挀琀椀漀渀䌀漀搀攀䬀攀礀ഀഀ
		,t.[Result__c] AS ResultCodeKey਍ऀऀⰀ搀最⸀嬀䜀攀渀搀攀爀䬀攀礀崀 䄀匀 䜀攀渀搀攀爀䬀攀礀ഀഀ
		,do.[OccupationKey] AS OccupationKey਍ऀऀⰀ攀琀⸀嬀䔀琀栀渀椀挀椀琀礀䬀攀礀崀 䄀匀 䔀琀栀渀椀挀椀琀礀䬀攀礀ഀഀ
		,m.[MaritalStatusKey] AS MaritalStatusKey਍ऀऀⰀ✀ⴀ㄀✀ 䄀匀 䠀愀椀爀䰀漀猀猀吀礀瀀攀䬀攀礀ഀഀ
		,'-1' AS AgeRangeKey਍ऀऀⰀ✀ⴀ㄀✀ 䄀匀 䌀漀洀瀀氀攀琀攀搀䈀礀䔀洀瀀氀漀礀攀攀䬀攀礀ഀഀ
		,NULL AS ClientNumber਍ऀऀⰀ䌀䄀匀䔀 圀䠀䔀一 昀氀⸀䄀瀀瀀漀椀渀琀洀攀渀琀猀 㸀 ✀　✀ 吀䠀䔀一 ✀㄀✀ഀഀ
			ELSE '0' ਍ऀऀऀ䔀一䐀 䄀匀 䄀瀀瀀漀椀渀琀洀攀渀琀猀ഀഀ
		,CASE WHEN fl.shows > '0' THEN '1'਍ऀऀऀ䔀䰀匀䔀 ✀　✀ഀഀ
			END AS Shows਍ऀऀⰀ䌀䄀匀䔀 圀䠀䔀一 昀氀⸀猀愀氀攀猀 㸀 ✀　✀ 吀䠀䔀一 ✀㄀✀ഀഀ
			ELSE '0' ਍ऀऀऀ䔀一䐀 䄀匀 匀愀氀攀猀ഀഀ
		,CASE WHEN fl.noshows > '0' THEN '1'਍ऀऀऀ䔀䰀匀䔀 ✀　✀ ഀഀ
			END AS NoShows਍ऀऀⰀ䌀䄀匀䔀 圀䠀䔀一 昀氀⸀渀漀猀愀氀攀猀 㸀 ✀　✀ 吀䠀䔀一 ✀㄀✀ഀഀ
			ELSE '0' ਍ऀऀऀ䔀一䐀 䄀匀 一漀匀愀氀攀猀ഀഀ
		,NULL AS Consultation਍ऀऀⰀ一唀䰀䰀 䄀匀 䈀攀䈀愀挀欀ഀഀ
		,NULL AS BebackAlt਍ऀऀⰀ一唀䰀䰀 䄀匀 䈀攀䈀愀挀欀一漀匀栀漀眀ഀഀ
		,'0' AS SurgeryOffered਍ऀऀⰀ✀　✀ 䄀匀 刀攀昀攀爀爀攀搀吀漀䐀漀挀琀漀爀ഀഀ
		,'0' AS InitialPayment਍ऀऀⰀ✀ⴀ㄀✀ 䄀匀 䄀挀琀椀瘀椀琀礀䔀洀瀀氀漀礀攀攀䬀攀礀ഀഀ
		,NULL AS LeadSourceKey਍ऀऀⰀ一唀䰀䰀 䄀匀 倀爀漀洀漀䌀漀搀攀䬀攀礀ഀഀ
		,NULL AS LTValue਍ऀऀⰀ一唀䰀䰀 䄀匀 䰀吀嘀愀氀甀攀夀爀ഀഀ
		,NULL AS Inhouse਍ऀऀⰀ一唀䰀䰀 䄀匀 䈀伀匀䄀瀀瀀琀ഀഀ
		,CASE WHEN c.sourcecode = 'BOSREF' THEN c.sourcecode਍ऀऀऀ䔀䰀匀䔀 一唀䰀䰀 ഀഀ
			END AS BOSRef਍ऀऀⰀ䌀䄀匀䔀 圀䠀䔀一 挀⸀猀漀甀爀挀攀挀漀搀攀 椀渀 ⠀✀䈀伀匀䐀䴀刀䔀䘀✀Ⰰ✀䈀伀匀䈀䤀伀䔀䴀刀䔀䘀✀Ⰰ✀䈀伀匀䈀䤀伀䐀䴀刀䔀䘀✀⤀ 吀䠀䔀一 挀⸀猀漀甀爀挀攀挀漀搀攀ഀഀ
			ELSE NULL਍ऀऀऀ䔀一䐀 䄀匀 䈀伀匀伀琀栀刀攀昀ഀഀ
		,CASE WHEN c.sourcecode in ('CORP REFER','REFERAFRND','STYLEREFER','REGISSTYRFR','NBREFCARD','IPREFCLRERECA12476','IPREFCLRERECA12476DC','IPREFCLRERECA12476DF','IPREFCLRERECA12476DP','IPREFCLRERECA12476MC','IPREFCLRERECA12476MF','IPREFCLRERECA12476MP') THEN c.sourcecode਍ऀऀऀ䔀䰀匀䔀 一唀䰀䰀ഀഀ
			END AS HCRef਍ऀऀⰀ昀氀⸀嬀䰀攀愀搀䌀爀攀愀琀椀漀渀䐀愀琀攀䬀攀礀崀 䄀匀 䰀攀愀搀䌀爀攀愀琀椀漀渀䐀愀琀攀䬀攀礀ഀഀ
		,fl.[LeadCreationTimeKey] AS LeadCreationTimeKey਍ऀऀⰀ一唀䰀䰀 䄀匀 䄀挀挀漀洀漀搀愀琀椀漀渀ഀഀ
		,c.SourceCode AS RecentLeadSourceKey਍    昀爀漀洀 嬀伀䐀匀崀⸀嬀匀䘀开吀愀猀欀崀 琀ഀഀ
  left join dbo.dimLead dl on isnull(dl.LeadId,dl.convertedcontactid) = t.[WhoId]਍  氀攀昀琀 樀漀椀渀 搀戀漀⸀搀椀洀䐀愀琀攀 搀 漀渀 搀⸀昀甀氀氀䐀愀琀攀 㴀 䌀䄀匀吀⠀搀愀琀攀愀搀搀⠀洀椀Ⰰ搀愀琀攀瀀愀爀琀⠀琀稀Ⰰ䌀伀一嘀䔀刀吀⠀搀愀琀攀琀椀洀攀Ⰰ琀⸀嬀䄀挀琀椀瘀椀琀礀䐀愀琀攀崀⤀    䄀吀 吀䤀䴀䔀 娀伀一䔀 ✀䔀愀猀琀攀爀渀 匀琀愀渀搀愀爀搀 吀椀洀攀✀⤀Ⰰ琀⸀嬀䄀挀琀椀瘀椀琀礀䐀愀琀攀崀⤀ 䄀匀 䐀䄀吀䔀⤀ഀഀ
  left join dbo.DimTimeOfDay dt on dt.[Time24] = CAST(dateadd(mi,datepart(tz,CONVERT(datetime,t.[ActivityDate])    AT TIME ZONE 'Eastern Standard Time'),t.[ActivityDate]) AS TIME)਍  氀攀昀琀 樀漀椀渀 搀戀漀⸀搀椀洀䜀攀渀搀攀爀 搀最 漀渀 搀最⸀嬀䜀攀渀搀攀爀䬀攀礀崀 㴀 搀氀⸀嬀䜀攀渀搀攀爀䬀攀礀崀ഀഀ
  left join dbo.dimEthnicity et on et.[EthnicityKey] = dl.[EthnicityKey]਍  氀攀昀琀 樀漀椀渀 搀戀漀⸀搀椀洀䴀愀爀椀琀愀氀匀琀愀琀甀猀 洀 漀渀 洀⸀嬀䴀愀爀椀琀愀氀匀琀愀琀甀猀䬀攀礀崀 㴀 搀氀⸀嬀䴀愀爀椀琀愀氀匀琀愀琀甀猀䬀攀礀崀ഀഀ
  left join dbo.dimCampaign c on dl.originalcampaignId = c.campaignid਍  氀攀昀琀 樀漀椀渀 搀戀漀⸀搀椀洀倀爀漀洀漀琀椀漀渀 搀瀀 漀渀 搀瀀⸀嬀倀爀漀洀漀琀椀漀渀䤀搀崀 㴀 挀⸀嬀倀爀漀洀漀䌀漀搀攀崀ഀഀ
  left join dbo.dimSystemUser su on su.[UserId] = dl.[CreateUser]਍  氀攀昀琀 樀漀椀渀 搀戀漀⸀搀椀洀匀漀甀爀挀攀  猀挀 漀渀 搀氀⸀猀漀甀爀挀攀䬀攀礀㴀猀挀⸀猀漀甀爀挀攀欀攀礀ഀഀ
  left join dbo.dimOccupation do on dl.LeadOccupation = do.[OccupationName]਍  氀攀昀琀 樀漀椀渀 搀戀漀⸀搀椀洀䐀愀琀攀 搀㈀ 漀渀 搀㈀⸀昀甀氀氀䐀愀琀攀 㴀 挀愀猀琀⠀琀⸀䌀漀洀瀀氀攀琀攀搀䐀愀琀攀吀椀洀攀 愀猀 搀愀琀攀⤀ഀഀ
  left join dbo.DimTimeOfDay dt2 on dt2.[Time24] = cast(t.CompletedDateTime as time)਍  氀攀昀琀 樀漀椀渀 搀戀漀⸀搀椀洀䐀愀琀攀 搀㌀ 漀渀 搀㌀⸀昀甀氀氀䐀愀琀攀 㴀 䌀䄀匀吀⠀琀⸀嬀䰀愀猀琀䴀漀搀椀昀椀攀搀䐀愀琀攀崀 䄀匀 䐀䄀吀䔀⤀ഀഀ
  left join dbo.DimTimeOfDay dt3 on dt3.[Time24] = CAST(t.[LastModifiedDate] AS time)਍  氀攀昀琀 樀漀椀渀 嬀搀戀漀崀⸀嬀嘀圀䘀愀挀琀䰀攀愀搀崀 昀氀 漀渀 昀氀⸀氀攀愀搀椀搀 㴀 琀⸀眀栀漀椀搀㬀ഀഀ
GO਍
