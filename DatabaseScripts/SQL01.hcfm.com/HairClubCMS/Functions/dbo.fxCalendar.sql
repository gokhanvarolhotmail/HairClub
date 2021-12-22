CREATE FUNCTION [dbo].[fxCalendar] (@Center VARCHAR(6), @Stylist VARCHAR(6))
RETURNS INT AS
BEGIN
	DECLARE @ScheduledCenter AS VARCHAR(20)

	SELECT @ScheduledCenter=
		CASE WHEN LEFT(@Stylist, 3) IN (
			--MANN
				'329', '365', '328',
			--JONES
				'317','381','361','392','379','380',
			--GAFFNEY
				'311','314','376','377','395', '375','378',
			--HOLZER
				'302','315','370','371','374',
			--DIDOCHA
				'330','335','337','383','363','385','384',
			--MCCLELLAN
				'350','394','396','390','313','349',
			--UNASSIGNED

			--SIMMONS
				'340','382',
			--LEONARD

			--ALLAN
				'691',
			--FROST
				'545', '546', '547', '548',
			--BOTTA
				'310', '368','359','312','304',
			--STOLLER
				'301','367','303','325','316', '326'
		) THEN LEFT(@Stylist,3) ELSE @Center END
	RETURN
	CASE
		--MANN
		WHEN @ScheduledCenter IN('329', '365', '328') THEN 8
		--JONES
		WHEN @ScheduledCenter IN('317','381','361','392','379','380') THEN 1
		--GAFFNEY
		WHEN @ScheduledCenter IN('311','314','376','377','395', '375', '378') THEN 5
		--HOLZER
		WHEN @ScheduledCenter IN('302','315','370','371','374') THEN 2
		--DIDOCHA
		WHEN @ScheduledCenter IN('330','335','337','383','363','385','384') THEN 7
		--MCCLELLAN
		WHEN @ScheduledCenter IN('350','394','396','390','313','349') THEN 9
		--SIMMONS
		WHEN @ScheduledCenter IN('340', '382') THEN 15
		--ALLAN
		WHEN @ScheduledCenter IN('691') THEN 13
		--FRIST
		WHEN @ScheduledCenter IN ('545', '546', '547', '548') THEN 12
		--BOTTA
		WHEN @ScheduledCenter IN('310','368','359','312','304') THEN 17
		--STOLLER
		WHEN @ScheduledCenter IN('301','303','367','325','316','326') THEN 18

		ELSE 0
	END
END
