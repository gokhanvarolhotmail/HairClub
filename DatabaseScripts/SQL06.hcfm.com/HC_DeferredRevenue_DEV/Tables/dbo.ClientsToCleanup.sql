/* CreateDate: 08/17/2015 09:58:06.820 , ModifyDate: 02/28/2020 12:25:45.927 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientsToCleanup](
	[ClientIdentifier] [int] NOT NULL,
	[Deferred] [money] NOT NULL,
	[Revenue] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClientsToCleanup] ADD  CONSTRAINT [DF_ClientsToCleanup_Deferred]  DEFAULT ((0)) FOR [Deferred]
GO
