/* CreateDate: 03/17/2022 11:57:05.040 , ModifyDate: 03/17/2022 11:57:15.823 */
GO
CREATE TABLE [bi_cms_dds].[DimHairSystemDesignTemplate](
	[HairSystemDesignTemplateKey] [int] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
