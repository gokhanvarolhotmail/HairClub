/* CreateDate: 04/07/2009 14:06:39.120 , ModifyDate: 04/07/2009 14:06:39.123 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_dnc_inquiry_scrubbed](
	[rowid] [bigint] IDENTITY(1,1) NOT NULL,
	[Phone] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastContactDate] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ListFlag] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExpirationDate] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Timestamp] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_dnc_inquiry_scrubbed] ADD  CONSTRAINT [DF_InquiryScrubbed_Timestamp]  DEFAULT (getdate()) FOR [Timestamp]
GO
