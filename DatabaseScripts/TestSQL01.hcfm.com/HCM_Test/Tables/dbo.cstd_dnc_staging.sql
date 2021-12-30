/* CreateDate: 04/07/2009 14:06:39.027 , ModifyDate: 04/07/2009 14:06:39.037 */
GO
CREATE TABLE [dbo].[cstd_dnc_staging](
	[contact_id] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_id] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[due_date] [datetime] NULL,
	[timestamp] [datetime] NULL
) ON [PRIMARY]
GO
