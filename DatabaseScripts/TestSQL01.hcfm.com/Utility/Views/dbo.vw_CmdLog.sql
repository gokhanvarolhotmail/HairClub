/* CreateDate: 12/20/2021 08:07:31.800 , ModifyDate: 12/22/2021 14:01:40.173 */
GO
CREATE view [dbo].[vw_CmdLog] as
SELECT top 100 [ID]
      ,[StartTime]
      --,[EndTime]
	  ,datediff(ss,starttime,endtime) as secs
      ,[DatabaseName]
      ,[CommandType]
	  --,[SchemaName]
	  ,[ObjectName]
	  ,[StatisticsName]
	  ,[IndexName]
      --,[ExtendedInfo]
  FROM [dbo].[CommandLog]
  WHERE [StartTime] > (getdate()-1)
  order by ID desc
GO
