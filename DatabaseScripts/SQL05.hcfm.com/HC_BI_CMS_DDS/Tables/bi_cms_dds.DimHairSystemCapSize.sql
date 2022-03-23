/* CreateDate: 06/27/2011 15:55:35.187 , ModifyDate: 03/17/2022 11:56:41.497 */
GO
CREATE TABLE [bi_cms_dds].[DimHairSystemCapSize](
	[HairSystemCapSizeKey] [int] NOT NULL,
	[HairSystemCapSizeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemCapSizeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemCapSizeDescriptionSortOrder] [int] NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimHairSystemCapSize] PRIMARY KEY CLUSTERED
(
	[HairSystemCapSizeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dds].[DimHairSystemCapSize] ADD  CONSTRAINT [DF_MSrepl_tran_version]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
