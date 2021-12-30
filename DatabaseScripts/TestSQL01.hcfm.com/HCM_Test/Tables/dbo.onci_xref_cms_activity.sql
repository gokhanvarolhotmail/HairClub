/* CreateDate: 02/13/2007 11:47:37.040 , ModifyDate: 01/25/2010 11:08:55.173 */
GO
CREATE TABLE [dbo].[onci_xref_cms_activity](
	[xref_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[s_act_key] [int] NULL,
	[t_activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
