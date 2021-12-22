/* CreateDate: 05/20/2014 07:52:23.130 , ModifyDate: 12/03/2021 10:24:48.553 */
GO
CREATE TABLE [dbo].[lkpPhotoMarkupType](
	[PhotoMarkupTypeID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[PhotoMarkupTypeSortOrder] [int] NOT NULL,
	[PhotoMarkupTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PhotoMarkupTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpPhotoMarkupType] PRIMARY KEY CLUSTERED
(
	[PhotoMarkupTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
