/* CreateDate: 02/01/2013 10:02:56.923 , ModifyDate: 06/18/2014 01:39:27.860 */
GO
CREATE TABLE [dbo].[lkpCommissionBatchStatus](
	[BatchStatusID] [int] NOT NULL,
	[BatchStatusDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpCommissionBatchStatus] PRIMARY KEY CLUSTERED
(
	[BatchStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
