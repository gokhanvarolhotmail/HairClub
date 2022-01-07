/****** Object:  StoredProcedure [ODS].[sp_PopulateDaily_GoogleFeed]    Script Date: 1/7/2022 4:05:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [ODS].[sp_PopulateDaily_GoogleFeed] AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

	
truncate table [ODS].[Google]

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
	    ConversionTime varchar(100),
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
	 sl.GCLID__c AS [GoogleClickID]
	, 'Import - Contacts' AS ConversionName
	, FORMAT(dateadd(mi,datepart(tz,CONVERT(datetime,sl.CreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.CreatedDate),'MM/dd/yyyy hh:mm:ss.00 tt') AS ConversionTime
	,dateadd(mi,datepart(tz,CONVERT(datetime,sl.CreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.CreatedDate) as dateTimeG
	, '0.00' AS ConversionValue
	, 'USD' AS ConversionCurrency
	FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl
	WHERE sl.GCLID__c IS NOT NULL;

	
	---Lead
	EXEC    [ODS].[LeadValidation]
	Insert into  #Lead
	Select 
	 sl.GCLID__c AS [GoogleClickID]
	, 'Import - Leads' AS ConversionName
	, FORMAT(DATEADD(MINUTE,2,dateadd(mi,datepart(tz,CONVERT(datetime,sl.CreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.CreatedDate)),'MM/dd/yyyy hh:mm:ss.00 tt') AS ConversionTime
	,DATEADD(MINUTE,2,dateadd(mi,datepart(tz,CONVERT(datetime,sl.CreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.CreatedDate)) as dateTimeG
	, '0.00' AS ConversionValue
	, 'USD' AS ConversionCurrency
	FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl
	LEFT JOIN ODS.#IsInvalid a
	ON sl.id = a.Id
	where a.IsInvalidLead is null AND sl.GCLID__c IS NOT NULL; 


	
	--Appointment
	With task as (
	SELECT id Taskid,PriceQuoted__c QuotedPrice,SaleTypeDescription__c saletypeDescription,b.WhoId,Result__c Result,Action__c Action,StartTime__c, activitydate,CreatedDate,
	ROW_NUMBER() OVER(PARTITION BY b.WhoId ORDER BY activityDate ASC)
	AS RowNum
	FROM [ODS].[SFDC_Task] b
	where trim(action__c) in ('Appointment','In House','Be Back') and result__c <> 'Void'
	)
		Insert into 
	     #Appointment
		SELECT
		 sl.GCLID__c AS [GoogleClickID]
		, 'Import - Appointments' AS ConversionName
		,FORMAT(DATEADD(MINUTE,3,dateadd(mi,datepart(tz,CONVERT(datetime,sl.CreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.CreatedDate)),'MM/dd/yyyy hh:mm:ss.00 tt') AS ConversionTime
		,DATEADD(MINUTE,3,dateadd(mi,datepart(tz,CONVERT(datetime,sl.CreatedDate)    AT TIME ZONE 'Eastern Standard Time'),sl.CreatedDate)) as dateTimeG
		, '0.00' AS ConversionValue
		, 'USD' AS ConversionCurrency
		FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid --OR sl.ConvertedContactId = task.WhoId
		where task.rownum=1 AND sl.GCLID__c IS NOT NULL; 


	
	
	---Show
	
	With task as (
	SELECT id Taskid,PriceQuoted__c QuotedPrice,SaleTypeDescription__c saletypeDescription,b.WhoId,Result__c Result,Action__c Action,StartTime__c, activitydate,
	ROW_NUMBER() OVER(PARTITION BY b.WhoId ORDER BY activityDate ASC)
	AS RowNum
	FROM [ODS].[SFDC_Task] b
	where action__c in ('Appointment','Be Back','In House') and (result__c='Show No Sale' or result__c='Show Sale') 
	)
		Insert into 
	    #Show
		SELECT
		 sl.GCLID__c AS [GoogleClickID]
		, 'Import - Shows' AS ConversionName
		,CASE WHEN (starttime__c not like '%NULL%') THEN FORMAT(DATEADD(MINUTE,2,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME)),'MM/dd/yyyy hh:mm:ss.00 tt') 
			  ELSE  FORMAT(DATEADD(MINUTE,2,task.ActivityDate),'MM/dd/yyyy hh:mm:s tt')
			  END AS ConversionTime
		,CASE WHEN (starttime__c not like '%NULL%') THEN (DATEADD(MINUTE,2,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME))) 
			  ELSE  (DATEADD(MINUTE,2,task.ActivityDate))
			  END AS dateTimeG
		, '0.00' AS ConversionValue
		, 'USD' AS ConversionCurrency
		FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid  --OR sl.ConvertedContactId = task.WhoId
		where task.rownum=1 AND sl.GCLID__c IS NOT NULL; 

	
	---Sale
	
	With task as (
	SELECT id Taskid,PriceQuoted__c QuotedPrice,SaleTypeDescription__c saletypeDescription,b.WhoId,Result__c Result,Action__c Action,StartTime__c, activitydate,[CompletedDateTime],
	ROW_NUMBER() OVER(PARTITION BY b.WhoId  ORDER BY [CompletedDateTime] ASC)
	AS RowNum
	FROM [ODS].[SFDC_Task] b
	where action__c in ('Appointment','Be Back','In House') and ( result__c='Show Sale') 
	and ([SaleTypeCode__c] is not null and ([SaleTypeCode__c] not in ('73','78')))
	)
		Insert into 
	    #Sale
		SELECT
		 sl.GCLID__c AS [GoogleClickID]
		, 'Import - Sales' AS ConversionName
		,CASE WHEN (task.[CompletedDateTime] IS NULL and task.StartTime__c not like '%NULL%') THEN FORMAT(DATEADD(MINUTE,4,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME)),'MM/dd/yyyy hh:mm:ss.00 tt') 
			  WHEN (task.[CompletedDateTime] IS NULL and task.StartTime__c is NULL) THEN FORMAT(DATEADD(MINUTE,4,task.[ActivityDate]),'MM/dd/yyyy hh:mm:ss.00 tt')
			  ELSE  FORMAT(DATEADD(MINUTE,4,dateadd(mi,datepart(tz,CONVERT(datetime,task.[CompletedDateTime])    AT TIME ZONE 'Eastern Standard Time'),task.[CompletedDateTime])),'MM/dd/yyyy hh:mm:ss.00 tt')
			  END AS ConversionTime
		,CASE WHEN (task.[CompletedDateTime] IS NULL and task.StartTime__c not like '%NULL%') THEN (DATEADD(MINUTE,4,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME))) 
			  WHEN (task.[CompletedDateTime] IS NULL and task.StartTime__c is NULL) THEN (DATEADD(MINUTE,4,task.[ActivityDate]))
			  ELSE  (DATEADD(MINUTE,4,dateadd(mi,datepart(tz,CONVERT(datetime,task.[CompletedDateTime])    AT TIME ZONE 'Eastern Standard Time'),task.[CompletedDateTime])))
			  END AS dateTimeG
		, '0.00' AS ConversionValue
		, 'USD' AS ConversionCurrency
		FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid --OR sl.ConvertedContactId = task.WhoId
		where task.rownum=1 AND sl.GCLID__c IS NOT NULL; 

	---Import - Sale - EXT


	With task as (
	SELECT id Taskid,PriceQuoted__c QuotedPrice,SaleTypeDescription__c saletypeDescription,b.WhoId,Result__c Result,Action__c Action,StartTime__c, activitydate,[CompletedDateTime],
	ROW_NUMBER() OVER(PARTITION BY b.WhoId  ORDER BY [CompletedDateTime] ASC)
	AS RowNum
	FROM [ODS].[SFDC_Task] b
	where action__c in ('Appointment','Be Back','In House') and ( result__c='Show Sale') 
	and ([SaleTypeCode__c] is not null and ([SaleTypeCode__c] in ('72','12','14','11','13','19','20','25','70','71','6','45','43','27','62')))
	)
		Insert into 
	    #SaleEXT
		SELECT
		 sl.GCLID__c AS [GoogleClickID]
		, 'Import - Sales - EXT' AS ConversionName
		,CASE WHEN (task.[CompletedDateTime] IS NULL) THEN FORMAT(DATEADD(MINUTE,5,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME)),'MM/dd/yyyy hh:mm:ss.00 tt') 
			  ELSE  FORMAT(DATEADD(MINUTE,5,dateadd(mi,datepart(tz,CONVERT(datetime,task.[CompletedDateTime])    AT TIME ZONE 'Eastern Standard Time'),task.[CompletedDateTime])),'MM/dd/yyyy hh:mm:ss.00 tt')
			  END AS ConversionTime
		,CASE WHEN (task.[CompletedDateTime] IS NULL) THEN (DATEADD(MINUTE,5,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME))) 
			  ELSE  (DATEADD(MINUTE,5,dateadd(mi,datepart(tz,CONVERT(datetime,task.[CompletedDateTime])    AT TIME ZONE 'Eastern Standard Time'),task.[CompletedDateTime])))
			  END AS dateTimeG
		, CASE WHEN task.QuotedPrice = 0 or task.QuotedPrice is null THEN '0.00'
			ELSE format(task.QuotedPrice, N'#.##') 
			END AS ConversionValue
		, 'USD' AS ConversionCurrency
		FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid --OR sl.ConvertedContactId = task.WhoId
		where task.rownum=1 AND sl.GCLID__c IS NOT NULL; 

---Import - Sale - Follicular Unit Extract (FUE)


	With task as (
	SELECT id Taskid,PriceQuoted__c QuotedPrice,SaleTypeDescription__c saletypeDescription,b.WhoId,Result__c Result,Action__c Action,StartTime__c, activitydate,[CompletedDateTime],
	ROW_NUMBER() OVER(PARTITION BY b.WhoId  ORDER BY [CompletedDateTime] ASC)
	AS RowNum
	FROM [ODS].[SFDC_Task] b
	where action__c in ('Appointment','Be Back','In House') and ( result__c='Show Sale') 
	and ([SaleTypeCode__c] is not null and ([SaleTypeCode__c] in ('46','50','48')))
	)
		Insert into 
	    #SaleFUE
		SELECT
		 sl.GCLID__c AS [GoogleClickID]
		, 'Import - Sales - Follicular Unit Extract (FUE)' AS ConversionName
		,CASE WHEN (task.[CompletedDateTime] IS NULL) THEN FORMAT(DATEADD(MINUTE,5,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME)),'MM/dd/yyyy hh:mm:s tt') 
			  ELSE  FORMAT(DATEADD(MINUTE,5,dateadd(mi,datepart(tz,CONVERT(datetime,task.[CompletedDateTime])    AT TIME ZONE 'Eastern Standard Time'),task.[CompletedDateTime])),'MM/dd/yyyy hh:mm:ss.00 tt')
			  END AS ConversionTime
		,CASE WHEN (task.[CompletedDateTime] IS NULL) THEN (DATEADD(MINUTE,5,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME))) 
			  ELSE  (DATEADD(MINUTE,5,dateadd(mi,datepart(tz,CONVERT(datetime,task.[CompletedDateTime])    AT TIME ZONE 'Eastern Standard Time'),task.[CompletedDateTime])))
			  END AS dateTimeG
		, CASE WHEN task.QuotedPrice = 0 or task.QuotedPrice is null THEN '0.00'
			ELSE format(task.QuotedPrice, N'#.##') 
			END AS ConversionValue
		, 'USD' AS ConversionCurrency
		FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid --OR sl.ConvertedContactId = task.WhoId
		where task.rownum=1 AND sl.GCLID__c IS NOT NULL; 

---Import - Sale - Follicular Unit Transportation (FUT)


	With task as (
	SELECT id Taskid,PriceQuoted__c QuotedPrice,SaleTypeDescription__c saletypeDescription,b.WhoId,Result__c Result,Action__c Action,StartTime__c, activitydate,[CompletedDateTime],
	ROW_NUMBER() OVER(PARTITION BY b.WhoId  ORDER BY [CompletedDateTime] ASC)
	AS RowNum
	FROM [ODS].[SFDC_Task] b
	where action__c in ('Appointment','Be Back','In House') and ( result__c='Show Sale') 
	and ([SaleTypeCode__c] is not null and ([SaleTypeCode__c] in ('47','51','4')))
	)
		Insert into 
	    #SaleFUT
		SELECT
		 ISNULL(sl.GCLID__c,' ') AS [GoogleClickID]
		, 'Import - Sales - Follicular Unit Transportation (FUT)' AS ConversionName
		,CASE WHEN (task.[CompletedDateTime] IS NULL) THEN FORMAT(DATEADD(MINUTE,5,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME)),'MM/dd/yyyy hh:mm:ss.00 tt') 
			  ELSE  FORMAT(DATEADD(MINUTE,5,dateadd(mi,datepart(tz,CONVERT(datetime,task.[CompletedDateTime])    AT TIME ZONE 'Eastern Standard Time'),task.[CompletedDateTime])),'MM/dd/yyyy hh:mm:ss.00 tt')
			  END AS ConversionTime
		,CASE WHEN (task.[CompletedDateTime] IS NULL) THEN (DATEADD(MINUTE,5,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME))) 
			  ELSE  (DATEADD(MINUTE,5,dateadd(mi,datepart(tz,CONVERT(datetime,task.[CompletedDateTime])    AT TIME ZONE 'Eastern Standard Time'),task.[CompletedDateTime])))
			  END AS dateTimeG
		, CASE WHEN task.QuotedPrice = 0 or task.QuotedPrice is null THEN '0.00'
			ELSE format(task.QuotedPrice, N'#.##') 
			END AS ConversionValue
		, 'USD' AS ConversionCurrency
		FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid --OR sl.ConvertedContactId = task.WhoId
		where task.rownum=1 AND sl.GCLID__c IS NOT NULL; 

---Import - Sale - Xtrands


	With task as (
	SELECT id Taskid,PriceQuoted__c QuotedPrice,SaleTypeDescription__c saletypeDescription,b.WhoId,Result__c Result,Action__c Action,StartTime__c, activitydate,[CompletedDateTime],
	ROW_NUMBER() OVER(PARTITION BY b.WhoId  ORDER BY [CompletedDateTime] ASC)
	AS RowNum
	FROM [ODS].[SFDC_Task] b
	where action__c in ('Appointment','Be Back','In House') and ( result__c='Show Sale') 
	and ([SaleTypeCode__c] is not null and ([SaleTypeCode__c] in ('56','57','58','59','26','22','52','54')))
	)
		Insert into 
	    #SaleXtrands
		SELECT
		 sl.GCLID__c AS [GoogleClickID]
		, 'Import - Sales - Xtrands' AS ConversionName
		,CASE WHEN (task.[CompletedDateTime] IS NULL) THEN FORMAT(DATEADD(MINUTE,5,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME)),'MM/dd/yyyy hh:mm:ss.00 tt') 
			  ELSE  FORMAT(DATEADD(MINUTE,5,dateadd(mi,datepart(tz,CONVERT(datetime,task.[CompletedDateTime])    AT TIME ZONE 'Eastern Standard Time'),task.[CompletedDateTime])),'MM/dd/yyyy hh:mm:ss.00 tt')
			  END AS ConversionTime
		,CASE WHEN (task.[CompletedDateTime] IS NULL) THEN (DATEADD(MINUTE,5,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME))) 
			  ELSE  (DATEADD(MINUTE,5,dateadd(mi,datepart(tz,CONVERT(datetime,task.[CompletedDateTime])    AT TIME ZONE 'Eastern Standard Time'),task.[CompletedDateTime])))
			  END AS dateTimeG
		, CASE WHEN task.QuotedPrice = 0 or task.QuotedPrice is null THEN '0.00'
			ELSE format(task.QuotedPrice, N'#.##') 
			END AS ConversionValue
		, 'USD' AS ConversionCurrency
		FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid --OR sl.ConvertedContactId = task.WhoId
		where task.rownum=1 AND sl.GCLID__c IS NOT NULL; 

---Import - Sale - Xtrands Plus


	With task as (
	SELECT id Taskid,PriceQuoted__c QuotedPrice,SaleTypeDescription__c saletypeDescription,b.WhoId,Result__c Result,Action__c Action,StartTime__c, activitydate,[CompletedDateTime],
	ROW_NUMBER() OVER(PARTITION BY b.WhoId  ORDER BY [CompletedDateTime] ASC)
	AS RowNum
	FROM [ODS].[SFDC_Task] b
	where action__c in ('Appointment','Be Back','In House') and ( result__c='Show Sale') 
	and ([SaleTypeCode__c] is not null and ([SaleTypeCode__c] in ('28','69','29','40','15','16','30','39','10','1','65','23','61','24','60','64')))
	)
		Insert into 
	    #SaleXtrandsPlus
		SELECT
		 sl.GCLID__c AS [GoogleClickID]
		, 'Import - Sales - Xtrands Plus' AS ConversionName
		,CASE WHEN (task.[CompletedDateTime] IS NULL) THEN FORMAT(DATEADD(MINUTE,5,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME)),'MM/dd/yyyy hh:mm:ss.00hh:mm:ss.00 tt') 
			  ELSE  FORMAT(DATEADD(MINUTE,5,dateadd(mi,datepart(tz,CONVERT(datetime,task.[CompletedDateTime])    AT TIME ZONE 'Eastern Standard Time'),task.[CompletedDateTime])),'MM/dd/yyyy hh:mm:ss.00 tt')
			  END AS ConversionTime
		,CASE WHEN (task.[CompletedDateTime] IS NULL) THEN (DATEADD(MINUTE,5,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME))) 
			  ELSE  (DATEADD(MINUTE,5,dateadd(mi,datepart(tz,CONVERT(datetime,task.[CompletedDateTime])    AT TIME ZONE 'Eastern Standard Time'),task.[CompletedDateTime])))
			  END AS dateTimeG
		, CASE WHEN task.QuotedPrice = 0 or task.QuotedPrice is null THEN '0.00'
			ELSE format(task.QuotedPrice, N'#.##') 
			END AS ConversionValue
		, 'USD' AS ConversionCurrency
		FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid --OR sl.ConvertedContactId = task.WhoId
		where task.rownum=1 AND sl.GCLID__c IS NOT NULL; 


	---Sale Unknown
	
	With task as (
	SELECT id Taskid,PriceQuoted__c QuotedPrice,SaleTypeDescription__c saletypeDescription,b.WhoId,Result__c Result,Action__c Action,StartTime__c, activitydate,[CompletedDateTime],
	ROW_NUMBER() OVER(PARTITION BY b.WhoId  ORDER BY [CompletedDateTime] ASC)
	AS RowNum
	FROM [ODS].[SFDC_Task] b
	where action__c in ('Appointment','Be Back','In House') and ( result__c='Show Sale') 
	and ([SaleTypeCode__c] is null or ([SaleTypeCode__c] in ('73','78')))
	)
		Insert into 
	    #SaleUnknown
		SELECT
		 sl.GCLID__c AS [GoogleClickID]
		, 'Unknown' AS ConversionName
		,CASE WHEN (task.[CompletedDateTime] IS NULL and task.StartTime__c not like '%NULL%') THEN FORMAT(DATEADD(MINUTE,5,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME)),'MM/dd/yyyy hh:mm:ss.00 tt') 
			  WHEN (task.[CompletedDateTime] IS NULL and task.StartTime__c is NULL) THEN FORMAT(DATEADD(MINUTE,5,task.[ActivityDate]),'MM/dd/yyyy hh:mm:ss.00 tt')
			  ELSE  FORMAT(DATEADD(MINUTE,5,dateadd(mi,datepart(tz,CONVERT(datetime,task.[CompletedDateTime])    AT TIME ZONE 'Eastern Standard Time'),task.[CompletedDateTime])),'MM/dd/yyyy hh:mm:ss.00 tt')
			  END AS ConversionTime
		,CASE WHEN (task.[CompletedDateTime] IS NULL and task.StartTime__c not like '%NULL%') THEN (DATEADD(MINUTE,5,CAST(concat(left(task.ActivityDate,11),task.StartTime__c) AS DATETIME))) 
			  WHEN (task.[CompletedDateTime] IS NULL and task.StartTime__c is NULL) THEN (DATEADD(MINUTE,5,task.[ActivityDate]))
			  ELSE  (DATEADD(MINUTE,5,dateadd(mi,datepart(tz,CONVERT(datetime,task.[CompletedDateTime])    AT TIME ZONE 'Eastern Standard Time'),task.[CompletedDateTime])))
			  END AS dateTimeG
		, '0.00' AS ConversionValue
		, 'USD' AS ConversionCurrency
		FROM [hc-sqlpool-eim-prod-eus2].ODS.SFDC_Lead sl
		INNER JOIN task on isnull(sl.ConvertedContactId,sl.id) = task.whoid --OR sl.ConvertedContactId = task.WhoId
		where task.rownum=1 AND sl.GCLID__c IS NOT NULL; 

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
	[ODS].[Google]
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
DROP TABLE #IsInvalid


END
GO
