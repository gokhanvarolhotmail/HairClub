/* CreateDate: 05/03/2010 12:09:05.090 , ModifyDate: 05/03/2010 12:09:05.410 */
GO
CREATE TABLE [bief_dq].[ViolationStatus](
	[ViolationStatusKey] [int] IDENTITY(1,1) NOT NULL,
	[ViolationStatus] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ViolationStatusDescription] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreateTimestamp] [datetime] NOT NULL,
	[UpdateTimestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_ViolationStatus] PRIMARY KEY CLUSTERED
(
	[ViolationStatusKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
