/****** Object:  StoredProcedure [ODS].[PopulateContact]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [ODS].[PopulateContact] AS
BEGIN

    truncate table Reports.Contact
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


    create table #task
    (
        Id varchar(50),
        CreatedDate datetime,
        Action varchar(50),
        Result varchar(50),
        IsBeBack bit,
        IsOld bit,
        IsOpportunityClosed bit,
        SourceCode varchar(50),
        CenterNumber int,
        ActivityDate datetime,
        whoid NVARCHAR(50),
        Accomodation varchar(50),
        CreatedDateEst datetime
    )


----------------------------------------------INSERT INTO TABLES----------------------------------------------------


	INSERT INTO #ContactTask
	SELECT   --ROW_NUMBER() OVER (PARTITION BY t.WhoId ORDER BY t.CreatedDate, t.StartTime__c ASC) AS 'RowID',
		   CASE WHEN(ct.CenterTypeDescription = 'Hans Wiemann') THEN 'Hans Wiemann'
				ELSE 'Hairclub'
				END AS Company,
		   l.LeadId AS LeadID,
		   l.GCLID AS GCLID,
		   LOWER(CONVERT(VARCHAR(128),hashbytes('SHA2_256', ODS.ValidMail(l.LeadEmail) ),2)) AS 'HashedEmail',
		   CASE WHEN (bpcd.start_time IS NOT NULL) THEN dateadd(mi,datepart(tz,CONVERT(datetime,bpcd.start_time)    AT TIME ZONE 'Eastern Standard Time'),bpcd.start_time)
				ELSE dateadd(mi,datepart(tz,CONVERT(datetime,t.AppointmentDate)    AT TIME ZONE 'Eastern Standard Time'),t.AppointmentDate)
				END as 'Start_Date',
		   CASE WHEN (bpcd.start_time IS NOT NULL) THEN cast(dateadd(mi,datepart(tz,CONVERT(datetime,bpcd.start_time)    AT TIME ZONE 'Eastern Standard Time'),bpcd.start_time) as date)
				ELSE cast(dateadd(mi,datepart(tz,CONVERT(datetime,t.AppointmentDate)    AT TIME ZONE 'Eastern Standard Time'),t.AppointmentDate) as date)
				END as Date,
		   CASE WHEN (cast(bpcd.start_time as time) is null) THEN cast(t.AppointmentDate as time)
				ELSE cast(dateadd(mi,datepart(tz,CONVERT(datetime,bpcd.start_time)    AT TIME ZONE 'Eastern Standard Time'),bpcd.start_time) as time)
				END as time,
		   dtd.DayPart AS 'DayPart',
		   dtd.[Hour] AS 'Hour',
		   dtd.[minute] AS 'Minute',
		   dtd.[Second] AS 'Seconds',
		   TRIM(l.LeadLastname),
		   TRIM(l.LeadFirstName),
		   REPLACE(REPLACE(REPLACE(REPLACE(l.[LeadPhone],'(',''),')',''),' ',''),'-','') as 'Phone',
		   REPLACE(REPLACE(REPLACE(REPLACE(l.[LeadMobilePhone],'(',''),')',''),' ',''),'-','') AS 'MobilePhone',
		   TRIM(l.LeadEmail),
		   CASE WHEN (bpcd.custom2 IS NULL) THEN l.LeadSource
				ELSE bpcd.custom2
				END AS 'Sourcecode',
		   NULL AS [DialedNumber],
		   left(l.LeadPhone,3) AS 'PhoneNumberAreaCode',
		   c.[AgencyName] AS 'CampaignAgency',
		   c.CampaignChannel  AS 'CampaignChannel',
		   c.CampaignMedia AS 'CampaignMedium',
		   c.[CampaignName] AS 'CampaignName',
		   c.CampaignFormat AS 'CampaignFormat',
		   c.[CampaignLocation] AS 'CampaignLocation',
		   null AS 'CampaignCompany',
		   CASE WHEN (c.[CampaignLocation] LIKE '%BARTH%' OR c.[CampaignLocation] LIKE '%LOCAL US%') THEN 'Barth'
				WHEN (c.[CampaignLocation] LIKE '%CANADA%' OR c.[CampaignLocation] LIKE '%NATIONAL CA%' OR c.[CampaignLocation] LIKE '%LOCAL CA%') THEN 'Canada'
				WHEN (c.[CampaignLocation] LIKE '%USA%' OR c.[CampaignLocation] LIKE '%NATIONAL US%') THEN 'United States'
				WHEN (c.[CampaignLocation] LIKE '%ECOMMERCE%') THEN 'Ecommerce'
				WHEN (c.[CampaignLocation] LIKE '%HANS%') THEN 'Hans'
				WHEN (c.[CampaignLocation] LIKE '%PUERTO RICO%') THEN 'Puerto Rico'
				ELSE
				'Unknown' END AS 'CampaignBudgetName',
		   c.[CampaignLanguage] AS 'CampaignLanguage',
		   null AS 'CampaignPromotionCode',
		   null AS 'CampaignLandingPageURL',
		   c.STARTDATE AS 'CampaignStartDate',
		   c.ENDDATE AS 'CampaignEndDate',
		   c.[CampaignStatus] AS 'CampaignStatus',
		   l.[LeadPostalCode] AS 'PostalCode',
		   bpcd.[duration]  AS 'TotalTime',
		   bpcd.[ivr_time] AS 'IVRTime',
		   bpcd.[talk_time] AS 'TalkTime',
		   1 AS 'RawContact',
		   CASE WHEN (bpcd.[disposition] like 'Abandon%' OR bpcd.[disposition] like 'System_dis%') THEN 1 ELSE 0 END AS 'AbandonedContact',
		   CASE	WHEN ((bpcd.[disposition] NOT like 'Abandon%' AND bpcd.[disposition] not like 'System_dis%') AND bpcd.[talk_time] > 0 ) THEN 1 ELSE 0 END AS 'Contact',
		   CASE	WHEN ((bpcd.[disposition] NOT like 'Abandon%' AND bpcd.[disposition] not like 'System_dis%') AND bpcd.[talk_time] >= 60 ) THEN 1 ELSE 0 END AS 'QualifiedContact',
		   CASE	WHEN ((bpcd.[disposition] NOT like 'Abandon%' AND bpcd.[disposition] not like 'System_dis%') AND bpcd.[talk_time] < 60 ) THEN 1 ELSE 0 END AS 'NonQualifiedContact',
		   bpcd.pkid as 'Pkid',
		   t.AppointmentId as 'TaskId',
		   CASE WHEN right(l.LeadSource,2) = 'DP' THEN c.[TollFreeName]
				WHEN right(l.LeadSource,2) NOT LIKE 'MP' THEN c.[TollFreeName]
				ELSE NULL END AS 'TollFreeName',
		   CASE WHEN right(l.LeadSource,2) = 'MP' THEN c.[TollFreeMobileName]
				WHEN right(l.LeadSource,2) NOT LIKE 'DP' THEN c.[TollFreeMobileName]
				ELSE NULL END AS 'TollFreeMobileName',
		   bpcd.original_destination_phone,
		   bpcd.custom2,
		   l.[OriginalCampaignId]
	--INTO #Activities
	FROM dbo.FactAppointment t
		LEFT OUTER JOIN dbo.VWLead l
			ON l.leadId = t.LeadId
		LEFT OUTER JOIN dbo.DimCampaign c
			ON c.CampaignId = l.OriginalCampaignId
		LEFT OUTER JOIN [ODS].[BP_CallDetail] bpcd
			ON TRIM(bpcd.custom3) = TRIM(t.AppointmentId)
 		LEFT OUTER JOIN [dbo].[DimTimeOfDay] dtd
 			ON dtd.[Time24] = convert(varchar,ISNULL(bpcd.start_time,t.AppointmentDate),8)
 		LEFT OUTER JOIN [ODS].[CNCT_Center] cn
 			ON l.CenterNumber = cn.CenterNumber and cn.IsActiveFlag = '1'
 		LEFT OUTER JOIN [ODS].[CNCT_CenterType] ct
 			ON cn.CenterTypeID = ct.CenterTypeID




		 -- AND t.whoId in (Select * from #NewLeads)




	INSERT INTO  #ContactBP
	SELECT   --ROW_NUMBER() OVER (PARTITION BY t.WhoId ORDER BY t.CreatedDate, t.StartTime__c ASC) AS 'RowID',
		   CASE WHEN(NULL = 'Hans Wiemann') THEN 'Hans Wiemann'
				ELSE 'Hairclub'
				END AS 'Company',
		   l.LeadId AS 'LeadID',
		   l.GCLID AS 'GCLID',
		   LOWER(CONVERT(VARCHAR(128),hashbytes('SHA2_256', ODS.ValidMail(l.LeadEmail) ),2)) AS 'HashedEmail',
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
		   TRIM(l.LeadLastname),
		   TRIM(l.LeadFirstName),
		   REPLACE(REPLACE(REPLACE(REPLACE(l.[LeadPhone],'(',''),')',''),' ',''),'-','') as 'Phone',
		   REPLACE(REPLACE(REPLACE(REPLACE(l.[LeadMobilePhone],'(',''),')',''),' ',''),'-','') AS 'MobilePhone',
		   TRIM(l.LeadEmail),
		   CASE WHEN (bpcd.custom2 IS NULL) THEN NULL
				ELSE bpcd.custom2
				END AS 'Sourcecode',
		   CASE WHEN bpcd.caller_phone_type = 'External' THEN RIGHT(bpcd.initial_original_destination_phone,10)
		   ELSE 'Unknown'
		   END AS [DialedNumber],
		   left(l.LeadPhone,3) AS 'PhoneNumberAreaCode',
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
		   null AS 'CampaignLandingPageURL',
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
		   l.OriginalCampaignId
	FROM [ODS].[BP_CallDetail] bpcd
		LEFT OUTER JOIN dbo.VWLead l
			ON l.LeadId = TRIM(bpcd.Custom1)
		LEFT OUTER JOIN [dbo].[DimTimeOfDay] dtd
			ON dtd.[Time24] = convert(varchar,bpcd.start_time,8)
	WHERE ((bpcd.caller_phone_type = 'External'
			AND bpcd.callee_phone_type = 'Internal'
			AND ISNULL(bpcd.service_name, '') NOT LIKE '%sms%')
			OR ((bpcd.caller_phone_type = 'External' OR bpcd.caller_phone_type IS NULL)
                               AND (bpcd.callee_phone_type = 'External' OR bpcd.caller_phone_type IS NULL)
                               AND ISNULL(bpcd.service_name, '') LIKE '%inbound%')) AND bpcd.custom1 not in (select leadid from #ContactTask) and bpcd.custom1 is not null;
			--AND bpcd.custom1 in (Select * from #NewLeads);




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
SET		[CampaignAgency] = t2.[CampaignType],
		[CampaignChannel] = t2.CampaignChannel,
		[CampaignMedium] = t2.CampaignMedia,
		[CampaignName] = t2.[CampaignName],
		[CampaignFormat] = t2.CampaignFormat,
		[CampaignCompany] = null,
		[CampaignLocation] = t2.[CampaignLocation],
		--[CampaignBudgetName] = t2.[CampaignBudgetName],
		[CampaignLanguage] = t2.[CampaignLanguage],
		[CampaignPromotionCode] = t2.[CampaignPromoDescription],
		[CampaignStartDate] = t2.STARTDATE,
		[CampaignEndDate] = t2.ENDDATE,
		[CampaignStatus] = t2.[CampaignStatus]
  FROM dbo.DimCampaign t2
  Where (#ContactTable.[OriginalCampaign__c] = t2.CampaignId) AND
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

	INSERT INTO [Reports].[Contact] ([Company]
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
    drop table #task

END
GO
