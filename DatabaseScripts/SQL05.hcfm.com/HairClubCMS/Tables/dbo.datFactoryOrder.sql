/* CreateDate: 05/05/2020 17:42:47.330 , ModifyDate: 05/05/2020 17:43:06.080 */
GO
CREATE TABLE [dbo].[datFactoryOrder](
	[FactoryOrderGUID] [uniqueidentifier] NOT NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[FactoryOrderStatusID] [int] NULL,
	[HairSystemTypeID] [int] NULL,
	[UsedByClientGUID] [uniqueidentifier] NULL,
	[UsedDate] [datetime] NULL,
	[IsHS4Flag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_datFactoryOrder] PRIMARY KEY CLUSTERED
(
	[FactoryOrderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
