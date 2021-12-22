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
