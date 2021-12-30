/* CreateDate: 05/05/2020 17:42:41.070 , ModifyDate: 05/05/2020 17:42:59.877 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
