/* CreateDate: 08/27/2008 11:32:57.360 , ModifyDate: 12/29/2021 15:38:46.337 */
GO
CREATE TABLE [dbo].[lkpCurrencyType](
	[CurrencyTypeID] [int] NOT NULL,
	[CurrencyTypeSortOrder] [int] NOT NULL,
	[CurrencyTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CurrencyTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpCurrencyType] PRIMARY KEY CLUSTERED
(
	[CurrencyTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpCurrencyType] ADD  CONSTRAINT [DF_lkpCurrencyType_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
