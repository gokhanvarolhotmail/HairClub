/* CreateDate: 02/26/2017 22:35:10.127 , ModifyDate: 05/26/2020 10:49:43.903 */
GO
CREATE TABLE [dbo].[lkpHairHealth](
	[HairHealthID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairHealthSortOrder] [int] NOT NULL,
	[HairHealthDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairHealthDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpHairHealth] PRIMARY KEY CLUSTERED
(
	[HairHealthID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
