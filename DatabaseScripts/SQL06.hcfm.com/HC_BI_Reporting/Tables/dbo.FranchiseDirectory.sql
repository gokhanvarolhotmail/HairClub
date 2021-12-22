CREATE TABLE [dbo].[FranchiseDirectory](
	[CenterKey] [int] NOT NULL,
	[CenterNumber] [int] NOT NULL,
	[CenterSSID] [int] NOT NULL,
	[CenterDescriptionNumber] [nvarchar](103) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Owners] [nvarchar](102) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Manager] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AssistantManager] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterAddress1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterAddress2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateProvinceDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterPhone] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Backline] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ManagerCell] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NB1] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CRM] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
