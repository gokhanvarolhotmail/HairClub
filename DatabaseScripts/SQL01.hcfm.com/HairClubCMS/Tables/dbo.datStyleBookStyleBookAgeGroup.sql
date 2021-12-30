/* CreateDate: 06/10/2019 06:44:57.820 , ModifyDate: 06/10/2019 06:44:57.910 */
GO
CREATE TABLE [dbo].[datStyleBookStyleBookAgeGroup](
	[StyleBookStyleBookAgeGroupID] [int] IDENTITY(1,1) NOT NULL,
	[StyleBookID] [int] NOT NULL,
	[StyleBookAgeGroupID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datStyleBookStyleBookAgeGroup] PRIMARY KEY CLUSTERED
(
	[StyleBookStyleBookAgeGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datStyleBookStyleBookAgeGroup]  WITH CHECK ADD  CONSTRAINT [FK_datStyleBookStyleBookAgeGroup_datStyleBook] FOREIGN KEY([StyleBookID])
REFERENCES [dbo].[datStyleBook] ([StyleBookID])
GO
ALTER TABLE [dbo].[datStyleBookStyleBookAgeGroup] CHECK CONSTRAINT [FK_datStyleBookStyleBookAgeGroup_datStyleBook]
GO
ALTER TABLE [dbo].[datStyleBookStyleBookAgeGroup]  WITH CHECK ADD  CONSTRAINT [FK_datStyleBookStyleBookAgeGroup_lkpStyleBookAgeGroup] FOREIGN KEY([StyleBookAgeGroupID])
REFERENCES [dbo].[lkpStyleBookAgeGroup] ([StyleBookAgeGroupID])
GO
ALTER TABLE [dbo].[datStyleBookStyleBookAgeGroup] CHECK CONSTRAINT [FK_datStyleBookStyleBookAgeGroup_lkpStyleBookAgeGroup]
GO
