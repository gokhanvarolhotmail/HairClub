/* CreateDate: 06/10/2019 06:44:57.853 , ModifyDate: 06/10/2019 06:44:57.927 */
GO
CREATE TABLE [dbo].[datStyleBook](
	[StyleBookID] [int] IDENTITY(1,1) NOT NULL,
	[StyleBookSortOrder] [int] NOT NULL,
	[StyleBookDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GenderID] [int] NOT NULL,
	[StyleBookHairTypeID] [int] NOT NULL,
	[Disclaimer] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsBarbering] [bit] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datStyleBook] PRIMARY KEY CLUSTERED
(
	[StyleBookID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datStyleBook]  WITH CHECK ADD  CONSTRAINT [FK_datStyleBook_lkpGender] FOREIGN KEY([GenderID])
REFERENCES [dbo].[lkpGender] ([GenderID])
GO
ALTER TABLE [dbo].[datStyleBook] CHECK CONSTRAINT [FK_datStyleBook_lkpGender]
GO
ALTER TABLE [dbo].[datStyleBook]  WITH CHECK ADD  CONSTRAINT [FK_datStyleBook_lkpStyleBookHairType] FOREIGN KEY([StyleBookHairTypeID])
REFERENCES [dbo].[lkpStyleBookHairType] ([StyleBookHairTypeID])
GO
ALTER TABLE [dbo].[datStyleBook] CHECK CONSTRAINT [FK_datStyleBook_lkpStyleBookHairType]
GO
