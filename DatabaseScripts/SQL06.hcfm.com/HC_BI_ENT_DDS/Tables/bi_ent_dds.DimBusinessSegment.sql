/* CreateDate: 01/08/2021 15:21:53.420 , ModifyDate: 01/08/2021 15:21:54.877 */
GO
CREATE TABLE [bi_ent_dds].[DimBusinessSegment](
	[BusinessSegmentKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[BusinessSegmentSSID] [int] NOT NULL,
	[BusinessSegmentDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BusinessSegmentDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BusinessUnitKey] [int] NOT NULL,
	[BusinessUnitSSID] [int] NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimBusinessSegment] PRIMARY KEY CLUSTERED
(
	[BusinessSegmentKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
