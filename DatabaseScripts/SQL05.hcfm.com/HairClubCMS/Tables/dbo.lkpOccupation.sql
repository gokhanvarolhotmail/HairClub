/* CreateDate: 05/05/2020 17:42:48.963 , ModifyDate: 05/05/2020 17:43:08.613 */
GO
CREATE TABLE [dbo].[lkpOccupation](
	[OccupationID] [int] NOT NULL,
	[BOSOccupationCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OccupationSortOrder] [int] NOT NULL,
	[OccupationDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OccupationDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpOccupation] PRIMARY KEY CLUSTERED
(
	[OccupationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO