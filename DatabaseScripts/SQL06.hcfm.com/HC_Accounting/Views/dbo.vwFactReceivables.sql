/* CreateDate: 07/30/2015 09:26:23.150 , ModifyDate: 07/30/2015 09:26:23.150 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwFactReceivables]
AS
SELECT [ID]
      ,[CenterKey]
      ,[DateKey]
      ,[ClientKey]
      ,([Balance] - [Prepaid]) AS 'ARBalance'

  FROM [dbo].[FactReceivables]
GO
