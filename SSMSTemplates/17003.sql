select * From cfgcenter where centerid = 100

select * From cfgCenterDistributorJoin where centerid = 100

select * From cfgCenterDistributorJoin where centerid = 1090

select [CenterId]
     , [DistributorId]
     , [IsActiveFlag]
     , [CreateDate]
     , [CreateUser]
     , [LastUpdate]
     , [LastUpdateUser]
     , [UpdateStamp] From cfgCenterDistributorJoin where centerid = 1090
UNION all
select 1090 AS [CenterId]
     , [DistributorId]
     , [IsActiveFlag]
     , GETDATE() [CreateDate]
     , SUSER_SNAME()  AS [CreateUser]
     , GETDATE()  AS [LastUpdate]
     , SUSER_SNAME() [LastUpdateUser]
     , GETDATE() [UpdateStamp] From cfgCenterDistributorJoin where centerid = 100 AND distributorid = 1098
GO
RETURN
INSERT [dbo].[cfgCenterDistributorJoin] WITH (TABLOCK) ([CenterId], [DistributorId], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp])
SELECT 1090 AS [CenterId]
     , [DistributorId]
     , [IsActiveFlag]
     , GETDATE()AS  [CreateDate]
     , SUSER_SNAME()  AS [CreateUser]
     , GETDATE()  AS [LastUpdate]
     , SUSER_SNAME() [LastUpdateUser]
     , NULL AS [UpdateStamp] From cfgCenterDistributorJoin where centerid = 100 AND distributorid = 1098

--DELETE [dbo].[cfgCenterDistributorJoin] WHERE [CenterDistributorId]=304