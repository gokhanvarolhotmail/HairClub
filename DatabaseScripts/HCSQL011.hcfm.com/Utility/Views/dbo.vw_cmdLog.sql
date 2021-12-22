/* CreateDate: 12/15/2021 14:10:56.697 , ModifyDate: 12/15/2021 14:10:56.697 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create View vw_cmdLog as
SELECT top 100 PERCENT
		[ID]
      ,[DatabaseName]
      ,[SchemaName]
      ,[ObjectName]
      ,[IndexName]
      ,[IndexType]
      ,[ExtendedInfo]
      ,[CommandType]
      ,[StartTime]
      ,[EndTime]
	  ,DATEDIFF(SECOND, [StartTime], [EndTime]) as Duration
  FROM [dbo].[CommandLog]
  WHERE CommandType = 'ALTER_INDEX'
  and [StartTime] > (getdate() -1)
  ORDER BY DATEDIFF(SECOND, [StartTime], [EndTime]) desc
GO
