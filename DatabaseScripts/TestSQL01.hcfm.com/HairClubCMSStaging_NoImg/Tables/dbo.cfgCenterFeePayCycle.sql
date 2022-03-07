/* CreateDate: 02/03/2014 07:54:43.377 , ModifyDate: 03/04/2022 16:09:12.867 */
GO
CREATE TABLE [dbo].[cfgCenterFeePayCycle](
	[CenterFeePayCycleID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterID] [int] NOT NULL,
	[FeePayCycleID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgCenterFeePayCycle] PRIMARY KEY NONCLUSTERED
(
	[CenterFeePayCycleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgCenterFeePayCycle]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterFeePayCycle_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[cfgCenterFeePayCycle] CHECK CONSTRAINT [FK_cfgCenterFeePayCycle_cfgCenter]
GO
ALTER TABLE [dbo].[cfgCenterFeePayCycle]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterFeePayCycle_lkpFeePayCycle] FOREIGN KEY([FeePayCycleID])
REFERENCES [dbo].[lkpFeePayCycle] ([FeePayCycleID])
GO
ALTER TABLE [dbo].[cfgCenterFeePayCycle] CHECK CONSTRAINT [FK_cfgCenterFeePayCycle_lkpFeePayCycle]
GO
