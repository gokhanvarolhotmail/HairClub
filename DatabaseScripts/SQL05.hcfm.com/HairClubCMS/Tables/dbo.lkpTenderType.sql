/* CreateDate: 05/05/2020 17:42:48.330 , ModifyDate: 05/05/2020 18:41:03.907 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
