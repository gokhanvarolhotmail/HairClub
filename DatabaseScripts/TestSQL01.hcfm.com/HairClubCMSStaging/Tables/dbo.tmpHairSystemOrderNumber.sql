/* CreateDate: 05/13/2013 11:59:03.650 , ModifyDate: 05/13/2013 11:59:03.650 */
GO
CREATE TABLE [dbo].[tmpHairSystemOrderNumber](
	[HairSystemOrderGUID] [uniqueidentifier] NULL,
	[HairSystemOrderNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientHomeCenterID] [int] NULL,
	[NewHairSystemOrderNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
