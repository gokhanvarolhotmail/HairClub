/* CreateDate: 05/23/2011 19:37:45.530 , ModifyDate: 12/07/2021 16:20:16.283 */
GO
CREATE TABLE [dbo].[cfgCenterFinanceCompanyJoin](
	[CenterFinanceCompanyJoinID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterID] [int] NOT NULL,
	[FinanceCompanyID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgCenterFinanceCompanyJoin] PRIMARY KEY CLUSTERED
(
	[CenterFinanceCompanyJoinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgCenterFinanceCompanyJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterFinanceCompanyJoin_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[cfgCenterFinanceCompanyJoin] CHECK CONSTRAINT [FK_cfgCenterFinanceCompanyJoin_cfgCenter]
GO
ALTER TABLE [dbo].[cfgCenterFinanceCompanyJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterFinanceCompanyJoin_lkpFinanceCompany] FOREIGN KEY([FinanceCompanyID])
REFERENCES [dbo].[lkpFinanceCompany] ([FinanceCompanyID])
GO
ALTER TABLE [dbo].[cfgCenterFinanceCompanyJoin] CHECK CONSTRAINT [FK_cfgCenterFinanceCompanyJoin_lkpFinanceCompany]
GO
