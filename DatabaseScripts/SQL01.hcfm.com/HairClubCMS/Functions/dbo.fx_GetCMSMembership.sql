/* CreateDate: 12/31/2010 13:21:03.870 , ModifyDate: 05/28/2015 14:55:09.457 */
GO
/***********************************************************************

FUNCTION:   [fx_GetCMSMembership]

DESTINATION SERVER:       HCSQL2/SQL2005

DESTINATION DATABASE: INFOSTORE

RELATED APPLICATION:

AUTHOR: Alex Pasieka

IMPLEMENTOR: Marlon Burrell

DATE IMPLEMENTED:

LAST REVISION DATE: 11/30/2009

--------------------------------------------------------------------------------------------------------
NOTES:
	* 1/31/2011 MVT - Added Case statements for @Member1 (MODEL, EMPLOYEE, EMPLOYEXT, MODELEXT) for
					'STANDARD' @Member2
	* 1/19/2012 KRM - Fixed EXT memberships not to default to EXTMEM but EXT6
	* 3/06/2012 KRM - Added NB1 and NULL to list - made them traditional
	* 8/29/2012 KRM - Added EXTENH9
	* 12/17/2012 KRM - Added GradPCP and GradPCP Solutions
	* 1/24/2015  KRM - Added Extrands for  Barth
	* 05/28/2015 MVT - Added GRDSVSOL for Barth
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:
SELECT [dbo].[fx_GetCMSMembership] ('gradpcp', 'standard')
***********************************************************************/

