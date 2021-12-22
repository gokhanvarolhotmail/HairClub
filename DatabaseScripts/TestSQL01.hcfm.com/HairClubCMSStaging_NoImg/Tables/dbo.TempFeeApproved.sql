/* CreateDate: 06/04/2013 18:00:56.413 , ModifyDate: 06/04/2013 18:00:56.413 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TempFeeApproved](
	[ttid] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[msoft_code] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phard_code] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[type] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[proc] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[entrymode] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tranflags] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[reversible] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[card] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[pclevel] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cardlevel] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[abaroute] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[account] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[expdate] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[checknum] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[timestamp] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[amount] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[examount] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tax] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cashback] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[authnum] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[stan] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batnum] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[item] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
	[custref] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[discountamount] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[freightamount] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[dutyamount] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[shipzip] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[shipcountry] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[l3num] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
