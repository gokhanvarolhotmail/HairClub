/* CreateDate: 05/03/2010 12:08:47.707 , ModifyDate: 09/16/2019 09:25:18.150 */
GO
CREATE TABLE [bi_ent_dds].[DimEthnicity](
	[EthnicityKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EthnicitySSID] [int] NOT NULL,
	[EthnicityDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EthnicityDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimEthnicity] PRIMARY KEY CLUSTERED
(
	[EthnicityKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_ent_dds].[DimEthnicity] ADD  CONSTRAINT [MSrepl_tran_version_default_28050261_E4A1_4CE4_B248_57A300B5258D_197575742]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
