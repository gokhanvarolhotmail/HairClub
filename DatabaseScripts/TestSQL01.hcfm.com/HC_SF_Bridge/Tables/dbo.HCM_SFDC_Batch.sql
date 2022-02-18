/* CreateDate: 11/28/2017 17:07:38.200 , ModifyDate: 11/28/2017 17:07:38.200 */
GO
CREATE TABLE [dbo].[HCM_SFDC_Batch](
	[BatchID] [int] IDENTITY(1,1) NOT NULL,
	[BatchStartDate] [datetime] NULL,
	[BatchEndDate] [datetime] NULL,
	[IsCompletedFlag] [bit] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_HCM_SFDC_Batch] PRIMARY KEY CLUSTERED
(
	[BatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
