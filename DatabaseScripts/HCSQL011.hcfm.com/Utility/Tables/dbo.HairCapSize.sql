/* CreateDate: 03/16/2021 10:54:53.133 , ModifyDate: 03/16/2021 10:54:53.133 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HairCapSize](
	[HairSystemHairCapID] [float] NULL,
	[CapSizeGroupDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CapSizeGroupCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
