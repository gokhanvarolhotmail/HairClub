/* CreateDate: 09/30/2013 10:49:43.957 , ModifyDate: 07/21/2014 01:20:44.103 */
GO
CREATE TABLE [dbo].[cstd_wireless_scrub_history](
	[wireless_scrub_history_id] [int] IDENTITY(1,1) NOT NULL,
	[scrub_date] [datetime] NOT NULL,
	[scrub_type] [nchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[scrub_direction] [nchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[scrub_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_cstd_wireless_scrub_history] PRIMARY KEY CLUSTERED
(
	[wireless_scrub_history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_wireless_scrub_history]  WITH NOCHECK ADD  CONSTRAINT [FK_cstd_wireless_scrub_history_onca_user] FOREIGN KEY([scrub_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_wireless_scrub_history] CHECK CONSTRAINT [FK_cstd_wireless_scrub_history_onca_user]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DAILY, MANUAL' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cstd_wireless_scrub_history', @level2type=N'COLUMN',@level2name=N'scrub_type'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'EXPORT, IMPORT' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cstd_wireless_scrub_history', @level2type=N'COLUMN',@level2name=N'scrub_direction'
GO
