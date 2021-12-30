/* CreateDate: 10/04/2010 12:08:45.290 , ModifyDate: 05/26/2020 10:49:24.880 */
GO
CREATE TABLE [dbo].[cfgHairSystemAllocationFilterDesignTemplate](
	[HairSystemAllocationFilterDesignTemplateID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[VendorID] [int] NOT NULL,
	[HairSystemDesignTemplateID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemAllocationFilterDesignTemplate] PRIMARY KEY CLUSTERED
(
	[HairSystemAllocationFilterDesignTemplateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemAllocationFilterDesignTemplate]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemAllocationFilterDesignTemplate_cfgVendor] FOREIGN KEY([VendorID])
REFERENCES [dbo].[cfgVendor] ([VendorID])
GO
ALTER TABLE [dbo].[cfgHairSystemAllocationFilterDesignTemplate] CHECK CONSTRAINT [FK_cfgHairSystemAllocationFilterDesignTemplate_cfgVendor]
GO
ALTER TABLE [dbo].[cfgHairSystemAllocationFilterDesignTemplate]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemAllocationFilterDesignTemplate_lkpHairSystemDesignTemplate] FOREIGN KEY([HairSystemDesignTemplateID])
REFERENCES [dbo].[lkpHairSystemDesignTemplate] ([HairSystemDesignTemplateID])
GO
ALTER TABLE [dbo].[cfgHairSystemAllocationFilterDesignTemplate] CHECK CONSTRAINT [FK_cfgHairSystemAllocationFilterDesignTemplate_lkpHairSystemDesignTemplate]
GO
