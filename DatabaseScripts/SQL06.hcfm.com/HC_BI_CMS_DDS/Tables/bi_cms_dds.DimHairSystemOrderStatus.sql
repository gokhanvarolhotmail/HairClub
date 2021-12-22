CREATE TABLE [bi_cms_dds].[DimHairSystemOrderStatus](
	[HairSystemOrderStatusKey] [int] NOT NULL,
	[HairSystemOrderStatusSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemOrderStatusSortOrder] [int] NOT NULL,
	[HairSystemOrderStatusDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemOrderStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CanApplyFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CanTransferFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CanEditFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CanCancelFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsPreallocationFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CanRedoFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CanRepairFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ShowInHistoryFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CanAddToStockFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IncludeInMembershipCountFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CanRequestCreditFlag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimHairSystemOrderStatus] PRIMARY KEY CLUSTERED
(
	[HairSystemOrderStatusKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
