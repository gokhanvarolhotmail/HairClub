/****** Object:  StoredProcedure [dbo].[Populate_DWHFactFunnel]    Script Date: 1/7/2022 4:05:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Populate_DWHFactFunnel] AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
    CREATE Table #NewLeads(
IdLead varchar(50)
)

insert into
  #NewLeads
Select sl.Leadid from [dbo].[DimLead] sl
where cast(sl.LastModifiedDate as date) = DATEADD(DAY, -1, Cast(GETDATE() as date)) 
union
Select st.whoid from [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Task st
where cast(st.LastModifiedDate as date) = DATEADD(DAY, -1, Cast(GETDATE() as date)) 

Delete from [dbo].[FactFunnel]
where LeadId in (Select * from #NewLeads)

---------------------------------------INSERT-------------------------------------------------

create Table #Lead
      (
          FactDateKey varchar(100),
          FactDate datetime,
          LeadID varchar(100),
          LeadKey varchar(100),
      LeadCreatedDate datetime,
          [Accountkey] varchar(100),
          AccountID varchar(50),
          ContactID varchar(50),
          CustomerID varchar(50),
          Membershipkey varchar(50),
          MembershipID varchar(50),
          FunnelStepKey varchar(20),
          FunnelStep varchar(20),
          CenterKey varchar(100),
          CenterID  varchar(50),
          CenterNumber varchar(100),
          IsValidLead bit
      )
      
      create Table #Appointment
      (
          FactDateKey varchar(100),
          FactDate datetime,
          LeadID varchar(100),
          LeadKey varchar(100),
          LeadCreatedDate datetime,
          [Accountkey] varchar(100),
          AccountID varchar(50),
          ContactID varchar(50),
          CustomerID varchar(50),
          Membershipkey varchar(50),
          MembershipID varchar(50),
          FunnelStepKey varchar(20),
          FunnelStep varchar(20),
          CenterKey varchar(100),
          CenterID  varchar(50),
          CenterNumber varchar(100),
          IsValidLead bit
      )

            create Table #Show
      (
          FactDateKey varchar(100),
          FactDate datetime,
          LeadID varchar(100),
          LeadKey varchar(100),
          LeadCreatedDate datetime,
          [Accountkey] varchar(100),
          AccountID varchar(50),
          ContactID varchar(50),
          CustomerID varchar(50),
          Membershipkey varchar(50),
          MembershipID varchar(50),
          FunnelStepKey varchar(20),
          FunnelStep varchar(20),
          CenterKey varchar(100),
          CenterID  varchar(50),
          CenterNumber varchar(100),
          IsValidLead bit
      )

            create Table #NB
      (
          FactDateKey varchar(100),
          FactDate datetime,
          LeadID varchar(100),
          LeadKey varchar(100),
          LeadCreatedDate datetime,
          [Accountkey] varchar(100),
          AccountID varchar(50),
          ContactID varchar(50),
          CustomerID varchar(50),
          Membershipkey varchar(50),
          MembershipID varchar(50),
          FunnelStepKey varchar(20),
          FunnelStep varchar(20),
          CenterKey varchar(100),
          CenterID  varchar(50),
          CenterNumber varchar(100),
          IsValidLead bit
      )

            create Table #PCP
      (
          FactDateKey varchar(100),
          FactDate datetime,
          LeadID varchar(100),
          LeadKey varchar(100),
          LeadCreatedDate datetime,
          [Accountkey] varchar(100),
          AccountID varchar(50),
          ContactID varchar(50),
          CustomerID varchar(50),
          Membershipkey varchar(50),
          MembershipID varchar(50),
          FunnelStepKey varchar(20),
          FunnelStep varchar(20),
          CenterKey varchar(100),
          CenterID  varchar(50),
          CenterNumber varchar(100),
          IsValidLead bit
      )

            create Table #FactFunnelTable
      (
          FactDateKey varchar(100),
          FactDate datetime,
          LeadID varchar(100),
          LeadKey varchar(100),
          LeadCreatedDate datetime,
          [Accountkey] varchar(100),
          AccountID varchar(50),
          ContactID varchar(50),
          CustomerID varchar(50),
          Membershipkey varchar(50),
          MembershipID varchar(50),
          FunnelStepKey varchar(20),
          FunnelStep varchar(20),
          CenterKey varchar(100),
          CenterID  varchar(50),
          CenterNumber varchar(100),
          IsValidLead bit
      )

-----------------------------------------------------
---LEAD
      Insert into #Lead
      Select 
      dl.[CreatedDateKey] AS FactDateKey
      ,dl.[LeadCreatedDate] AS FactDate
      ,dl.LeadID 
      ,dl.LeadKey
      ,dl.[LeadCreatedDate] AS LeadCreatedDate
    ,NULL AS [Accountkey] 
    ,dl.ConvertedAccountId AS AccountID 
    ,dl.ConvertedContactId AS ContactID 
    ,NULL AS CustomerID 
    ,NULL AS Membershipkey 
    ,NULL AS MembershipID 
    ,fs.FunnelStepKey
    ,'Lead' as FunnelStep
      , cntr.[CenterKey]
      , cntr.[CenterID]
      , cntr.[CenterNumber]
      ,dl.IsValid as IsValidLead 
      FROM [dbo].[DimLead] dl
      left join [dbo].[DimFunnelStep] fs
      on fs.[FunnelStepName] = 'Lead'
    LEFT JOIN [dbo].[DimCenter] cntr
    ON cntr.[CenterKey] = dl.Centerkey
  where dl.LeadID in (select IDLead from #NewLeads);


--APPOINTMENT
      With task as (
      SELECT PriceQuoted__c QuotedPrice,b.WhoId,Result__c Result,Action__c Action,StartTime__c, activitydate,[CreatedDate],
      ROW_NUMBER() OVER(PARTITION BY b.WhoId ORDER BY activityDate ASC)
      AS RowNum
      FROM [ODS].[SFDC_Task] b
      where trim(action__c) in ('Appointment','In House','Be Back') and result__c <> 'Void'
      )
            Insert into 
           #Appointment
            SELECT
            dt.DateKey AS FactDateKey
          ,CASE WHEN (task.starttime__c not like '%NULL%') THEN cast(concat(left(task.ActivityDate,11),task.StartTime__c) as datetime)
            ELSE task.activitydate 
            END AS FactDate
          ,dl.LeadID 
          ,dl.LeadKey
          ,dl.[LeadCreatedDate] AS LeadCreatedDate
          ,NULL AS [Accountkey] 
          ,dl.ConvertedAccountId AS AccountID 
          ,dl.ConvertedContactId AS ContactID 
          ,NULL AS CustomerID 
          ,NULL AS Membershipkey 
          ,NULL AS MembershipID 
          ,fs.FunnelStepKey
          ,'Appointment' as FunnelStep 
      , cntr.[CenterKey]
      , cntr.[CenterID]
      , cntr.[CenterNumber]
          ,dl.IsValid as IsValidLead 
            FROM [dbo].[DimLead] dl
            left join [dbo].[DimFunnelStep] fs
            on fs.[FunnelStepName] = 'Appointment'
            INNER JOIN task on isnull(dl.ConvertedContactId,dl.LeadID) = task.whoid 
            LEFT JOIN [dbo].[DimDate] dt
            ON dt.FullDate = cast(task.activitydate as date)
      LEFT JOIN [dbo].[DimCenter] cntr
      ON cntr.[CenterKey] = dl.Centerkey
            where task.rownum=1 and dl.LeadID in (select IDLead from #NewLeads);

 ---SHOW     
      
      With task as (
      SELECT PriceQuoted__c QuotedPrice,b.WhoId,Result__c Result,Action__c Action,StartTime__c, activitydate,[CreatedDate],
      ROW_NUMBER() OVER(PARTITION BY b.WhoId ORDER BY activityDate ASC)
      AS RowNum
      FROM [ODS].[SFDC_Task] b
      where action__c in ('Appointment','Be Back','In House') and (result__c='Show No Sale' or result__c='Show Sale') 
      )
            Insert into 
          #Show
            SELECT
            dt.DateKey AS FactDateKey
          ,CASE WHEN (task.starttime__c not like '%NULL%') THEN cast(concat(left(task.ActivityDate,11),task.StartTime__c) as datetime)
          ELSE task.activitydate 
          END AS FactDate
          ,dl.LeadID 
          ,dl.LeadKey
          ,dl.[LeadCreatedDate] AS LeadCreatedDate
          ,NULL AS [Accountkey] 
          ,dl.ConvertedAccountId AS AccountID 
          ,dl.ConvertedContactId AS ContactID 
          ,NULL AS CustomerID 
          ,NULL AS Membershipkey 
          ,NULL AS MembershipID 
          ,fs.FunnelStepKey
          ,'Show' as FunnelStep 
      , cntr.[CenterKey]
      , cntr.[CenterID]
      , cntr.[CenterNumber]
          ,dl.IsValid as IsValidLead 
            FROM [dbo].[DimLead] dl
            left join [dbo].[DimFunnelStep] fs
            on fs.[FunnelStepName] = 'Show'
            INNER JOIN task on isnull(dl.ConvertedContactId,dl.LeadID) = task.whoid 
            LEFT JOIN [dbo].[DimDate] dt
            ON dt.FullDate = cast(task.activitydate as date)
      LEFT JOIN [dbo].[DimCenter] cntr
      ON cntr.[CenterKey] = dl.Centerkey
            where task.rownum=1 and dl.LeadID in (select IDLead from #NewLeads);

-----NB
      with membership as (
            SELECT ROW_NUMBER() OVER ( PARTITION BY clt.[SalesforceContactID], rg.RevenueGroupDescription ORDER BY cm.BeginDate, cm.EndDate ) AS 'RowID'
            , 'First ' + rg.RevenueGroupDescriptionShort + ' Membership' AS 'Data'
            , clt.CenterID
            , clt.ClientIdentifier
            , clt.ClientFullNameAltCalc
            , rg.RevenueGroupDescriptionShort AS 'FunnelStep'
            , cm.BeginDate
      , dt.DateKey as 'FactDateKey'
            , cm.EndDate
            , cm.CancelDate
            , cm.MonthlyFee
            , clt.[SalesforceContactID]
      ,clt.ClientGUID
      , dm.MembershipID
      , dm.MembershipKey
            FROM [ODS].[CNCT_datClientMembership] cm
            INNER JOIN [ODS].[CNCT_cfgMembership] m
            ON m.MembershipID = cm.MembershipID
            INNER JOIN [ODS].[CNCT_RevenueGroup] rg
            ON rg.RevenueGroupID = m.RevenueGroupID
            INNER JOIN [ODS].[CNCT_lkpBusinessSegment] bs
            ON bs.BusinessSegmentID = m.BusinessSegmentID
            INNER JOIN [ODS].[CNCT_lkpClientMembershipStatus] cms
            ON cms.ClientMembershipStatusID = cm.ClientMembershipStatusID
            INNER JOIN [ODS].[CNCT_datClient] clt
            ON clt.ClientGUID = cm.ClientGUID
      LEFT JOIN [dbo].[DimDate] dt
      ON dt.FullDate = cm.BeginDate
      left JOIN[dbo].[DimMembership]  dm
            ON m.MembershipID = dm.MembershipID
            WHERE rg.RevenueGroupDescriptionShort = 'NB' and (([MembershipShortName] not like 's%' and [MembershipName] not like 'New%') or [MembershipName] not like 'Retail')
      )

      Insert into 
            #NB
            SELECT
            m.FactDateKey
          , m.BeginDate AS FactDate
          ,dl.LeadID 
          ,dl.LeadKey
          ,dl.[LeadCreatedDate] AS LeadCreatedDate
          ,NULL AS [Accountkey] 
          ,dl.ConvertedAccountId AS AccountID 
          ,dl.ConvertedContactId AS ContactID 
          ,cu.[CustomerIdentifier] AS CustomerID 
      , m.MembershipID
      , m.MembershipKey
          ,fs.FunnelStepKey
          ,'NB' as FunnelStep
      , cntr.[Centerkey] as [CenterKey]
      , cntr.[CenterId] as [CenterID]
      , cntr.[CenterNumber]
          ,dl.IsValid as IsValidLead 
            FROM [dbo].[DimLead] dl
            left join [dbo].[DimFunnelStep] fs
            on fs.[FunnelStepName] = 'NB'
            INNER JOIN membership m
            on isnull(dl.ConvertedContactId,dl.LeadID) = m.[SalesforceContactID]
      LEFT JOIN [dbo].[DimCustomer] cu
      ON cu.[CustomerGUID] = m.ClientGUID
      LEFT JOIN [dbo].[DimCenter] cntr
      ON cu.[CenterKey] = cntr.Centerkey
      where m.RowID=1 and dl.LeadID in (select IDLead from #NewLeads);

----PCP

      with membership as (
          SELECT ROW_NUMBER() OVER ( PARTITION BY clt.[SalesforceContactID], rg.RevenueGroupDescription ORDER BY cm.BeginDate, cm.EndDate ) AS 'RowID'
          , 'First ' + rg.RevenueGroupDescriptionShort + ' Membership' AS 'Data'
          , clt.CenterID
          , clt.ClientIdentifier
          , clt.ClientFullNameAltCalc
          , rg.RevenueGroupDescriptionShort AS 'FunnelStep'
      , cm.BeginDate
      , dt.DateKey as 'FactDateKey'
      , cm.EndDate
      , cm.CancelDate
          , cm.MonthlyFee
          , clt.[SalesforceContactID]
      , dm.MembershipID
      , dm.MembershipKey
      ,clt.ClientGUID
          FROM [ODS].[CNCT_datClientMembership] cm
      INNER JOIN [ODS].[CNCT_cfgMembership] m
          ON m.MembershipID = cm.MembershipID
      INNER JOIN [ODS].[CNCT_RevenueGroup] rg
          ON rg.RevenueGroupID = m.RevenueGroupID
      INNER JOIN [ODS].[CNCT_lkpBusinessSegment] bs
          ON bs.BusinessSegmentID = m.BusinessSegmentID
      INNER JOIN [ODS].[CNCT_lkpClientMembershipStatus] cms
          ON cms.ClientMembershipStatusID = cm.ClientMembershipStatusID
      INNER JOIN [ODS].[CNCT_datClient] clt
          ON clt.ClientGUID = cm.ClientGUID
      LEFT JOIN [dbo].[DimDate] dt
      ON dt.FullDate = cm.BeginDate
      left JOIN[dbo].[DimMembership]  dm
          ON m.MembershipID = dm.MembershipID
          WHERE rg.RevenueGroupDescriptionShort = 'PCP' and (([MembershipShortName] not like 's%' and [MembershipName] not like 'New%') or [MembershipName] not like 'Retail')
      )

      Insert into 
            #PCP
            SELECT
            m.FactDateKey
          , m.BeginDate AS FactDate
          ,dl.LeadID 
          ,dl.LeadKey
          ,dl.[LeadCreatedDate] AS LeadCreatedDate
          ,NULL AS [Accountkey] 
          ,dl.ConvertedAccountId AS AccountID 
          ,dl.ConvertedContactId AS ContactID 
          ,cu.[CustomerIdentifier] AS CustomerID 
          , m.MembershipID
        , m.MembershipKey
          ,fs.FunnelStepKey
          ,'PCP' as FunnelStep 
        , cntr.[Centerkey] as [CenterKey]
        , cntr.[CenterId] as [CenterID]
        , cntr.[CenterNumber]
          ,dl.IsValid as IsValidLead 
      FROM [dbo].[DimLead] dl
      left join [dbo].[DimFunnelStep] fs
          on fs.[FunnelStepName] = 'PCP'
      inner JOIN membership m
            on isnull(dl.ConvertedContactId,dl.LeadID) = m.[SalesforceContactID]
      LEFT JOIN [dbo].[DimCustomer] cu
          ON cu.[CustomerGUID] = m.ClientGUID
      LEFT JOIN [dbo].[DimCenter] cntr
        ON cntr.[CenterKey] = cu.Centerkey
    where m.RowID=1 and dl.LeadID in (select IDLead from #NewLeads);


-------------------------------------------

      Insert into 
         #FactFunnelTable
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
      from #NB
      Union all
      Select * 
      from #PCP;


      insert into [dbo].[FactFunnel]
      select 
     [FactDatekey]
      ,[FactDate]
      ,[LeadCreatedDate]
      ,[Leadkey]
      ,[LeadId]
      ,[Accountkey]
      ,[AccountId]
      ,[ContactId]
      ,[CustomerId]
      ,[Membershipkey]
      ,[MembershipId]
      ,[FunnelStepKey]
      ,[FunnelStep]
      ,[CenterKey]
      ,[CenterID]
      ,[CenterNumber]
      ,[IsvalidLead]
      from #FactFunnelTable
    


      
      DROP TABLE #Lead
      DROP TABLE #Appointment
      DROP TABLE #Show
      DROP TABLE #NB
      DROP TABLE #PCP
      DROP TABLE #FactFunnelTable
	  DROP TABLE #NewLeads
END
GO
