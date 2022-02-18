/* CreateDate: 02/18/2013 07:00:53.980 , ModifyDate: 01/31/2022 08:32:31.803 */
GO
CREATE TABLE [dbo].[lkpCenterBusinessType](
	[CenterBusinessTypeID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterBusinessTypeSortOrder] [int] NOT NULL,
	[CenterBusinessTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterBusinessTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpCenterBusinessType] PRIMARY KEY CLUSTERED
(
	[CenterBusinessTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
