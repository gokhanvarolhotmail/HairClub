/* CreateDate: 11/01/2019 09:34:53.353 , ModifyDate: 11/01/2019 09:34:53.467 */
GO
CREATE TABLE [dbo].[cfgHairSystemAllocationFilterDesignTemplateArea](
	[HairSystemAllocationFilterDesignTemplateAreaID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[VendorID] [int] NOT NULL,
	[TemplateAreaMinimum] [decimal](10, 4) NOT NULL,
	[TemplateAreaMaximum] [decimal](10, 4) NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemAllocationFilterDesignTemplateArea] PRIMARY KEY CLUSTERED
(
	[HairSystemAllocationFilterDesignTemplateAreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgHairSystemAllocationFilterDesignTemplateArea_TemplateAreaMaximum] ON [dbo].[cfgHairSystemAllocationFilterDesignTemplateArea]
(
	[TemplateAreaMaximum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgHairSystemAllocationFilterDesignTemplateArea_TemplateAreaMinimum] ON [dbo].[cfgHairSystemAllocationFilterDesignTemplateArea]
(
	[TemplateAreaMinimum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
