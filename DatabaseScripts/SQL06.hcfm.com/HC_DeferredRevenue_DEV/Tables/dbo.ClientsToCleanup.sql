CREATE TABLE [dbo].[ClientsToCleanup](
	[ClientIdentifier] [int] NOT NULL,
	[Deferred] [money] NOT NULL,
	[Revenue] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClientsToCleanup] ADD  CONSTRAINT [DF_ClientsToCleanup_Deferred]  DEFAULT ((0)) FOR [Deferred]
