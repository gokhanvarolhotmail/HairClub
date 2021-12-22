/* CreateDate: 08/05/2014 08:14:37.683 , ModifyDate: 12/07/2021 16:20:16.077 */
GO
CREATE TABLE [dbo].[lkpHairLossSeverity](
	[HairLossSeverityID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairLossSeveritySortOrder] [int] NOT NULL,
	[HairLossSeverityDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairLossSeverityDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairLossSeverityDescriptionLong] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[MinValue] [decimal](18, 0) NOT NULL,
	[MaxValue] [decimal](18, 0) NOT NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DescriptionLongResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpHairLossSeverity] PRIMARY KEY CLUSTERED
(
	[HairLossSeverityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
