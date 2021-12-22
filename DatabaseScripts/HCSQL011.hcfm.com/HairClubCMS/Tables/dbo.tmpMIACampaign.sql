/* CreateDate: 08/14/2018 12:10:13.093 , ModifyDate: 08/14/2018 12:10:13.093 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmpMIACampaign](
	[CenterID] [int] NULL,
	[CenterDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientIdentifier] [int] NULL,
	[FullName] [nvarchar](102) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
