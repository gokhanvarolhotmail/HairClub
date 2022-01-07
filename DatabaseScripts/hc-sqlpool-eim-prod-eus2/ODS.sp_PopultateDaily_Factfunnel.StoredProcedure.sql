/****** Object:  StoredProcedure [ODS].[sp_PopultateDaily_Factfunnel]    Script Date: 1/7/2022 4:05:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [ODS].[sp_PopultateDaily_Factfunnel] AS begin

DECLARE @MaxModifiedDate DATETIME;
SET @MaxModifiedDate = (select max(LastModifiedDate) from [hc-sqlpool-eim-prod-eus2].Reports.Funnel) 
	
CREATE Table  #AllLeads(
IdLead varchar(50)
)

CREATE  Table #NewLeads(
IdLead varchar(50)
)


CREATE Table  #UpdateLeads(
IdLead varchar(50)
)

insert into
	#AllLeads
Select sl.id from [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl
where cast(sl.LastModifiedDate as date) >=  cast(@MaxModifiedDate as date)
union
Select st.whoid from [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Task st
where cast(st.LastModifiedDate as date) >= cast(@MaxModifiedDate as date)

insert into
	#NewLeads 
select IdLead from #AllLeads
where IdLead  not in (select saleforceleadid from [hc-sqlpool-eim-prod-eus2].Reports.Funnel)

insert into
	#UpdateLeads 
select IdLead from #AllLeads
where IdLead  in (select saleforceleadid from [hc-sqlpool-eim-prod-eus2].Reports.Funnel)
	
	
---Create temp Tables

create Table #Contact
	(
	    id varchar(50),
	    TaskID varchar(50),
	    QuotedPrice int,
	    SaletypeDescription varchar(100),
	    Whoid varchar(50),
	    Result varchar(50),
	    Action varchar(50),
	    ActivityDateUTC datetime,
		ActivityDateEST datetime,
	    FunnelStep varchar(20),
	    Contact bit,
	    Lead bit,
	    Appointment bit,
	    Show bit,
	    Sale bit,
	    NewLeadToappointment bit,
	    NewLeadToshow bit,
	    NewLeadTosale bit,
		CreatedDate datetime,
		LastModifiedDate datetime
	)
	
	create Table #Lead
	(
	    id varchar(50),
	    TaskID varchar(50),
	    QuotedPrice int,
	    SaletypeDescription varchar(100),
	    Whoid varchar(50),
	    Result varchar(50),
	    Action varchar(50),
	    ActivityDateUTC datetime,
		ActivityDateEST datetime,
	    FunnelStep varchar(20),
	    Contact bit,
	    Lead bit,
	    Appointment bit,
	    Show bit,
	    Sale bit,
	    NewLeadToappointment bit,
	    NewLeadToshow bit,
	    NewLeadTosale bit,
		CreatedDate datetime,
		LastModifiedDate datetime
	)
	
	create Table #Appointment
	(
	    id varchar(50),
	    TaskID varchar(50),
	    QuotedPrice int,
	    SaletypeDescription varchar(100),
	    Whoid varchar(50),
	    Result varchar(50),
	    Action varchar(50),
	    ActivityDateUTC datetime,
		ActivityDateEST datetime,
	    FunnelStep varchar(20),
	    Contact bit,
	    Lead bit,
	    Appointment bit,
	    Show bit,
	    Sale bit,
	    NewLeadToappointment bit,
	    NewLeadToshow bit,
	    NewLeadTosale bit,
		CreatedDate datetime,
		LastModifiedDate datetime
	)
	
	create Table #Show
	(
	    id varchar(50),
	    TaskID varchar(50),
	    QuotedPrice int,
	    SaletypeDescription varchar(100),
	    Whoid varchar(50),
	    Result varchar(50),
	    Action varchar(50),
	    ActivityDateUTC datetime,
		ActivityDateEST datetime,
	    FunnelStep varchar(20),
	    Contact bit,
	    Lead bit,
	    Appointment bit,
	    Show bit,
	    Sale bit,
	    NewLeadToappointment bit,
	    NewLeadToshow bit,
	    NewLeadTosale bit,
		CreatedDate datetime,
		LastModifiedDate datetime
	)
	
	create Table #Sale
	(
	    id varchar(50),
	    TaskID varchar(50),
	    QuotedPrice int,
	    SaletypeDescription varchar(100),
	    Whoid varchar(50),
	    Result varchar(50),
	    Action varchar(50),
	    ActivityDateUTC datetime,
		ActivityDateEST datetime,
	    FunnelStep varchar(20),
	    Contact bit,
	    Lead bit,
	    Appointment bit,
	    Show bit,
	    Sale bit,
	    NewLeadToappointment bit,
	    NewLeadToshow bit,
	    NewLeadTosale bit,
		CreatedDate datetime,
		LastModifiedDate datetime
	)
	
	create Table #FunnelTable
	(
	    id varchar(50),
	    TaskID varchar(50),
	    QuotedPrice int,
	    SaletypeDescription varchar(100),
	    Whoid varchar(50),
	    Result varchar(50),
	    Action varchar(50),
	    ActivityDateUTC datetime,
		ActivityDateEST datetime,
	    FunnelStep varchar(20),
	    Contact bit,
	    Lead bit,
	    Appointment bit,
	    Show bit,
	    Sale bit,
	    NewLeadToappointment bit,
	    NewLeadToshow bit,
	    NewLeadTosale bit,
		CreatedDate datetime,
		LastModifiedDate datetime
	)
	
	-----------------------------------------------------------------------------------------
	---Insert into temp tables
	
	---Contact
	Insert into 
	    #Contact
	Select 
	  sl.id
	, null as TaskID
	, null as QuotedPrice
	, null as SaletypeDescription
	, null as Whoid
	, null as Result
	, null as Action
	, sl.CreatedDate as ActivityDateUTC
	, dateadd(mi,datepart(tz,CONVERT(datetime,sl.CreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.CreatedDate) as ActivityDateEST  
	, 'Contact' as FunnelStep 
	, 1 as Contact
	, 0 as lead
	, 0 as appointment
	, 0 as show
	, 0 as sale
	, 0 as NewLeadToappointment
	, 0 as NewLeadToshow
	, 0 as NewLeadTosale
	, sl.CreatedDate
	, sl.LastModifiedDate
	FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl

	
	---Lead
	EXEC    [ODS].[LeadValidation]
	Insert into  #Lead
	Select 
	  sl.id
	, null as TaskID
	, null as QuotedPrice
	, null as SaletypeDescription
	, null as Whoid
	, null as Result
	, null as Action
	, sl.CreatedDate as ActivityDateUTC
	, dateadd(mi,datepart(tz,CONVERT(datetime,sl.CreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.CreatedDate) as ActivityDateEST  
	, 'Lead' as FunnelStep 
	, 0 as Contact
	, 1 as lead
	, 0 as appointment
	, 0 as show
	, 0 as sale
	, 0 as NewLeadToappointment
	, 0 as NewLeadToshow
	, 0 as NewLeadTosale
	, sl.CreatedDate
	, sl.LastModifiedDate
	FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl
	LEFT JOIN ODS.#IsInvalid a
	ON sl.id = a.Id
	where a.IsInvalidLead is null; 


	
	--Appointment
	With task as (
	SELECT id Taskid,PriceQuoted__c QuotedPrice,SaleTypeDescription__c saletypeDescription,b.WhoId,Result__c Result,Action__c Action,StartTime__c, activitydate,LastModifiedDate,
	ROW_NUMBER() OVER(PARTITION BY b.WhoId ORDER BY activityDate ASC)
	AS RowNum
	FROM [ODS].[SFDC_Task] b
	where trim(action__c) in ('Appointment','In House','Be Back') and result__c <> 'Void'
	)
		Insert into 
	     #Appointment
		SELECT
		sl.id
		, task.Taskid
		, task.QuotedPrice
		, ISNULL(task.saletypeDescription, 'Unknown') as saletypeDescription
		, task.whoid
		, task.Result
		, task.Action
		, NULL as ActivityDate
		, CASE WHEN (starttime__c not like '%NULL%') THEN cast(concat(left(task.ActivityDate,11),task.StartTime__c) as datetime)
			   ELSE task.ActivityDate 
			   END AS ActivityDateEST
		, 'Appointment' as FunnelStep
		, 0 as Contact
		, 0 as Lead
		, 1 as Appointment
		, 0 as Show
		, 0 as Sale
		, 0 as NewLeadToappointment
		, 0 as NewLeadToshow
		, 0 as NewLeadTosale
		, task.ActivityDate as CreatedDate
		, task.LastModifiedDate
		FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid --OR sl.ConvertedContactId = task.WhoId
		where task.rownum=1;


	
	
	---Show
	
	With task as (
	SELECT id Taskid,PriceQuoted__c QuotedPrice,SaleTypeDescription__c saletypeDescription,b.WhoId,Result__c Result,Action__c Action,StartTime__c, activitydate,LastModifiedDate,
	ROW_NUMBER() OVER(PARTITION BY b.WhoId ORDER BY activityDate ASC)
	AS RowNum
	FROM [ODS].[SFDC_Task] b
	where action__c in ('Appointment','Be Back','In House') and (result__c='Show No Sale' or result__c='Show Sale') 
	)
		Insert into 
	    #Show
		SELECT
		sl.id
		, task.Taskid
		, task.QuotedPrice
		, ISNULL(task.saletypeDescription, 'Unknown') as saletypeDescription
		, task.whoid
		, task.Result
		, task.Action
		, NULL as ActivityDate
		, CASE WHEN (starttime__c not like '%NULL%') THEN cast(concat(left(task.ActivityDate,11),task.StartTime__c) as datetime)
			   ELSE task.ActivityDate 
			   END AS ActivityDateEST
		, 'Show' as FunnelStep
		, 0 as Contact
		, 0 as Lead
		, 0 as Appointment
		, 1 as Show
		, 0 as Sale
		, 0 as NewLeadToappointment
		, 0 as NewLeadToshow
		, 0 as NewLeadTosale
		, task.ActivityDate as CreatedDate
		, task.LastModifiedDate
		FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid  --OR sl.ConvertedContactId = task.WhoId
		where task.rownum=1;

	
	---Sale
	
	With task as (
	SELECT id Taskid,PriceQuoted__c QuotedPrice,SaleTypeDescription__c saletypeDescription,b.WhoId,Result__c Result,Action__c Action,StartTime__c, activitydate,LastModifiedDate,
	ROW_NUMBER() OVER(PARTITION BY b.WhoId  ORDER BY activityDate ASC)
	AS RowNum
	FROM [ODS].[SFDC_Task] b
	where action__c in ('Appointment','Be Back','In House') and ( result__c='Show Sale') 
	)
		Insert into 
	    #Sale
		SELECT
		sl.id
		, task.Taskid
		, task.QuotedPrice
		, ISNULL(task.saletypeDescription, 'Unknown') as saletypeDescription
		, task.whoid
		, task.Result
		, task.Action
		, NULL as ActivityDate
		, CASE WHEN (starttime__c not like '%NULL%') THEN cast(concat(left(task.ActivityDate,11),task.StartTime__c) as datetime)
			   ELSE task.ActivityDate 
			   END AS ActivityDateEST
		, 'Sale' as FunnelStep
		, 0 as Contact
		, 0 as Lead
		, 0 as Appointment
		, 0 as Show
		, 1 as Sale
		, 0 as NewLeadToappointment
		, 0 as NewLeadToshow
		, 0 as NewLeadTosale
		, task.ActivityDate as CreatedDate
		, task.LastModifiedDate
		FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid --OR sl.ConvertedContactId = task.WhoId
		where task.rownum=1;

	---Temp

	With task as (
	SELECT id Taskid,b.WhoId,Result__c Result,Action__c Action,StartTime__c, activitydate,
	ROW_NUMBER() OVER(PARTITION BY b.WhoId  ORDER BY activityDate ASC)
	AS RowNum
	FROM [ODS].[SFDC_Task] b
	where activitydate is not null
	)
		
	--insert into #temp
	select RowNum, taskid , whoid, activitydate into #temp from task 
	where RowNum = 1;
	
	-------------------------------------------------------------------------------------------------
	
	---Union Tables
	
	Insert into 
	   #FunnelTable
	Select * 
	FROM #Contact
	union all
	Select * 
	From #Lead
	Union all
	Select *
	From #Appointment
	Union all
	Select *
	From #Show
	Union all
	Select * 
	from #Sale;


	with newlead as (
		SELECT
		id,
		COUNT(*) as number
		FROM #funnelTable
		WHERE id not IN
		(
		SELECT id FROM #funnelTable WHERE FunnelStep = 'Lead'
		)
		GROUP BY id
		HAVING COUNT(*) >1
	)
	select a.* into #temporal from #funnelTable a
	inner join newlead l
	on a.id = l.id
	where a.funnelstep = 'Contact'

	update  #temporal set FunnelStep = 'Lead'

	insert into #funneltable
	select * from  #temporal
	
	update #funnelTable set NewLeadToappointment = 1
	where id in (select id from #funnelTable where funnelstep='Appointment') 
	and funnelstep='Lead'
	
	update #funnelTable set NewLeadToshow = 1
	where (id in (select id from #funnelTable where funnelstep='Show'))
	and funnelstep='Lead'
	
	update #funnelTable set NewLeadTosale = 1
	where id in (select id from #funnelTable where funnelstep='Sale')
	and funnelstep ='Lead'

	update #funnelTable 
		set TaskId = t.taskid
	FROM #funnelTable f
	INNER JOIN #temp t
	on f.id = t.whoid
	where (f.funnelstep ='Lead' or f.funnelstep ='Contact')

	

	/*
	Select count(*) from #funnelTable
	WHERE FunnelStep =  'Show' or FunnelStep  = 'sale'
	order by id desc, case When FunnelStep = 'Contact' then 1
	                When FunnelStep = 'Lead' then 2
	                when FunnelStep = 'Appointment' then 3
	                when FunnelStep = 'Show' then 4
	                when FunnelStep = 'sale' then 5 END
	*/
	
	
	DROP TABLE #Appointment
	DROP TABLE #Contact
	DROP TABLE #Lead
	DROP TABLE #Sale
	DROP TABLE #Show
	DROP TABLE ODS.#IsInvalid
	DROP TABLE #temp
	DROP TABLE #temporal
	
	

	
	
	Insert into 
		     Reports.Funnel ([ContactID]
		  ,[SalesForceTaskID]
		  ,[BrightPatternID]
		  ,[LeadFunnelTransactionID]
		  ,[SaleforceLeadID]
		  ,[Company]
		  ,[FunnelStep]
		  ,[Funnelstatus]
		  ,[OriginalGCLID]
		  ,[LeadCreateDateUTC]
		  ,[LeadCreateDateEST]
		  ,[ActivityDateUTC]
		  ,[ActivityDateEST]
		  ,[ReportCreateDate]
		  ,[Date]
		  ,[Time]
		  ,[DayPart]
		  ,[Hour]
		  ,[Minute]
		  ,[Seconds]
		  ,[OriginalContactType]
		  ,[OriginalSourcecode]
		  ,[OriginalDialedNumber]
		  ,[OriginalPhoneNumberAreaCode]
		  ,[OriginalCampaignAgency]
		  ,[OriginalCampaignChannel]
		  ,[OriginalCampaignName]
		  ,[OriginalCampaignFormat]
		  ,[OriginalCampaignLanguage]
		  ,[OriginalCampaignPromotionCode]
		  ,[OriginalCampaignStartDate]
		  ,[OriginalCampaignEndDate]
		  ,[OriginalCampaignStatus]
		  ,[RecentSourcecode]
		  ,[RecentDialedNumber]
		  ,[RecentPhoneNumberAreaCode]
		  ,[RecentCampaignAgency]
		  ,[RecentCampaignChannel]
		  ,[RecentCampaignName]
		  ,[RecentCampaignFormat]
		  ,[RecentCampaignLanguage]
		  ,[RecentCampaignPromotionCode]
		  ,[RecentCampaignStartDate]
		  ,[RecentCampaignEndDate]
		  ,[RecentCampaignStatus]
		  ,[PostalCode]
		  ,[Region]
		  ,[MarketDMA]
		  ,[CenterName]
		  ,[CenterRegion]
		  ,[CenterDMA]
		  ,[CenterType]
		  ,[CenterOwner]
		  ,[Language]
		  ,[Gender]
		  ,[LastName]
		  ,[FirstName]
		  ,[Phone]
		  ,[MobilePhone]
		  ,[Email]
		  ,[Ethnicity]
		  ,[HairLossCondition]
		  ,[MaritalStatus]
		  ,[Occupation]
		  ,[BirthYear]
		  ,[AgeBands]
		  ,[NewContact]
		  ,[NewLead]
		  ,[NewAppointment]
		  ,[NewShow]
		  ,[NewSale]
		  ,[NewLeadToAppointment]
		  ,[NewLeadToShow]
		  ,[NewLeadToSale]
		  ,[QuotedPrice]
		  ,[PrimarySolution]
		  ,[DoNotContactFlag]
		  ,[DoNotCallFlag]
		  ,[DoNotSMSFlag]
		  ,[DoNotEmailFlag]
		  ,[DoNotMailFlag]
		  ,[IsDeleted]
		  ,[LastModifiedDate])

		SELECT 
		 NULL as 'ContactID'
		, ft.Taskid as SalesForceTaskID
		,NULL as [BrightPatternID]
		,NULL AS LeadFunnelTransactionID
		, sl.Id as SaleforceLeadID
		, CASE WHEN(cty.CenterTypeDescription = 'Hans Wiemann') THEN 'Hans Wiemann'
			   ELSE 'Hair Club'
			   END AS Company
		, ft.FunnelStep 
		, sl.Status as FunnelStatus
		--, NULL AS OriginalHCUID
		--, NULL AS OriginalGCID
		, sl.GCLID__c as OriginalGCLID
		--, NULL AS OriginalMSCLKID
		--, NULL AS OriginalFBCLID
		--, NULL AS OriginalHashedEmail
		--, NULL AS OriginalHashedPhone
		--, NULL AS RecentHCUID
		--, NULL AS RecentGCID
		--, NULL AS RecentGCLID
		--, NULL AS RecentMSCLKID
		--, NULL AS RecentFBCLID
		--, NULL AS RecentHashedEmail
		--, NULL AS RecentHashedPhone
		, sl.CreatedDate as LeadCreateDateUTC
		, dateadd(mi,datepart(tz,CONVERT(datetime,sl.CreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.CreatedDate) as LeadCreateDateEST
		, ft.ActivityDateUTC as ActivityDateUTC
		, ft.ActivityDateEST as ActivityDateEST
		, sl.[ReportCreateDate__c] as ReportCreateDate
		, cast(ft.ActivityDateEST as date) as Date
		, cast(ft.ActivityDateEST as time) as time
		, dtd.DayPart as DayPart
		, dtd.[Hour] as Hour
		, dtd.[minute] as Minute
		, dtd.[Second] as Seconds
		, sl.LeadSource AS OriginalContactType
		--, NULL AS OriginalContactGroup
		--, null as SystemOfOrigin
		--, NULL AS LeadState
		, sl.Source_Code_Legacy__c as OriginalSourcecode
		--, NULL AS OriginalSourcecodeName
		--, NULL AS OriginalSourcecodeType
		--, NULL AS OriginalSourececodeGroup
		, CASE WHEN soc.SourceCode_L__c like '%MP'
				THEN soc.TollFreeMobileName__c
			ELSE
				soc.TollFreeName__c
		  END AS OriginalDialedNumber
		, SUBSTRING(sl.PhoneAbr__c, 0,4 ) AS OriginalPhoneNumberAreaCode
		, soc.[Type] as OriginalCampaignAgency
		--, NULL AS OriginalCampaignPurpose
		--, NULL AS OriginalCampaignMethod
		, soc.Channel__c as OriginalCampaignChannel
		--, NULL AS OriginalCampaignMedium
		--, NULL AS OriginalCampaignSource
		--, NULL AS OriginalCampaignContentType
		--, NULL AS OriginalCompaignContent
		--, NULL AS OriginalCampaignType
		, soc.Name  as OriginalCampaignName
		--, NULL AS OriginalCampaignTactic
		, soc.Format__c as OriginalCampaignFormat
		--, NULL AS OriginalCampaignPlacement
		--, NULL AS OriginalCampaignCompany
		--, NULL AS OriginalCampaignLocation
		--, NULL AS OriginalCampaignBudgetType
		--, NULL AS OriginalCampaignBudgetName
		--, NULL AS OriginalCampaignRegion
		--, NULL AS OriginalCampaignMarketDMA
		--, NULL AS OriginalCampaignAudience
		, soc.Language__c as OriginalCampaignLanguage
		, soc.PromoCodeName__c as OriginalCampaignPromotionCode
		--, NULL AS OriginalCampaignLandingPageURL
		, soc.StartDate as OriginalCampaignStartDate
		, soc.EndDate as OriginalCampaignEndDate
		, soc.Status as OriginalCampaignStatus
		, sl.RecentSourceCode__c as RecentSourceCode
		--, NULL AS RecentSourcecodeName
		--, NULL AS RecentSourcecodeType
		--, NULL AS RecentSourececodeGroup
		, CASE WHEN src.SourceCode_L__c like '%MP'
				THEN src.TollFreeMobileName__c
			ELSE
				src.TollFreeName__c
		  END AS OriginalDialedNumber
		, SUBSTRING(sl.PhoneAbr__c, 0,4 ) as RecentPhoneNumberAreaCode
		, src.[Type] as RecentCampaignAgency
		--, NULL AS RecentCampaignPurpose
		--, NULL AS RecentlCampaignMethod
		, src.Channel__c as RecentCampaignChannel
		--, NULL AS RecentCampaignMedium
		--, NULL AS RecentCampaignSource
		--, NULL AS RecentCampaignContentType
		--, NULL AS RecentCompaignContent
		--, NULL AS RecentCampaignType
		, src.Name as RecentCampaignName
		--, NULL AS RecentCampaignTactic
		, src.Format__c as RecentCampaignFormat
		--, NULL AS RecentCampaignPlacement
		--, NULL AS RecentCampaignCompany
		--, NULL AS RecentCampaignLocation
		--, NULL AS RecentCampaignBudgetType
		--, NULL AS RecentCampaignBudgetName
		--, NULL as RecentCampaignRegion
		--, NULL as RecentCampaignMarketDMA
		--, NULL as RecentCampaignAudience
		, src.Language__c as RecentCampaignLanguage
		, src.PromoCodeName__c as RecentCampaignPromotionCode
		--, NULL as RecentCampaignLandingPageURL
		, src.StartDate as RecentCampaignStartDate
		, src.EndDate as RecentCampaignEndDate
		, src.Status as RecentCampaignStatus
		--, NULL as HowDidYouHearAboutUs
		, sl.PostalCode as PostalCode 
		--, NULL as DistanceToAssignedCenter
		--, NULL as DistanceToNearestCenter
		, g.DMAMarketRegion as Region 
		, g.DMADescription as MarketDMA
		, ctr.CenterDescriptionFullCalc as CenterName
		, cn.DMAMarketRegion as CenterRegion
		, cn.DMADescription as CenterDMA
		, ctr.CenterTypeDescription as CenterType
		, ctr.CenterOwnershipDescription as CenterOwner
		, sl.Language__c as Language
		, sl.Gender__c as Gender
		, sl.LastName 
		, sl.FirstName 
		, REPLACE(REPLACE(REPLACE(REPLACE(sl.[Phone],'(',''),')',''),' ',''),'-','') as 'Phone'
		, REPLACE(REPLACE(REPLACE(REPLACE(sl.[MobilePhone],'(',''),')',''),' ',''),'-','') AS 'MobilePhone'
		, sl.Email 
		, sl.Ethnicity__c as Ethnicity
		, Isnull(sl.NorwoodScale__c,sl.LudwigScale__c) as HairLossCondition
		, sl.MaritalStatus__c as MaritalStatus
		, sl.Occupation__c as Occupation
		--, NULL as HHIncome
		, YEAR(sl.Birthday__c) as BirthYear
		, CASE WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 1 AND 17) THEN 'Under 18'
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 18 AND 24) THEN '18 to 24'
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 25 AND 34) THEN '25 to 34'
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 35 AND 44) THEN '35 to 44'
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 45 AND 54) THEN '45 to 54'
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 55 AND 64) THEN '55 to 64'
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 65 AND 120) THEN '65 +'
				 ELSE 'Unknown'
				END AS AgeBands
		, ft.Contact as NewContact
		, ft.Lead as NewLead
		, ft.Appointment as NewAppointment
		, ft.Show as NewShow
		, ft.Sale as NewSale
		, ft.NewLeadToappointment as NewLeadToAppointment
		, ft.NewLeadToshow as NewLeadToShow
		, ft.NewLeadTosale as NewLeadToSale
		, ft.QuotedPrice as QuotedPrice
		--, null as ContractedPrice
		--, Null as NetRevenue
		--, Null as LifetimeRevenue
		, ft.saletypeDescription as PrimarySolution
		--, Null as Solution
		--, Null as Service
		, case when sl.DoNotContact__c = 1 then 'Y' else 'N' end as DoNotContactFlag
		, case when sl.DoNotCall = 1 then 'Y' else 'N' end as DoNotCallFlag
		, case when sl.DoNotText__c = 1 then 'Y' else 'N' end as DoNotSMSFlag
		, case when sl.DoNotEmail__c = 1 then 'Y' else 'N' end as DoNotEmailFlag
		, case when sl.DoNotMail__c = 1 then 'Y' else 'N' end as DoNotMailFlag
		, sl.IsDeleted as 'IsDeleted'
		, ft.LastModifiedDate
		FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl 
		left join [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Campaign soc
		on sl.OriginalCampaignID__c = soc.Id 
		left join [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Campaign src
		on sl.RecentCampaign__c = src.Id 
		left join (
			Select cc.CenterID
			, cc.CenterDescriptionFullCalc 
			, cct.CenterTypeDescription 
			, cco.CenterOwnershipDescription 
			from [hc-sqlpool-eim-prod-eus2].ODS.CNCT_Center cc 
			inner join [hc-sqlpool-eim-prod-eus2].ODS.CNCT_CenterOwnership cco 
			on cc.CenterOwnershipID = cco.CenterOwnershipID
			INNER join [hc-sqlpool-eim-prod-eus2].ODS.CNCT_CenterType cct 
			on cc.CenterTypeID = cct.CenterTypeID 
			where cc.isactiveflag = 1
		) as ctr
		on ISNULL(sl.CenterNumber__c, sl.CenterID__c) = ctr.CenterID
		inner join #FunnelTable ft
		on sl.Id = ft.id
		left join [ODS].[SFDC_Task] tsk
			on tsk.Id = ft.TaskId
		LEFT JOIN [ODS].[CNCT_Center] center
			ON tsk.CenterNumber__c = center.CenterId and center.isactiveflag = 1
		LEFT JOIN [ODS].[CNCT_CenterType] cty
			ON center.CenterTypeID = cty.CenterTypeID
		left join [dbo].[DimTimeOfDay] dtd
		on trim(dtd.[Time24]) = trim(convert(varchar,ActivityDateEST,8))
		left join [dbo].[DimGeography] g
		on sl.PostalCode = g.DigitZipCode
		left join (
			SELECT g.DigitZipCode
			, g.DMACode
			, c.CenterNumber
			, DMAMarketRegion
			, DMADescription
			FROM [hc-sqlpool-eim-prod-eus2].[dbo].[DimGeography] g
			inner join [ODS].[CNCT_Center] c
			on c.[PostalCode] = g.[DigitZipCode]
			where c.isactiveflag=1) as cn
		on sl.[CenterNumber__c] = cn.[CenterNumber]
	where sl.Id in (Select * from #NewLeads) 


	update Reports.Funnel 
	set [ContactID] = NULL
		  ,[SalesForceTaskID] = ft.Taskid
		  ,[BrightPatternID] = NULL
		  ,[LeadFunnelTransactionID] = NULL
		  ,[SaleforceLeadID] = sl.Id
		  ,[Company] = CASE WHEN(cty.CenterTypeDescription = 'Hans Wiemann') THEN 'Hans Wiemann'
					   ELSE 'Hair Club' end
		  ,[FunnelStep] = ft.FunnelStep
		  ,[Funnelstatus] = sl.Status
		  ,[OriginalGCLID] = sl.GCLID__c
		  ,[OriginalContactType] = sl.LeadSource
		  ,[OriginalSourcecode] = sl.Source_Code_Legacy__c
		  ,[OriginalDialedNumber] = CASE WHEN soc.SourceCode_L__c like '%MP'
									THEN soc.TollFreeMobileName__c
									ELSE soc.TollFreeName__c end
		  ,[OriginalPhoneNumberAreaCode] = SUBSTRING(sl.PhoneAbr__c, 0,4 )
		  ,[OriginalCampaignAgency] = soc.[Type]
		  ,[OriginalCampaignChannel] = soc.Channel__c
		  ,[OriginalCampaignName] = soc.Name
		  ,[OriginalCampaignFormat] = soc.Format__c
		  ,[OriginalCampaignLanguage] = soc.Language__c
		  ,[OriginalCampaignPromotionCode] = soc.PromoCodeName__c
		  ,[OriginalCampaignStartDate] = soc.StartDate
		  ,[OriginalCampaignEndDate] = soc.EndDate
		  ,[OriginalCampaignStatus] = soc.Status
		  ,[RecentSourcecode] = sl.RecentSourceCode__c
		  ,[RecentDialedNumber] = CASE WHEN src.SourceCode_L__c like '%MP'
								  THEN src.TollFreeMobileName__c
								  ELSE src.TollFreeName__c end
		  ,[RecentPhoneNumberAreaCode] = SUBSTRING(sl.PhoneAbr__c, 0,4 )
		  ,[RecentCampaignAgency] = src.[Type]
		  ,[RecentCampaignChannel] = src.Channel__c
		  ,[RecentCampaignName] = src.Name
		  ,[RecentCampaignFormat] = src.Format__c
		  ,[RecentCampaignLanguage] = src.Language__c
		  ,[RecentCampaignPromotionCode] = src.PromoCodeName__c
		  ,[RecentCampaignStartDate] = src.StartDate
		  ,[RecentCampaignEndDate] = src.EndDate
		  ,[RecentCampaignStatus] = src.Status
		  ,[PostalCode] = sl.PostalCode
		  ,[Region] = g.DMAMarketRegion
		  ,[MarketDMA] = g.DMADescription
		  ,[CenterName] = ctr.CenterDescriptionFullCalc
		  ,[CenterRegion] = cn.DMAMarketRegion
		  ,[CenterDMA] = cn.DMADescription
		  ,[CenterType] = ctr.CenterTypeDescription
		  ,[CenterOwner] = ctr.CenterOwnershipDescription
		  ,[Language] = sl.Language__c
		  ,[Gender] = sl.Gender__c 
		  ,[LastName] = sl.LastName 
		  ,[FirstName] = sl.FirstName 
		  ,[Phone] = REPLACE(REPLACE(REPLACE(REPLACE(sl.[Phone],'(',''),')',''),' ',''),'-','')
		  ,[MobilePhone] = REPLACE(REPLACE(REPLACE(REPLACE(sl.[MobilePhone],'(',''),')',''),' ',''),'-','')
		  ,[Email] = sl.Email 
		  ,[Ethnicity] = sl.Ethnicity__c
		  ,[HairLossCondition] = Isnull(sl.NorwoodScale__c,sl.LudwigScale__c)
		  ,[MaritalStatus] = sl.MaritalStatus__c
		  ,[Occupation] = sl.Occupation__c
		  ,[BirthYear] = YEAR(sl.Birthday__c)
		  ,[AgeBands] = CASE WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 1 AND 17) THEN 'Under 18'
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 18 AND 24) THEN '18 to 24'
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 25 AND 34) THEN '25 to 34'
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 35 AND 44) THEN '35 to 44'
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 45 AND 54) THEN '45 to 54'
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 55 AND 64) THEN '55 to 64'
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 65 AND 120) THEN '65 +'
				 ELSE 'Unknown' end
		  ,[NewContact] = ft.Contact
		  ,[NewLead] = ft.Lead
		  ,[NewAppointment] = ft.Appointment
		  ,[NewShow] = ft.Show
		  ,[NewSale] = ft.Sale
		  ,[NewLeadToAppointment] = ft.NewLeadToappointment
		  ,[NewLeadToShow] = ft.NewLeadToshow
		  ,[NewLeadToSale] = ft.NewLeadTosale
		  ,[QuotedPrice] = ft.QuotedPrice
		  ,[PrimarySolution] = ft.saletypeDescription
		  ,[DoNotContactFlag] =  case when sl.DoNotContact__c = 1 then 'Y' else 'N' end
		  ,[DoNotCallFlag] =  case when sl.DoNotCall = 1 then 'Y' else 'N' end
		  ,[DoNotSMSFlag] =  case when sl.DoNotText__c = 1 then 'Y' else 'N' end
		  ,[DoNotEmailFlag] =  case when sl.DoNotEmail__c = 1 then 'Y' else 'N' end
		  ,[DoNotMailFlag] =  case when sl.DoNotMail__c = 1 then 'Y' else 'N' end
		  ,[IsDeleted] = sl.IsDeleted
		  ,[LastModifiedDate] = ft.LastModifiedDate
	FROM Reports.Funnel  r
	inner join [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl
	on r.saleforceleadid = sl.id
	left join [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Campaign soc
		on sl.OriginalCampaignID__c = soc.Id 
		left join [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Campaign src
		on sl.RecentCampaign__c = src.Id 
		left join (
			Select cc.CenterID
			, cc.CenterDescriptionFullCalc 
			, cct.CenterTypeDescription 
			, cco.CenterOwnershipDescription 
			from [hc-sqlpool-eim-prod-eus2].ODS.CNCT_Center cc 
			inner join [hc-sqlpool-eim-prod-eus2].ODS.CNCT_CenterOwnership cco 
			on cc.CenterOwnershipID = cco.CenterOwnershipID
			INNER join [hc-sqlpool-eim-prod-eus2].ODS.CNCT_CenterType cct 
			on cc.CenterTypeID = cct.CenterTypeID 
			where cc.isactiveflag = 1
		) as ctr
		on ISNULL(sl.CenterNumber__c, sl.CenterID__c) = ctr.CenterID
		inner join #FunnelTable ft
		on sl.Id = ft.id
		left join [ODS].[SFDC_Task] tsk
			on tsk.Id = ft.TaskId
		LEFT JOIN [ODS].[CNCT_Center] center
			ON tsk.CenterNumber__c = center.CenterId and center.isactiveflag = 1
		LEFT JOIN [ODS].[CNCT_CenterType] cty
			ON center.CenterTypeID = cty.CenterTypeID
		left join [dbo].[DimTimeOfDay] dtd
		on trim(dtd.[Time24]) = trim(convert(varchar,ft.ActivityDateEST,8))
		left join [dbo].[DimGeography] g
		on sl.PostalCode = g.DigitZipCode
		left join (
			SELECT g.DigitZipCode
			, g.DMACode
			, c.CenterNumber
			, DMAMarketRegion
			, DMADescription
			FROM [hc-sqlpool-eim-prod-eus2].[dbo].[DimGeography] g
			inner join [ODS].[CNCT_Center] c
			on c.[PostalCode] = g.[DigitZipCode]
			where c.isactiveflag=1) as cn
		on sl.[CenterNumber__c] = cn.[CenterNumber]
		where sl.Id in (Select * from #UpdateLeads) and ft.[FunnelStep] = 'Contact'
	;

		update Reports.Funnel 
	set [ContactID] = NULL
		  ,[SalesForceTaskID] = ft.Taskid
		  ,[BrightPatternID] = NULL
		  ,[LeadFunnelTransactionID] = NULL
		  ,[SaleforceLeadID] = sl.Id
		  ,[Company] = CASE WHEN(cty.CenterTypeDescription = 'Hans Wiemann') THEN 'Hans Wiemann'
					   ELSE 'Hair Club' end
		  ,[FunnelStep] = ft.FunnelStep
		  ,[Funnelstatus] = sl.Status
		  ,[OriginalGCLID] = sl.GCLID__c
		  ,[LeadCreateDateUTC] = sl.CreatedDate
		  ,[LeadCreateDateEST] = dateadd(mi,datepart(tz,CONVERT(datetime,sl.CreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.CreatedDate)
		  ,[ActivityDateUTC] = ft.ActivityDateUTC
		  ,[ActivityDateEST] = ft.ActivityDateEST
		  ,[ReportCreateDate] = sl.[ReportCreateDate__c]
		  ,[Date] = cast(ft.ActivityDateEST as date)
		  ,[Time] = cast(ft.ActivityDateEST as time)
		  ,[DayPart] = dtd.DayPart
		  ,[Hour] = dtd.[Hour]
		  ,[Minute] = dtd.[minute]
		  ,[Seconds] = dtd.[Second]
		  ,[OriginalContactType] = sl.LeadSource
		  ,[OriginalSourcecode] = sl.Source_Code_Legacy__c
		  ,[OriginalDialedNumber] = CASE WHEN soc.SourceCode_L__c like '%MP'
									THEN soc.TollFreeMobileName__c
									ELSE soc.TollFreeName__c end
		  ,[OriginalPhoneNumberAreaCode] = SUBSTRING(sl.PhoneAbr__c, 0,4 )
		  ,[OriginalCampaignAgency] = soc.[Type]
		  ,[OriginalCampaignChannel] = soc.Channel__c
		  ,[OriginalCampaignName] = soc.Name
		  ,[OriginalCampaignFormat] = soc.Format__c
		  ,[OriginalCampaignLanguage] = soc.Language__c
		  ,[OriginalCampaignPromotionCode] = soc.PromoCodeName__c
		  ,[OriginalCampaignStartDate] = soc.StartDate
		  ,[OriginalCampaignEndDate] = soc.EndDate
		  ,[OriginalCampaignStatus] = soc.Status
		  ,[RecentSourcecode] = sl.RecentSourceCode__c
		  ,[RecentDialedNumber] = CASE WHEN src.SourceCode_L__c like '%MP'
								  THEN src.TollFreeMobileName__c
								  ELSE src.TollFreeName__c end
		  ,[RecentPhoneNumberAreaCode] = SUBSTRING(sl.PhoneAbr__c, 0,4 )
		  ,[RecentCampaignAgency] = src.[Type]
		  ,[RecentCampaignChannel] = src.Channel__c
		  ,[RecentCampaignName] = src.Name
		  ,[RecentCampaignFormat] = src.Format__c
		  ,[RecentCampaignLanguage] = src.Language__c
		  ,[RecentCampaignPromotionCode] = src.PromoCodeName__c
		  ,[RecentCampaignStartDate] = src.StartDate
		  ,[RecentCampaignEndDate] = src.EndDate
		  ,[RecentCampaignStatus] = src.Status
		  ,[PostalCode] = sl.PostalCode
		  ,[Region] = g.DMAMarketRegion
		  ,[MarketDMA] = g.DMADescription
		  ,[CenterName] = ctr.CenterDescriptionFullCalc
		  ,[CenterRegion] = cn.DMAMarketRegion
		  ,[CenterDMA] = cn.DMADescription
		  ,[CenterType] = ctr.CenterTypeDescription
		  ,[CenterOwner] = ctr.CenterOwnershipDescription
		  ,[Language] = sl.Language__c
		  ,[Gender] = sl.Gender__c 
		  ,[LastName] = sl.LastName 
		  ,[FirstName] = sl.FirstName 
		  ,[Phone] = REPLACE(REPLACE(REPLACE(REPLACE(sl.[Phone],'(',''),')',''),' ',''),'-','')
		  ,[MobilePhone] = REPLACE(REPLACE(REPLACE(REPLACE(sl.[MobilePhone],'(',''),')',''),' ',''),'-','')
		  ,[Email] = sl.Email 
		  ,[Ethnicity] = sl.Ethnicity__c
		  ,[HairLossCondition] = Isnull(sl.NorwoodScale__c,sl.LudwigScale__c)
		  ,[MaritalStatus] = sl.MaritalStatus__c
		  ,[Occupation] = sl.Occupation__c
		  ,[BirthYear] = YEAR(sl.Birthday__c)
		  ,[AgeBands] = CASE WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 1 AND 17) THEN 'Under 18'
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 18 AND 24) THEN '18 to 24'
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 25 AND 34) THEN '25 to 34'
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 35 AND 44) THEN '35 to 44'
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 45 AND 54) THEN '45 to 54'
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 55 AND 64) THEN '55 to 64'
				 WHEN(CAST(DATEDIFF(year, sl.Birthday__c, getdate()) AS INT) BETWEEN 65 AND 120) THEN '65 +'
				 ELSE 'Unknown' end
		  ,[NewContact] = ft.Contact
		  ,[NewLead] = ft.Lead
		  ,[NewAppointment] = ft.Appointment
		  ,[NewShow] = ft.Show
		  ,[NewSale] = ft.Sale
		  ,[NewLeadToAppointment] = ft.NewLeadToappointment
		  ,[NewLeadToShow] = ft.NewLeadToshow
		  ,[NewLeadToSale] = ft.NewLeadTosale
		  ,[QuotedPrice] = ft.QuotedPrice
		  ,[PrimarySolution] = ft.saletypeDescription
		  ,[DoNotContactFlag] =  case when sl.DoNotContact__c = 1 then 'Y' else 'N' end
		  ,[DoNotCallFlag] =  case when sl.DoNotCall = 1 then 'Y' else 'N' end
		  ,[DoNotSMSFlag] =  case when sl.DoNotText__c = 1 then 'Y' else 'N' end
		  ,[DoNotEmailFlag] =  case when sl.DoNotEmail__c = 1 then 'Y' else 'N' end
		  ,[DoNotMailFlag] =  case when sl.DoNotMail__c = 1 then 'Y' else 'N' end
		  ,[IsDeleted] = sl.IsDeleted
		  ,[LastModifiedDate] = ft.LastModifiedDate
	FROM Reports.Funnel  r
	inner join [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl
	on r.saleforceleadid = sl.id
	left join [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Campaign soc
		on sl.OriginalCampaignID__c = soc.Id 
		left join [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Campaign src
		on sl.RecentCampaign__c = src.Id 
		left join (
			Select cc.CenterID
			, cc.CenterDescriptionFullCalc 
			, cct.CenterTypeDescription 
			, cco.CenterOwnershipDescription 
			from [hc-sqlpool-eim-prod-eus2].ODS.CNCT_Center cc 
			inner join [hc-sqlpool-eim-prod-eus2].ODS.CNCT_CenterOwnership cco 
			on cc.CenterOwnershipID = cco.CenterOwnershipID
			INNER join [hc-sqlpool-eim-prod-eus2].ODS.CNCT_CenterType cct 
			on cc.CenterTypeID = cct.CenterTypeID 
			where cc.isactiveflag = 1
		) as ctr
		on ISNULL(sl.CenterNumber__c, sl.CenterID__c) = ctr.CenterID
		inner join #FunnelTable ft
		on sl.Id = ft.id
		left join [ODS].[SFDC_Task] tsk
			on tsk.Id = ft.TaskId
		LEFT JOIN [ODS].[CNCT_Center] center
			ON tsk.CenterNumber__c = center.CenterId and center.isactiveflag = 1
		LEFT JOIN [ODS].[CNCT_CenterType] cty
			ON center.CenterTypeID = cty.CenterTypeID
		left join [dbo].[DimTimeOfDay] dtd
		on trim(dtd.[Time24]) = trim(convert(varchar,ft.ActivityDateEST,8))
		left join [dbo].[DimGeography] g
		on sl.PostalCode = g.DigitZipCode
		left join (
			SELECT g.DigitZipCode
			, g.DMACode
			, c.CenterNumber
			, DMAMarketRegion
			, DMADescription
			FROM [hc-sqlpool-eim-prod-eus2].[dbo].[DimGeography] g
			inner join [ODS].[CNCT_Center] c
			on c.[PostalCode] = g.[DigitZipCode]
			where c.isactiveflag=1) as cn
		on sl.[CenterNumber__c] = cn.[CenterNumber]
		where sl.Id in (Select * from #UpdateLeads) and ft.[FunnelStep] not in ('Contact');



update Reports.Funnel set Region = Funnel.CenterRegion
where PostalCode is null or Region is null

update Reports.Funnel set MarketDMA = Funnel.CenterDMA
where PostalCode is null or MarketDMA is null

update Reports.Funnel set CenterRegion = Funnel.Region
where CenterRegion is null

update Reports.Funnel set CenterDMA = Funnel.MarketDMA
where CenterDMA is null;


With lead_temp as (
		SELECT [SaleforceLeadID],[FunnelTransactionID]
		FROM Reports.Funnel 
		where funnelstep = 'Lead' --and [SaleforceLeadID] ='00Qf4000003mSxVEAU'
		)
		--insert into #temp
		select [SaleforceLeadID],[FunnelTransactionID] into #update_transaction from lead_temp;

update Reports.Funnel 
	set [LeadFunnelTransactionID] = u.[FunnelTransactionID]
FROM Reports.Funnel  r
INNER JOIN #update_transaction u
on r.[SaleforceLeadID] = u.[SaleforceLeadID];

With bpcd as (
		SELECT [pkid],cast([custom3] as varchar) custom3
		FROM [ODS].[BP_CallDetail]
		where custom3 is not null
		)
		--insert into #temp
		select [pkid],cast([custom3]  as varchar) custom3 into #pkid from bpcd;



update Reports.Funnel 
	set [BrightPatternID] = b.pkid
FROM Reports.Funnel  r
INNER JOIN #pkid b
on r.[SalesForceTaskID] = b.custom3;

With bpcd_lead as (
		SELECT [pkid],cast([custom1] as varchar) custom1,[start_time],ROW_NUMBER() OVER(PARTITION BY custom1 ORDER BY [start_time] ASC) as rownum
		FROM [ODS].[BP_CallDetail]
		where custom3 is not null
		)
		--insert into #temp
		select [pkid],cast([custom1]  as varchar) custom1,[start_time],rownum into #pkid_lead from bpcd_lead
		where rownum = 1;


update Reports.Funnel 
	set [BrightPatternID] = b.pkid
FROM Reports.Funnel  r
INNER JOIN #pkid_lead b
on r.[SaleforceLeadID] = b.custom1



	DROP TABLE #FunnelTable
	DROP TABLE #update_transaction
	DROP TABLE #pkid
	DROP TABLE #pkid_lead
	DROP TABLE #NewLeads

end
        
GO
