/* CreateDate: 08/09/2007 14:06:33.907 , ModifyDate: 08/09/2007 14:06:33.937 */
GO
CREATE TABLE [dbo].[NoShowsDaily](
	[RowId] [int] IDENTITY(1,1) NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_gender_code] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HasEmail] [bit] NULL,
	[SentEmail] [bit] NULL,
	[IsBounced] [bit] NULL,
	[NoShowDate] [smalldatetime] NULL,
	[NoShowWeek] [smallint] NULL,
	[NoShowYear] [smallint] NULL,
	[NextApptDateBooked] [smalldatetime] NULL,
	[BookedWeekNumber] [smallint] NULL,
	[isShow] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NoShowsDaily] ADD  CONSTRAINT [DF_NoShowsDaily_SentEmail]  DEFAULT ((0)) FOR [SentEmail]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'In relation to initial no show week' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NoShowsDaily', @level2type=N'COLUMN',@level2name=N'BookedWeekNumber'
GO
