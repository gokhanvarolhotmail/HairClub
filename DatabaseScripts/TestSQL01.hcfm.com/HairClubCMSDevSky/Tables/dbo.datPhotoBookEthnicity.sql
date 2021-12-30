/* CreateDate: 05/21/2017 22:29:10.797 , ModifyDate: 05/21/2017 22:29:10.857 */
GO
CREATE TABLE [dbo].[datPhotoBookEthnicity](
	[PhotoBookEthnicityID] [int] IDENTITY(1,1) NOT NULL,
	[PhotoBookID] [int] NOT NULL,
	[EthnicityID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datPhotoBookEthnicity] PRIMARY KEY CLUSTERED
(
	[PhotoBookEthnicityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datPhotoBookEthnicity]  WITH CHECK ADD  CONSTRAINT [FK_datPhotoBookEthnicity_datPhotoBook] FOREIGN KEY([PhotoBookID])
REFERENCES [dbo].[datPhotoBook] ([PhotoBookID])
GO
ALTER TABLE [dbo].[datPhotoBookEthnicity] CHECK CONSTRAINT [FK_datPhotoBookEthnicity_datPhotoBook]
GO
ALTER TABLE [dbo].[datPhotoBookEthnicity]  WITH CHECK ADD  CONSTRAINT [FK_datPhotoBookEthnicity_lkpEthnicity] FOREIGN KEY([EthnicityID])
REFERENCES [dbo].[lkpEthnicity] ([EthnicityID])
GO
ALTER TABLE [dbo].[datPhotoBookEthnicity] CHECK CONSTRAINT [FK_datPhotoBookEthnicity_lkpEthnicity]
GO
