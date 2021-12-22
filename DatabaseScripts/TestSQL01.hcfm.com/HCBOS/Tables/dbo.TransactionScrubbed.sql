/* CreateDate: 08/10/2006 13:45:48.660 , ModifyDate: 05/08/2010 02:30:11.683 */
GO
CREATE TABLE [dbo].[TransactionScrubbed](
	[Phone] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastSaleDate] [datetime] NULL,
	[ListFlag] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExpirationDate] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Timestamp] [datetime] NULL,
 CONSTRAINT [PK_TransactionScrubbed] PRIMARY KEY CLUSTERED
(
	[Phone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TransactionScrubbed] ADD  CONSTRAINT [DF_TransactionScrubbed_Timestamp]  DEFAULT (getdate()) FOR [Timestamp]
GO
