/* CreateDate: 01/19/2009 11:51:13.270 , ModifyDate: 12/03/2021 10:24:48.547 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpTenderType](
	[TenderTypeID] [int] NOT NULL,
	[TenderTypeSortOrder] [int] NOT NULL,
	[TenderTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TenderTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MaxOccurrences] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[GeneralLedgerID] [int] NULL,
	[EFTGeneralLedgerID] [int] NULL,
 CONSTRAINT [PK_lkpTenderType] PRIMARY KEY CLUSTERED
(
	[TenderTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpTenderType] ADD  CONSTRAINT [DF_lkpTenderType_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpTenderType]  WITH CHECK ADD  CONSTRAINT [FK_lkpTenderType_lkpGeneralLedger] FOREIGN KEY([EFTGeneralLedgerID])
REFERENCES [dbo].[lkpGeneralLedger] ([GeneralLedgerID])
GO
ALTER TABLE [dbo].[lkpTenderType] CHECK CONSTRAINT [FK_lkpTenderType_lkpGeneralLedger]
GO
ALTER TABLE [dbo].[lkpTenderType]  WITH CHECK ADD  CONSTRAINT [FK_lkpTenderType_lkpGeneralLedger1] FOREIGN KEY([GeneralLedgerID])
REFERENCES [dbo].[lkpGeneralLedger] ([GeneralLedgerID])
GO
ALTER TABLE [dbo].[lkpTenderType] CHECK CONSTRAINT [FK_lkpTenderType_lkpGeneralLedger1]
GO
