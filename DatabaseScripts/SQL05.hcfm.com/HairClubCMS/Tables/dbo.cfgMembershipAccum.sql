/* CreateDate: 05/05/2020 17:42:44.423 , ModifyDate: 05/05/2020 17:43:03.023 */
GO
CREATE TABLE [dbo].[cfgMembershipAccum](
	[MembershipAccumulatorID] [int] NOT NULL,
	[MembershipAccumulatorSortOrder] [int] NULL,
	[MembershipID] [int] NULL,
	[AccumulatorID] [int] NULL,
	[InitialQuantity] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgMembershipAccum] PRIMARY KEY CLUSTERED
(
	[MembershipAccumulatorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
