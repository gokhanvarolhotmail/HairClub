/* CreateDate: 05/20/2016 14:21:16.663 , ModifyDate: 05/20/2016 14:21:16.663 */
GO
CREATE TABLE [dbo].[tmpRecords](
	[Subscriber_Key] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Appointment_Guid] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Appointment_Date] [date] NULL,
	[Appointment_Time] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Client_Email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Client_First] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Client_Gender] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Center] [int] NULL,
	[Address_1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address_2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Center_Time_Zone] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Center_Phone] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee_1_First_Name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee_1_Last_Name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee_1_Position] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee_2_First_Name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee_2_Last_Name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee_2_Position] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Confirmation_Status] [int] NULL,
	[ClientLanguage] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LanguageID] [int] NULL
) ON [PRIMARY]
GO
