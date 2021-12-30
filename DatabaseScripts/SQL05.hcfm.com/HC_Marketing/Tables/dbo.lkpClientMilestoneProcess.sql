/* CreateDate: 01/20/2020 15:02:20.290 , ModifyDate: 01/20/2020 15:02:20.290 */
GO
CREATE TABLE [dbo].[lkpClientMilestoneProcess](
	[ClientMilestoneProcessID] [int] IDENTITY(1,1) NOT NULL,
	[ClientMilestoneProcessDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientMilestoneProcessDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
