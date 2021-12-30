/* CreateDate: 05/21/2017 22:29:10.487 , ModifyDate: 05/21/2017 22:29:11.170 */
GO
CREATE TABLE [dbo].[lkpPhotoBookAgeRange](
	[PhotoBookAgeRangeID] [int] IDENTITY(1,1) NOT NULL,
	[PhotoBookAgeRangeSortOrder] [int] NOT NULL,
	[PhotoBookAgeRangeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PhotoBookAgeRangeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MinimumAge] [int] NOT NULL,
	[MaximumAge] [int] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpPhotoBookAgeRange] PRIMARY KEY CLUSTERED
(
	[PhotoBookAgeRangeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
