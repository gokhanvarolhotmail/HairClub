/****** Object:  StoredProcedure [ODS].[sp_PopulateFunnel]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [ODS].[sp_PopulateFunnel] AS
BEGIN

    truncate table Reports.Funnel

/************************************************** CREATE TABLES *******************************************************/
create Table #Contact
	(
	    id varchar(50),
	    TaskID varchar(50),
	    QuotedPrice int,
	    SaletypeDescription varchar(100),
	    Whoid varchar(50),
	    Result varchar(50),
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

/****************************************************INSERT INTO TEMP TABLES**************************************************/


	Insert into
	   #Contact
	Select
	  sl.LeadId
	, null as TaskID
	, null as QuotedPrice
	, null as SaletypeDescription
	, null as Whoid
	, null as Result
	, sl.LeadLastActivityDate as ActivityDateUTC
	, dateadd(mi,datepart(tz,CONVERT(datetime,sl.LeadLastActivityDate)    AT TIME ZONE 'Eastern Standard Time'),sl.LeadLastActivityDate) as ActivityDateEST
	, 'Contact' as FunnelStep
	, 1 as Contact
	, 0 as lead
	, 0 as appointment
	, 0 as show
	, 0 as sale
	, 0 as NewLeadToappointment
	, 0 as NewLeadToshow
	, 0 as NewLeadTosale
	, sl.LeadCreatedDateUTC as CreatedDate
	, NULL AS LastModifiedDate
	FROM dbo.VWLead sl


	---Lead
	Insert into  #Lead
	Select
	  sl.leadid
	, null as TaskID
	, null as QuotedPrice
	, null as SaletypeDescription
	, null as Whoid
	, null as Result
	, sl.LeadLastActivityDate as ActivityDateUTC
	, dateadd(mi,datepart(tz,CONVERT(datetime,sl.LeadLastActivityDate)    AT TIME ZONE 'Eastern Standard Time'),sl.LeadLastActivityDate) as ActivityDateEST
	, 'Lead' as FunnelStep
	, 0 as Contact
	, 1 as lead
	, 0 as appointment
	, 0 as show
	, 0 as sale
	, 0 as NewLeadToappointment
	, 0 as NewLeadToshow
	, 0 as NewLeadTosale
	, sl.LeadCreatedDateUTC as CreatedDate
	, null as LastModifiedDate
	FROM dbo.VWLead sl
	where Isvalid = '1';



--Appointment
	With task as (
	SELECT AppointmentId Taskid,a.leadid as leadid,a.AppointmentStatus,a.AppointmentDate,FactDate,a.DWH_LastUpdateDate,a.accountid,a.externalTaskID,
	ROW_NUMBER() OVER(PARTITION BY a.leadid ORDER BY a.FactDate ASC)
	AS RowNum
	FROM dbo.FactAppointment a
	left JOIN dbo.VWLead sl on a.LeadId=sl.leadid
    left join dimaccount c on a.accountid=c.accountid
    left join dbo.VWLead d on c.accountid=d.convertedaccountid
	)
		Insert into
	      #Appointment
		SELECT
		a.leadid
		, a.Taskid
		, NULL AS QuotedPrice
		, 'Unknown' as saletypeDescription
		, a.leadid
		, a.AppointmentStatus as Result
		, NULL as ActivityDate
		, a.AppointmentDate AS ActivityDateEST
		, 'Appointment' as FunnelStep
		, 0 as Contact
		, 0 as Lead
		, 1 as Appointment
		, 0 as Show
		, 0 as Sale
		, 0 as NewLeadToappointment
		, 0 as NewLeadToshow
		, 0 as NewLeadTosale
		, a.FactDate as CreatedDate
		, a.DWH_LastUpdateDate
		FROM task a
        where RowNum = 1 and a.Taskid is not null and a.AppointmentStatus not like 'Canceled';


	---Show
        With task as (
            SELECT OpportunityId Taskid,b.LeadId,b.OpportunityStatus,b.FactDate,b.LastModifiedDate,b.accountid,externaltaskid,
            ROW_NUMBER() OVER(PARTITION BY b.LeadId,b.accountid ORDER BY b.FactDate ASC)
            AS RowNum
            FROM dbo.FactOpportunity b

            )

		Insert into
	    #Show
		SELECT
		a.leadid
		, a.Taskid
		, null as QuotedPrice
		, 'Unknown' as saletypeDescription
		, a.LeadId
		, a.OpportunityStatus as Result
		, NULL as ActivityDate
		, a.FactDate AS ActivityDateEST
		, 'Show' as FunnelStep
		, 0 as Contact
		, 0 as Lead
		, 0 as Appointment
		, 1 as Show
		, 0 as Sale
		, 0 as NewLeadToappointment
		, 0 as NewLeadToshow
		, 0 as NewLeadTosale
		, a.FactDate as CreatedDate
		, a.LastModifiedDate
        FROM task a
		left JOIN dbo.VWLead sl on a.LeadId=sl.leadid
        left join dimaccount c on a.accountid=c.accountid
       -- left join dbo.VWLead d on c.accountid=d.convertedaccountid
        where RowNum = 1 and a.Taskid is not null and a.OpportunityStatus is not null ;



	---Sale

		With task as (
            SELECT OpportunityId Taskid,b.LeadId,b.OpportunityStatus,b.FactDate,b.LastModifiedDate,Iswon,accountid,ExternalTaskId,
            ROW_NUMBER() OVER(PARTITION BY b.LeadId,accountid ORDER BY b.FactDate ASC)
            AS RowNum
            FROM dbo.FactOpportunity b

            )

		Insert into
	    #Sale
		SELECT
		a.leadid
		, a.Taskid
		, null as QuotedPrice
		, 'Unknown' as saletypeDescription
		, a.LeadId
		, a.OpportunityStatus as Result
		, NULL as ActivityDate
		, a.FactDate AS ActivityDateEST
		, 'Sale' as FunnelStep
		, 0 as Contact
		, 0 as Lead
		, 0 as Appointment
		, 0 as Show
		, 1 as Sale
		, 0 as NewLeadToappointment
		, 0 as NewLeadToshow
		, 0 as NewLeadTosale
		, a.FactDate as CreatedDate
		, a.LastModifiedDate
		FROM task a
		left JOIN dbo.VWLead sl on a.LeadId=sl.leadid
        left join dimaccount c on a.accountid=c.accountid
       -- left join dbo.VWLead d on c.accountid=d.convertedaccountid
        where RowNum = 1
        and a.IsWon = '1' and a.Taskid is not null and a.OpportunityStatus = 'Closed Won';



	---Temp

	With task as (
	SELECT id Taskid,b.WhoId,Result__c Result,ActivityDate,
	ROW_NUMBER() OVER(PARTITION BY b.WhoId  ORDER BY activityDate ASC)
	AS RowNum
	FROM ods.SF_Task b
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





/*********************************UPDATE FUNNEL TABLE*********************************************/

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


	DROP TABLE #Appointment
	DROP TABLE #Contact
	DROP TABLE #Lead
	DROP TABLE #Sale
	DROP TABLE #Show
	DROP TABLE #temp
	DROP TABLE #temporal;


/****************************************INSERT INTO REPORTS FUNNEL TABLE***************************************/

    With recentcampaign as (
    SELECT b.*,
    ROW_NUMBER() OVER(PARTITION BY b.CampaignId ORDER BY b.CreatedDate ASC)
    AS RowNum
    FROM ods.SF_CampaignMember b


    )

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
		, sl.LeadId as SaleforceLeadID
		, CASE WHEN(cty.CenterTypeDescription = 'Hans Wiemann') THEN 'Hans Wiemann'
			   ELSE 'Hair Club'
			   END AS Company
		, ft.FunnelStep
		, sl.LeadStatus as FunnelStatus
		, sl.GCLID as OriginalGCLID
		, sl.LeadCreatedDateUTC as LeadCreateDateUTC
		, dateadd(mi,datepart(tz,CONVERT(datetime,sl.LeadCreatedDateUTC)    AT TIME ZONE 'Eastern Standard Time'),sl.LeadCreatedDateUTC) as LeadCreateDateEST
		, ft.ActivityDateUTC as ActivityDateUTC
		, ft.ActivityDateEST as ActivityDateEST
		, sl.LeadCreatedDateUTC as ReportCreateDate
		, cast(ft.ActivityDateEST as date) as Date
		, cast(ft.ActivityDateEST as time) as time
		, dtd.DayPart as DayPart
		, dtd.[Hour] as Hour
		, dtd.[minute] as Minute
		, dtd.[Second] as Seconds
		, sl.SourceName AS OriginalContactType
		, soc.SourceCode as OriginalSourcecode
		, CASE WHEN soc.SourceCode like '%MP'
				THEN soc.TollFreeMobileName
			ELSE
				soc.TollFreeName
		  END AS OriginalDialedNumber
		, SUBSTRING(sl.LeadPhone, 0,4 ) AS OriginalPhoneNumberAreaCode
		, soc.AgencyName as OriginalCampaignAgency
		, soc.CampaignChannel as OriginalCampaignChannel
		, soc.CampaignName  as OriginalCampaignName
		, soc.CampaignFormat as OriginalCampaignFormat
		, soc.CampaignLanguage as OriginalCampaignLanguage
		, soc.PromoCode as OriginalCampaignPromotionCode
		, soc.StartDate as OriginalCampaignStartDate
		, soc.EndDate as OriginalCampaignEndDate
		, soc.CampaignStatus as OriginalCampaignStatus
	    , sl.SourceName as RecentSourceCode
		, CASE WHEN roc.SourceCode like '%MP'
				THEN roc.TollFreeMobileName
			ELSE
				roc.TollFreeName
		  END AS OriginalDialedNumber
		, SUBSTRING(sl.LeadPhone, 0,4 ) as RecentPhoneNumberAreaCode
		, roc.CampaignType as RecentCampaignAgency
		, roc.CampaignChannel as RecentCampaignChannel
		, roc.CampaignName as RecentCampaignName
		, roc.CampaignFormat as RecentCampaignFormat
		, roc.CampaignLanguage as RecentCampaignLanguage
		, roc.PromoCode as RecentCampaignPromotionCode
		, roc.StartDate as RecentCampaignStartDate
		, roc.EndDate as RecentCampaignEndDate
		, roc.CampaignStatus as RecentCampaignStatus
		, sl.CenterPostalCode as PostalCode
		, g.DMAMarketRegion as Region
		, g.DMADescription as MarketDMA
		, ctr.CenterDescriptionFullCalc as CenterName
		, cn.DMAMarketRegion as CenterRegion
		, cn.DMADescription as CenterDMA
		, ctr.CenterTypeDescription as CenterType
		, ctr.CenterOwnershipDescription as CenterOwner
		, sl.LeadLanguage as Language
		, sl.LeadGender as Gender
		, sl.LeadLastname
		, sl.LeadName
		, REPLACE(REPLACE(REPLACE(REPLACE(sl.LeadPhone,'(',''),')',''),' ',''),'-','') as 'Phone'
		, REPLACE(REPLACE(REPLACE(REPLACE(sl.LeadMobilePhone,'(',''),')',''),' ',''),'-','') AS 'MobilePhone'
		, sl.LeadEmail
		, sl.LeadEthnicity as Ethnicity
		, Isnull(sl.NorwoodScale,sl.LudwigScale) as HairLossCondition
		, sl.LeadMaritalStatus as MaritalStatus
		, sl.LeadOccupation as Occupation
		, YEAR(sl.LeadBirthday) as BirthYear
		, CASE WHEN(CAST(DATEDIFF(year, sl.LeadBirthday, getdate()) AS INT) BETWEEN 1 AND 17) THEN 'Under 18'
				 WHEN(CAST(DATEDIFF(year, sl.LeadBirthday, getdate()) AS INT) BETWEEN 18 AND 24) THEN '18 to 24'
				 WHEN(CAST(DATEDIFF(year, sl.LeadBirthday, getdate()) AS INT) BETWEEN 25 AND 34) THEN '25 to 34'
				 WHEN(CAST(DATEDIFF(year, sl.LeadBirthday, getdate()) AS INT) BETWEEN 35 AND 44) THEN '35 to 44'
				 WHEN(CAST(DATEDIFF(year, sl.LeadBirthday, getdate()) AS INT) BETWEEN 45 AND 54) THEN '45 to 54'
				 WHEN(CAST(DATEDIFF(year, sl.LeadBirthday, getdate()) AS INT) BETWEEN 55 AND 64) THEN '55 to 64'
				 WHEN(CAST(DATEDIFF(year, sl.LeadBirthday, getdate()) AS INT) BETWEEN 65 AND 120) THEN '65 +'
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
		, ft.saletypeDescription as PrimarySolution
		, case when sl.DoNotContact = 1 then 'Y' else 'N' end as DoNotContactFlag
		, case when sl.DoNotCall = 1 then 'Y' else 'N' end as DoNotCallFlag
		, case when sl.DoNotText = 1 then 'Y' else 'N' end as DoNotSMSFlag
		, case when sl.DoNotEmail = 1 then 'Y' else 'N' end as DoNotEmailFlag
		, case when sl.DoNotMail = 1 then 'Y' else 'N' end as DoNotMailFlag
		, sl.IsDeleted as 'IsDeleted'
		, ft.LastModifiedDate
		FROM VWLead sl
		left join ( select * from recentcampaign
		            where RowNum = 2) as rcg
		on rcg.CampaignId = sl.OriginalCampaignId
		left join dbo.DimCampaign soc
		on sl.OriginalCampaignId = soc.CampaignId
		left join dbo.DimCampaign roc
		on roc.CampaignId = rcg.CampaignId
		left join (
			Select cc.CenterID
			, cc.CenterNumber
			, cc.CenterDescriptionFullCalc
			, cct.CenterTypeDescription
			, cco.CenterOwnershipDescription
			from ODS.CNCT_Center cc
			inner join ODS.CNCT_CenterOwnership cco
			on cc.CenterOwnershipID = cco.CenterOwnershipID
			INNER join ODS.CNCT_CenterType cct
			on cc.CenterTypeID = cct.CenterTypeID
			where cc.isactiveflag = 1
		) as ctr
		on sl.CenterNumber = ctr.CenterNumber
		inner join #FunnelTable ft
		on sl.leadid = ft.id
		LEFT JOIN [ODS].[CNCT_Center] center
			ON sl.CenterNumber = center.CenterId and center.isactiveflag = 1
		LEFT JOIN [ODS].[CNCT_CenterType] cty
			ON center.CenterTypeID = cty.CenterTypeID
		left join [dbo].[DimTimeOfDay] dtd
		on trim(dtd.[Time24]) = trim(convert(varchar,ActivityDateEST,8))
		left join [dbo].[DimGeography] g
		on sl.CenterPostalCode = g.DigitZipCode
		left join (
			SELECT g.DigitZipCode
			, g.DMACode
			, c.CenterNumber
			, DMAMarketRegion
			, DMADescription
			FROM [dbo].[DimGeography] g
			inner join [ODS].[CNCT_Center] c
			on c.[PostalCode] = g.[DigitZipCode]
			where c.isactiveflag=1) as cn
		on sl.[CenterNumber] = cn.[CenterNumber];


/****************************************UPDATE REPORTS FUNNEL********************************************/

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

END
GO
