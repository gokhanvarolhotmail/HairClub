CREATE FUNCTION [dbo].[ISFLASH_SALE_ByDepartmentAndDivision] (
		@center int
		, @code as varchar(25)
		, @department as int
		, @division as int
		, @type as int
		, @membership as varchar(25)
	)

/*
	MODIFICATIONS:
		10/18/2006 - HAbelow - Add new type (19) for POSTEXT$
		11/11/2008 - MBurrell - Add new codes for POSTEL, POSTELX, POSTELPMT
		09/21/2009 - JHannah - Added Drilldowns from ISFLASH_SALE for Upgrades, Downgrades,
				Cancels, Bio Conversions, and Ext Conversions.
*/


	RETURNS bit AS
	BEGIN
	RETURN(

		CASE @type
			/* GROSS NB1 QTY */
			WHEN 1 THEN
				CASE WHEN @membership IN ('POSTEXT', 'POSTEL') THEN
					CASE WHEN @department IN (1005) OR @code IN ('SUR', 'POSTOPEXT') THEN 1 ELSE 0 END
				ELSE
					CASE WHEN @department IN (1005) OR @code IN ('SUR', 'POSTEXT', 'POSTOPEXT', 'POSTEL') THEN 1 ELSE 0 END
				END

			/* NET TRADITIONAL NB1 QTY */
			WHEN 2 THEN
				CASE WHEN @membership IN ('NB1', 'TRADITION')
					AND @department IN (1005) THEN 1 ELSE 0 END
				-
				CASE WHEN @membership IN ('NB1', 'TRADITION')
					AND @department IN (1099) THEN 1 ELSE 0 END


			/* NET TRADITIONAL NB1 $ */
			WHEN 3 THEN
				CASE WHEN @membership IN ('NB1', 'TRADITION', 'POSTEXT', 'POSTEL')
					AND @department IN (2020) THEN 1 ELSE 0 END


			/* NET GRADUAL */
			WHEN 4 THEN
				CASE WHEN @membership IN ('GRADUAL','GRADSERV','ELITENB')
					AND  @department IN (1005) THEN 1 ELSE 0 END
				-
				CASE WHEN @membership IN ('GRADUAL','GRADSERV','ELITENB')
					AND  @department IN (1099) THEN 1 ELSE 0 END


			/* NET GRADUAL $ */
			WHEN 5 THEN
				CASE WHEN @membership IN ('GRADUAL','GRADSERV','ELITENB')
					AND @department IN (2020) THEN 1 ELSE 0 END


			/* NET EXT SALES */
			WHEN 6 THEN
				CASE WHEN @membership IN ('EXT')
					AND @department IN (1005) THEN 1 ELSE 0 END
				-
				CASE WHEN @membership IN ('EXT')
					AND @department IN (1099) THEN 1 ELSE 0 END


			/* NET EXTREME $ */
			WHEN 7 THEN
				CASE WHEN @membership IN ('EXT')
					AND @department IN (2020) THEN 1 ELSE 0 END


			/* NET SURGERY SALES */
			WHEN 8 THEN
				CASE WHEN @code IN ('SUR', 'SURX') THEN 1 ELSE 0 END


			/* NET SURGERY $ */
			WHEN 9 THEN
				CASE WHEN @code IN ('SURPMT', 'DUEFROM', 'CREDIT') THEN 1 ELSE 0 END


			/* NB1 APPS */
			WHEN 10 THEN
				CASE WHEN @department IN (5010) THEN 1 ELSE 0 END


			/* NB1 CONV */
			WHEN 11 THEN
				CASE WHEN @department IN (1075) THEN 1 ELSE 0 END


			/* PCP $ */
			WHEN 12 THEN
				CASE WHEN @department IN (2020, 1010) THEN 1 ELSE 0 END


			/* PCP & Non Program	*/
			WHEN 13 THEN
				CASE WHEN @department IN (2020, 1010)
				THEN 1 ELSE 0 END


			/* SERVICE $ */
			WHEN 14 THEN
				CASE WHEN @division IN (5) THEN 1 ELSE 0 END


			/* RETAIL $ */
			WHEN 15 THEN
				CASE WHEN @division IN (4) THEN 1 ELSE 0 END


			/* PEXT# */
			WHEN 16 THEN
				CASE WHEN @code IN ('POSTEXT', 'POSTOPEXT', 'POSTEXTPKG', 'POSTEXTX', 'POSTEL', 'POSTELX') THEN 1 ELSE 0 END


			/* NB1 NET # */
			WHEN 17 THEN
				CASE WHEN @membership IN ('POSTEXT', 'POSTEL') THEN
					CASE WHEN @department IN (1005) OR @code IN ('SUR', 'POSTOPEXT') THEN 1 ELSE 0 END
					-
					CASE WHEN @department IN (1099, 8) OR @code IN ('SURX', 'POSTEXTX', 'POSTELX') THEN 1 ELSE 0 END
				ELSE
					CASE WHEN @department IN (10) OR @code IN ('SUR', 'POSTEXT', 'POSTOPEXT', 'POSTEL') THEN 1 ELSE 0 END
					-
					CASE WHEN @department IN (1099, 8) OR @code IN ('SURX', 'POSTEXTX', 'POSTELX') THEN 1 ELSE 0 END
				END


			/* NB1 NET $ */
			WHEN 18 THEN
				CASE WHEN @department IN (2020) OR @code IN ('SURPMT', 'DUEFROM', 'CREDIT', 'POSTEXTPMT', 'POSTELPMT') THEN 1 ELSE 0 END


			/* POSTEXT $ */
			WHEN 19 THEN
				CASE WHEN @code IN ('POSTEXTPMT', 'POSTELPMT') THEN 1 ELSE 0 END


			/* HairSales	*/
			WHEN 300 THEN
				CASE WHEN @membership IN ('GRADUAL', 'ELITENB','GRADSERV','NB1','TRADITION')
					AND @department IN (1099, 1005) THEN 1 ELSE 0 END

			/* UPGRADES */
			WHEN 22 THEN
				CASE WHEN @code in('PCPXU', 'NB2XU', 'ACQUIREDXU') THEN 1 ELSE 0 END


			/* DOWNGRADES */
			WHEN 23 THEN
				CASE WHEN @code in('PCPXD') THEN 1 ELSE 0 END


			/* CANCELS */
			WHEN 24 THEN
				CASE WHEN @code in('PCPX', 'TXFROUT', 'TXFR') THEN 1 ELSE 0 END

			/* BIO CONV */
			WHEN 25 THEN
				CASE WHEN @code in('NB1C', 'NB1GC', 'NB1CG', 'EXTC', 'NB1CR')
					AND @membership not in('EXT','POSTEXT') THEN 1 ELSE 0 END

			/* EXT CONV */
			WHEN 26 THEN
				CASE WHEN @code in('NB1C', 'NB1GC', 'NB1CG', 'EXTC', 'NB1CR')
					AND @membership in('EXT','POSTEXT') THEN 1 ELSE 0 END


		END
	)
	END
