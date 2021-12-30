/* CreateDate: 06/30/2020 13:57:03.607 , ModifyDate: 06/30/2020 13:57:03.727 */
GO
CREATE TABLE [dbo].[tmpProjectedEFTMonthlySummary](
	[Area] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterName] [nvarchar](103) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountTypeId] [int] NULL,
	[AccountType] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EFTAccountTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FeeCount] [int] NULL,
	[FeeAmount] [money] NULL,
	[AddOnAmount] [money] NULL,
	[TotalFees] [money] NULL,
	[ExceptionsCount] [int] NULL,
	[ExceptionsAmount] [money] NULL,
	[FrozenCount] [int] NULL,
	[FrozenAmount] [money] NULL,
	[WillRunCount] [int] NULL,
	[WillRunAmount] [money] NULL
) ON [FG_CDC]
GO
