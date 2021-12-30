/* CreateDate: 09/23/2019 12:23:24.913 , ModifyDate: 09/23/2019 12:23:51.200 */
GO
CREATE TABLE [dbo].[lkpMembershipProfileType](
	[MembershipProfileTypeID] [int] IDENTITY(1,1) NOT NULL,
	[MembershipProfileTypeSortOrder] [int] NOT NULL,
	[MembershipProfileTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipProfileTypeDescriptionShort] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[IsSale] [bit] NOT NULL,
	[IsCommissionable] [bit] NOT NULL,
	[IsPCPToInterco] [bit] NOT NULL,
	[CopyProfileOnRenewal] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpMembershipProfileType] PRIMARY KEY CLUSTERED
(
	[MembershipProfileTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
