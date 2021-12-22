/* CreateDate: 05/13/2013 12:11:51.397 , ModifyDate: 12/07/2021 16:20:16.203 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datOutgoingResponseLog](
	[OutgoingResponseID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OutgoingRequestID] [int] NOT NULL,
	[SeibelID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ErrorMessage] [varchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExceptionMessage] [varchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[BosleySalesforceAccountID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK__datOutgo__0871E9767130D9B8] PRIMARY KEY CLUSTERED
(
	[OutgoingResponseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datOutgoingResponseLog_OutgoingRequestID] ON [dbo].[datOutgoingResponseLog]
(
	[OutgoingRequestID] ASC
)
INCLUDE([OutgoingResponseID],[SeibelID],[ErrorMessage],[ExceptionMessage]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datOutgoingResponseLog]  WITH CHECK ADD  CONSTRAINT [FK_datOutgoingResponseLog_OutgoingRequestLogID] FOREIGN KEY([OutgoingRequestID])
REFERENCES [dbo].[datOutgoingRequestLog] ([OutgoingRequestID])
GO
ALTER TABLE [dbo].[datOutgoingResponseLog] CHECK CONSTRAINT [FK_datOutgoingResponseLog_OutgoingRequestLogID]
GO
