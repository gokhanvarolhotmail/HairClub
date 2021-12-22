/* CreateDate: 05/03/2010 12:08:47.550 , ModifyDate: 09/16/2019 09:25:18.143 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_ent_dds].[DimAgeRange](
	[AgeRangeKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AgeRangeSSID] [int] NOT NULL,
	[AgeRangeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AgeRangeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[BeginAge] [int] NULL,
	[EndAge] [int] NULL,
 CONSTRAINT [PK_DimAgeRange] PRIMARY KEY CLUSTERED
(
	[AgeRangeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_ent_dds].[DimAgeRange] ADD  CONSTRAINT [MSrepl_tran_version_default_E84BBDBD_DE59_42F8_99B3_2D32860BE1BF_53575229]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
