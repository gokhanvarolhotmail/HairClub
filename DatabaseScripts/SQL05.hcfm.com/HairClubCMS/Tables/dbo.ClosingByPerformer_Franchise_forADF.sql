/* CreateDate: 10/28/2021 13:57:36.023 , ModifyDate: 10/28/2021 13:57:36.023 */
GO
CREATE TABLE [dbo].[ClosingByPerformer_Franchise_forADF](
	[ConsultationDate] [date] NULL,
	[OrderDate] [date] NULL,
	[NetNB1Count] [int] NULL,
	[GrossNB1Count] [int] NULL,
	[NetNB1Sales] [money] NULL,
	[ExtendedPriceCalc] [money] NULL,
	[Price] [money] NULL,
	[Discount] [money] NULL,
	[PriceTaxCalc] [money] NULL,
	[Tax1] [money] NULL,
	[Tax2] [money] NULL,
	[TaxRate1] [money] NULL,
	[TaxRate2] [money] NULL,
	[TotalTaxCalc] [money] NULL,
	[OrderType] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OrderDescription] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipDescription] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientIdentifier] [int] NULL,
	[ClientFullName] [nvarchar](101) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientEMailAddress] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OrderCenterDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OrderCenterNumber] [int] NULL,
	[ConsultationCenterNumber] [int] NULL,
	[accomodation] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppoitnemtnType] [varchar](7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ConsultationResult] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appointmentNumber] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConsultationPerformerCNCT] [nvarchar](101) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OrderPerformerCNCT] [nvarchar](101) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFPerformer] [nvarchar](765) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PersonAccountFullName] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadFullName] [nvarchar](201) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[accountID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG_CDC]
GO
