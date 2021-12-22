/* CreateDate: 10/10/2007 12:24:38.340 , ModifyDate: 10/10/2007 12:24:38.530 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InquiryScrubbed](
	[rowid] [bigint] IDENTITY(1,1) NOT NULL,
	[Phone] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastContactDate] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ListFlag] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExpirationDate] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Timestamp] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InquiryScrubbed] ADD  CONSTRAINT [DF_InquiryScrubbed_Timestamp]  DEFAULT (getdate()) FOR [Timestamp]
GO
