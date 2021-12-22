/* CreateDate: 11/04/2019 08:18:20.280 , ModifyDate: 11/04/2019 08:18:20.320 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgSalesCodeCenterScorecardCategory](
	[SalesCodeCenterScorecardCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[SalesCodeCenterID] [int] NOT NULL,
	[ScorecardCategoryID] [int] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgSalesCodeCenterScorecardCategory] PRIMARY KEY CLUSTERED
(
	[SalesCodeCenterScorecardCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgSalesCodeCenterScorecardCategory]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCodeCenterScorecardCategory_cfgSalesCodeCenter] FOREIGN KEY([SalesCodeCenterID])
REFERENCES [dbo].[cfgSalesCodeCenter] ([SalesCodeCenterID])
GO
ALTER TABLE [dbo].[cfgSalesCodeCenterScorecardCategory] CHECK CONSTRAINT [FK_cfgSalesCodeCenterScorecardCategory_cfgSalesCodeCenter]
GO
ALTER TABLE [dbo].[cfgSalesCodeCenterScorecardCategory]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCodeCenterScorecardCategory_lkpScorecardCategory] FOREIGN KEY([ScorecardCategoryID])
REFERENCES [dbo].[lkpScorecardCategory] ([ScorecardCategoryID])
GO
ALTER TABLE [dbo].[cfgSalesCodeCenterScorecardCategory] CHECK CONSTRAINT [FK_cfgSalesCodeCenterScorecardCategory_lkpScorecardCategory]
GO
