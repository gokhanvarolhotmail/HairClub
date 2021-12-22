/* CreateDate: 09/23/2019 12:36:10.507 , ModifyDate: 09/23/2019 12:36:10.620 */
GO
CREATE TABLE [dbo].[datSlideShowDownloadTurn](
	[SlideShowDownloadTurnID] [int] IDENTITY(1,1) NOT NULL,
	[CenterID] [int] NOT NULL,
	[DateTurn] [datetime] NOT NULL,
	[DeviceId] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TimeTurn] [time](7) NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datSlideShowDownloadTurn] PRIMARY KEY CLUSTERED
(
	[SlideShowDownloadTurnID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datSlideShowDownloadTurn]  WITH CHECK ADD  CONSTRAINT [FK_datSlideShowDownloadTurn_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datSlideShowDownloadTurn] CHECK CONSTRAINT [FK_datSlideShowDownloadTurn_cfgCenter]
GO
