/* CreateDate: 12/20/2021 08:07:31.800 , ModifyDate: 12/22/2021 13:51:35.760 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[vw_CmdLog] as
SELECT top 100 percent [ID]
      ,[StartTime]
      ,[EndTime]
      ,[DatabaseName]
      ,[CommandType]
	  ,[SchemaName]
	  ,[ObjectName]
	  ,[IndexName]
	  ,[StatisticsName]
      --,[ExtendedInfo]
  FROM [dbo].[CommandLog]
  WHERE [StartTime] >  (getdate()-1)
  order by ID desc
GO
