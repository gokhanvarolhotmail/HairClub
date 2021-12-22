/* CreateDate: 02/18/2013 06:59:50.583 , ModifyDate: 12/07/2021 16:20:16.003 */
GO
CREATE TABLE [dbo].[datRegisterTender](
	[RegisterTenderGUID] [uniqueidentifier] NOT NULL,
	[RegisterLogGUID] [uniqueidentifier] NOT NULL,
	[TenderTypeID] [int] NOT NULL,
	[TenderQuantity] [int] NULL,
	[TenderTotal] [money] NULL,
	[RegisterQuantity] [int] NULL,
	[RegisterTotal] [money] NULL,
	[TotalVariance]  AS (isnull([TenderTotal],(0.00))-isnull([RegisterTotal],(0.00))),
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_datRegisterTender] PRIMARY KEY CLUSTERED
(
	[RegisterTenderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datRegisterTender_RegisterLogGUID] ON [dbo].[datRegisterTender]
(
	[RegisterLogGUID] ASC
)
INCLUDE([TenderTypeID],[RegisterQuantity],[RegisterTotal],[TotalVariance]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datRegisterTender]  WITH CHECK ADD  CONSTRAINT [FK_datRegisterTender_datRegisterLog] FOREIGN KEY([RegisterLogGUID])
REFERENCES [dbo].[datRegisterLog] ([RegisterLogGUID])
GO
ALTER TABLE [dbo].[datRegisterTender] CHECK CONSTRAINT [FK_datRegisterTender_datRegisterLog]
GO
ALTER TABLE [dbo].[datRegisterTender]  WITH CHECK ADD  CONSTRAINT [FK_datRegisterTender_lkpTenderType] FOREIGN KEY([TenderTypeID])
REFERENCES [dbo].[lkpTenderType] ([TenderTypeID])
GO
ALTER TABLE [dbo].[datRegisterTender] CHECK CONSTRAINT [FK_datRegisterTender_lkpTenderType]
GO
