/* CreateDate: 06/27/2011 16:01:44.287 , ModifyDate: 11/21/2019 15:17:46.543 */
GO
CREATE TABLE [bi_cms_dds].[DimHairSystemHairColor](
	[HairSystemHairColorKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemHairColorSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemHairColorDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemHairColorDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemHairColorSortOrder] [int] NULL,
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
 CONSTRAINT [PK_DimHairSystemHairColor] PRIMARY KEY CLUSTERED
(
	[HairSystemHairColorKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dds].[DimHairSystemHairColor] ADD  CONSTRAINT [DF_DimHairSystemHairColor_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_cms_dds].[DimHairSystemHairColor] ADD  CONSTRAINT [DF_DimHairSystemHairColor_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_cms_dds].[DimHairSystemHairColor] ADD  CONSTRAINT [DF_DimHairSystemHairColor_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_cms_dds].[DimHairSystemHairColor] ADD  CONSTRAINT [DF_DimHairSystemHairColor_msrepl_tran_version]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
