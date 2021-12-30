/* CreateDate: 08/27/2008 12:24:14.877 , ModifyDate: 12/28/2021 09:20:54.457 */
GO
CREATE TABLE [dbo].[lkpTaxType](
	[TaxTypeID] [int] NOT NULL,
	[TaxTypeSortOrder] [int] NOT NULL,
	[TaxTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TaxTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[GeneralLedgerID] [int] NULL,
 CONSTRAINT [PK_lkpTaxType] PRIMARY KEY CLUSTERED
(
	[TaxTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpTaxType] ADD  CONSTRAINT [DF_lkpTaxType_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpTaxType]  WITH CHECK ADD  CONSTRAINT [FK_lkpTaxType_lkpGeneralLedger] FOREIGN KEY([GeneralLedgerID])
REFERENCES [dbo].[lkpGeneralLedger] ([GeneralLedgerID])
GO
ALTER TABLE [dbo].[lkpTaxType] CHECK CONSTRAINT [FK_lkpTaxType_lkpGeneralLedger]
GO
