/* CreateDate: 01/03/2018 16:31:36.277 , ModifyDate: 11/08/2018 11:05:01.647 */
GO
CREATE TABLE [dbo].[cstd_contact_marketing_score](
	[contact_marketing_score_id] [uniqueidentifier] NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[marketing_score_contact_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[marketing_score_type] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[marketing_score] [decimal](15, 4) NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK__cstd_contact_marketing_score] PRIMARY KEY CLUSTERED
(
	[contact_marketing_score_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cstd_contact_marketing_score_contact_id] ON [dbo].[cstd_contact_marketing_score]
(
	[contact_id] ASC
)
INCLUDE([marketing_score]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
