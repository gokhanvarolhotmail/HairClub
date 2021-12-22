/* CreateDate: 03/16/2021 10:54:53.433 , ModifyDate: 03/16/2021 10:54:53.433 */
GO
CREATE TABLE [dbo].[HairSystemType](
	[HairSystemID] [float] NULL,
	[HairSystemDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShortDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemTypeGroupCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemTypeGroupDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
