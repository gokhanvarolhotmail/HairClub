/* CreateDate: 10/03/2019 23:03:41.223 , ModifyDate: 10/03/2019 23:03:46.187 */
GO
CREATE TABLE [bi_cms_dds].[DimHairSystemVendorContract](
	[HairSystemVendorContractKey] [int] NOT NULL,
	[HairSystemVendorContractSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemVendorContractName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemVendorDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemVendorDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemVendorContractBeginDate] [datetime] NOT NULL,
	[HairSystemVendorContractEndDate] [datetime] NOT NULL,
	[IsRepair] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveContract] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimHairSystemVendorContract] PRIMARY KEY CLUSTERED
(
	[HairSystemVendorContractKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO