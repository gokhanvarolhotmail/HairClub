/* CreateDate: 06/27/2011 16:01:44.340 , ModifyDate: 09/16/2019 09:33:49.853 */
GO
CREATE TABLE [bi_cms_dds].[DimHairSystemDesignTemplate](
	[HairSystemDesignTemplateKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemDesignTemplateSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemDesignTemplateDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemDesignTemplateDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemDesignTemplateSortOrder] [int] NULL,
	[Active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimHairSystemDesignTemplate] PRIMARY KEY CLUSTERED
(
	[HairSystemDesignTemplateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dds].[DimHairSystemDesignTemplate] ADD  CONSTRAINT [DF_DimHairSystemDesignTemplate_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_cms_dds].[DimHairSystemDesignTemplate] ADD  CONSTRAINT [DF_DimHairSystemDesignTemplate_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_cms_dds].[DimHairSystemDesignTemplate] ADD  CONSTRAINT [DF_DimHairSystemDesignTemplate_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_cms_dds].[DimHairSystemDesignTemplate] ADD  CONSTRAINT [DF_DimHairSystemDesignTemplate_msrepl_tran_version]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
