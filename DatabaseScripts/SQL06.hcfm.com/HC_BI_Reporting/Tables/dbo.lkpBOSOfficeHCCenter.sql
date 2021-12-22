/* CreateDate: 10/20/2015 15:19:00.370 , ModifyDate: 10/20/2015 15:19:00.370 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpBOSOfficeHCCenter](
	[BOSOfficeHCCenterID] [int] IDENTITY(1,1) NOT NULL,
	[BOSOffice] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterSSID] [int] NULL,
	[CenterDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterDescriptionNumber] [nvarchar](103) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
