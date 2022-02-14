/****** Object:  StoredProcedure [ODS].[sp_PopulateGoogleFeed]    Script Date: 2/14/2022 11:44:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [ODS].[sp_PopulateGoogleFeed] AS
BEGIN

truncate table Reports.[Google]

----Create tables----------

create Table #Contact
	(
	    [GoogleClickID] varchar(2048),
	    ConversionName varchar(1024),
	    ConversionTime varchar(100),
		dateTimeG datetime,
	    ConversionValue VARCHAR(1000),
		ConversionCurrency varchar(10)
	)

	create Table #Lead
	(
	    [GoogleClickID] varchar(2048),
	    ConversionName varchar(1024),
	    ConversionTime varchar(100),
		dateTimeG datetime,
	    ConversionValue VARCHAR(1000),
		ConversionCurrency varchar(10)
	)

	create Table #Appointment
	(
	    [GoogleClickID] varchar(2048),
	    ConversionName varchar(1024),
	    ConversionTime varchar(100),
		dateTimeG datetime,
	    ConversionValue VARCHAR(1000),
		ConversionCurrency varchar(10)
	)

	create Table #Show
	(
	    [GoogleClickID] varchar(2048),
	    ConversionName varchar(1024),
	    ConversionTime varchar(100),
		dateTimeG datetime,
	    ConversionValue VARCHAR(1000),
		ConversionCurrency varchar(10)
	)

	create Table #Sale
	(
	    [GoogleClickID] varchar(2048),
	    ConversionName varchar(1024),
	    ConversionTime varchar(100),
		dateTimeG datetime,
	    ConversionValue VARCHAR(1000),
		ConversionCurrency varchar(10)
	)


	create Table #SaleUnknown
	(
	    [GoogleClickID] varchar(2048),
	    ConversionName varchar(1024),
	    ConversionTime varchar(100),
		dateTimeG datetime,
	    ConversionValue VARCHAR(1000),
		ConversionCurrency varchar(10)
	)

	create Table #SaleEXT
	(
	    [GoogleClickID] varchar(2048),
	    ConversionName varchar(1024),
	    ConversionTime datetime,
		dateTimeG datetime,
	    ConversionValue VARCHAR(1000),
		ConversionCurrency varchar(10)
	)

		create Table #SaleFUE
	(
	    [GoogleClickID] varchar(2048),
	    ConversionName varchar(1024),
	    ConversionTime varchar(100),
		dateTimeG datetime,
	    ConversionValue VARCHAR(1000),
		ConversionCurrency varchar(10)
	)
		create Table #SaleFUT
	(
	    [GoogleClickID] varchar(2048),
	    ConversionName varchar(1024),
	    ConversionTime varchar(100),
		dateTimeG datetime,
	    ConversionValue VARCHAR(1000),
		ConversionCurrency varchar(10)
	)
		create Table #SaleXtrands
	(
	    [GoogleClickID] varchar(2048),
	    ConversionName varchar(1024),
	    ConversionTime varchar(100),
		dateTimeG datetime,
	    ConversionValue VARCHAR(1000),
		ConversionCurrency varchar(10)
	)
		create Table #SaleXtrandsPlus
	(
	    [GoogleClickID] varchar(2048),
	    ConversionName varchar(1024),
	    ConversionTime varchar(100),
		dateTimeG datetime,
	    ConversionValue VARCHAR(1000),
		ConversionCurrency varchar(10)
	)

	create Table #FunnelTable
	(
	    [GoogleClickID] varchar(2048),
	    ConversionName varchar(1024),
	    ConversionTime varchar(100),
		dateTimeG datetime,
	    ConversionValue VARCHAR(1000),
		ConversionCurrency varchar(10)
	)


	Insert into
	    #Contact
	Select
	 sl.GCLID AS [GoogleClickID]
	, 'Import - Contacts' AS ConversionName
	, FORMAT(dateadd(mi,datepart(tz,CONVERT(datetime,sl.LeadCreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.LeadCreatedDate),'MM/dd/yyyy hh:mm:ss.00 tt') AS ConversionTime
	,dateadd(mi,datepart(tz,CONVERT(datetime,sl.LeadCreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.LeadCreatedDate) as dateTimeG
	, '0.00' AS ConversionValue
	, 'USD' AS ConversionCurrency
	FROM dbo.DimLead sl
	WHERE sl.GCLID IS NOT NULL;


	---Lead
	Insert into  #Lead
	Select
	 sl.GCLID AS [GoogleClickID]
	, 'Import - Leads' AS ConversionName
	, FORMAT(DATEADD(MINUTE,2,dateadd(mi,datepart(tz,CONVERT(datetime,sl.LeadCreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.LeadCreatedDate)),'MM/dd/yyyy hh:mm:ss.00 tt') AS ConversionTime
	,DATEADD(MINUTE,2,dateadd(mi,datepart(tz,CONVERT(datetime,sl.LeadCreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.LeadCreatedDate)) as dateTimeG
	, '0.00' AS ConversionValue
	, 'USD' AS ConversionCurrency
	FROM dbo.DimLead sl
	where Isvalid = '1' AND sl.GCLID IS NOT NULL;



	--Appointment
	With task as (
	SELECT AppointmentId Taskid,b.LeadId,b.AppointmentStatus,b.AppointmentDate,FactDate,b.DWH_LastUpdateDate,b.accountid,b.externalTaskID,
	ROW_NUMBER() OVER(PARTITION BY b.LeadId,b.AccountId ORDER BY b.AppointmentDate ASC)
	AS RowNum
	FROM dbo.FactAppointment b

	)
		Insert into
	     #Appointment
		SELECT
		 sl.GCLID AS [GoogleClickID]
		, 'Import - Appointments' AS ConversionName
		,FORMAT(DATEADD(MINUTE,3,dateadd(mi,datepart(tz,CONVERT(datetime,sl.LeadCreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.LeadCreatedDate)),'MM/dd/yyyy hh:mm:ss.00 tt') AS ConversionTime
		,DATEADD(MINUTE,3,dateadd(mi,datepart(tz,CONVERT(datetime,sl.LeadCreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.LeadCreatedDate)) as dateTimeG
		, '0.00' AS ConversionValue
		, 'USD' AS ConversionCurrency
		FROM dbo.DimLead sl
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.LeadId) = task.LeadId --OR sl.ConvertedContactId = task.WhoId
		where task.rownum=1 AND sl.GCLID IS NOT NULL;




	---Show

        With task as (
            SELECT AppointmentId Taskid,b.LeadId,b.OpportunityStatus,b.FactDate,b.DWH_LastUpdateDate,b.accountid,externaltaskid,b.OpportunityId,
            ROW_NUMBER() OVER(PARTITION BY b.LeadId,b.accountid ORDER BY b.FactDate ASC)
            AS RowNum
            FROM dbo.FactAppointment b

            )
		Insert into
	    #Show
		SELECT
		 sl.GCLID AS [GoogleClickID]
		, 'Import - Shows' AS ConversionName
		,FORMAT(DATEADD(MINUTE,2,CAST(task.FactDate AS DATETIME)),'MM/dd/yyyy hh:mm:ss.00 tt') AS ConversionTime
		,(DATEADD(MINUTE,2,task.FactDate)) AS dateTimeG
		, '0.00' AS ConversionValue
		, 'USD' AS ConversionCurrency
		FROM dbo.DimLead sl
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.LeadId) = task.LeadId  --OR sl.ConvertedContactId = task.WhoId
		where task.rownum=1 AND sl.GCLID IS NOT NULL and task.OpportunityId is not null;


	---Sale

	With task as (
            SELECT AppointmentId Taskid,b.LeadId,b.OpportunityStatus,b.FactDate,b.DWH_LastUpdateDate,b.AppointmentStatus,accountid,ExternalTaskId,
            ROW_NUMBER() OVER(PARTITION BY b.LeadId,accountid ORDER BY b.FactDate ASC)
            AS RowNum
            FROM dbo.FactAppointment b

            )
		Insert into
	    #Sale
		SELECT
		 sl.GCLID AS [GoogleClickID]
		, 'Import - Sales' AS ConversionName
		,FORMAT(DATEADD(MINUTE,4,CAST(left(task.FactDate,11) AS DATETIME)),'MM/dd/yyyy hh:mm:ss.00 tt') AS ConversionTime
		,(DATEADD(MINUTE,4,CAST(left(task.FactDate,11) AS DATETIME))) AS dateTimeG
		, '0.00' AS ConversionValue
		, 'USD' AS ConversionCurrency
		FROM dbo.DimLead sl
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.leadId) = task.LeadId --OR sl.ConvertedContactId = task.WhoId
		where task.rownum=1 AND sl.GCLID IS NOT NULL and task.OpportunityStatus = 'Closed Won';



	---Import - Sale - EXT


        With task as (
            SELECT AppointmentId Taskid,b.LeadId,b.OpportunityStatus,b.FactDate,b.DWH_LastUpdateDate,b.AppointmentStatus,b.accountid,ExternalTaskId,b.OpportunityId,
            ROW_NUMBER() OVER(PARTITION BY b.LeadId,b.accountid ORDER BY b.FactDate ASC)
            AS RowNum
            FROM dbo.FactAppointment b
            LEFT OUTER JOIN ods.CNCT_datClient AS clt
					ON clt.SalesforceContactID = b.leadid
            LEFT OUTER JOIN ODS.CNCT_datClientMembership AS dcm
                        ON dcm.ClientGUID = clt.ClientGUID AND CAST(b.AppointmentDate as date) = dcm.BeginDate
            LEFT OUTER JOIN ODS.CNCT_cfgMembership AS m WITH (NOLOCK)
                        ON m.MembershipID = dcm.MembershipID
            LEFT OUTER JOIN ODS.CNCT_lkpBusinessSegment AS bs WITH (NOLOCK)
                        ON bs.BusinessSegmentID = m.BusinessSegmentID
            where bs.BusinessSegmentDescription = 'Extreme Therapy'

            )
		Insert into
	    #SaleEXT
		SELECT
		 sl.GCLID AS [GoogleClickID]
		, 'Import - Sales - EXT' AS ConversionName
		,FORMAT(DATEADD(MINUTE,5,CAST(left(task.FactDate,11) AS DATETIME)),'MM/dd/yyyy hh:mm:ss.00 tt')
		,(DATEADD(MINUTE,5,CAST(left(task.FactDate,11) AS DATETIME))) AS dateTimeG
		,format(cast('0.00' as float), N'#.##') AS ConversionValue
		, 'USD' AS ConversionCurrency
		FROM dbo.VWLead sl
		INNER JOIN task on sl.LeadId = task.LeadId --OR sl.ConvertedContactId = task.WhoId
		where task.rownum=1 AND sl.GCLID IS NOT NULL and task.OpportunityId is not null;

---Import - Sale - Follicular Unit Extract (FUE)


       With task as (
            SELECT AppointmentId Taskid,b.LeadId,b.OpportunityStatus,b.FactDate,b.DWH_LastUpdateDate,b.AppointmentStatus,b.accountid,ExternalTaskId,b.OpportunityId,
            ROW_NUMBER() OVER(PARTITION BY b.LeadId,b.accountid ORDER BY b.FactDate ASC)
            AS RowNum
            FROM dbo.FactAppointment b
            LEFT OUTER JOIN ods.CNCT_datClient AS clt
					ON clt.SalesforceContactID = b.leadid
            LEFT OUTER JOIN ODS.CNCT_datClientMembership AS dcm
                        ON dcm.ClientGUID = clt.ClientGUID AND CAST(b.AppointmentDate as date) = dcm.BeginDate
            LEFT OUTER JOIN ODS.CNCT_cfgMembership AS m WITH (NOLOCK)
                        ON m.MembershipID = dcm.MembershipID
            LEFT OUTER JOIN ODS.CNCT_lkpBusinessSegment AS bs WITH (NOLOCK)
                        ON bs.BusinessSegmentID = m.BusinessSegmentID
            where bs.BusinessSegmentDescription = 'Surgery'

            )
		Insert into
	    #SaleFUE
		SELECT
		 sl.GCLID AS [GoogleClickID]
		, 'Import - Sales - Follicular Unit Extract (FUE)' AS ConversionName
		,FORMAT(DATEADD(MINUTE,5,CAST(left(task.FactDate,11) AS DATETIME)),'MM/dd/yyyy hh:mm:ss.00 tt') AS ConversionTime
		,(DATEADD(MINUTE,5,CAST(left(task.FactDate,11) AS DATETIME))) AS dateTimeG
		,format(cast('0.00' as float), N'#.##') AS ConversionValue
		, 'USD' AS ConversionCurrency
		FROM dbo.VWLead sl
		INNER JOIN task on sl.LeadId = task.LeadId --OR sl.ConvertedContactId = task.WhoId
		where task.rownum=1 AND sl.GCLID IS NOT NULL and OpportunityId is not null;

---Import - Sale - Follicular Unit Transportation (FUT)


	With task as (
            SELECT AppointmentId Taskid,b.LeadId,b.OpportunityStatus,b.FactDate,b.DWH_LastUpdateDate,b.AppointmentStatus,b.accountid,ExternalTaskId,b.OpportunityId,
            ROW_NUMBER() OVER(PARTITION BY b.LeadId,b.accountid ORDER BY b.FactDate ASC)
            AS RowNum
            FROM dbo.FactAppointment b
            LEFT OUTER JOIN ods.CNCT_datClient AS clt
					ON clt.SalesforceContactID = b.leadid
            LEFT OUTER JOIN ODS.CNCT_datClientMembership AS dcm
                        ON dcm.ClientGUID = clt.ClientGUID AND CAST(b.AppointmentDate as date) = dcm.BeginDate
            LEFT OUTER JOIN ODS.CNCT_cfgMembership AS m WITH (NOLOCK)
                        ON m.MembershipID = dcm.MembershipID
            LEFT OUTER JOIN ODS.CNCT_lkpBusinessSegment AS bs WITH (NOLOCK)
                        ON bs.BusinessSegmentID = m.BusinessSegmentID
            where bs.BusinessSegmentDescription = 'Surgery Complete'

            )
		Insert into
	    #SaleFUT
		SELECT
		 ISNULL(sl.GCLID,' ') AS [GoogleClickID]
		, 'Import - Sales - Follicular Unit Transportation (FUT)' AS ConversionName
		,FORMAT(DATEADD(MINUTE,5,CAST(left(task.FactDate,11) AS DATETIME)),'MM/dd/yyyy hh:mm:ss.00 tt') AS ConversionTime
		,(DATEADD(MINUTE,5,CAST(left(task.FactDate,11) AS DATETIME))) AS dateTimeG
		,  format(cast('0.00' as float), N'#.##') AS ConversionValue
		, 'USD' AS ConversionCurrency
		FROM dbo.VWLead sl
		INNER JOIN task on sl.LeadId = task.LeadId --OR sl.ConvertedContactId = task.WhoId
		where task.rownum=1 AND sl.GCLID IS NOT NULL and OpportunityId is not null;

---Import - Sale - Xtrands


	With task as (
            SELECT AppointmentId Taskid,b.LeadId,b.OpportunityStatus,b.FactDate,b.DWH_LastUpdateDate,b.AppointmentStatus,b.accountid,ExternalTaskId,b.OpportunityId,
            ROW_NUMBER() OVER(PARTITION BY b.LeadId,b.accountid ORDER BY b.FactDate ASC)
            AS RowNum
            FROM dbo.FactAppointment b
            LEFT OUTER JOIN ods.CNCT_datClient AS clt
					ON clt.SalesforceContactID = b.leadid
            LEFT OUTER JOIN ODS.CNCT_datClientMembership AS dcm
                        ON dcm.ClientGUID = clt.ClientGUID AND CAST(b.AppointmentDate as date) = dcm.BeginDate
            LEFT OUTER JOIN ODS.CNCT_cfgMembership AS m WITH (NOLOCK)
                        ON m.MembershipID = dcm.MembershipID
            LEFT OUTER JOIN ODS.CNCT_lkpBusinessSegment AS bs WITH (NOLOCK)
                        ON bs.BusinessSegmentID = m.BusinessSegmentID
            where bs.BusinessSegmentDescription = 'Xtrands'

            )
		Insert into
	    #SaleXtrands
		SELECT
		 sl.GCLID AS [GoogleClickID]
		, 'Import - Sales - Xtrands' AS ConversionName
		,FORMAT(DATEADD(MINUTE,5,CAST(left(task.FactDate,11) AS DATETIME)),'MM/dd/yyyy hh:mm:ss.00 tt') AS ConversionTime
		,(DATEADD(MINUTE,5,CAST(left(task.FactDate,11) AS DATETIME))) AS dateTimeG
		,  format(cast('0.00' as float), N'#.##') AS ConversionValue
		, 'USD' AS ConversionCurrency
		FROM dbo.VWLead sl
		INNER JOIN task on sl.LeadId = task.leadid --OR sl.ConvertedContactId = task.WhoId
		where task.rownum=1 AND sl.GCLID IS NOT NULL and OpportunityId is not null;

---Import - Sale - Xtrands Plus


	With task as (
            SELECT AppointmentId Taskid,b.LeadId,b.OpportunityStatus,b.FactDate,b.DWH_LastUpdateDate,b.AppointmentStatus,b.accountid,ExternalTaskId,b.OpportunityId,
            ROW_NUMBER() OVER(PARTITION BY b.LeadId,b.accountid ORDER BY b.FactDate ASC)
            AS RowNum
            FROM dbo.FactAppointment b
            LEFT OUTER JOIN ods.CNCT_datClient AS clt
					ON clt.SalesforceContactID = b.leadid
            LEFT OUTER JOIN ODS.CNCT_datClientMembership AS dcm
                        ON dcm.ClientGUID = clt.ClientGUID AND CAST(b.AppointmentDate as date) = dcm.BeginDate
            LEFT OUTER JOIN ODS.CNCT_cfgMembership AS m WITH (NOLOCK)
                        ON m.MembershipID = dcm.MembershipID
            LEFT OUTER JOIN ODS.CNCT_lkpBusinessSegment AS bs WITH (NOLOCK)
                        ON bs.BusinessSegmentID = m.BusinessSegmentID
            where bs.BusinessSegmentDescription = 'Xtrands+'

            )
		Insert into
	    #SaleXtrandsPlus
		SELECT
		 sl.GCLID AS [GoogleClickID]
		, 'Import - Sales - Xtrands Plus' AS ConversionName
		,FORMAT(DATEADD(MINUTE,5,CAST(left(task.FactDate,11) AS DATETIME)),'MM/dd/yyyy hh:mm:ss.00 tt') AS ConversionTime
		,(DATEADD(MINUTE,5,CAST(left(task.FactDate,11) AS DATETIME))) AS dateTimeG
		,  format(cast('0.00' as float), N'#.##') AS ConversionValue
		, 'USD' AS ConversionCurrency
		FROM dbo.VWLead sl
		INNER JOIN task on sl.LeadId = task.LeadId --OR sl.ConvertedContactId = task.WhoId
		where task.rownum=1 AND sl.GCLID IS NOT NULL and OpportunityId is not null;


	---Sale Unknown

	With task as (
            SELECT AppointmentId Taskid,b.LeadId,b.OpportunityStatus,b.FactDate,b.DWH_LastUpdateDate,b.AppointmentStatus,b.accountid,ExternalTaskId,b.OpportunityId,
            ROW_NUMBER() OVER(PARTITION BY b.LeadId,b.accountid ORDER BY b.FactDate ASC)
            AS RowNum
            FROM dbo.FactAppointment b
            LEFT OUTER JOIN ods.CNCT_datClient AS clt
					ON clt.SalesforceContactID = b.leadid
            LEFT OUTER JOIN ODS.CNCT_datClientMembership AS dcm
                        ON dcm.ClientGUID = clt.ClientGUID AND CAST(b.AppointmentDate as date) = dcm.BeginDate
            LEFT OUTER JOIN ODS.CNCT_cfgMembership AS m WITH (NOLOCK)
                        ON m.MembershipID = dcm.MembershipID
            LEFT OUTER JOIN ODS.CNCT_lkpBusinessSegment AS bs WITH (NOLOCK)
                        ON bs.BusinessSegmentID = m.BusinessSegmentID
            where bs.BusinessSegmentDescription not in ('Surgery','Surgery Complete','Extreme Therapy','Xtrands+','Xtrands')

            )
		Insert into
	    #SaleUnknown
		SELECT
		 sl.GCLID AS [GoogleClickID]
		, 'Unknown' AS ConversionName
		,FORMAT(DATEADD(MINUTE,5,CAST(left(task.FactDate,11) AS DATETIME)),'MM/dd/yyyy hh:mm:ss.00 tt') AS ConversionTime
		,(DATEADD(MINUTE,5,CAST(left(task.FactDate,11) AS DATETIME))) AS dateTimeG
		, '0.00' AS ConversionValue
		, 'USD' AS ConversionCurrency
		FROM dbo.VWLead sl
		INNER JOIN task on sl.LeadId = task.LeadId --OR sl.ConvertedContactId = task.WhoId
		where task.rownum=1 AND sl.GCLID IS NOT NULL;

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
	from #Sale
	Union all
	Select *
	from #SaleEXT
	Union all
	Select *
	from #SaleFUE
	Union all
	Select *
	from #SaleFUT
	Union all
	Select *
	from #SaleXtrands
	Union all
	Select *
	from #SaleXtrandsPlus
	Union all
	Select *
	from #SaleUnknown;

	insert into
	[Reports].[Google]
	select
	distinct [GoogleClickID]
      ,[ConversionName]
      ,[ConversionTime]
      ,[ConversionValue]
      ,[ConversionCurrency]
	  ,[dateTimeG] from #FunnelTable


DROP TABLE #Contact
DROP TABLE #Lead
DROP TABLE #Appointment
DROP TABLE #Show
DROP TABLE #Sale
DROP TABLE #SaleUnknown
DROP TABLE #SaleEXT
DROP TABLE #SaleFUE
DROP TABLE #SaleFUT
DROP TABLE #SaleXtrands
DROP TABLE #SaleXtrandsPlus
DROP TABLE #FunnelTable


END
GO
