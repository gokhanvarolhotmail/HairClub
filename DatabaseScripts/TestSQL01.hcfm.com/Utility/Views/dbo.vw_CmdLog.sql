/* CreateDate: 12/20/2021 08:07:31.800 , ModifyDate: 12/20/2021 08:07:31.800 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view vw_CmdLog as
SELECT [ID]
      ,[DatabaseName]
      ,[IndexName]
      ,[StatisticsName]
      ,[ExtendedInfo]
      ,[Command]
      ,[StartTime]
      ,[EndTime]
  FROM [dbo].[CommandLog]
  WHERE [StartTime] >  (getdate()-1)
GO
