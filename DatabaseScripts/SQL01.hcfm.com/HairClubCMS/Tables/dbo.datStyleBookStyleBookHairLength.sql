CREATE TABLE [dbo].[datStyleBookStyleBookHairLength](
	[StyleBookStyleBookHairLengthID] [int] IDENTITY(1,1) NOT NULL,
	[StyleBookID] [int] NOT NULL,
	[StyleBookHairLengthID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datStyleBookStyleBookHairLength] PRIMARY KEY CLUSTERED
(
	[StyleBookStyleBookHairLengthID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datStyleBookStyleBookHairLength]  WITH CHECK ADD  CONSTRAINT [FK_datStyleBookStyleBookHairLength_datStyleBook] FOREIGN KEY([StyleBookID])
REFERENCES [dbo].[datStyleBook] ([StyleBookID])
GO
ALTER TABLE [dbo].[datStyleBookStyleBookHairLength] CHECK CONSTRAINT [FK_datStyleBookStyleBookHairLength_datStyleBook]
GO
ALTER TABLE [dbo].[datStyleBookStyleBookHairLength]  WITH CHECK ADD  CONSTRAINT [FK_datStyleBookStyleBookHairLength_lkpStyleBookHairLength] FOREIGN KEY([StyleBookHairLengthID])
REFERENCES [dbo].[lkpStyleBookHairLength] ([StyleBookHairLengthID])
GO
ALTER TABLE [dbo].[datStyleBookStyleBookHairLength] CHECK CONSTRAINT [FK_datStyleBookStyleBookHairLength_lkpStyleBookHairLength]
