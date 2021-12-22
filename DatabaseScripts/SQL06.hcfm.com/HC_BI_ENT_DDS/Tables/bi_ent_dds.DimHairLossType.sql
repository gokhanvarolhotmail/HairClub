/* CreateDate: 01/08/2021 15:21:53.833 , ModifyDate: 01/08/2021 15:21:55.293 */
GO
CREATE TABLE [bi_ent_dds].[DimHairLossType](
	[HairLossTypeKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairLossTypeSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairLossTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairLossTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimHairLossType] PRIMARY KEY CLUSTERED
(
	[HairLossTypeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
