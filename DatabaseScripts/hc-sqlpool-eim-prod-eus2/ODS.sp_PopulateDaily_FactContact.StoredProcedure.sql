/****** Object:  StoredProcedure [ODS].[sp_PopulateDaily_FactContact]    Script Date: 1/7/2022 4:05:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [ODS].[sp_PopulateDaily_FactContact] AS
BEGIN
	
	TRUNCATE TABLE [Reports].[FactContact]


-----------------------------------------------------CREATE TEM TABLES--------------------------------------------------

	
	CREATE TABLE #ContactTask
	(
		[Company] [nvarchar](18) NULL,
		[LeadID] [nvarchar](18) NULL,
		[GCLID] [nvarchar](100) NULL,
		[HashedEmail] [varchar](4000) NULL,
		[Start_Date] [datetime] NULL,
		[Date] [date] NULL,
		[Time] [time](7) NULL,
		[DayPart] [nvarchar](20) NULL,
		[Hour] [varchar](10) NULL,
		[Minute] [smallint] NULL,
		[Seconds] [smallint] NULL,
		[LastName] [nvarchar](100) NULL,
		[FirstName] [nvarchar](100) NULL,
		[Phone] [nvarchar](100) NULL,
		[MobilePhone] [nvarchar](100) NULL,
		[Email] [nvarchar](200) NULL,
		[Sourcecode] [nvarchar](500) NULL,
		[DialedNumber] [nvarchar] (100) NULL,
		[PhoneNumberAreaCode] [nvarchar](10) NULL,
		[CampaignAgency] [nvarchar](50) NULL,
		[CampaignChannel] [nvarchar](50) NULL,
		[CampaignMedium] [nvarchar](50) NULL,
		[CampaignName] [nvarchar](80) NULL,
		[CampaignFormat] [nvarchar](50) NULL,
		[CampaignCompany] [nvarchar](50) NULL,
		[CampaignLocation] [nvarchar](50) NULL,
		[CampaignBudgetName] [nvarchar](50) NULL,
		[CampaignLanguage] [nvarchar](100) NULL,
		[CampaignPromotionCode] [nvarchar](100) NULL,
		[CampaignLandingPageURL] [nvarchar](1250) NULL,
		[CampaignStartDate] [datetime] NULL,
		[CampaignEndDate] [datetime] NULL,
		[CampaignStatus] [nvarchar](50) NULL,
		[PostalCode] [nvarchar](50) NULL,
		[TotalTime] [bigint] NULL,
		[IVRTime] [bigint] NULL,
		[TalkTime] [bigint] NULL,
		[RawContact] [int] NULL,
		[AbandonedContact] [int] NULL,
		[Contact] [int] NULL,
		[QualifiedContact] [int] NULL,
		[NonQualifiedContact] [int] NULL,
		[Pkid] [varchar](1024) NULL,
		[TaskId] [varchar](1024) NULL,
		[TollFreeName] [varchar](1024) NULL,
		[TollFreeMobileName] [varchar](1024) NULL,
		[original_destination_phone] [varchar](1024) NULL,
		[custom2] [varchar](1024) NULL,
		[OriginalCampaign__c][varchar](1024) NULL

	)

	CREATE TABLE #ContactBP
	(
		[Company] [nvarchar](18) NULL,
		[LeadID] [nvarchar](18) NULL,
		[GCLID] [nvarchar](100) NULL,
		[HashedEmail] [varchar](4000) NULL,
		[Start_Date] [datetime] NULL,
		[Date] [date] NULL,
		[Time] [time](7) NULL,
		[DayPart] [nvarchar](20) NULL,
		[Hour] [varchar](10) NULL,
		[Minute] [smallint] NULL,
		[Seconds] [smallint] NULL,
		[LastName] [nvarchar](100) NULL,
		[FirstName] [nvarchar](100) NULL,
		[Phone] [nvarchar](100) NULL,
		[MobilePhone] [nvarchar](100) NULL,
		[Email] [nvarchar](200) NULL,
		[Sourcecode] [nvarchar](500) NULL,
		[DialedNumber] [nvarchar] (100) NULL,
		[PhoneNumberAreaCode] [nvarchar](10) NULL,
		[CampaignAgency] [nvarchar](50) NULL,
		[CampaignChannel] [nvarchar](50) NULL,
		[CampaignMedium] [nvarchar](50) NULL,
		[CampaignName] [nvarchar](80) NULL,
		[CampaignFormat] [nvarchar](50) NULL,
		[CampaignCompany] [nvarchar](50) NULL,
		[CampaignLocation] [nvarchar](50) NULL,
		[CampaignBudgetName] [nvarchar](50) NULL,
		[CampaignLanguage] [nvarchar](100) NULL,
		[CampaignPromotionCode] [nvarchar](100) NULL,
		[CampaignLandingPageURL] [nvarchar](1250) NULL,
		[CampaignStartDate] [datetime] NULL,
		[CampaignEndDate] [datetime] NULL,
		[CampaignStatus] [nvarchar](50) NULL,
		[PostalCode] [nvarchar](50) NULL,
		[TotalTime] [bigint] NULL,
		[IVRTime] [bigint] NULL,
		[TalkTime] [bigint] NULL,
		[RawContact] [int] NULL,
		[AbandonedContact] [int] NULL,
		[Contact] [int] NULL,
		[QualifiedContact] [int] NULL,
		[NonQualifiedContact] [int] NULL,
		[Pkid] [varchar](1024) NULL,
		[TaskId] [varchar](1024) NULL,
		[TollFreeName] [varchar](1024) NULL,
		[TollFreeMobileName] [varchar](1024) NULL,
		[original_destination_phone] [varchar](1024) NULL,
		[custom2] [varchar](1024) NULL,
		[OriginalCampaign__c][varchar](1024) NULL
	)

	CREATE TABLE #ContactTable
	(
		[Company] [nvarchar](18) NULL,
		[LeadID] [nvarchar](18) NULL,
		[GCLID] [nvarchar](100) NULL,
		[HashedEmail] [varchar](4000) NULL,
		[Start_Date] [datetime] NULL,
		[Date] [date] NULL,
		[Time] [time](7) NULL,
		[DayPart] [nvarchar](20) NULL,
		[Hour] [varchar](10) NULL,
		[Minute] [smallint] NULL,
		[Seconds] [smallint] NULL,
		[LastName] [nvarchar](100) NULL,
		[FirstName] [nvarchar](100) NULL,
		[Phone] [nvarchar](100) NULL,
		[MobilePhone] [nvarchar](100) NULL,
		[Email] [nvarchar](200) NULL,
		[Sourcecode] [nvarchar](500) NULL,
		[DialedNumber] [nvarchar] (100) NULL,
		[PhoneNumberAreaCode] [nvarchar](10) NULL,
		[CampaignAgency] [nvarchar](50) NULL,
		[CampaignChannel] [nvarchar](50) NULL,
		[CampaignMedium] [nvarchar](50) NULL,
		[CampaignName] [nvarchar](80) NULL,
		[CampaignFormat] [nvarchar](50) NULL,
		[CampaignCompany] [nvarchar](50) NULL,
		[CampaignLocation] [nvarchar](50) NULL,
		[CampaignBudgetName] [nvarchar](50) NULL,
		[CampaignLanguage] [nvarchar](100) NULL,
		[CampaignPromotionCode] [nvarchar](100) NULL,
		[CampaignLandingPageURL] [nvarchar](1250) NULL,
		[CampaignStartDate] [datetime] NULL,
		[CampaignEndDate] [datetime] NULL,
		[CampaignStatus] [nvarchar](50) NULL,
		[PostalCode] [nvarchar](50) NULL,
		[TotalTime] [bigint] NULL,
		[IVRTime] [bigint] NULL,
		[TalkTime] [bigint] NULL,
		[RawContact] [int] NULL,
		[AbandonedContact] [int] NULL,
		[Contact] [int] NULL,
		[QualifiedContact] [int] NULL,
		[NonQualifiedContact] [int] NULL,
		[Pkid] [varchar](1024) NULL,
		[TaskId] [varchar](1024) NULL,
		[TollFreeName] [varchar](1024) NULL,
		[TollFreeMobileName] [varchar](1024) NULL,
		[original_destination_phone] [varchar](1024) NULL,
		[custom2] [varchar](1024) NULL,
		[OriginalCampaign__c][varchar](1024) NULL
	)

	create TABLE #temporalSource
	(
		id varchar(250) NULL,
		names varchar(250) NULL,
		value varchar(250) NULL,
		[CampaignAgency] [nvarchar](50) NULL,
		[CampaignChannel] [nvarchar](50) NULL,
		[CampaignMedium] [nvarchar](50) NULL,
		[CampaignName] [nvarchar](80) NULL,
		[CampaignFormat] [nvarchar](50) NULL,
		[CampaignCompany] [nvarchar](50) NULL,
		[CampaignLocation] [nvarchar](50) NULL,
		[CampaignBudgetName] [nvarchar](50) NULL,
		[CampaignLanguage] [nvarchar](100) NULL,
		[CampaignPromotionCode] [nvarchar](100) NULL,
		[CampaignStartDate] [datetime] NULL,
		[CampaignEndDate] [datetime] NULL,
		[CampaignStatus] [nvarchar](50) NULL

	)

	create TABLE #temporalPhone
	(
		id varchar(250) NULL,
		names varchar(250) NULL,
		value varchar(250) NULL,
		[TollFreeName] [varchar](1024) NULL,
		[TollFreeMobileName] [varchar](1024) NULL,
		[CampaignAgency] [nvarchar](50) NULL,
		[CampaignChannel] [nvarchar](50) NULL,
		[CampaignMedium] [nvarchar](50) NULL,
		[CampaignName] [nvarchar](80) NULL,
		[CampaignFormat] [nvarchar](50) NULL,
		[CampaignCompany] [nvarchar](50) NULL,
		[CampaignLocation] [nvarchar](50) NULL,
		[CampaignBudgetName] [nvarchar](50) NULL,
		[CampaignLanguage] [nvarchar](100) NULL,
		[CampaignPromotionCode] [nvarchar](100) NULL,
		[CampaignStartDate] [datetime] NULL,
		[CampaignEndDate] [datetime] NULL,
		[CampaignStatus] [nvarchar](50) NULL

	)
	
----------------------------------------------INSERT INTO TABLES----------------------------------------------------
	INSERT INTO #ContactTask
	SELECT --ROW_NUMBER() OVER (PARTITION BY t.WhoId ORDER BY t.CreatedDate, t.StartTime__c ASC) AS 'RowID',
		   CASE WHEN(ct.CenterTypeDescription = 'Hans Wiemann') THEN 'Hans Wiemann'
				ELSE 'Hairclub'
				END AS 'Company',
		   l.id AS 'LeadID',
		   l.GCLID__c AS 'GCLID',
		   LOWER(CONVERT(VARCHAR(128),hashbytes('SHA2_256', [ODS].[ValidMail](l.Email) ),2)) AS 'HashedEmail',
		   CASE WHEN (bpcd.start_time IS NOT NULL) THEN dateadd(mi,datepart(tz,CONVERT(datetime,bpcd.start_time)    AT TIME ZONE 'Eastern Standard Time'),bpcd.start_time)
				ELSE dateadd(mi,datepart(tz,CONVERT(datetime,t.ActivityDate)    AT TIME ZONE 'Eastern Standard Time'),t.ActivityDate)
				END as 'Start_Date',
		   CASE WHEN (bpcd.start_time IS NOT NULL) THEN cast(dateadd(mi,datepart(tz,CONVERT(datetime,bpcd.start_time)    AT TIME ZONE 'Eastern Standard Time'),bpcd.start_time) as date)
				ELSE cast(dateadd(mi,datepart(tz,CONVERT(datetime,t.ActivityDate)    AT TIME ZONE 'Eastern Standard Time'),t.ActivityDate) as date)
				END as Date,
		   CASE WHEN (cast(bpcd.start_time as time) is null) THEN cast(t.CreatedTime__c as time)
				ELSE cast(dateadd(mi,datepart(tz,CONVERT(datetime,bpcd.start_time)    AT TIME ZONE 'Eastern Standard Time'),bpcd.start_time) as time)
				END as time,
		   dtd.DayPart AS 'DayPart',
		   dtd.[Hour] AS 'Hour',
		   dtd.[minute] AS 'Minute',
		   dtd.[Second] AS 'Seconds',
		   TRIM(l.LastName),
		   TRIM(l.FirstName),
		   REPLACE(REPLACE(REPLACE(REPLACE(l.[Phone],'(',''),')',''),' ',''),'-','') as 'Phone',
		   REPLACE(REPLACE(REPLACE(REPLACE(l.[MobilePhone],'(',''),')',''),' ',''),'-','') AS 'MobilePhone',
		   TRIM(l.Email),
		   CASE WHEN (bpcd.custom2 IS NULL) THEN t.SourceCode__c 
				ELSE bpcd.custom2
				END AS 'Sourcecode',
		   NULL AS [DialedNumber],
		   left(l.PhoneAbr__c,3) AS 'PhoneNumberAreaCode',
		   c.[Type] AS 'CampaignAgency',
		   c.CHANNEL__C  AS 'CampaignChannel',
		   c.MEDIA__C AS 'CampaignMedium',
		   c.[NAME] AS 'CampaignName',
		   c.FORMAT__C AS 'CampaignFormat',
		   c.[Location__c] AS 'CampaignLocation',
		   c.[Company__c] AS 'CampaignCompany',
		   CASE WHEN (c.[Location__c] LIKE '%BARTH%' OR c.[Location__c] LIKE '%LOCAL US%') THEN 'Barth'
				WHEN (c.[Location__c] LIKE '%CANADA%' OR c.[Location__c] LIKE '%NATIONAL CA%' OR c.[Location__c] LIKE '%LOCAL CA%') THEN 'Canada'
				WHEN (c.[Location__c] LIKE '%USA%' OR c.[Location__c] LIKE '%NATIONAL US%') THEN 'United States'
				WHEN (c.[Location__c] LIKE '%ECOMMERCE%') THEN 'Ecommerce'
				WHEN (c.[Location__c] LIKE '%HANS%') THEN 'Hans'
				WHEN (c.[Location__c] LIKE '%PUERTO RICO%') THEN 'Puerto Rico'
				ELSE
				'Unknown' END AS 'CampaignBudgetName',
		   c.[Language__c] AS 'CampaignLanguage',
		   c.[PromoCodeName__c] AS 'CampaignPromotionCode',
		   cast(l.[HTTPReferrer__c] as nvarchar(1000)) AS 'CampaignLandingPageURL',
		   c.STARTDATE AS 'CampaignStartDate',
		   c.ENDDATE AS 'CampaignEndDate',
		   c.[STATUS] AS 'CampaignStatus',
		   l.[PostalCode] AS 'PostalCode',
		   bpcd.[duration]  AS 'TotalTime',
		   bpcd.[ivr_time] AS 'IVRTime',
		   bpcd.[talk_time] AS 'TalkTime',
		   1 AS 'RawContact',
		   CASE WHEN (bpcd.[disposition] like 'Abandon%' OR bpcd.[disposition] like 'System_dis%') THEN 1 ELSE 0 END AS 'AbandonedContact',
		   CASE	WHEN ((bpcd.[disposition] NOT like 'Abandon%' AND bpcd.[disposition] not like 'System_dis%') AND bpcd.[talk_time] > 0 ) THEN 1 ELSE 0 END AS 'Contact',
		   CASE	WHEN ((bpcd.[disposition] NOT like 'Abandon%' AND bpcd.[disposition] not like 'System_dis%') AND bpcd.[talk_time] >= 60 ) THEN 1 ELSE 0 END AS 'QualifiedContact',
		   CASE	WHEN ((bpcd.[disposition] NOT like 'Abandon%' AND bpcd.[disposition] not like 'System_dis%') AND bpcd.[talk_time] < 60 ) THEN 1 ELSE 0 END AS 'NonQualifiedContact',
		   bpcd.pkid as 'Pkid',
		   t.id as 'TaskId',
		   CASE WHEN right(l.Source_Code_Legacy__c,2) = 'DP' THEN c.[TollFreeName__c]
				WHEN right(l.Source_Code_Legacy__c,2) NOT LIKE 'MP' THEN c.[TollFreeName__c]
				ELSE NULL END AS 'TollFreeName',
		   CASE WHEN right(l.Source_Code_Legacy__c,2) = 'MP' THEN c.[TollFreeMobileName__c]
				WHEN right(l.Source_Code_Legacy__c,2) NOT LIKE 'DP' THEN c.[TollFreeMobileName__c]
				ELSE NULL END AS 'TollFreeMobileName',
		   bpcd.original_destination_phone,
		   bpcd.custom2,
		   l.[OriginalCampaign__c]
	--INTO #Activities
	FROM [ODS].[SFDC_Task] t
		LEFT OUTER JOIN [ODS].[SFDC_Lead] l
			ON l.Id = t.WhoId
		LEFT OUTER JOIN [ODS].[SFDC_Campaign] c
			ON c.id = t.[CampaignID__c]
		LEFT OUTER JOIN [ODS].[BP_CallDetail] bpcd
			ON TRIM(bpcd.custom3) = TRIM(t.id)
		LEFT OUTER JOIN [ODS].[DimTimeOfDay] dtd
			ON dtd.[Time24] = convert(varchar,ISNULL(bpcd.start_time,t.CreatedTime__c),8)
		LEFT OUTER JOIN [ODS].[CNCT_Center] cn
			ON t.CenterNumber__c = cn.CenterNumber
		LEFT OUTER JOIN [ODS].[CNCT_CenterType] ct
			ON cn.CenterTypeID = ct.CenterTypeID
	WHERE (t.Action__c IN ('Web Form','Web Chat','Inbound Call') 
			OR (t.Action__c = 'Confirmation Call' and t.Result__c IN ('Appointment','Call Back','Cancel','Direct Confirmation','Reschedule'))
			OR (t.Action__c IN ('Show no buy call','No Show Call','Brochure Call','Cancel Call') AND t.Result__c = 'Appointment'))
		  AND t.Result__c IS NOT null 
		 -- AND t.whoId in (Select * from #NewLeads)

	INSERT INTO #ContactBP
	SELECT --ROW_NUMBER() OVER (PARTITION BY t.WhoId ORDER BY t.CreatedDate, t.StartTime__c ASC) AS 'RowID',
		   CASE WHEN(NULL = 'Hans Wiemann') THEN 'Hans Wiemann'
				ELSE 'Hairclub'
				END AS 'Company',
		   l.id AS 'LeadID',
		   l.GCLID__c AS 'GCLID',
		   LOWER(CONVERT(VARCHAR(128),hashbytes('SHA2_256', [ODS].[ValidMail](l.Email) ),2)) AS 'HashedEmail',
		   CASE WHEN (bpcd.start_time IS NOT NULL) THEN dateadd(mi,datepart(tz,CONVERT(datetime,bpcd.start_time)    AT TIME ZONE 'Eastern Standard Time'),bpcd.start_time)
				END as 'Start_Date',
		   CASE WHEN (bpcd.start_time IS NOT NULL) THEN cast(dateadd(mi,datepart(tz,CONVERT(datetime,bpcd.start_time)    AT TIME ZONE 'Eastern Standard Time'),bpcd.start_time) as date)
				END as Date,
		   CASE WHEN (cast(bpcd.start_time as time) is null) THEN null
				ELSE cast(dateadd(mi,datepart(tz,CONVERT(datetime,bpcd.start_time)    AT TIME ZONE 'Eastern Standard Time'),bpcd.start_time) as time)
				END as time,
		   dtd.DayPart AS 'DayPart',
		   dtd.[Hour] AS 'Hour',
		   dtd.[minute] AS 'Minute',
		   dtd.[Second] AS 'Seconds',
		   TRIM(l.LastName),
		   TRIM(l.FirstName),
		   REPLACE(REPLACE(REPLACE(REPLACE(l.[Phone],'(',''),')',''),' ',''),'-','') as 'Phone',
		   REPLACE(REPLACE(REPLACE(REPLACE(l.[MobilePhone],'(',''),')',''),' ',''),'-','') AS 'MobilePhone',
		   TRIM(l.Email),
		   CASE WHEN (bpcd.custom2 IS NULL) THEN NULL 
				ELSE bpcd.custom2
				END AS 'Sourcecode',
		   CASE WHEN bpcd.caller_phone_type = 'External' THEN RIGHT(bpcd.initial_original_destination_phone,10) 
		   ELSE 'Unknown'
		   END AS [DialedNumber],
		   left(l.PhoneAbr__c,3) AS 'PhoneNumberAreaCode',
		   NULL AS 'CampaignAgency',
		   NULL  AS 'CampaignChannel',
		   NULL AS 'CampaignMedium',
		   NULL AS 'CampaignName',
		   NULL AS 'CampaignFormat',
		   NULL AS 'CampaignLocation',
		   NULL AS 'CampaignCompany',
		   CASE WHEN (NULL LIKE '%BARTH%' OR NULL LIKE '%LOCAL US%') THEN 'Barth'
				WHEN (NULL LIKE '%CANADA%' OR NULL LIKE '%NATIONAL CA%' OR NULL LIKE '%LOCAL CA%') THEN 'Canada'
				WHEN (NULL LIKE '%USA%' OR NULL LIKE '%NATIONAL US%') THEN 'United States'
				WHEN (NULL LIKE '%ECOMMERCE%') THEN 'Ecommerce'
				WHEN (NULL LIKE '%HANS%') THEN 'Hans'
				WHEN (NULL LIKE '%PUERTO RICO%') THEN 'Puerto Rico'
				ELSE
				'Unknown' END AS 'CampaignBudgetName',
		   NULL AS 'CampaignLanguage',
		   NULL AS 'CampaignPromotionCode',
		   cast(l.[HTTPReferrer__c] as nvarchar(1000)) AS 'CampaignLandingPageURL',
		   NULL AS 'CampaignStartDate',
		   NULL AS 'CampaignEndDate',
		   NULL AS 'CampaignStatus',
		   NULL AS 'PostalCode',
		   bpcd.[duration]  AS 'TotalTime',
		   bpcd.[ivr_time] AS 'IVRTime',
		   bpcd.[talk_time] AS 'TalkTime',
		   1 AS 'RawContact',
		   CASE WHEN (bpcd.[disposition] like 'Abandon%' OR bpcd.[disposition] like 'System_dis%') THEN 1 ELSE 0 END AS 'AbandonedContact',
		   CASE	WHEN ((bpcd.[disposition] NOT like 'Abandon%' AND bpcd.[disposition] not like 'System_dis%') AND bpcd.[talk_time] > 0 ) THEN 1 ELSE 0 END AS 'Contact',
		   CASE	WHEN ((bpcd.[disposition] NOT like 'Abandon%' AND bpcd.[disposition] not like 'System_dis%') AND bpcd.[talk_time] >= 60 ) THEN 1 ELSE 0 END AS 'QualifiedContact',
		   CASE	WHEN ((bpcd.[disposition] NOT like 'Abandon%' AND bpcd.[disposition] not like 'System_dis%') AND bpcd.[talk_time] < 60 ) THEN 1 ELSE 0 END AS 'NonQualifiedContact',
		   bpcd.pkid as 'Pkid',
		   NULL as 'TaskId',
		   NULL as 'TollFreeName',
		   NULL as 'TollFreeMobileName',
		   bpcd.original_destination_phone,
		   bpcd.custom2,
		   l.[OriginalCampaign__c]
	FROM [ODS].[BP_CallDetail] bpcd
		--LEFT OUTER JOIN [ODS].[SFDC_Task] t
		--	ON TRIM(bpcd.custom3) = TRIM(t.id)
		LEFT OUTER JOIN [ODS].[SFDC_Lead] l
			ON l.Id = TRIM(bpcd.Custom1)
		--LEFT OUTER JOIN [ODS].[SFDC_Campaign] c
		--	ON c.id = t.[CampaignID__c]
		LEFT OUTER JOIN [ODS].[DimTimeOfDay] dtd
			ON dtd.[Time24] = convert(varchar,bpcd.start_time,8)
		--LEFT OUTER JOIN [ODS].[CNCT_Center] cn
		--	ON t.CenterNumber__c = cn.CenterNumber
		--LEFT OUTER JOIN [ODS].[CNCT_CenterType] ct
		--	ON cn.CenterTypeID = ct.CenterTypeID
	WHERE ((bpcd.caller_phone_type = 'External'
			AND bpcd.callee_phone_type = 'Internal'
			AND ISNULL(bpcd.service_name, '') NOT LIKE '%sms%') 
			OR ((bpcd.caller_phone_type = 'External' OR bpcd.caller_phone_type IS NULL)
                               AND (bpcd.callee_phone_type = 'External' OR bpcd.caller_phone_type IS NULL)
                               AND ISNULL(bpcd.service_name, '') LIKE '%inbound%')) AND bpcd.custom1 not in (select leadid from #ContactTask);
			--AND bpcd.custom1 in (Select * from #NewLeads);

--------CTE----------------------
	with cte as
(
Select id, [names], [value]
from [ODS].[SFDC_Campaign]
Unpivot (
[Value] for [Names] in ([MPNCode__c] ,[MWCCode__c] ,[MWFCode__c], DPNCode__c,DWCCode__c, DWFCode__c)
) as pv)

insert into #temporalSource
	(
		id,
		names,
		value,
		[CampaignAgency],
		[CampaignChannel],
		[CampaignMedium],
		[CampaignName],
		[CampaignFormat],
		[CampaignCompany],
		[CampaignLocation],
		[CampaignBudgetName],
		[CampaignLanguage],
		[CampaignPromotionCode],
		[CampaignStartDate],
		[CampaignEndDate],
		[CampaignStatus]
	)

select 
	cte.id,
	cte.names,
	cte.value,
	c.[Type] AS 'CampaignAgency',
	c.CHANNEL__C  AS 'CampaignChannel',
	c.MEDIA__C AS 'CampaignMedium',
	c.[NAME] AS 'CampaignName',
	c.FORMAT__C AS 'CampaignFormat',
	c.[Company__c] AS 'CampaignCompany',
	c.[Location__c] AS 'CampaignLocation',
	CASE WHEN (c.[Location__c] LIKE '%BARTH%' OR c.[Location__c] LIKE '%LOCAL US%') THEN 'Barth'
		WHEN (c.[Location__c] LIKE '%CANADA%' OR c.[Location__c] LIKE '%NATIONAL CA%' OR c.[Location__c] LIKE '%LOCAL CA%') THEN 'Canada'
		WHEN (c.[Location__c] LIKE '%USA%' OR c.[Location__c] LIKE '%NATIONAL US%') THEN 'United States'
		WHEN (c.[Location__c] LIKE '%ECOMMERCE%') THEN 'Ecommerce'
		WHEN (c.[Location__c] LIKE '%HANS%') THEN 'Hans'
		WHEN (c.[Location__c] LIKE '%PUERTO RICO%') THEN 'Puerto Rico'
		ELSE
		'Unknown' END AS 'CampaignBudgetName',
	c.[Language__c] AS 'CampaignLanguage',
	c.[PromoCodeName__c] AS 'CampaignPromotionCode',
	c.STARTDATE AS 'CampaignStartDate',
	c.ENDDATE AS 'CampaignEndDate',
	c.[STATUS] AS 'CampaignStatus'
from cte
inner join [ODS].[SFDC_Campaign] c on cte.id=c.id;


------------CTA------------------

with cta as
(
Select id,[TollFreeName__c],[TollFreeMobileName__c], [names], [value]
from [ODS].[SFDC_Campaign]
Unpivot (
[Value] for [Names] in ([MPNCode__c] ,[MWCCode__c] ,[MWFCode__c], DPNCode__c,DWCCode__c, DWFCode__c)
) as pv)

insert into #temporalPhone
	(
		id,
		names,
		value,
		[TollFreeName],
        [TollFreeMobileName],
		[CampaignAgency],
		[CampaignChannel],
		[CampaignMedium],
		[CampaignName],
		[CampaignFormat],
		[CampaignCompany],
		[CampaignLocation],
		[CampaignBudgetName],
		[CampaignLanguage],
		[CampaignPromotionCode],
		[CampaignStartDate],
		[CampaignEndDate],
		[CampaignStatus]
	)

select
	cta.id,
	cta.names,
	cta.value,
	cta.[TollFreeName__c] as 'TollFreeName',
	cta.[TollFreeMobileName__c] as 'TollFreeMobileName',
	c.[Type] AS 'CampaignAgency',
	c.CHANNEL__C  AS 'CampaignChannel',
	c.MEDIA__C AS 'CampaignMedium',
	c.[NAME] AS 'CampaignName',
	c.FORMAT__C AS 'CampaignFormat',
	c.[Company__c] AS 'CampaignCompany',
	c.[Location__c] AS 'CampaignLocation',
	CASE WHEN (c.[Location__c] LIKE '%BARTH%' OR c.[Location__c] LIKE '%LOCAL US%') THEN 'Barth'
		WHEN (c.[Location__c] LIKE '%CANADA%' OR c.[Location__c] LIKE '%NATIONAL CA%' OR c.[Location__c] LIKE '%LOCAL CA%') THEN 'Canada'
		WHEN (c.[Location__c] LIKE '%USA%' OR c.[Location__c] LIKE '%NATIONAL US%') THEN 'United States'
		WHEN (c.[Location__c] LIKE '%ECOMMERCE%') THEN 'Ecommerce'
		WHEN (c.[Location__c] LIKE '%HANS%') THEN 'Hans'
		WHEN (c.[Location__c] LIKE '%PUERTO RICO%') THEN 'Puerto Rico'
		ELSE
		'Unknown' END AS 'CampaignBudgetName',
	c.[Language__c] AS 'CampaignLanguage',
	c.[PromoCodeName__c] AS 'CampaignPromotionCode',
	c.STARTDATE AS 'CampaignStartDate',
	c.ENDDATE AS 'CampaignEndDate',
	c.[STATUS] AS 'CampaignStatus'
from cta
inner join [ODS].[SFDC_Campaign] c on cta.id=c.id


-------------------------------------------UNION OF THE TABLES--------------------------------

	Insert into 
	#ContactTable
	Select * 
	FROM #ContactTask
	union all
	Select * 
	From #ContactBP



------------------------------------------UPDATE TABLES-------------------------------------------


UPDATE #ContactTable
SET		[CampaignAgency] = t2.[CampaignAgency],
		[CampaignChannel] = t2.[CampaignChannel],
		[CampaignMedium] = t2.[CampaignMedium],
		[CampaignName] = t2.[CampaignName],
		[CampaignFormat] = t2.[CampaignFormat],
		[CampaignCompany] = t2.[CampaignCompany],
		[CampaignLocation] = t2.[CampaignLocation],
		--[CampaignBudgetName] = t2.[CampaignBudgetName],
		[CampaignLanguage] = t2.[CampaignLanguage],
		[CampaignPromotionCode] = t2.[CampaignPromotionCode],
		[CampaignStartDate] = t2.[CampaignStartDate],
		[CampaignEndDate] = t2.[CampaignEndDate],
		[CampaignStatus] = t2.[CampaignStatus]
  FROM #temporalSource t2
  Where (#ContactTable.custom2 = t2.value) AND
   (#ContactTable.[CampaignAgency] IS NULL AND
		#ContactTable.[CampaignChannel] IS NULL AND
		#ContactTable.[CampaignMedium] IS NULL AND
		#ContactTable.[CampaignName] IS NULL AND
		#ContactTable.[CampaignFormat] IS NULL AND
		#ContactTable.[CampaignCompany] IS NULL AND
		#ContactTable.[CampaignLocation] IS NULL AND
		--#ContactTable.[CampaignBudgetName] IS NULL AND
		#ContactTable.[CampaignLanguage] IS NULL AND
		#ContactTable.[CampaignPromotionCode] IS NULL AND
		#ContactTable.[CampaignStartDate] IS NULL AND
		#ContactTable.[CampaignEndDate] IS NULL AND
		#ContactTable.[CampaignStatus] IS NULL)-- AND (t1.SourceCode = t2.value)

UPDATE #ContactTable
SET		[CampaignAgency] = t2.[CampaignAgency],
		[CampaignChannel] = t2.[CampaignChannel],
		[CampaignMedium] = t2.[CampaignMedium],
		[CampaignName] = t2.[CampaignName],
		[CampaignFormat] = t2.[CampaignFormat],
		[CampaignCompany] = t2.[CampaignCompany],
		[CampaignLocation] = t2.[CampaignLocation],
		[CampaignBudgetName] = t2.[CampaignBudgetName],
		[CampaignLanguage] = t2.[CampaignLanguage],
		[CampaignPromotionCode] = t2.[CampaignPromotionCode],
		[CampaignStartDate] = t2.[CampaignStartDate],
		[CampaignEndDate] = t2.[CampaignEndDate],
		[CampaignStatus] = t2.[CampaignStatus]
  FROM #temporalPhone t2
  Where (right(#ContactTable.[original_destination_phone],10)=ISNULL(t2.[TollFreeName],t2.[TollFreeMobileName]))
  and (#ContactTable.[CampaignAgency] IS NULL AND
		#ContactTable.[CampaignChannel] IS NULL AND
		#ContactTable.[CampaignMedium] IS NULL AND
		#ContactTable.[CampaignName] IS NULL AND
		#ContactTable.[CampaignFormat] IS NULL AND
		#ContactTable.[CampaignCompany] IS NULL AND
		#ContactTable.[CampaignLocation] IS NULL AND
		--#ContactTable.[CampaignBudgetName] IS NULL AND
		#ContactTable.[CampaignLanguage] IS NULL AND
		#ContactTable.[CampaignPromotionCode] IS NULL AND
		#ContactTable.[CampaignStartDate] IS NULL AND
		#ContactTable.[CampaignEndDate] IS NULL AND
		#ContactTable.[CampaignStatus] IS NULL)



UPDATE #ContactTable
SET		[CampaignAgency] = t2.[Type],
		[CampaignChannel] = t2.CHANNEL__C,
		[CampaignMedium] = t2.MEDIA__C,
		[CampaignName] = t2.[NAME],
		[CampaignFormat] = t2.FORMAT__C,
		[CampaignCompany] = t2.[Company__c],
		[CampaignLocation] = t2.[Location__c],
		--[CampaignBudgetName] = t2.[CampaignBudgetName],
		[CampaignLanguage] = t2.[Language__c],
		[CampaignPromotionCode] = t2.[PromoCodeName__c],
		[CampaignStartDate] = t2.STARTDATE,
		[CampaignEndDate] = t2.ENDDATE,
		[CampaignStatus] = t2.[STATUS]
  FROM [ODS].[SFDC_Campaign] t2
  Where (#ContactTable.[OriginalCampaign__c] = t2.id) AND
   (#ContactTable.[CampaignAgency] IS NULL AND
		#ContactTable.[CampaignChannel] IS NULL AND
		#ContactTable.[CampaignMedium] IS NULL AND
		#ContactTable.[CampaignName] IS NULL AND
		#ContactTable.[CampaignFormat] IS NULL AND
		#ContactTable.[CampaignCompany] IS NULL AND
		#ContactTable.[CampaignLocation] IS NULL AND
		--#ContactTable.[CampaignBudgetName] IS NULL AND
		#ContactTable.[CampaignLanguage] IS NULL AND
		#ContactTable.[CampaignPromotionCode] IS NULL AND
		#ContactTable.[CampaignStartDate] IS NULL AND
		#ContactTable.[CampaignEndDate] IS NULL AND
		#ContactTable.[CampaignStatus] IS NULL)




---------------------------------------------------------INSERT INTO CONTACTS----------------------------------------------

	INSERT INTO [Reports].[FactContact] ([Company]
      ,[LeadID]
      ,[GCLID]
      ,[HashedEmail]
      ,[Start_Date]
      ,[Date]
      ,[Time]
      ,[DayPart]
      ,[Hour]
      ,[Minute]
      ,[Seconds]
      ,[LastName]
      ,[FirstName]
      ,[Phone]
      ,[MobilePhone]
      ,[Email]
      ,[Sourcecode]
	  ,[DialedNumber]
      ,[PhoneNumberAreaCode]
      ,[CampaignAgency]
      ,[CampaignChannel]
      ,[CampaignMedium]
      ,[CampaignName]
      ,[CampaignFormat]
      ,[CampaignCompany]
      ,[CampaignLocation]
      ,[CampaignBudgetName]
      ,[CampaignLanguage]
      ,[CampaignPromotionCode]
      ,[CampaignLandingPageURL]
      ,[CampaignStartDate]
      ,[CampaignEndDate]
      ,[CampaignStatus]
      ,[PostalCode]
      ,[TotalTime]
      ,[IVRTime]
      ,[TalkTime]
      ,[RawContact]
      ,[AbandonedContact]
      ,[Contact]
      ,[QualifiedContact]
      ,[NonQualifiedContact]
	  ,[Pkid]
	  ,[TaskId]
	  ,[TollFreeName]
	  ,[TollFreeMobileName])

	  SELECT 
	   [Company]
      ,[LeadID]
      ,[GCLID]
      ,[HashedEmail]
      ,[Start_Date]
      ,[Date]
      ,[Time]
      ,[DayPart]
      ,[Hour]
      ,[Minute]
      ,[Seconds]
      ,[LastName]
      ,[FirstName]
      ,[Phone]
      ,[MobilePhone]
      ,[Email]
      ,[Sourcecode]
	  ,[DialedNumber]
      ,[PhoneNumberAreaCode]
      ,[CampaignAgency]
      ,[CampaignChannel]
      ,[CampaignMedium]
      ,[CampaignName]
      ,[CampaignFormat]
      ,[CampaignCompany]
      ,[CampaignLocation]
      ,[CampaignBudgetName]
      ,[CampaignLanguage]
      ,[CampaignPromotionCode]
      ,[CampaignLandingPageURL]
      ,[CampaignStartDate]
      ,[CampaignEndDate]
      ,[CampaignStatus]
      ,[PostalCode]
      ,[TotalTime]
      ,[IVRTime]
      ,[TalkTime]
      ,[RawContact]
      ,[AbandonedContact]
      ,[Contact]
      ,[QualifiedContact]
      ,[NonQualifiedContact]
	  ,[Pkid]
	  ,[TaskId]
	  ,[TollFreeName]
	  ,[TollFreeMobileName]
	  FROM #ContactTable
	
	DROP TABLE #ContactTask
	DROP TABLE #ContactBP
	DROP TABLE #ContactTable
	DROP TABLE #temporalSource
	DROP TABLE #temporalPhone


END
GO
