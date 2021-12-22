/* CreateDate: 09/03/2021 09:37:06.413 , ModifyDate: 09/03/2021 09:37:11.767 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_mktg_dds].[DimSource](
	[SourceKey] [int] NOT NULL,
	[SourceSSID] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Media] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Level02Location] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Level03Language] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Level04Format] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Level05Creative] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Number] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[NumberType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[CampaignName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Channel] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PromoCode] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Origin] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Content] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimSource] PRIMARY KEY CLUSTERED
(
	[SourceKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
