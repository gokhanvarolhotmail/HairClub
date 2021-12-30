/* CreateDate: 05/03/2010 12:08:47.780 , ModifyDate: 09/16/2019 09:25:18.160 */
GO
CREATE TABLE [bi_ent_dds].[DimOccupation](
	[OccupationKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[OccupationSSID] [int] NOT NULL,
	[OccupationDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OccupationDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimOccupation] PRIMARY KEY CLUSTERED
(
	[OccupationKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_ent_dds].[DimOccupation] ADD  CONSTRAINT [MSrepl_tran_version_default_7893A22F_09FF_48E4_BE04_CC33C04D687C_293576084]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
