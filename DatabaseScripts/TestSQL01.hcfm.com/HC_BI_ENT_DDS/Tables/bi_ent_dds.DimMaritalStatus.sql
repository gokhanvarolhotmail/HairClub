/* CreateDate: 05/03/2010 12:08:47.767 , ModifyDate: 09/16/2019 09:25:18.160 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_ent_dds].[DimMaritalStatus](
	[MaritalStatusKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[MaritalStatusSSID] [int] NOT NULL,
	[MaritalStatusDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MaritalStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimMaritalStatus] PRIMARY KEY CLUSTERED
(
	[MaritalStatusKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_ent_dds].[DimMaritalStatus] ADD  CONSTRAINT [MSrepl_tran_version_default_ABB78A10_74A9_4D84_84CB_88AF9106D533_277576027]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
