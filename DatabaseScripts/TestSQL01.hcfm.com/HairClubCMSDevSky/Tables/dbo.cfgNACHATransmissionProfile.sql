/* CreateDate: 09/26/2016 08:09:20.977 , ModifyDate: 09/26/2016 08:09:21.273 */
GO
CREATE TABLE [dbo].[cfgNACHATransmissionProfile](
	[NACHATransmissionProfileID] [int] IDENTITY(1,1) NOT NULL,
	[NACHATransmissionProtocolID] [int] NOT NULL,
	[NACHATransmissionProfileDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[NACHATransmissionProfileDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HostName] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UserName] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Password] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PortNumber] [int] NULL,
	[SshHostKeyFingerprint] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DestinationUploadFolder] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_NACHATransmissionProfile] PRIMARY KEY CLUSTERED
(
	[NACHATransmissionProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgNACHATransmissionProfile]  WITH CHECK ADD  CONSTRAINT [FK_cfgNACHATransmissionProfile_lkpNACHATransmissionProtocol] FOREIGN KEY([NACHATransmissionProtocolID])
REFERENCES [dbo].[lkpNACHATransmissionProtocol] ([NACHATransmissionProtocolID])
GO
ALTER TABLE [dbo].[cfgNACHATransmissionProfile] CHECK CONSTRAINT [FK_cfgNACHATransmissionProfile_lkpNACHATransmissionProtocol]
GO
