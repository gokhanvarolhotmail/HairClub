/* CreateDate: 02/26/2017 22:35:10.437 , ModifyDate: 12/03/2021 10:24:48.740 */
GO
CREATE TABLE [dbo].[datTechnicalProfileXtrands](
	[TechnicalProfileXtrandsID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[TechnicalProfileID] [int] NOT NULL,
	[LastTrichoViewDate] [datetime] NULL,
	[LastXtrandsServiceDate] [datetime] NULL,
	[HairStrandGroupID] [int] NULL,
	[HairHealthID] [int] NULL,
	[LaserDeviceSalesCodeID] [int] NULL,
	[ShampooSalesCodeID] [int] NULL,
	[ConditionerSalesCodeID] [int] NULL,
	[Other] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsMinoxidilUsed] [bit] NULL,
	[MinoxidilSalesCodeID] [int] NULL,
	[ServiceDuration] [int] NULL,
	[ServiceTimeUnitID] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[Strands] [int] NULL,
	[OtherServiceSalesCodeID] [int] NULL,
	[OtherServiceDuration] [int] NULL,
	[OtherServiceTimeUnitID] [int] NULL,
 CONSTRAINT [PK_datTechnicalProfileXtrands] PRIMARY KEY CLUSTERED
(
	[TechnicalProfileXtrandsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_datTechnicalProfileXtrands_TechnicalProfileID] UNIQUE NONCLUSTERED
(
	[TechnicalProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datTechnicalProfileXtrands]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileXtrands_cfgSalesCode] FOREIGN KEY([LaserDeviceSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[datTechnicalProfileXtrands] CHECK CONSTRAINT [FK_datTechnicalProfileXtrands_cfgSalesCode]
GO
ALTER TABLE [dbo].[datTechnicalProfileXtrands]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileXtrands_cfgSalesCode_OtherService] FOREIGN KEY([OtherServiceSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[datTechnicalProfileXtrands] CHECK CONSTRAINT [FK_datTechnicalProfileXtrands_cfgSalesCode_OtherService]
GO
ALTER TABLE [dbo].[datTechnicalProfileXtrands]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileXtrands_cfgSalesCode1] FOREIGN KEY([ShampooSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[datTechnicalProfileXtrands] CHECK CONSTRAINT [FK_datTechnicalProfileXtrands_cfgSalesCode1]
GO
ALTER TABLE [dbo].[datTechnicalProfileXtrands]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileXtrands_cfgSalesCode2] FOREIGN KEY([ConditionerSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[datTechnicalProfileXtrands] CHECK CONSTRAINT [FK_datTechnicalProfileXtrands_cfgSalesCode2]
GO
ALTER TABLE [dbo].[datTechnicalProfileXtrands]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileXtrands_cfgSalesCode3] FOREIGN KEY([MinoxidilSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[datTechnicalProfileXtrands] CHECK CONSTRAINT [FK_datTechnicalProfileXtrands_cfgSalesCode3]
GO
ALTER TABLE [dbo].[datTechnicalProfileXtrands]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileXtrands_datTechnicalProfile] FOREIGN KEY([TechnicalProfileID])
REFERENCES [dbo].[datTechnicalProfile] ([TechnicalProfileID])
GO
ALTER TABLE [dbo].[datTechnicalProfileXtrands] CHECK CONSTRAINT [FK_datTechnicalProfileXtrands_datTechnicalProfile]
GO
ALTER TABLE [dbo].[datTechnicalProfileXtrands]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileXtrands_lkpHairHealth] FOREIGN KEY([HairHealthID])
REFERENCES [dbo].[lkpHairHealth] ([HairHealthID])
GO
ALTER TABLE [dbo].[datTechnicalProfileXtrands] CHECK CONSTRAINT [FK_datTechnicalProfileXtrands_lkpHairHealth]
GO
ALTER TABLE [dbo].[datTechnicalProfileXtrands]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileXtrands_lkpHairStrandGroup] FOREIGN KEY([HairStrandGroupID])
REFERENCES [dbo].[lkpHairStrandGroup] ([HairStrandGroupID])
GO
ALTER TABLE [dbo].[datTechnicalProfileXtrands] CHECK CONSTRAINT [FK_datTechnicalProfileXtrands_lkpHairStrandGroup]
GO
ALTER TABLE [dbo].[datTechnicalProfileXtrands]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileXtrands_lkpTimeUnit] FOREIGN KEY([ServiceTimeUnitID])
REFERENCES [dbo].[lkpTimeUnit] ([TimeUnitID])
GO
ALTER TABLE [dbo].[datTechnicalProfileXtrands] CHECK CONSTRAINT [FK_datTechnicalProfileXtrands_lkpTimeUnit]
GO
ALTER TABLE [dbo].[datTechnicalProfileXtrands]  WITH CHECK ADD  CONSTRAINT [FK_datTechnicalProfileXtrands_lkpTimeUnit_OtherService] FOREIGN KEY([OtherServiceTimeUnitID])
REFERENCES [dbo].[lkpTimeUnit] ([TimeUnitID])
GO
ALTER TABLE [dbo].[datTechnicalProfileXtrands] CHECK CONSTRAINT [FK_datTechnicalProfileXtrands_lkpTimeUnit_OtherService]
GO
