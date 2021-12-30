/* CreateDate: 03/11/2021 16:45:36.973 , ModifyDate: 03/16/2021 10:06:50.443 */
GO
CREATE TABLE [dbo].[HairSystemType](
	[HairSystemID] [float] NULL,
	[HairSystemDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShortDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemTypeGroupCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemTypeGroupDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
