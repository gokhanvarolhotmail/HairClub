/* CreateDate: 08/01/2012 15:46:35.987 , ModifyDate: 11/21/2019 15:17:46.730 */
GO
CREATE TABLE [bi_cms_dds].[DimSecurityElement](
	[SecurityElementKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SecurityElementSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SecurityElementDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SecurityElementDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SecurityElementSortOrder] [int] NULL,
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
 CONSTRAINT [PK_DimSecurityElement] PRIMARY KEY CLUSTERED
(
	[SecurityElementKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dds].[DimSecurityElement] ADD  CONSTRAINT [DF_DimSecurityElement_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_cms_dds].[DimSecurityElement] ADD  CONSTRAINT [DF_DimSecurityElement_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_cms_dds].[DimSecurityElement] ADD  CONSTRAINT [DF_DimSecurityElement_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_cms_dds].[DimSecurityElement] ADD  CONSTRAINT [DF_DimSecurityElement_msrepl_tran_version]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
