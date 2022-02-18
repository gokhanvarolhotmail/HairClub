/* CreateDate: 04/05/2013 08:49:18.803 , ModifyDate: 04/05/2013 08:49:18.803 */
GO
CREATE VIEW [dbo].[vwFactReceivables]
AS
SELECT [ID]
      ,[CenterKey]
      ,[DateKey]
      ,[ClientKey]
      ,([Balance] - [Prepaid]) as 'ARBalance'

  FROM [dbo].[FactReceivables]
GO
