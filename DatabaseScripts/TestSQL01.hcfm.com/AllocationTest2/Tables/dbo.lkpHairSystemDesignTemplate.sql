/* CreateDate: 10/31/2019 20:53:49.493 , ModifyDate: 11/01/2019 09:57:49.000 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
