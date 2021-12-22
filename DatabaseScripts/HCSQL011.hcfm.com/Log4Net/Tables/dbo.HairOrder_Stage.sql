/* CreateDate: 05/16/2019 16:33:57.383 , ModifyDate: 05/16/2019 16:33:57.383 */
GO
CREATE TABLE [dbo].[HairOrder_Stage](
	[HairSystemOrderNumber] [float] NULL,
	[weekof] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NULL,
	[isprocessedflag] [bit] NULL
) ON [PRIMARY]
GO
