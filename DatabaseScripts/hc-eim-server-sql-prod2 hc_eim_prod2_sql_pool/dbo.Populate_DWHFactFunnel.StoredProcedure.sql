/****** Object:  StoredProcedure [dbo].[Populate_DWHFactFunnel]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Populate_DWHFactFunnel] AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

truncate table dbo.FactFunnel

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
      dt.DateKey AS FactDateKey
      ,dateadd(mi,datepart(tz,CONVERT(datetime,dl.[LeadCreatedDateUTC])    AT TIME ZONE 'Eastern Standard Time'),dl.[LeadCreatedDateUTC]) AS FactDate
      ,dl.LeadID
      ,dl.LeadKey
      ,dateadd(mi,datepart(tz,CONVERT(datetime,dl.[LeadCreatedDateUTC])    AT TIME ZONE 'Eastern Standard Time'),dl.[LeadCreatedDateUTC]) AS LeadCreatedDate
      ,NULL AS [Accountkey]
      ,dl.ConvertedAccountId AS AccountID
      ,null AS ContactID
      ,NULL AS CustomerID
      ,NULL AS Membershipkey
      ,NULL AS MembershipID
      ,fs.FunnelStepKey
      ,'Lead' as FunnelStep
      , cntr.[CenterKey]
      , cntr.[CenterID]
      , cntr.[CenterNumber]
      ,dl.IsValid as IsValidLead
      FROM [dbo].[VWLead] dl
      left join [dbo].[DimFunnelStep] fs
      on fs.[FunnelStepName] = 'Lead'
    LEFT JOIN [dbo].[DimCenter] cntr
    ON cntr.[CenterKey] = dl.Centerkey
    LEFT JOIN dbo.DimDate dt
    ON dt.FullDate = convert(date,dateadd(mi,datepart(tz,CONVERT(datetime,dl.[LeadCreatedDateUTC])    AT TIME ZONE 'Eastern Standard Time'),dl.[LeadCreatedDateUTC]));


--APPOINTMENT
      With task as (
        SELECT AppointmentId Taskid,isnull(a.leadid,d.LeadId) as leadid,a.AppointmentStatus,a.AppointmentDate,FactDate,a.DWH_LastUpdateDate,a.accountid,a.externalTaskID,
        ROW_NUMBER() OVER(PARTITION BY isnull(a.leadid,d.LeadId) ORDER BY a.AppointmentDate ASC)
        AS RowNum
        FROM dbo.FactAppointment a
        left JOIN dbo.DimLead sl on a.LeadId=sl.leadid
        left join dimaccount c on a.accountid=c.accountid
        left join dimlead d on c.accountid=d.convertedaccountid
        )
            Insert into
           #Appointment
            SELECT
            dt.DateKey AS FactDateKey
          , task.FactDate AS FactDate
          ,dl.LeadID
          ,dl.LeadKey
          ,dateadd(mi,datepart(tz,CONVERT(datetime,dl.[LeadCreatedDateUTC])    AT TIME ZONE 'Eastern Standard Time'),dl.[LeadCreatedDateUTC]) AS LeadCreatedDate
          ,NULL AS [Accountkey]
          ,dl.ConvertedAccountId AS AccountID
          ,null AS ContactID
          ,NULL AS CustomerID
          ,NULL AS Membershipkey
          ,NULL AS MembershipID
          ,fs.FunnelStepKey
          ,'Appointment' as FunnelStep
          , cntr.[CenterKey]
          , cntr.[CenterID]
          , cntr.[CenterNumber]
          ,dl.IsValid as IsValidLead
            FROM [dbo].[VWLead] dl
            left join [dbo].[DimFunnelStep] fs
            on fs.[FunnelStepName] = 'Appointment'
            INNER JOIN task on dl.LeadID = task.leadid
            LEFT JOIN [dbo].[DimDate] dt
            ON dt.FullDate = cast(task.FactDate as date)
      LEFT JOIN [dbo].[DimCenter] cntr
      ON cntr.[CenterKey] = dl.Centerkey
            where task.rownum=1;

 ---SHOW

       With task as (
            SELECT b.OpportunityId Taskid,b.LeadId,b.OpportunityStatus,b.AppointmentDate as FactDate,b.accountid,externaltaskid,
            ROW_NUMBER() OVER(PARTITION BY b.LeadId,b.accountid ORDER BY b.AppointmentDate ASC)
            AS RowNum
            FROM dbo.VWFactAppointment b

            )
            Insert into
          #Show
            SELECT
            dt.DateKey AS FactDateKey
          ,task.FactDate AS FactDate
          ,dl.LeadID
          ,dl.LeadKey
          ,dateadd(mi,datepart(tz,CONVERT(datetime,dl.[LeadCreatedDateUTC])    AT TIME ZONE 'Eastern Standard Time'),dl.[LeadCreatedDateUTC]) AS LeadCreatedDate
          ,NULL AS [Accountkey]
          ,dl.ConvertedAccountId AS AccountID
          ,null AS ContactID
          ,NULL AS CustomerID
          ,NULL AS Membershipkey
          ,NULL AS MembershipID
          ,fs.FunnelStepKey
          ,'Show' as FunnelStep
          , cntr.[CenterKey]
          , cntr.[CenterID]
          , cntr.[CenterNumber]
          ,dl.IsValid as IsValidLead
            FROM [dbo].[VWLead] dl
            left join [dbo].[DimFunnelStep] fs
            on fs.[FunnelStepName] = 'Show'
            INNER JOIN task on dl.LeadID = task.LeadId
            LEFT JOIN [dbo].[DimDate] dt
            ON dt.FullDate = cast(task.FactDate as date)
      LEFT JOIN [dbo].[DimCenter] cntr
      ON cntr.[CenterKey] = dl.Centerkey
            where task.rownum=1 and task.Taskid is not null;

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
            WHERE rg.RevenueGroupDescriptionShort = 'NB' and (([MembershipShortName] not like 's%' and [MembershipName] not like 'New%') or [MembershipName] not like 'Retail') and
                  DM.MembershipShortName NOT IN ( 'SHOWSALE', 'SHOWNOSALE', 'SNSSURGOFF', 'RETAIL', 'HCFK', 'NONPGM', 'MODEL', 'EMPLOYEE', 'EMPLOYEXT', 'MODELEXT','EMPLOYEE6' )
      )



      Insert into
            #NB
            SELECT
            m.FactDateKey
          , m.BeginDate AS FactDate
          ,dl.LeadID
          ,dl.LeadKey
          ,dateadd(mi,datepart(tz,CONVERT(datetime,dl.[LeadCreatedDateUTC])    AT TIME ZONE 'Eastern Standard Time'),dl.[LeadCreatedDateUTC]) AS LeadCreatedDate
          ,NULL AS [Accountkey]
          ,dl.ConvertedAccountId AS AccountID
          ,null AS ContactID
          ,cu.[CustomerIdentifier] AS CustomerID
          , m.MembershipID
          , m.MembershipKey
          ,fs.FunnelStepKey
          ,'NB' as FunnelStep
          , cntr.[Centerkey] as [CenterKey]
          , cntr.[CenterId] as [CenterID]
          , cntr.[CenterNumber]
          ,dl.IsValid as IsValidLead
            FROM [dbo].[VWLead] dl
            left join [dbo].[DimFunnelStep] fs
            on fs.[FunnelStepName] = 'NB'
            INNER JOIN membership m
            on isnull(dl.LeadID,dl.ConvertedAccountId) = m.[SalesforceContactID]
      LEFT JOIN [dbo].[DimCustomer] cu
      ON cu.[CustomerGUID] = m.ClientGUID
      LEFT JOIN [dbo].[DimCenter] cntr
      ON cu.[CenterKey] = cntr.Centerkey
      where m.RowID=1 ;

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
          ,dateadd(mi,datepart(tz,CONVERT(datetime,dl.[LeadCreatedDateUTC])    AT TIME ZONE 'Eastern Standard Time'),dl.[LeadCreatedDateUTC]) AS LeadCreatedDate
          , NULL AS [Accountkey]
          , dl.ConvertedAccountId AS AccountID
          , null AS ContactID
          , cu.[CustomerIdentifier] AS CustomerID
          , m.MembershipID
          , m.MembershipKey
          , fs.FunnelStepKey
          ,'PCP' as FunnelStep
          , cntr.[Centerkey] as [CenterKey]
          , cntr.[CenterId] as [CenterID]
          , cntr.[CenterNumber]
          ,dl.IsValid as IsValidLead
      FROM [dbo].[VWLead] dl
      left join [dbo].[DimFunnelStep] fs
          on fs.[FunnelStepName] = 'PCP'
      inner JOIN membership m
            on isnull(dl.LeadID,dl.ConvertedAccountId) = m.[SalesforceContactID]
      LEFT JOIN [dbo].[DimCustomer] cu
          ON cu.[CustomerGUID] = m.ClientGUID
      LEFT JOIN [dbo].[DimCenter] cntr
        ON cntr.[CenterKey] = cu.Centerkey
    where m.RowID=1;


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

END
GO
