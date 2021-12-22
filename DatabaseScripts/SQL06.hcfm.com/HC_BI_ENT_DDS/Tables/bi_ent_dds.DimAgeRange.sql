/* CreateDate: 01/08/2021 15:21:53.263 , ModifyDate: 01/08/2021 15:21:54.667 */
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
