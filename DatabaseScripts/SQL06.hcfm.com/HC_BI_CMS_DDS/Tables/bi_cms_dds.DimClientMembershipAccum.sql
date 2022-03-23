/* CreateDate: 03/17/2022 11:57:04.700 , ModifyDate: 03/17/2022 11:57:15.210 */
GO
CREATE TABLE [bi_cms_dds].[DimClientMembershipAccum](
	[ClientMembershipAccumKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientMembershipAccumSSID] [uniqueidentifier] NOT NULL,
	[ClientMembershipKey] [int] NOT NULL,
	[ClientMembershipSSID] [uniqueidentifier] NOT NULL,
	[AccumulatorKey] [int] NOT NULL,
	[AccumulatorSSID] [int] NOT NULL,
	[AccumulatorDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AccumulatorDescriptionShort] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UsedAccumQuantity] [int] NOT NULL,
	[AccumMoney] [money] NOT NULL,
	[AccumDate] [datetime] NOT NULL,
	[TotalAccumQuantity] [int] NOT NULL,
	[AccumQuantityRemaining] [int] NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_DimClientMembershipAccum] PRIMARY KEY CLUSTERED
(
	[ClientMembershipAccumKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
