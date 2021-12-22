/* CreateDate: 01/08/2021 15:21:54.110 , ModifyDate: 01/08/2021 15:21:55.520 */
GO
CREATE TABLE [bi_ent_dds].[DimTimeZone](
	[TimeZoneKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TimeZoneSSID] [int] NOT NULL,
	[TimeZoneDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TimeZoneDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UTCOffset] [int] NULL,
	[UsesDayLightSavingsFlag] [bit] NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimTimeZone] PRIMARY KEY CLUSTERED
(
	[TimeZoneKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
