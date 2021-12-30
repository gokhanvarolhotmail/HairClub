/* CreateDate: 09/14/2020 13:42:25.060 , ModifyDate: 09/14/2020 13:42:25.313 */
GO
CREATE TABLE [dbo].[tmpProjectedEFTMonthlyDetail](
	[Area] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterName] [nvarchar](103) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientIdentifier] [int] NULL,
	[ClientName] [nvarchar](127) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailAddress] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneNumber] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneType] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountTypeId] [int] NULL,
	[AccountType] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Membership] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipBeginDate] [varchar](11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipEndDate] [varchar](11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FeeAmount] [money] NULL,
	[AddOnAmount] [money] NULL,
	[TotalFees] [money] NULL,
	[FreezeStartDate] [varchar](11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FreezeEndDate] [varchar](11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FreezeReason] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastServiceDate] [varchar](11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ARBalance] [money] NULL,
	[DoNotCallFlag] [bit] NULL,
	[DoNotContactFlag] [bit] NULL
) ON [FG_CDC]
GO
