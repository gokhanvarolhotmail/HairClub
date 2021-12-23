/* CreateDate: 02/18/2013 06:59:17.683 , ModifyDate: 05/26/2020 10:49:18.083 */
GO
CREATE TABLE [dbo].[cfgRegister](
	[RegisterID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[RegisterDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RegisterDescriptionShort] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterID] [int] NOT NULL,
	[HasCashDrawer] [bit] NOT NULL,
	[CanRunEndOfDay] [bit] NOT NULL,
	[CashRegisterID] [int] NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[IPAddress] [nvarchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_cfgRegister] PRIMARY KEY CLUSTERED
(
	[RegisterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [NK_cfgRegister] ON [dbo].[cfgRegister]
(
	[RegisterDescriptionShort] ASC,
	[CenterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgRegister] ADD  CONSTRAINT [DF_cfgRegister_HasCashDrawer]  DEFAULT ((0)) FOR [HasCashDrawer]
GO
ALTER TABLE [dbo].[cfgRegister] ADD  DEFAULT ((0)) FOR [CanRunEndOfDay]
GO
ALTER TABLE [dbo].[cfgRegister] ADD  CONSTRAINT [DF_cfgRegister_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[cfgRegister]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgRegister_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[cfgRegister] CHECK CONSTRAINT [FK_cfgRegister_cfgCenter]
GO
ALTER TABLE [dbo].[cfgRegister]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgRegister_cfgRegister] FOREIGN KEY([CashRegisterID])
REFERENCES [dbo].[cfgRegister] ([RegisterID])
GO
ALTER TABLE [dbo].[cfgRegister] CHECK CONSTRAINT [FK_cfgRegister_cfgRegister]
GO