CREATE FUNCTION [dbo].[fx_GetCMSMembership] (@Member1 VARCHAR(50), @Member2 VARCHAR(50))
      RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @NewMembership VARCHAR(50)

    SET @NewMembership =
		CASE
			WHEN @Member1 IN ('ACQUIRED')	THEN 'ACQUIRED'
			WHEN @Member1 IN ('DESIGNER')	THEN 'DESIGNER'
			WHEN @Member1 IN ('EMERALD')	THEN 'EMERALD'
			WHEN @Member1 IN ('EXTPRO')		THEN 'EXTMEM'
			WHEN @Member1 IN ('HCFK')		THEN 'HCFK'
			WHEN @Member1 IN ('POSTEXT')	THEN CASE WHEN @Member2 IN ('LASER') THEN 'POSTEL' ELSE 'POSTEXT' END
			WHEN @Member1 IN ('RETAIL')		THEN 'RETAIL'
			WHEN @Member1 IN ('GRADPCP')	THEN CASE WHEN @Member2 IN ('SOLUTIONS') THEN 'GRADPCPSOL' ELSE 'GRADPCP' END
			WHEN @Member1 IN ('BASIC')		THEN CASE WHEN @Member2 IN ('SOLUTIONS') THEN 'BASICSOL' ELSE 'BASIC' END
			WHEN @Member1 IN ('BRONZE')		THEN CASE WHEN @Member2 IN ('SOLUTIONS') THEN 'BRZSOL' ELSE 'BRZ' END
			WHEN @Member1 IN ('CANCEL')		THEN 'CANCEL'
			WHEN @Member1 IN ('DIAMOND')	THEN CASE WHEN @Member2 IN ('SOLUTIONS') THEN 'DIASOL' ELSE 'DIA' END
			WHEN @Member1 IN ('ELITE')		THEN CASE WHEN @Member2 IN ('SOLUTIONS') THEN 'ELITESOL' ELSE 'ELITE' END
			WHEN @Member1 IN ('EXECUTIVE')	THEN CASE WHEN @Member2 IN ('SOLUTIONS') THEN 'EXESOL' ELSE 'EXE' END
			WHEN @Member1 IN ('EXTMEM')		THEN CASE WHEN @Member2 IN ('SOLUTIONS') THEN 'EXTMEMSOL' ELSE 'EXTMEM' END
			WHEN @Member1 IN ('GOLD')		THEN CASE WHEN @Member2 IN ('SOLUTIONS') THEN 'GLDSOL' ELSE 'GLD' END
			WHEN @Member1 IN ('PLATINUM')	THEN CASE WHEN @Member2 IN ('SOLUTIONS') THEN 'PLASOL' ELSE 'PLA' END
			WHEN @Member1 IN ('PREMIER')	THEN CASE WHEN @Member2 IN ('SOLUTIONS') THEN 'PRESOL' ELSE 'PRE' END
			WHEN @Member1 IN ('PRESIDENT')	THEN CASE WHEN @Member2 IN ('SOLUTIONS') THEN 'PRSSOL' ELSE 'PRS' END
			WHEN @Member1 IN ('SILVER')		THEN CASE WHEN @Member2 IN ('SOLUTIONS') THEN 'SILSOL' ELSE 'SIL' END
			WHEN @Member1 IN ('NONPGM', 'NON PGM') THEN 'NONPGM'
			--WHEN @Member1 IN ('G6', 'SG6') THEN 'G06'
			--WHEN @Member1 IN ('G12', 'SG12') THEN 'G12'
			--WHEN @Member1 IN ('NB1G') THEN 'GRA'
			WHEN @Member1 IN ('EXT')THEN
				CASE @Member2
					WHEN 'SOLUTIONS' THEN 'EXTMEMSOL'
					WHEN 'ENHANCED 12' THEN 'EXTENH12'
					WHEN 'ENHANCED 6' THEN 'EXTENH6'
					WHEN 'ENHANCED' THEN 'EXTENH12'
					WHEN 'ENHANCED 9' THEN 'EXTENH9'
					WHEN '' THEN 'EXT6'
					WHEN 'STANDARD' THEN 'EXT6'
					WHEN 'STANDARD 12' THEN 'EXT12'
					WHEN 'STANDARD 6' THEN 'EXT6'
					ELSE 'EXT6'
				  END
			WHEN @Member1 IN ('GRADUAL') THEN
				CASE
					WHEN @Member2 IN ('SOLUTIONS 6') THEN 'GRADSOL6'
					WHEN @Member2 IN ('SOLUTIONS 12') THEN 'GRADSOL12'
					WHEN @Member2 IN ('SOLUTIONS') THEN 'GRADSOL12'
					ELSE 'GRAD'
				  END
			WHEN @Member1 IN ('GRADSERV') THEN
				CASE
					  WHEN @Member2 IN ('SOLUTIONS') THEN 'GRDSVSOL'
					  WHEN @Member2 IN ('SOLUTIONS 6') THEN 'GRDSVSOL'
					  WHEN @Member2 IN ('SOLUTIONS 12') THEN 'GRDSVSOL12'
					  WHEN @Member2 IN ('STANDARD 12') THEN 'GRDSV12'
					  ELSE 'GRDSV'
				  END
			WHEN @Member1 IN ('EXTRMEM') THEN
				CASE
					WHEN @Member2 IN ('STANDARD') THEN 'XTRANDMEM'
					WHEN @Member2 IN ('SOLUTIONS') THEN 'XTDMEMSOL'
					ELSE 'XTRANDMEM'
				  END
			WHEN @Member1 IN ('EXTRANDS6') THEN 'XTRAND6'
			WHEN @Member1 IN ('TRADITION','NB1') OR @Member1 IS NULL THEN 'TRADITION'
			WHEN @Member1 IN ('MODEL') THEN CASE WHEN @Member2 IN ('STANDARD') THEN 'MODEL' END
			WHEN @Member1 IN ('EMPLOYEE') THEN CASE WHEN @Member2 IN ('STANDARD') THEN 'EMPLOYEE' END
			WHEN @Member1 IN ('EMPLOYEXT') THEN CASE WHEN @Member2 IN ('STANDARD') THEN 'EMPLOYEXT' END
			WHEN @Member1 IN ('MODELEXT') THEN CASE WHEN @Member2 IN ('STANDARD') THEN 'MODELEXT' END
          END

    RETURN @NewMembership

END
GO
