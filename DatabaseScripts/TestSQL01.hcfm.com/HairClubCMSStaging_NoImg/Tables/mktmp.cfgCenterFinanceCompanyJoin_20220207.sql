/* CreateDate: 02/07/2022 15:50:30.363 , ModifyDate: 02/07/2022 15:50:30.363 */
GO
CREATE TABLE [mktmp].[cfgCenterFinanceCompanyJoin_20220207](
	[CenterFinanceCompanyJoinID] [int] IDENTITY(1,1) NOT NULL,
	[CenterID] [int] NOT NULL,
	[FinanceCompanyID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
