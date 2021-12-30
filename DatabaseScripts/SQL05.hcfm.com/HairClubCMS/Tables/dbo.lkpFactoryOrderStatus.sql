/* CreateDate: 05/05/2020 17:42:47.280 , ModifyDate: 05/05/2020 17:43:06.073 */
GO
CREATE TABLE [dbo].[lkpFactoryOrderStatus](
	[FactoryOrderStatusID] [int] NOT NULL,
	[FactoryOrderStatusSortOrder] [int] NULL,
	[FactoryOrderDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FactoryOrderDescriptionShort] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsAvailableForOrderFlag] [bit] NULL,
	[IsOrderUsedStatusFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpFactoryOrderStatus] PRIMARY KEY CLUSTERED
(
	[FactoryOrderStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
