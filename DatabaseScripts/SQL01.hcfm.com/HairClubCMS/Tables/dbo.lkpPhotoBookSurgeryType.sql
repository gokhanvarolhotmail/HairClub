/* CreateDate: 06/05/2017 06:22:02.963 , ModifyDate: 06/05/2017 06:22:03.037 */
GO
CREATE TABLE [dbo].[lkpPhotoBookSurgeryType](
	[PhotoBookSurgeryTypeID] [int] IDENTITY(1,1) NOT NULL,
	[PhotoBookSurgeryTypeSortOrder] [int] NOT NULL,
	[PhotoBookSurgeryTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PhotoBookSurgeryTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpPhotoBookSurgeryType] PRIMARY KEY CLUSTERED
(
	[PhotoBookSurgeryTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
