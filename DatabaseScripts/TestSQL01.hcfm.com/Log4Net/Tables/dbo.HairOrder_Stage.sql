/* CreateDate: 05/15/2019 12:16:56.270 , ModifyDate: 05/15/2019 14:30:26.200 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HairOrder_Stage](
	[HairSystemOrderNumber] [float] NULL,
	[weekof] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NULL,
	[isprocessedflag] [bit] NULL
) ON [PRIMARY]
GO
