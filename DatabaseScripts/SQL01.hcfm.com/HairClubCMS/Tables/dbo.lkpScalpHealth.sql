/* CreateDate: 07/15/2014 08:03:42.067 , ModifyDate: 05/26/2020 10:49:17.657 */
GO
CREATE TABLE [dbo].[lkpScalpHealth](
	[ScalpHealthID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ScalpHealthSortOrder] [int] NOT NULL,
	[ScalpHealthDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ScalpHealthDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ScalpHealthDetail] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DetailResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpScalpHealth] PRIMARY KEY CLUSTERED
(
	[ScalpHealthID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
