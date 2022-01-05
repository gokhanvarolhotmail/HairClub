/* CreateDate: 01/21/2014 23:48:16.687 , ModifyDate: 01/04/2022 10:56:36.877 */
GO
CREATE TABLE [dbo].[lkpDocumentType](
	[DocumentTypeID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[DocumentTypeSortOrder] [int] NOT NULL,
	[DocumentTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DocumentTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ElectronicSignatureEnabled] [bit] NOT NULL,
	[IsAvailableToStylistApp] [bit] NOT NULL,
 CONSTRAINT [PK_lkpDocumentType] PRIMARY KEY CLUSTERED
(
	[DocumentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpDocumentType] ADD  CONSTRAINT [DF_lkpDocumentType_ElectronicSignatureEnabled]  DEFAULT ((0)) FOR [ElectronicSignatureEnabled]
GO
