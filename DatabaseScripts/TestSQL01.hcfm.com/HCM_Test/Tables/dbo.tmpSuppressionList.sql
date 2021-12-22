/* CreateDate: 04/27/2017 11:58:18.687 , ModifyDate: 04/27/2017 11:59:26.783 */
GO
CREATE TABLE [dbo].[tmpSuppressionList](
	[Email] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_tmpSuppressionList_Email] ON [dbo].[tmpSuppressionList]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
