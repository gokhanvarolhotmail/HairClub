/****** Object:  StoredProcedure [ODS].[sp_PopulateGoogleFeed]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [ODS].[sp_PopulateGoogleFeed] AS
TRUNCATE TABLE [Reports].[Google] ;

----Create tables----------
CREATE TABLE [#Contact]
(
    [GoogleClickID]      VARCHAR(2048)
  , [ConversionName]     VARCHAR(1024)
  , [ConversionTime]     VARCHAR(100)
  , [dateTimeG]          DATETIME
  , [ConversionValue]    VARCHAR(1000)
  , [ConversionCurrency] VARCHAR(10)
) ;

CREATE TABLE [#Lead]
(
    [GoogleClickID]      VARCHAR(2048)
  , [ConversionName]     VARCHAR(1024)
  , [ConversionTime]     VARCHAR(100)
  , [dateTimeG]          DATETIME
  , [ConversionValue]    VARCHAR(1000)
  , [ConversionCurrency] VARCHAR(10)
) ;

CREATE TABLE [#Appointment]
(
    [GoogleClickID]      VARCHAR(2048)
  , [ConversionName]     VARCHAR(1024)
  , [ConversionTime]     VARCHAR(100)
  , [dateTimeG]          DATETIME
  , [ConversionValue]    VARCHAR(1000)
  , [ConversionCurrency] VARCHAR(10)
) ;

CREATE TABLE [#Show]
(
    [GoogleClickID]      VARCHAR(2048)
  , [ConversionName]     VARCHAR(1024)
  , [ConversionTime]     VARCHAR(100)
  , [dateTimeG]          DATETIME
  , [ConversionValue]    VARCHAR(1000)
  , [ConversionCurrency] VARCHAR(10)
) ;

CREATE TABLE [#Sale]
(
    [GoogleClickID]      VARCHAR(2048)
  , [ConversionName]     VARCHAR(1024)
  , [ConversionTime]     VARCHAR(100)
  , [dateTimeG]          DATETIME
  , [ConversionValue]    VARCHAR(1000)
  , [ConversionCurrency] VARCHAR(10)
) ;

CREATE TABLE [#SaleUnknown]
(
    [GoogleClickID]      VARCHAR(2048)
  , [ConversionName]     VARCHAR(1024)
  , [ConversionTime]     VARCHAR(100)
  , [dateTimeG]          DATETIME
  , [ConversionValue]    VARCHAR(1000)
  , [ConversionCurrency] VARCHAR(10)
) ;

CREATE TABLE [#SaleEXT]
(
    [GoogleClickID]      VARCHAR(2048)
  , [ConversionName]     VARCHAR(1024)
  , [ConversionTime]     DATETIME
  , [dateTimeG]          DATETIME
  , [ConversionValue]    VARCHAR(1000)
  , [ConversionCurrency] VARCHAR(10)
) ;

CREATE TABLE [#SaleFUE]
(
    [GoogleClickID]      VARCHAR(2048)
  , [ConversionName]     VARCHAR(1024)
  , [ConversionTime]     VARCHAR(100)
  , [dateTimeG]          DATETIME
  , [ConversionValue]    VARCHAR(1000)
  , [ConversionCurrency] VARCHAR(10)
) ;

CREATE TABLE [#SaleFUT]
(
    [GoogleClickID]      VARCHAR(2048)
  , [ConversionName]     VARCHAR(1024)
  , [ConversionTime]     VARCHAR(100)
  , [dateTimeG]          DATETIME
  , [ConversionValue]    VARCHAR(1000)
  , [ConversionCurrency] VARCHAR(10)
) ;

CREATE TABLE [#SaleXtrands]
(
    [GoogleClickID]      VARCHAR(2048)
  , [ConversionName]     VARCHAR(1024)
  , [ConversionTime]     VARCHAR(100)
  , [dateTimeG]          DATETIME
  , [ConversionValue]    VARCHAR(1000)
  , [ConversionCurrency] VARCHAR(10)
) ;

CREATE TABLE [#SaleXtrandsPlus]
(
    [GoogleClickID]      VARCHAR(2048)
  , [ConversionName]     VARCHAR(1024)
  , [ConversionTime]     VARCHAR(100)
  , [dateTimeG]          DATETIME
  , [ConversionValue]    VARCHAR(1000)
  , [ConversionCurrency] VARCHAR(10)
) ;

CREATE TABLE [#FunnelTable]
(
    [GoogleClickID]      VARCHAR(2048)
  , [ConversionName]     VARCHAR(1024)
  , [ConversionTime]     VARCHAR(100)
  , [dateTimeG]          DATETIME
  , [ConversionValue]    VARCHAR(1000)
  , [ConversionCurrency] VARCHAR(10)
) ;

INSERT INTO [#Contact]
SELECT
    [sl].[GCLID] AS [GoogleClickID]
  , 'Import - Contacts' AS [ConversionName]
  , FORMAT(
        DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [sl].[LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [sl].[LeadCreatedDate])
        , 'MM/dd/yyyy hh:mm:ss.00 tt') AS [ConversionTime]
  , DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [sl].[LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [sl].[LeadCreatedDate]) AS [dateTimeG]
  , '0.00' AS [ConversionValue]
  , 'USD' AS [ConversionCurrency]
FROM [dbo].[DimLead] AS [sl]
WHERE [sl].[GCLID] IS NOT NULL ;

---Lead
INSERT INTO [#Lead]
SELECT
    [sl].[GCLID] AS [GoogleClickID]
  , 'Import - Leads' AS [ConversionName]
  , FORMAT(
        DATEADD(MINUTE, 2, DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [sl].[LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [sl].[LeadCreatedDate]))
      , 'MM/dd/yyyy hh:mm:ss.00 tt') AS [ConversionTime]
  , DATEADD(MINUTE, 2, DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [sl].[LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [sl].[LeadCreatedDate])) AS [dateTimeG]
  , '0.00' AS [ConversionValue]
  , 'USD' AS [ConversionCurrency]
FROM [dbo].[DimLead] AS [sl]
WHERE [Isvalid] = '1' AND [sl].[GCLID] IS NOT NULL ;

--Appointment
WITH [task]
AS ( SELECT
         [AppointmentId] AS [Taskid]
       , [b].[LeadId]
       , [b].[AppointmentStatus]
       , [b].[AppointmentDate]
       , [FactDate]
       , [b].[DWH_LastUpdateDate]
       , [b].[accountid]
       , [b].[externalTaskID]
       , ROW_NUMBER() OVER ( PARTITION BY [b].[LeadId], [b].[AccountId] ORDER BY [b].[AppointmentDate] ASC ) AS [RowNum]
     FROM [dbo].[FactAppointment] AS [b] )
INSERT INTO [#Appointment]
SELECT
    [sl].[GCLID] AS [GoogleClickID]
  , 'Import - Appointments' AS [ConversionName]
  , FORMAT(
        DATEADD(MINUTE, 3, DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [sl].[LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [sl].[LeadCreatedDate]))
      , 'MM/dd/yyyy hh:mm:ss.00 tt') AS [ConversionTime]
  , DATEADD(MINUTE, 3, DATEADD(mi, DATEPART(tz, CONVERT(DATETIME, [sl].[LeadCreatedDate])AT TIME ZONE 'Eastern Standard Time'), [sl].[LeadCreatedDate])) AS [dateTimeG]
  , '0.00' AS [ConversionValue]
  , 'USD' AS [ConversionCurrency]
FROM [dbo].[DimLead] AS [sl]
INNER JOIN [task] ON ISNULL([sl].[ConvertedContactId], [sl].[LeadId]) = [task].[LeadId] --OR sl.ConvertedContactId = task.WhoId
WHERE [task].[RowNum] = 1 AND [sl].[GCLID] IS NOT NULL ;

---Show
WITH [task]
AS ( SELECT
         [AppointmentId] AS [Taskid]
       , [b].[LeadId]
       , [b].[OpportunityStatus]
       , [b].[FactDate]
       , [b].[DWH_LastUpdateDate]
       , [b].[accountid]
       , [externaltaskid]
       , [b].[OpportunityId]
       , ROW_NUMBER() OVER ( PARTITION BY [b].[LeadId], [b].[accountid] ORDER BY [b].[FactDate] ASC ) AS [RowNum]
     FROM [dbo].[FactAppointment] AS [b] )
INSERT INTO [#Show]
SELECT
    [sl].[GCLID] AS [GoogleClickID]
  , 'Import - Shows' AS [ConversionName]
  , FORMAT(DATEADD(MINUTE, 2, CAST([task].[FactDate] AS DATETIME)), 'MM/dd/yyyy hh:mm:ss.00 tt') AS [ConversionTime]
  , ( DATEADD(MINUTE, 2, [task].[FactDate])) AS [dateTimeG]
  , '0.00' AS [ConversionValue]
  , 'USD' AS [ConversionCurrency]
FROM [dbo].[DimLead] AS [sl]
INNER JOIN [task] ON ISNULL([sl].[ConvertedContactId], [sl].[LeadId]) = [task].[LeadId] --OR sl.ConvertedContactId = task.WhoId
WHERE [task].[RowNum] = 1 AND [sl].[GCLID] IS NOT NULL AND [task].[OpportunityId] IS NOT NULL ;

---Sale
WITH [task]
AS ( SELECT
         [AppointmentId] AS [Taskid]
       , [b].[LeadId]
       , [b].[OpportunityStatus]
       , [b].[FactDate]
       , [b].[DWH_LastUpdateDate]
       , [b].[AppointmentStatus]
       , [accountid]
       , [ExternalTaskId]
       , ROW_NUMBER() OVER ( PARTITION BY [b].[LeadId], [accountid] ORDER BY [b].[FactDate] ASC ) AS [RowNum]
     FROM [dbo].[FactAppointment] AS [b] )
INSERT INTO [#Sale]
SELECT
    [sl].[GCLID] AS [GoogleClickID]
  , 'Import - Sales' AS [ConversionName]
  , FORMAT(DATEADD(MINUTE, 4, CAST(LEFT([task].[FactDate], 11) AS DATETIME)), 'MM/dd/yyyy hh:mm:ss.00 tt') AS [ConversionTime]
  , ( DATEADD(MINUTE, 4, CAST(LEFT([task].[FactDate], 11) AS DATETIME))) AS [dateTimeG]
  , '0.00' AS [ConversionValue]
  , 'USD' AS [ConversionCurrency]
FROM [dbo].[DimLead] AS [sl]
INNER JOIN [task] ON ISNULL([sl].[ConvertedContactId], [sl].[leadId]) = [task].[LeadId] --OR sl.ConvertedContactId = task.WhoId
WHERE [task].[RowNum] = 1 AND [sl].[GCLID] IS NOT NULL AND [task].[OpportunityStatus] = 'Closed Won' ;

---Import - Sale - EXT
WITH [task]
AS ( SELECT
         [AppointmentId] AS [Taskid]
       , [b].[LeadId]
       , [b].[OpportunityStatus]
       , [b].[FactDate]
       , [b].[DWH_LastUpdateDate]
       , [b].[AppointmentStatus]
       , [b].[accountid]
       , [ExternalTaskId]
       , [b].[OpportunityId]
       , ROW_NUMBER() OVER ( PARTITION BY [b].[LeadId], [b].[accountid] ORDER BY [b].[FactDate] ASC ) AS [RowNum]
     FROM [dbo].[FactAppointment] AS [b]
     LEFT OUTER JOIN [ODS].[CNCT_datClient] AS [clt] ON [clt].[SalesforceContactID] = [b].[leadid]
     LEFT OUTER JOIN [ODS].[CNCT_datClientMembership] AS [dcm] ON [dcm].[ClientGUID] = [clt].[ClientGUID]
                                                              AND CAST([b].[AppointmentDate] AS DATE) = [dcm].[BeginDate]
     LEFT OUTER JOIN [ODS].[CNCT_cfgMembership] AS [m] WITH( NOLOCK )ON [m].[MembershipID] = [dcm].[MembershipID]
     LEFT OUTER JOIN [ODS].[CNCT_lkpBusinessSegment] AS [bs] WITH( NOLOCK )ON [bs].[BusinessSegmentID] = [m].[BusinessSegmentID]
     WHERE [bs].[BusinessSegmentDescription] = 'Extreme Therapy' )
INSERT INTO [#SaleEXT]
SELECT
    [sl].[GCLID] AS [GoogleClickID]
  , 'Import - Sales - EXT' AS [ConversionName]
  , FORMAT(DATEADD(MINUTE, 5, CAST(LEFT([task].[FactDate], 11) AS DATETIME)), 'MM/dd/yyyy hh:mm:ss.00 tt')
  , ( DATEADD(MINUTE, 5, CAST(LEFT([task].[FactDate], 11) AS DATETIME))) AS [dateTimeG]
  , FORMAT(CAST('0.00' AS FLOAT), N'#.##') AS [ConversionValue]
  , 'USD' AS [ConversionCurrency]
FROM [dbo].[VWLead] AS [sl]
INNER JOIN [task] ON [sl].[LeadId] = [task].[LeadId] --OR sl.ConvertedContactId = task.WhoId
WHERE [task].[RowNum] = 1 AND [sl].[GCLID] IS NOT NULL AND [task].[OpportunityId] IS NOT NULL ;

---Import - Sale - Follicular Unit Extract (FUE)
WITH [task]
AS ( SELECT
         [AppointmentId] AS [Taskid]
       , [b].[LeadId]
       , [b].[OpportunityStatus]
       , [b].[FactDate]
       , [b].[DWH_LastUpdateDate]
       , [b].[AppointmentStatus]
       , [b].[accountid]
       , [ExternalTaskId]
       , [b].[OpportunityId]
       , ROW_NUMBER() OVER ( PARTITION BY [b].[LeadId], [b].[accountid] ORDER BY [b].[FactDate] ASC ) AS [RowNum]
     FROM [dbo].[FactAppointment] AS [b]
     LEFT OUTER JOIN [ODS].[CNCT_datClient] AS [clt] ON [clt].[SalesforceContactID] = [b].[leadid]
     LEFT OUTER JOIN [ODS].[CNCT_datClientMembership] AS [dcm] ON [dcm].[ClientGUID] = [clt].[ClientGUID]
                                                              AND CAST([b].[AppointmentDate] AS DATE) = [dcm].[BeginDate]
     LEFT OUTER JOIN [ODS].[CNCT_cfgMembership] AS [m] WITH( NOLOCK )ON [m].[MembershipID] = [dcm].[MembershipID]
     LEFT OUTER JOIN [ODS].[CNCT_lkpBusinessSegment] AS [bs] WITH( NOLOCK )ON [bs].[BusinessSegmentID] = [m].[BusinessSegmentID]
     WHERE [bs].[BusinessSegmentDescription] = 'Surgery' )
INSERT INTO [#SaleFUE]
SELECT
    [sl].[GCLID] AS [GoogleClickID]
  , 'Import - Sales - Follicular Unit Extract (FUE)' AS [ConversionName]
  , FORMAT(DATEADD(MINUTE, 5, CAST(LEFT([task].[FactDate], 11) AS DATETIME)), 'MM/dd/yyyy hh:mm:ss.00 tt') AS [ConversionTime]
  , ( DATEADD(MINUTE, 5, CAST(LEFT([task].[FactDate], 11) AS DATETIME))) AS [dateTimeG]
  , FORMAT(CAST('0.00' AS FLOAT), N'#.##') AS [ConversionValue]
  , 'USD' AS [ConversionCurrency]
FROM [dbo].[VWLead] AS [sl]
INNER JOIN [task] ON [sl].[LeadId] = [task].[LeadId] --OR sl.ConvertedContactId = task.WhoId
WHERE [task].[RowNum] = 1 AND [sl].[GCLID] IS NOT NULL AND [OpportunityId] IS NOT NULL ;

---Import - Sale - Follicular Unit Transportation (FUT)
WITH [task]
AS ( SELECT
         [AppointmentId] AS [Taskid]
       , [b].[LeadId]
       , [b].[OpportunityStatus]
       , [b].[FactDate]
       , [b].[DWH_LastUpdateDate]
       , [b].[AppointmentStatus]
       , [b].[accountid]
       , [ExternalTaskId]
       , [b].[OpportunityId]
       , ROW_NUMBER() OVER ( PARTITION BY [b].[LeadId], [b].[accountid] ORDER BY [b].[FactDate] ASC ) AS [RowNum]
     FROM [dbo].[FactAppointment] AS [b]
     LEFT OUTER JOIN [ODS].[CNCT_datClient] AS [clt] ON [clt].[SalesforceContactID] = [b].[leadid]
     LEFT OUTER JOIN [ODS].[CNCT_datClientMembership] AS [dcm] ON [dcm].[ClientGUID] = [clt].[ClientGUID]
                                                              AND CAST([b].[AppointmentDate] AS DATE) = [dcm].[BeginDate]
     LEFT OUTER JOIN [ODS].[CNCT_cfgMembership] AS [m] WITH( NOLOCK )ON [m].[MembershipID] = [dcm].[MembershipID]
     LEFT OUTER JOIN [ODS].[CNCT_lkpBusinessSegment] AS [bs] WITH( NOLOCK )ON [bs].[BusinessSegmentID] = [m].[BusinessSegmentID]
     WHERE [bs].[BusinessSegmentDescription] = 'Surgery Complete' )
INSERT INTO [#SaleFUT]
SELECT
    ISNULL([sl].[GCLID], ' ') AS [GoogleClickID]
  , 'Import - Sales - Follicular Unit Transportation (FUT)' AS [ConversionName]
  , FORMAT(DATEADD(MINUTE, 5, CAST(LEFT([task].[FactDate], 11) AS DATETIME)), 'MM/dd/yyyy hh:mm:ss.00 tt') AS [ConversionTime]
  , ( DATEADD(MINUTE, 5, CAST(LEFT([task].[FactDate], 11) AS DATETIME))) AS [dateTimeG]
  , FORMAT(CAST('0.00' AS FLOAT), N'#.##') AS [ConversionValue]
  , 'USD' AS [ConversionCurrency]
FROM [dbo].[VWLead] AS [sl]
INNER JOIN [task] ON [sl].[LeadId] = [task].[LeadId] --OR sl.ConvertedContactId = task.WhoId
WHERE [task].[RowNum] = 1 AND [sl].[GCLID] IS NOT NULL AND [OpportunityId] IS NOT NULL ;

---Import - Sale - Xtrands
WITH [task]
AS ( SELECT
         [AppointmentId] AS [Taskid]
       , [b].[LeadId]
       , [b].[OpportunityStatus]
       , [b].[FactDate]
       , [b].[DWH_LastUpdateDate]
       , [b].[AppointmentStatus]
       , [b].[accountid]
       , [ExternalTaskId]
       , [b].[OpportunityId]
       , ROW_NUMBER() OVER ( PARTITION BY [b].[LeadId], [b].[accountid] ORDER BY [b].[FactDate] ASC ) AS [RowNum]
     FROM [dbo].[FactAppointment] AS [b]
     LEFT OUTER JOIN [ODS].[CNCT_datClient] AS [clt] ON [clt].[SalesforceContactID] = [b].[leadid]
     LEFT OUTER JOIN [ODS].[CNCT_datClientMembership] AS [dcm] ON [dcm].[ClientGUID] = [clt].[ClientGUID]
                                                              AND CAST([b].[AppointmentDate] AS DATE) = [dcm].[BeginDate]
     LEFT OUTER JOIN [ODS].[CNCT_cfgMembership] AS [m] WITH( NOLOCK )ON [m].[MembershipID] = [dcm].[MembershipID]
     LEFT OUTER JOIN [ODS].[CNCT_lkpBusinessSegment] AS [bs] WITH( NOLOCK )ON [bs].[BusinessSegmentID] = [m].[BusinessSegmentID]
     WHERE [bs].[BusinessSegmentDescription] = 'Xtrands' )
INSERT INTO [#SaleXtrands]
SELECT
    [sl].[GCLID] AS [GoogleClickID]
  , 'Import - Sales - Xtrands' AS [ConversionName]
  , FORMAT(DATEADD(MINUTE, 5, CAST(LEFT([task].[FactDate], 11) AS DATETIME)), 'MM/dd/yyyy hh:mm:ss.00 tt') AS [ConversionTime]
  , ( DATEADD(MINUTE, 5, CAST(LEFT([task].[FactDate], 11) AS DATETIME))) AS [dateTimeG]
  , FORMAT(CAST('0.00' AS FLOAT), N'#.##') AS [ConversionValue]
  , 'USD' AS [ConversionCurrency]
FROM [dbo].[VWLead] AS [sl]
INNER JOIN [task] ON [sl].[LeadId] = [task].[leadid] --OR sl.ConvertedContactId = task.WhoId
WHERE [task].[RowNum] = 1 AND [sl].[GCLID] IS NOT NULL AND [OpportunityId] IS NOT NULL ;

---Import - Sale - Xtrands Plus
WITH [task]
AS ( SELECT
         [AppointmentId] AS [Taskid]
       , [b].[LeadId]
       , [b].[OpportunityStatus]
       , [b].[FactDate]
       , [b].[DWH_LastUpdateDate]
       , [b].[AppointmentStatus]
       , [b].[accountid]
       , [ExternalTaskId]
       , [b].[OpportunityId]
       , ROW_NUMBER() OVER ( PARTITION BY [b].[LeadId], [b].[accountid] ORDER BY [b].[FactDate] ASC ) AS [RowNum]
     FROM [dbo].[FactAppointment] AS [b]
     LEFT OUTER JOIN [ODS].[CNCT_datClient] AS [clt] ON [clt].[SalesforceContactID] = [b].[leadid]
     LEFT OUTER JOIN [ODS].[CNCT_datClientMembership] AS [dcm] ON [dcm].[ClientGUID] = [clt].[ClientGUID]
                                                              AND CAST([b].[AppointmentDate] AS DATE) = [dcm].[BeginDate]
     LEFT OUTER JOIN [ODS].[CNCT_cfgMembership] AS [m] WITH( NOLOCK )ON [m].[MembershipID] = [dcm].[MembershipID]
     LEFT OUTER JOIN [ODS].[CNCT_lkpBusinessSegment] AS [bs] WITH( NOLOCK )ON [bs].[BusinessSegmentID] = [m].[BusinessSegmentID]
     WHERE [bs].[BusinessSegmentDescription] = 'Xtrands+' )
INSERT INTO [#SaleXtrandsPlus]
SELECT
    [sl].[GCLID] AS [GoogleClickID]
  , 'Import - Sales - Xtrands Plus' AS [ConversionName]
  , FORMAT(DATEADD(MINUTE, 5, CAST(LEFT([task].[FactDate], 11) AS DATETIME)), 'MM/dd/yyyy hh:mm:ss.00 tt') AS [ConversionTime]
  , ( DATEADD(MINUTE, 5, CAST(LEFT([task].[FactDate], 11) AS DATETIME))) AS [dateTimeG]
  , FORMAT(CAST('0.00' AS FLOAT), N'#.##') AS [ConversionValue]
  , 'USD' AS [ConversionCurrency]
FROM [dbo].[VWLead] AS [sl]
INNER JOIN [task] ON [sl].[LeadId] = [task].[LeadId] --OR sl.ConvertedContactId = task.WhoId
WHERE [task].[RowNum] = 1 AND [sl].[GCLID] IS NOT NULL AND [OpportunityId] IS NOT NULL ;

---Sale Unknown
WITH [task]
AS ( SELECT
         [AppointmentId] AS [Taskid]
       , [b].[LeadId]
       , [b].[OpportunityStatus]
       , [b].[FactDate]
       , [b].[DWH_LastUpdateDate]
       , [b].[AppointmentStatus]
       , [b].[accountid]
       , [ExternalTaskId]
       , [b].[OpportunityId]
       , ROW_NUMBER() OVER ( PARTITION BY [b].[LeadId], [b].[accountid] ORDER BY [b].[FactDate] ASC ) AS [RowNum]
     FROM [dbo].[FactAppointment] AS [b]
     LEFT OUTER JOIN [ODS].[CNCT_datClient] AS [clt] ON [clt].[SalesforceContactID] = [b].[leadid]
     LEFT OUTER JOIN [ODS].[CNCT_datClientMembership] AS [dcm] ON [dcm].[ClientGUID] = [clt].[ClientGUID]
                                                              AND CAST([b].[AppointmentDate] AS DATE) = [dcm].[BeginDate]
     LEFT OUTER JOIN [ODS].[CNCT_cfgMembership] AS [m] WITH( NOLOCK )ON [m].[MembershipID] = [dcm].[MembershipID]
     LEFT OUTER JOIN [ODS].[CNCT_lkpBusinessSegment] AS [bs] WITH( NOLOCK )ON [bs].[BusinessSegmentID] = [m].[BusinessSegmentID]
     WHERE [bs].[BusinessSegmentDescription] NOT IN ('Surgery', 'Surgery Complete', 'Extreme Therapy', 'Xtrands+', 'Xtrands'))
INSERT INTO [#SaleUnknown]
SELECT
    [sl].[GCLID] AS [GoogleClickID]
  , 'Unknown' AS [ConversionName]
  , FORMAT(DATEADD(MINUTE, 5, CAST(LEFT([task].[FactDate], 11) AS DATETIME)), 'MM/dd/yyyy hh:mm:ss.00 tt') AS [ConversionTime]
  , ( DATEADD(MINUTE, 5, CAST(LEFT([task].[FactDate], 11) AS DATETIME))) AS [dateTimeG]
  , '0.00' AS [ConversionValue]
  , 'USD' AS [ConversionCurrency]
FROM [dbo].[VWLead] AS [sl]
INNER JOIN [task] ON [sl].[LeadId] = [task].[LeadId] --OR sl.ConvertedContactId = task.WhoId
WHERE [task].[RowNum] = 1 AND [sl].[GCLID] IS NOT NULL ;

---Union Tables
INSERT INTO [#FunnelTable]
SELECT *
FROM [#Contact]
UNION ALL
SELECT *
FROM [#Lead]
UNION ALL
SELECT *
FROM [#Appointment]
UNION ALL
SELECT *
FROM [#Show]
UNION ALL
SELECT *
FROM [#Sale]
UNION ALL
SELECT *
FROM [#SaleEXT]
UNION ALL
SELECT *
FROM [#SaleFUE]
UNION ALL
SELECT *
FROM [#SaleFUT]
UNION ALL
SELECT *
FROM [#SaleXtrands]
UNION ALL
SELECT *
FROM [#SaleXtrandsPlus]
UNION ALL
SELECT *
FROM [#SaleUnknown] ;

INSERT INTO [Reports].[Google]
SELECT DISTINCT
       [GoogleClickID]
     , [ConversionName]
     , [ConversionTime]
     , [ConversionValue]
     , [ConversionCurrency]
     , [dateTimeG]
FROM [#FunnelTable] ;

DROP TABLE [#Contact] ;
DROP TABLE [#Lead] ;
DROP TABLE [#Appointment] ;
DROP TABLE [#Show] ;
DROP TABLE [#Sale] ;
DROP TABLE [#SaleUnknown] ;
DROP TABLE [#SaleEXT] ;
DROP TABLE [#SaleFUE] ;
DROP TABLE [#SaleFUT] ;
DROP TABLE [#SaleXtrands] ;
DROP TABLE [#SaleXtrandsPlus] ;
DROP TABLE [#FunnelTable] ;
;
GO
