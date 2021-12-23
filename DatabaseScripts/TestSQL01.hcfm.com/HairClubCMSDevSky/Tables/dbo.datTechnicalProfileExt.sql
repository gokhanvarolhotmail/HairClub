/* CreateDate: 02/26/2017 22:35:10.400 , ModifyDate: 12/07/2021 16:20:16.267 */
GO
CREATE TABLE [dbo].[datTechnicalProfileExt](
	[TechnicalProfileExtID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TechnicalProfileID] [int] NOT NULL,
	[LastTrichoViewDate] [datetime] NULL,
	[LastExtServiceDate] [datetime] NULL,
	[HairHealthID] [int] NULL,
	[ScalpHealthID] [int] NULL,
	[CleanserUsedSalesCodeID] [int] NULL,
	[ElixirFormulation] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MassagePressureID] [int] NULL,
	[LaserDeviceSalesCodeID] [int] NULL,
	[CleanserSalesCodeID] [int] NULL,
	[ConditionerSalesCodeID] [int] NULL,
	[IsMinoxidilUsed] [bit] NULL,
	[MinoxidilSalesCodeID] [int] NULL,
	[IsScalpEnzymeCleanserUsed] [bit] NULL,
	[Other] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceDuration] [int] NULL,
	[ServiceTimeUnitID] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsSurgeryClient] [bit] NULL,
	[GraftCount] [int] NULL,
	[LastSurgeryDate] [datetime] NULL,
	[OtherServiceSalesCodeID] [int] NULL,
	[OtherServiceDuration] [int] NULL,
	[OtherServiceTimeUnitID] [int] NULL,
 CONSTRAINT [PK_datTechnicalProfileExt] PRIMARY KEY CLUSTERED
(
	[TechnicalProfileExtID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_datTechnicalProfileExt_TechnicalProfileID] UNIQUE NONCLUSTERED
(
	[TechnicalProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datTechnicalProfileExt]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfileExt_cfgSalesCode] FOREIGN KEY([CleanserUsedSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[datTechnicalProfileExt] CHECK CONSTRAINT [FK_datTechnicalProfileExt_cfgSalesCode]
GO
ALTER TABLE [dbo].[datTechnicalProfileExt]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfileExt_cfgSalesCode_OtherService] FOREIGN KEY([OtherServiceSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[datTechnicalProfileExt] CHECK CONSTRAINT [FK_datTechnicalProfileExt_cfgSalesCode_OtherService]
GO
ALTER TABLE [dbo].[datTechnicalProfileExt]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfileExt_cfgSalesCode1] FOREIGN KEY([LaserDeviceSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[datTechnicalProfileExt] CHECK CONSTRAINT [FK_datTechnicalProfileExt_cfgSalesCode1]
GO
ALTER TABLE [dbo].[datTechnicalProfileExt]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfileExt_cfgSalesCode2] FOREIGN KEY([CleanserSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[datTechnicalProfileExt] CHECK CONSTRAINT [FK_datTechnicalProfileExt_cfgSalesCode2]
GO
ALTER TABLE [dbo].[datTechnicalProfileExt]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfileExt_cfgSalesCode3] FOREIGN KEY([ConditionerSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[datTechnicalProfileExt] CHECK CONSTRAINT [FK_datTechnicalProfileExt_cfgSalesCode3]
GO
ALTER TABLE [dbo].[datTechnicalProfileExt]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfileExt_cfgSalesCode4] FOREIGN KEY([MinoxidilSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[datTechnicalProfileExt] CHECK CONSTRAINT [FK_datTechnicalProfileExt_cfgSalesCode4]
GO
ALTER TABLE [dbo].[datTechnicalProfileExt]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfileExt_datTechnicalProfile] FOREIGN KEY([TechnicalProfileID])
REFERENCES [dbo].[datTechnicalProfile] ([TechnicalProfileID])
GO
ALTER TABLE [dbo].[datTechnicalProfileExt] CHECK CONSTRAINT [FK_datTechnicalProfileExt_datTechnicalProfile]
GO
ALTER TABLE [dbo].[datTechnicalProfileExt]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfileExt_lkpHairHealth] FOREIGN KEY([HairHealthID])
REFERENCES [dbo].[lkpHairHealth] ([HairHealthID])
GO
ALTER TABLE [dbo].[datTechnicalProfileExt] CHECK CONSTRAINT [FK_datTechnicalProfileExt_lkpHairHealth]
GO
ALTER TABLE [dbo].[datTechnicalProfileExt]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfileExt_lkpMassagePressure] FOREIGN KEY([MassagePressureID])
REFERENCES [dbo].[lkpMassagePressure] ([MassagePressureID])
GO
ALTER TABLE [dbo].[datTechnicalProfileExt] CHECK CONSTRAINT [FK_datTechnicalProfileExt_lkpMassagePressure]
GO
ALTER TABLE [dbo].[datTechnicalProfileExt]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfileExt_lkpScalpHealth] FOREIGN KEY([ScalpHealthID])
REFERENCES [dbo].[lkpScalpHealth] ([ScalpHealthID])
GO
ALTER TABLE [dbo].[datTechnicalProfileExt] CHECK CONSTRAINT [FK_datTechnicalProfileExt_lkpScalpHealth]
GO
ALTER TABLE [dbo].[datTechnicalProfileExt]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfileExt_lkpTimeUnit] FOREIGN KEY([ServiceTimeUnitID])
REFERENCES [dbo].[lkpTimeUnit] ([TimeUnitID])
GO
ALTER TABLE [dbo].[datTechnicalProfileExt] CHECK CONSTRAINT [FK_datTechnicalProfileExt_lkpTimeUnit]
GO
ALTER TABLE [dbo].[datTechnicalProfileExt]  WITH NOCHECK ADD  CONSTRAINT [FK_datTechnicalProfileExt_lkpTimeUnit_OtherService] FOREIGN KEY([OtherServiceTimeUnitID])
REFERENCES [dbo].[lkpTimeUnit] ([TimeUnitID])
GO
ALTER TABLE [dbo].[datTechnicalProfileExt] CHECK CONSTRAINT [FK_datTechnicalProfileExt_lkpTimeUnit_OtherService]
GO
