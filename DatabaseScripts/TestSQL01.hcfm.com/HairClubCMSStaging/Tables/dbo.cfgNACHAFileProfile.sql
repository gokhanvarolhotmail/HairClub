/* CreateDate: 03/24/2015 07:43:18.500 , ModifyDate: 09/26/2016 08:09:21.333 */
GO
CREATE TABLE [dbo].[cfgNACHAFileProfile](
	[NACHAFileProfileID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[NACHAFileProfileName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FileHeaderRecordTypeCode] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FileHeaderPriorityCode] [nvarchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FileHeaderImmediateDestination] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FileHeaderImmediateOrigin] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FileHeaderCurrentFileID] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FileHeaderLastFileCreationDate] [datetime] NOT NULL,
	[FileHeaderRecordSize] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FileHeaderBlockingFactor] [nvarchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FileHeaderFormatCode] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FileHeaderDestination] [nvarchar](23) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FileHeaderCompanyName] [nvarchar](23) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BatchHeaderRecordTypeCode] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BatchHeaderServiceClassCode] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BatchHeaderCompanyName] [nvarchar](16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BatchHeaderCompanyIdentification] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BatchHeaderStandardEntryClassCode] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BatchHeaderCompanyEntryDescription] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BatchHeaderEffectiveEntryDateOffsetDays] [int] NOT NULL,
	[BatchHeaderOriginatorStatusCode] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BatchHeaderOriginatingDFI] [nvarchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EntryDetailRecordTypeCode] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[NACHATransmissionProfileID] [int] NOT NULL,
	[FileRoutingHeaderRecord] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryID] [int] NOT NULL,
 CONSTRAINT [PK_cfgNACHAFileProfile] PRIMARY KEY CLUSTERED
(
	[NACHAFileProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgNACHAFileProfile] ADD  DEFAULT ('1') FOR [FileHeaderRecordTypeCode]
GO
ALTER TABLE [dbo].[cfgNACHAFileProfile] ADD  DEFAULT ('01') FOR [FileHeaderPriorityCode]
GO
ALTER TABLE [dbo].[cfgNACHAFileProfile] ADD  DEFAULT ('1') FOR [FileHeaderFormatCode]
GO
ALTER TABLE [dbo].[cfgNACHAFileProfile] ADD  DEFAULT ('5') FOR [BatchHeaderRecordTypeCode]
GO
ALTER TABLE [dbo].[cfgNACHAFileProfile] ADD  DEFAULT ('1') FOR [BatchHeaderOriginatorStatusCode]
GO
ALTER TABLE [dbo].[cfgNACHAFileProfile] ADD  DEFAULT ('6') FOR [EntryDetailRecordTypeCode]
GO
ALTER TABLE [dbo].[cfgNACHAFileProfile]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgNACHAFileProfile_cfgNACHATransmissionProfile] FOREIGN KEY([NACHATransmissionProfileID])
REFERENCES [dbo].[cfgNACHATransmissionProfile] ([NACHATransmissionProfileID])
GO
ALTER TABLE [dbo].[cfgNACHAFileProfile] CHECK CONSTRAINT [FK_cfgNACHAFileProfile_cfgNACHATransmissionProfile]
GO
ALTER TABLE [dbo].[cfgNACHAFileProfile]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgNACHAFileProfile_lkpCountry] FOREIGN KEY([CountryID])
REFERENCES [dbo].[lkpCountry] ([CountryID])
GO
ALTER TABLE [dbo].[cfgNACHAFileProfile] CHECK CONSTRAINT [FK_cfgNACHAFileProfile_lkpCountry]
GO
