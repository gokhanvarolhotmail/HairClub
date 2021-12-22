/* CreateDate: 06/04/2013 18:01:41.543 , ModifyDate: 06/04/2013 18:01:41.543 */
GO
CREATE TABLE [dbo].[TempFeeDeclined](
	[ttid] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[msoft_code] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phard_code] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[type] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[proc] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[entrymode] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tranflags] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[card] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[abaroute] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[account] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[expdate] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[checknum] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[timestamp] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[code] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[verbiage] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[amount] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batch] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cardholdername] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[avs] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cv] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[clerkid] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[stationid] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[comments] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[divisionnum] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[promoid] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[descmerch] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ptrannum] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ordernum] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[custref] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
