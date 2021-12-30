/* CreateDate: 01/20/2020 15:02:20.350 , ModifyDate: 01/20/2020 15:02:20.350 */
GO
CREATE TABLE [dbo].[lkpClientMilestoneStatus](
	[ClientMilestoneStatusID] [int] IDENTITY(1,1) NOT NULL,
	[ClientMilestoneStatusDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientMilestoneStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
