/* CreateDate: 01/15/2007 09:39:49.950 , ModifyDate: 08/09/2007 14:06:28.860 */
GO
CREATE TABLE [dbo].[NoShowsDailyOLD](
	[RowId] [int] IDENTITY(1,1) NOT NULL,
	[RecordId] [int] NOT NULL,
	[Gender] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
ALTER TABLE [dbo].[NoShowsDailyOLD] ADD  CONSTRAINT [DF_NoShowsDaily_SentEmailOLD]  DEFAULT (0) FOR [SentEmail]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'In relation to initial no show week' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'NoShowsDailyOLD', @level2type=N'COLUMN',@level2name=N'BookedWeekNumber'
GO
