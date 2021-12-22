/* CreateDate: 02/26/2017 22:35:10.203 , ModifyDate: 12/07/2021 16:20:16.217 */
GO
CREATE TABLE [dbo].[lkpStrandBuilderColor](
	[StrandBuilderColorID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[StrandBuilderColorSortOrder] [int] NOT NULL,
	[StrandBuilderColorDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[StrandBuilderColorDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpStrandBuilderColor] PRIMARY KEY CLUSTERED
(
	[StrandBuilderColorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
