/* CreateDate: 01/08/2015 13:34:34.127 , ModifyDate: 01/08/2015 13:34:34.127 */
GO
CREATE TABLE [dbo].[DataLoad](
	[Center] [int] NULL,
	[Year] [int] NULL,
	[Period] [int] NULL,
	[Date] [smalldatetime] NULL,
	[Account] [int] NULL,
	[Value] [real] NULL,
	[ValueType] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Submit] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
