/* CreateDate: 04/24/2017 08:10:29.317 , ModifyDate: 12/29/2021 15:38:46.477 */
GO
CREATE TABLE [dbo].[cfgAddOnAccumulator](
	[AddOnAccumulatorID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AddOnID] [int] NOT NULL,
	[AccumulatorID] [int] NOT NULL,
	[InitialQuantity] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgAddOnAccumulatorID] PRIMARY KEY CLUSTERED
(
	[AddOnAccumulatorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgAddOnAccumulator]  WITH CHECK ADD  CONSTRAINT [FK_cfgAddOnAccumulator_cfgAccumulator] FOREIGN KEY([AccumulatorID])
REFERENCES [dbo].[cfgAccumulator] ([AccumulatorID])
GO
ALTER TABLE [dbo].[cfgAddOnAccumulator] CHECK CONSTRAINT [FK_cfgAddOnAccumulator_cfgAccumulator]
GO
ALTER TABLE [dbo].[cfgAddOnAccumulator]  WITH CHECK ADD  CONSTRAINT [FK_cfgAddOnAccumulator_cfgAddOn] FOREIGN KEY([AddOnID])
REFERENCES [dbo].[cfgAddOn] ([AddOnID])
GO
ALTER TABLE [dbo].[cfgAddOnAccumulator] CHECK CONSTRAINT [FK_cfgAddOnAccumulator_cfgAddOn]
GO
