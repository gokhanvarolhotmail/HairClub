/* CreateDate: 05/05/2020 17:42:42.113 , ModifyDate: 05/05/2020 18:41:05.183 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
