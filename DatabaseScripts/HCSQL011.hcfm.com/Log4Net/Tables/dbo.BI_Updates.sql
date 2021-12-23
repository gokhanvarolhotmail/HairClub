/* CreateDate: 10/11/2018 10:50:14.593 , ModifyDate: 10/12/2018 07:31:49.453 */
GO
CREATE TABLE [dbo].[BI_Updates](
	[TableName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TableGUID] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_BI_Updates_TableNameGUID] ON [dbo].[BI_Updates]
(
	[TableName] ASC,
	[TableGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO