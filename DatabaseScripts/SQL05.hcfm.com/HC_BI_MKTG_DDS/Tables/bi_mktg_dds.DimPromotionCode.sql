/* CreateDate: 02/04/2011 12:01:45.373 , ModifyDate: 09/03/2021 09:35:33.377 */
GO
CREATE TABLE [bi_mktg_dds].[DimPromotionCode](
	[PromotionCodeKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PromotionCodeSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PromotionCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_DimPromotionCode] PRIMARY KEY CLUSTERED
(
	[PromotionCodeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_mktg_dds].[DimPromotionCode] ADD  CONSTRAINT [DF_DimPromotionCode_RowStartDate]  DEFAULT ('1/1/1753') FOR [RowStartDate]
GO
ALTER TABLE [bi_mktg_dds].[DimPromotionCode] ADD  CONSTRAINT [DF_DimPromotionCode_RowEndDate]  DEFAULT ('12/31/9999') FOR [RowEndDate]
GO
ALTER TABLE [bi_mktg_dds].[DimPromotionCode] ADD  CONSTRAINT [DF_DimPromotionCode_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
