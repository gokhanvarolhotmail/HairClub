/* CreateDate: 03/12/2019 09:24:30.090 , ModifyDate: 03/12/2019 09:24:30.090 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ObjectList](
	[ItemID] [uniqueidentifier] NOT NULL,
	[Path] [nvarchar](425) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Name] [nvarchar](425) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Type] [int] NOT NULL,
	[TypeDesc] [nvarchar](37) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Description] [nvarchar](512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Hidden] [bit] NULL,
	[CreationDate] [datetime] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
	[ParentID] [uniqueidentifier] NULL,
	[Parent Path] [nvarchar](425) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Parent Name] [nvarchar](425) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Parent Type] [int] NULL,
	[Parent TypeDesc] [nvarchar](37) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Parent Description] [nvarchar](512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Parent Hidden] [bit] NULL,
	[Parent CreationDate] [datetime] NULL,
	[Parent ModifiedDate] [datetime] NULL,
	[Parent ParentID] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
