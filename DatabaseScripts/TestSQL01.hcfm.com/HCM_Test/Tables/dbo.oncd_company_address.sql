/* CreateDate: 01/18/2005 09:34:08.453 , ModifyDate: 10/23/2017 12:35:40.110 */
/* ***HasTriggers*** TriggerCount: 1 */
GO
CREATE TABLE [dbo].[oncd_company_address](
	[company_address_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[address_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_1] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_2] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_3] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_4] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_1_soundex] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_2_soundex] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[city] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[city_soundex] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[state_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip_code] [nchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[county_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[country_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[time_zone_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_company_address] PRIMARY KEY CLUSTERED
(
	[company_address_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_address_i2] ON [dbo].[oncd_company_address]
(
	[company_id] ASC,
	[sort_order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_address_i3] ON [dbo].[oncd_company_address]
(
	[address_line_1] ASC,
	[city] ASC,
	[zip_code] ASC,
	[state_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_address_i4] ON [dbo].[oncd_company_address]
(
	[city] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_address_i5] ON [dbo].[oncd_company_address]
(
	[state_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_address_i6] ON [dbo].[oncd_company_address]
(
	[zip_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_address_i7] ON [dbo].[oncd_company_address]
(
	[address_line_1_soundex] ASC,
	[address_line_2_soundex] ASC,
	[city_soundex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_address_i8] ON [dbo].[oncd_company_address]
(
	[city_soundex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_company_address]  WITH NOCHECK ADD  CONSTRAINT [address_type_company_addr_510] FOREIGN KEY([address_type_code])
REFERENCES [dbo].[onca_address_type] ([address_type_code])
GO
ALTER TABLE [dbo].[oncd_company_address] CHECK CONSTRAINT [address_type_company_addr_510]
GO
ALTER TABLE [dbo].[oncd_company_address]  WITH NOCHECK ADD  CONSTRAINT [company_company_addr_94] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_company_address] CHECK CONSTRAINT [company_company_addr_94]
GO
ALTER TABLE [dbo].[oncd_company_address]  WITH NOCHECK ADD  CONSTRAINT [country_company_addr_513] FOREIGN KEY([country_code])
REFERENCES [dbo].[onca_country] ([country_code])
GO
ALTER TABLE [dbo].[oncd_company_address] CHECK CONSTRAINT [country_company_addr_513]
GO
ALTER TABLE [dbo].[oncd_company_address]  WITH NOCHECK ADD  CONSTRAINT [county_company_addr_512] FOREIGN KEY([county_code])
REFERENCES [dbo].[onca_county] ([county_code])
GO
ALTER TABLE [dbo].[oncd_company_address] CHECK CONSTRAINT [county_company_addr_512]
GO
ALTER TABLE [dbo].[oncd_company_address]  WITH NOCHECK ADD  CONSTRAINT [state_company_addr_511] FOREIGN KEY([state_code])
REFERENCES [dbo].[onca_state] ([state_code])
GO
ALTER TABLE [dbo].[oncd_company_address] CHECK CONSTRAINT [state_company_addr_511]
GO
ALTER TABLE [dbo].[oncd_company_address]  WITH NOCHECK ADD  CONSTRAINT [time_zone_company_addr_514] FOREIGN KEY([time_zone_code])
REFERENCES [dbo].[onca_time_zone] ([time_zone_code])
GO
ALTER TABLE [dbo].[oncd_company_address] CHECK CONSTRAINT [time_zone_company_addr_514]
GO
ALTER TABLE [dbo].[oncd_company_address]  WITH NOCHECK ADD  CONSTRAINT [user_company_addr_515] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_address] CHECK CONSTRAINT [user_company_addr_515]
GO
ALTER TABLE [dbo].[oncd_company_address]  WITH NOCHECK ADD  CONSTRAINT [user_company_addr_516] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_address] CHECK CONSTRAINT [user_company_addr_516]
GO
-- =============================================
-- Author:		Workwise LLC - MJW
-- Create date: 2016-10-19
-- Description:	Update time zone on activity record based on Company address
-- =============================================
CREATE TRIGGER [dbo].[pso_UpdateActivityTimeZone_Company]
   ON  [dbo].[oncd_company_address]
   AFTER INSERT,UPDATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @company_id nchar(10)
	DECLARE @time_zone_code nchar(10)

	--Find all companies for entries that have new/modified ZIP, primary_flag or sort_order
	DECLARE chg CURSOR FOR
	SELECT DISTINCT i.company_id
	FROM inserted i
	LEFT OUTER JOIN deleted d ON d.company_address_id = i.company_address_id
	WHERE
		(d.zip_code IS NULL OR i.zip_code <> d.zip_code) OR
		(d.primary_flag IS NULL OR i.primary_flag <> d.primary_flag) OR
		(d.sort_order IS NULL OR i.sort_order <> d.sort_order)

	OPEN chg
	FETCH chg INTO @company_id
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @time_zone_code = NULL
		SELECT TOP 1 @time_zone_code = co.time_zone_code
			FROM oncd_company_address ca
			INNER JOIN onca_zip z ON z.zip_code = ca.zip_code AND z.county_code IS NOT NULL
			INNER JOIN onca_county co ON co.county_code = z.county_code
		WHERE ca.company_id = @company_id
		ORDER BY ca.primary_flag DESC, ca.sort_order

		IF @time_zone_code IS NOT NULL
			UPDATE a SET cst_time_zone_code = @time_zone_code
			FROM oncd_activity a
			INNER JOIN oncd_activity_company ac ON ac.activity_id = a.activity_id
			WHERE ac.company_id = @company_id
			AND a.action_code IN ('APPOINT', 'BEBACK', 'INHOUSE')
			AND result_code IS NULL
			AND cst_time_zone_code <> @time_zone_code
		ELSE
			UPDATE a SET cst_time_zone_code = 'UNK'
			FROM oncd_activity a
			INNER JOIN oncd_activity_company ac ON ac.activity_id = a.activity_id
			WHERE ac.company_id = @company_id
			AND a.action_code IN ('APPOINT', 'BEBACK', 'INHOUSE')
			AND result_code IS NULL
			AND cst_time_zone_code <> 'UNK'

		FETCH chg INTO @company_id
	END

	CLOSE chg
	DEALLOCATE chg
END
GO
ALTER TABLE [dbo].[oncd_company_address] ENABLE TRIGGER [pso_UpdateActivityTimeZone_Company]
GO
