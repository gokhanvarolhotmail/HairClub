/* CreateDate: 05/05/2020 17:42:49.307 , ModifyDate: 05/05/2020 18:41:04.393 */
GO
CREATE TABLE [dbo].[datClientMembershipAccum](
	[ClientMembershipAccumGUID] [uniqueidentifier] NOT NULL,
	[ClientMembershipGUID] [uniqueidentifier] NULL,
	[AccumulatorID] [int] NULL,
	[UsedAccumQuantity] [int] NULL,
	[AccumMoney] [decimal](21, 6) NULL,
	[AccumDate] [datetime] NULL,
	[TotalAccumQuantity] [int] NULL,
	[AccumQuantityRemainingCalc]  AS ([TotalAccumQuantity]-[UsedAccumQuantity]),
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[ClientMembershipAddOnID] [int] NULL,
 CONSTRAINT [PK_datClientMembershipAccum] PRIMARY KEY CLUSTERED
(
	[ClientMembershipAccumGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
