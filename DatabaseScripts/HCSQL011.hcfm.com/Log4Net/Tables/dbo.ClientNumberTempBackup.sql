/* CreateDate: 02/25/2015 16:46:50.843 , ModifyDate: 02/25/2015 16:46:50.843 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientNumberTempBackup](
	[ClientNumberTempBackupID] [int] IDENTITY(1,1) NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[ClientIdentifier] [int] NOT NULL,
	[CenterID] [int] NOT NULL,
	[ClientNumber_Temp] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_ClientNumberTempBackup] PRIMARY KEY CLUSTERED
(
	[ClientNumberTempBackupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
