/* CreateDate: 09/30/2013 10:49:29.890 , ModifyDate: 09/10/2019 22:44:10.840 */
/* ***HasTriggers*** TriggerCount: 1 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_wireless_scrub_history_detail](
	[wireless_scrub_history_detail_id] [int] IDENTITY(1,1) NOT NULL,
	[wireless_scrub_history_id] [int] NOT NULL,
	[full_phone_number] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[dnc_code] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_cstd_wireless_scrub_history_detail] PRIMARY KEY CLUSTERED
(
	[wireless_scrub_history_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_wireless_scrub_history_detail]  WITH CHECK ADD  CONSTRAINT [FK_cstd_wireless_scrub_history_detail_cstd_wireless_scrub_history] FOREIGN KEY([wireless_scrub_history_id])
REFERENCES [dbo].[cstd_wireless_scrub_history] ([wireless_scrub_history_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cstd_wireless_scrub_history_detail] CHECK CONSTRAINT [FK_cstd_wireless_scrub_history_detail_cstd_wireless_scrub_history]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[cstd_wireless_scrub_history_detail_insert]
   ON  [dbo].[cstd_wireless_scrub_history_detail]
   AFTER INSERT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @FullPhoneNumber		NCHAR(10)
	DECLARE @DNCCode				NVARCHAR(3)
	DECLARE @IsWireless				NCHAR(1)
	DECLARE @AreaCode				NCHAR(3)
	DECLARE @PhoneNumber			NCHAR(7)

    DECLARE insertCursor CURSOR
	FOR
		SELECT full_phone_number, inserted.dnc_code, csta_dnc.is_wireless
		FROM inserted
		LEFT OUTER JOIN csta_dnc ON
			inserted.dnc_code = csta_dnc.dnc_code
		INNER JOIN cstd_wireless_scrub_history ON
			inserted.wireless_scrub_history_id = cstd_wireless_scrub_history.wireless_scrub_history_id
		WHERE
		inserted.dnc_code IS NOT NULL AND
		cstd_wireless_scrub_history.scrub_type = 'IMPORT'

	OPEN insertCursor

	FETCH NEXT FROM insertCursor
	INTO @FullPhoneNumber, @DNCCode, @IsWireless

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @FullPhoneNumber = @FullPhoneNumber + '          '
		SET @AreaCode = SUBSTRING(@FullPhoneNumber, 1, 3)
		SET @PhoneNumber = SUBSTRING(@FullPhoneNumber, 4, 7)

		IF (@IsWireless = 'Y')
		BEGIN
			UPDATE oncd_contact_phone
			SET
				phone_type_code = 'CELL',
				cst_dnc_code = @DNCCode,
				cst_last_dnc_date = GETDATE()
			WHERE
				area_code = @AreaCode AND
				phone_number = @PhoneNumber
		END
		ELSE
		BEGIN
			UPDATE oncd_contact_phone
			SET
				cst_dnc_code = @DNCCode,
				cst_last_dnc_date = GETDATE()
			WHERE
				area_code = @AreaCode AND
				phone_number = @PhoneNumber
		END

		FETCH NEXT FROM insertCursor
		INTO @FullPhoneNumber, @DNCCode, @IsWireless
	END

	CLOSE insertCursor
	DEALLOCATE insertCursor
END
GO
ALTER TABLE [dbo].[cstd_wireless_scrub_history_detail] ENABLE TRIGGER [cstd_wireless_scrub_history_detail_insert]
GO
