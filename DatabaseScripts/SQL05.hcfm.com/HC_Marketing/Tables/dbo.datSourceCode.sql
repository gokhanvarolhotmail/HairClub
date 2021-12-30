/* CreateDate: 11/26/2018 17:40:33.360 , ModifyDate: 04/18/2019 14:26:56.533 */
GO
CREATE TABLE [dbo].[datSourceCode](
	[SourceCodeID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceCodeName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Number] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NumberType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Media] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Location] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Language] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Format] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Creative] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CreationDate] [datetime] NULL,
	[LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[Channel] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Origin] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PromoCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_SourceCode_SourceCode] ON [dbo].[datSourceCode]
(
	[SourceCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_SourceCode_SourceCodeID] ON [dbo].[datSourceCode]
(
	[SourceCodeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
