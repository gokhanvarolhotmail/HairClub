/* CreateDate: 10/04/2010 12:08:46.000 , ModifyDate: 12/29/2021 15:38:46.137 */
GO
CREATE TABLE [dbo].[lkpHairSystemDesignTemplate](
	[HairSystemDesignTemplateID] [int] NOT NULL,
	[HairSystemDesignTemplateSortOrder] [int] NOT NULL,
	[HairSystemDesignTemplateDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemDesignTemplateDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsManualTemplateFlag] [bit] NULL,
	[IsMeasurementFlag] [bit] NULL,
	[HairSystemWidth] [decimal](10, 4) NULL,
	[HairSystemLength] [decimal](10, 4) NULL,
	[AdjustmentRange] [decimal](10, 4) NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpHairSystemDesignTemplate] PRIMARY KEY CLUSTERED
(
	[HairSystemDesignTemplateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_lkpHairSystemDesignTemplate_HairSystemLength] ON [dbo].[lkpHairSystemDesignTemplate]
(
	[HairSystemLength] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_lkpHairSystemDesignTemplate_HairSystemWidth] ON [dbo].[lkpHairSystemDesignTemplate]
(
	[HairSystemWidth] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpHairSystemDesignTemplate] ADD  DEFAULT ((0)) FOR [IsManualTemplateFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemDesignTemplate] ADD  DEFAULT ((0)) FOR [IsMeasurementFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemDesignTemplate] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
