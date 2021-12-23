/* CreateDate: 12/31/2010 13:21:02.120 , ModifyDate: 05/26/2020 10:49:09.543 */
GO
CREATE TABLE [dbo].[cfgHairSystemLocation](
	[HairSystemLocationID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterID] [int] NOT NULL,
	[CabinetNumber] [int] NULL,
	[DrawerNumber] [int] NULL,
	[BinNumber] [int] NULL,
	[NonstandardDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaximumQuantityPerLocation] [int] NULL,
	[HairSystemLocationDescriptionCalc]  AS (isnull([NonstandardDescription],(((('C:'+isnull(CONVERT([nvarchar],[CabinetNumber],0),'x'))+' D:')+isnull(CONVERT([nvarchar],[DrawerNumber],0),'x'))+' B:')+isnull(CONVERT([nvarchar],[BinNumber],0),'x'))),
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemLocation] PRIMARY KEY CLUSTERED
(
	[HairSystemLocationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgHairSystemLocation_CabinetDrawerBin] ON [dbo].[cfgHairSystemLocation]
(
	[CenterID] ASC,
	[CabinetNumber] ASC,
	[DrawerNumber] ASC,
	[BinNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemLocation] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[cfgHairSystemLocation]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgHairSystemLocation_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[cfgHairSystemLocation] CHECK CONSTRAINT [FK_cfgHairSystemLocation_cfgCenter]
GO
