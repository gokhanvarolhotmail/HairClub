/* CreateDate: 05/05/2020 17:42:47.970 , ModifyDate: 05/05/2020 17:43:07.390 */
GO
CREATE TABLE [dbo].[datAccountReceivableJoin](
	[AccountReceivableJoinID] [int] NOT NULL,
	[ARChargeID] [int] NOT NULL,
	[ARPaymentID] [int] NOT NULL,
	[Amount] [money] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datAccountReceivableJoin] PRIMARY KEY CLUSTERED
(
	[AccountReceivableJoinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
