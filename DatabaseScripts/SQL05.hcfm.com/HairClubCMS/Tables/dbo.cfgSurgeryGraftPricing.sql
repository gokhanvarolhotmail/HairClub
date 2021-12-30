/* CreateDate: 05/05/2020 17:42:45.117 , ModifyDate: 05/05/2020 17:43:04.193 */
GO
CREATE TABLE [dbo].[cfgSurgeryGraftPricing](
	[SurgeryGraftPricingID] [int] NOT NULL,
	[SurgeryGraftPricingSortOrder] [int] NULL,
	[CenterID] [int] NOT NULL,
	[GraftsMinimum] [int] NULL,
	[GraftsMaximum] [int] NULL,
	[CostPerGraft] [money] NULL,
	[CreateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgSurgeryGraftPricing] PRIMARY KEY CLUSTERED
(
	[SurgeryGraftPricingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
