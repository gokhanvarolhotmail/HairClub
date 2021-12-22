/* CreateDate: 12/16/2014 20:44:41.000 , ModifyDate: 12/16/2014 20:44:41.210 */
GO
CREATE TABLE [dbo].[ET_DataExtensionSnapshot](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SnapshotTime] [smalldatetime] NOT NULL,
	[Appointment_Guid] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Appointment_Date] [datetime] NULL,
	[Appointment_Time] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Client_Email] [nvarchar](254) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Center_Time_Zone] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee_1_First_Name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee_1_Last_Name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee_1_Position] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee_2_First_Name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee_2_Last_Name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee_2_Position] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Confirmation_Status] [datetime] NULL,
	[Subscriber_Key] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SubscriberID] [int] NULL,
	[DateUndeliverable] [datetime] NULL,
	[DateJoined] [datetime] NULL,
	[DateUnsubscribed] [datetime] NULL,
	[BounceCount] [int] NULL,
	[Center_Phone] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Client_Gender] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Client_First] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Center] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address_1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address_2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_ET_DataExtensionSnapshot] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
