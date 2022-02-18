/* CreateDate: 11/28/2017 15:41:57.090 , ModifyDate: 11/28/2017 15:41:57.127 */
GO
CREATE TABLE [dbo].[SFDC_HCM_ErrorLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BatchID] [int] NULL,
	[TableName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesforceID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ErrorMessage] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ErrorDate] [datetime] NULL,
 CONSTRAINT [PK_SFDC_HCM_ErrorLog] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SFDC_HCM_ErrorLog_BatchID] ON [dbo].[SFDC_HCM_ErrorLog]
(
	[BatchID] ASC
)
INCLUDE([SalesforceID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
