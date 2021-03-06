/* CreateDate: 03/17/2022 11:57:06.390 , ModifyDate: 03/17/2022 11:57:15.923 */
GO
CREATE TABLE [bi_cms_dds].[DimMembership](
	[MembershipKey] [int] NOT NULL,
	[MembershipSSID] [int] NOT NULL,
	[MembershipDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BusinessSegmentKey] [int] NOT NULL,
	[BusinessSegmentSSID] [int] NOT NULL,
	[RevenueGroupSSID] [int] NOT NULL,
	[RevenueGroupDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RevenueGroupDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[GenderSSID] [int] NOT NULL,
	[GenderDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[GenderDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipDurationMonths] [int] NOT NULL,
	[MembershipContractPrice] [money] NULL,
	[MembershipMonthlyFee] [money] NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[MembershipSortOrder] [int] NULL,
	[BusinessSegmentDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BusinessSegmentDescriptionShort] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_DimMembership] PRIMARY KEY CLUSTERED
(
	[MembershipKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
