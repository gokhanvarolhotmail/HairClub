/* CreateDate: 05/05/2020 17:42:41.120 , ModifyDate: 05/05/2020 17:42:59.883 */
GO
CREATE TABLE [dbo].[cfgCenterTaxRate](
	[CenterTaxRateID] [int] NOT NULL,
	[CenterID] [int] NOT NULL,
	[TaxTypeID] [int] NULL,
	[TaxRate] [decimal](6, 5) NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[TaxIdNumber] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_cfgCenterTaxRate] PRIMARY KEY CLUSTERED
(
	[CenterTaxRateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
