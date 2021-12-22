/* CreateDate: 04/15/2020 11:09:32.173 , ModifyDate: 04/15/2020 11:09:32.173 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmpBosleyClientReferral](
	[PatientID] [int] NULL,
	[HairClubSiebelID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientIdentifier] [int] NULL,
	[ClientName] [nvarchar](105) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
