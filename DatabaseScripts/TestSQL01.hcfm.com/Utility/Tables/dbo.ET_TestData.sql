/* CreateDate: 12/02/2014 12:08:13.377 , ModifyDate: 12/02/2014 12:08:14.013 */
GO
CREATE TABLE [dbo].[ET_TestData](
	[Batch] [datetime] NOT NULL,
	[Appointment_GUID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Appointment_Date] [datetime] NULL,
	[Appointment_Time] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Confirmation_Status] [datetime] NULL,
	[Subscriber_Key] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SubscriberID] [int] NULL,
	[DateUndeliverable] [datetime] NULL,
	[DateUnsubscribed] [datetime] NULL,
	[BounceCount] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ET_TestData] ADD  CONSTRAINT [DF_ET_TestData_Batch]  DEFAULT ((0)) FOR [Batch]
GO
