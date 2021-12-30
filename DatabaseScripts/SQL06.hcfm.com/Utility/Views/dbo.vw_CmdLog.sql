/* CreateDate: 12/17/2021 13:49:47.840 , ModifyDate: 12/17/2021 13:49:47.840 */
GO
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
GO
