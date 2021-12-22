/* CreateDate: 01/10/2020 16:05:29.803 , ModifyDate: 01/10/2020 16:05:29.803 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['100Corporate$'](
	[CenterID] [float] NULL,
	[CenterDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeID] [float] NULL,
	[SalesCodeDescriptionShort] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterCost_JV-Corporate] [money] NULL,
	[CenterCost_Franchise] [money] NULL,
	[F8] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
