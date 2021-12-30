/* CreateDate: 07/07/2013 19:23:17.533 , ModifyDate: 07/12/2014 04:23:14.233 */
GO
CREATE TABLE [dbo].[tmpInfostoreDailyImportLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RunDate] [date] NOT NULL,
	[JobStep] [int] NOT NULL,
	[Timestamp] [datetime] NOT NULL,
	[Message] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_tmpInfostoreDailyImportLog] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
