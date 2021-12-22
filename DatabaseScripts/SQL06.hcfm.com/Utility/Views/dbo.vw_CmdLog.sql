Create View vw_CmdLog as
SELECT
		[ID]
      ,[DatabaseName]
      ,[Command]
      ,[ExtendedInfo]
      ,[StartTime]
      ,[EndTime]
      ,[ErrorNumber]
      ,[ErrorMessage]
  FROM [dbo].[CommandLog]
  where CommandType = 'ALTER_INDEX'
  and [StartTime] > (getdate() -1)
