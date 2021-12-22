CREATE TABLE [dbo].[ClientsToCleanup](
	[ClientIdentifier] [int] NOT NULL,
	[Deferred] [money] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClientsToCleanup] ADD  CONSTRAINT [DF_ClientsToCleanup_Deferred]  DEFAULT ((0)) FOR [Deferred]
