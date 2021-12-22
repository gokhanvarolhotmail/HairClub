/* CreateDate: 08/17/2015 09:58:06.820 , ModifyDate: 03/01/2016 15:11:25.233 */
GO
CREATE TABLE [dbo].[ClientsToCleanup](
	[ClientIdentifier] [int] NOT NULL,
	[Deferred] [money] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClientsToCleanup] ADD  CONSTRAINT [DF_ClientsToCleanup_Deferred]  DEFAULT ((0)) FOR [Deferred]
GO
