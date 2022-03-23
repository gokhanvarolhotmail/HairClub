/* CreateDate: 02/10/2014 13:25:22.350 , ModifyDate: 03/17/2022 11:56:41.117 */
GO
CREATE TABLE [bi_cms_dds].[DimMembershipOrderReasonType](
	[MembershipOrderReasonTypeID] [int] NOT NULL,
	[MembershipOrderReasonTypeSortOrder] [int] NOT NULL,
	[MembershipOrderReasonTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipOrderReasonTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_DimMembershipOrderReasonType] PRIMARY KEY CLUSTERED
(
	[MembershipOrderReasonTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
