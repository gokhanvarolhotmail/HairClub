/* CreateDate: 02/04/2009 09:15:59.620 , ModifyDate: 12/07/2021 16:20:16.097 */
GO
CREATE TABLE [dbo].[lkpGeneralLedger](
	[GeneralLedgerID] [int] NOT NULL,
	[GeneralLedgerSortOrder] [int] NOT NULL,
	[GeneralLedgerDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[GeneralLedgerDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[QuickBooksDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuickBooksAccountType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpGeneralLedger] PRIMARY KEY CLUSTERED
(
	[GeneralLedgerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpGeneralLedger] ADD  CONSTRAINT [DF_lkpGeneralLedger_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
