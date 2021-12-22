/* CreateDate: 05/03/2010 12:08:47.757 , ModifyDate: 09/16/2019 09:25:18.157 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_ent_dds].[DimIncomeRange](
	[IncomeRangeKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[IncomeRangeSSID] [int] NOT NULL,
	[IncomeRangeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IncomeRangeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimIncomeRange] PRIMARY KEY CLUSTERED
(
	[IncomeRangeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_ent_dds].[DimIncomeRange] ADD  CONSTRAINT [MSrepl_tran_version_default_4E530578_FFA7_41FE_B05A_051AAE3BD2DD_261575970]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
