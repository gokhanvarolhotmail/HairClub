/* CreateDate: 05/05/2020 17:42:52.040 , ModifyDate: 05/05/2020 17:43:13.887 */
GO
CREATE TABLE [dbo].[datTechnicalProfile](
	[TechnicalProfileID] [int] NOT NULL,
	[TechnicalProfileDate] [datetime] NOT NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[SalesOrderGUID] [uniqueidentifier] NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[Notes] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datTechnicalProfile] PRIMARY KEY CLUSTERED
(
	[TechnicalProfileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
