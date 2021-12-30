/* CreateDate: 05/06/2014 09:10:03.770 , ModifyDate: 05/26/2020 10:49:24.337 */
GO
CREATE TABLE [dbo].[lkpHelpText](
	[HelpTextID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HelpTextSortOrder] [int] NOT NULL,
	[HelpTextDescription] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HelpTextDescriptionShort] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpHelpText] PRIMARY KEY CLUSTERED
(
	[HelpTextID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
