/* CreateDate: 03/26/2018 16:12:16.640 , ModifyDate: 03/26/2018 16:16:46.033 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_ent_dds].[DimBusinessUnitSegment](
	[BusinessUnitSegmentKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[BusinessUnitSegmentSSID] [int] NOT NULL,
	[BusinessUnitBrandSSID] [int] NOT NULL,
	[BusinessUnitBrandDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BusinessUnitBrandDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BusinessSegmentSSID] [int] NOT NULL,
	[BusinessSegmentDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BusinessSegmentDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BusinessSegmentSortOrder] [int] NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_DimBusinessUnitSegment] PRIMARY KEY CLUSTERED
(
	[BusinessUnitSegmentKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_ent_dds].[DimBusinessUnitSegment] ADD  CONSTRAINT [DF_DimBusinessUnitSegment_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_ent_dds].[DimBusinessUnitSegment] ADD  CONSTRAINT [DF_DimBusinessUnitSegment_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_ent_dds].[DimBusinessUnitSegment] ADD  CONSTRAINT [DF_DimBusinessUnitSegment_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
