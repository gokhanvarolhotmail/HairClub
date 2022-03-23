/* CreateDate: 10/24/2013 09:54:51.523 , ModifyDate: 06/18/2014 01:38:23.807 */
GO
CREATE TABLE [dbo].[Contest](
	[ContestSSID] [int] IDENTITY(1,1) NOT NULL,
	[ContestName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ContestDescription] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
 CONSTRAINT [PK_Contest] PRIMARY KEY CLUSTERED
(
	[ContestSSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
