/* CreateDate: 11/12/2019 09:41:20.377 , ModifyDate: 04/30/2020 11:15:43.067 */
GO
CREATE TABLE [dbo].[dbTicket](
	[Ticket ID] [int] NOT NULL,
	[Open Date & Time] [datetime] NOT NULL,
	[Due Date & Time] [datetime] NULL,
	[Requestor] [nvarchar](101) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Location] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Department] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Assigned To Technician] [nvarchar](61) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Group] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Ticket Summary] [nvarchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Additional Information] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Category] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Category Full Path] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Priority] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Close Date & Time] [datetime] NULL,
	[Status] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Note] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsClosedBeforeDueDate] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
