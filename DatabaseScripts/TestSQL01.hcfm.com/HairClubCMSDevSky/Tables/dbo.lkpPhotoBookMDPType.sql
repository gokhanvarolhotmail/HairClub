/* CreateDate: 06/10/2019 07:10:15.343 , ModifyDate: 06/10/2019 07:10:15.367 */
GO
CREATE TABLE [dbo].[lkpPhotoBookMDPType](
	[PhotoBookMDPTypeID] [int] IDENTITY(1,1) NOT NULL,
	[PhotoBookMDPTypeSortOrder] [int] NOT NULL,
	[PhotoBookMDPTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PhotoBookMDPTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpPhotoBookMDPType] PRIMARY KEY CLUSTERED
(
	[PhotoBookMDPTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
