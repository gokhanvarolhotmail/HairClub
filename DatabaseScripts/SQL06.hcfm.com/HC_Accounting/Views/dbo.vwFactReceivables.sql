CREATE VIEW [dbo].[vwFactReceivables]
AS
SELECT [ID]
      ,[CenterKey]
      ,[DateKey]
      ,[ClientKey]
      ,([Balance] - [Prepaid]) AS 'ARBalance'

  FROM [dbo].[FactReceivables]
