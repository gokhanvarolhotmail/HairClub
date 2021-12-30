/* CreateDate: 12/07/2012 12:07:08.203 , ModifyDate: 03/01/2017 08:26:11.377 */
GO
CREATE TABLE [dbo].[dbaClientProfitability](
	[ClientProfitabilityID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[ClientIdentifier] [int] NOT NULL,
	[CenterId] [int] NOT NULL,
	[ClientMembershipGUID] [uniqueidentifier] NOT NULL,
	[MembershipID] [int] NOT NULL,
	[MembershipDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipIdentifier] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsMembershipActive] [bit] NOT NULL,
	[MembershipStartDate] [datetime] NULL,
	[MembershipEndDate] [datetime] NULL,
	[MembershipDuration] [int] NULL,
	[Status] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PaymentsTotal] [money] NOT NULL,
	[RefundsTotal] [money] NOT NULL,
	[NetPayments]  AS ([PaymentsTotal]-[RefundsTotal]),
	[ServiceRevenue] [money] NOT NULL,
	[ProductRevenue] [money] NOT NULL,
	[HairOrderCount] [int] NOT NULL,
	[HairOrderTotalCost] [money] NOT NULL,
	[AppointmentsCount] [int] NOT NULL,
	[FullService] [int] NOT NULL,
	[Applications] [int] NOT NULL,
	[Services] [int] NOT NULL,
	[AppointmentDuration] [int] NOT NULL,
	[AppointmentCost] [money] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_dbaClientProfitability] PRIMARY KEY CLUSTERED
(
	[ClientProfitabilityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
