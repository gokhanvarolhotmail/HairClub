/* CreateDate: 07/03/2012 09:29:51.057 , ModifyDate: 02/27/2017 09:49:31.833 */
GO
/***********************************************************************
PROCEDURE:				[selEFTProcessCenterACHExportText]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				HDu
IMPLEMENTOR: 			HDu
DATE IMPLEMENTED: 		02/02/2012
LAST REVISION DATE: 	02/02/2012
--------------------------------------------------------------------------------------------------------
NOTES: 	This is not integrated into CMS, it returns string data for manual creation of MICROCASH files
		for centers that already have run successfully
		07/02/2012 - HDu Created Stored Proc

		02/03/2014 - MTovbin Modified to return cONEct Client Identifier instead of CMS 2.5 id
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
SELECT * FROM [datCenterFeeBatch] cfb WHERE FeePayCycleID IN (1,2)
AND CenterID IN (232,281,289) ORDER BY FeeYear DESC, FeeMonth DESC, FeePayCycleID

EXEC [selEFTProcessCenterACHExportText] '968C1885-F1EA-45B1-AD41-D9A668127B31'
EXEC [selEFTProcessCenterACHExportText] '71696E47-0254-415B-8E53-9C4B23906CF8'
EXEC [selEFTProcessCenterACHExportText] '0D19738E-7104-4F87-9F87-ECB0AE09EAF3'
***********************************************************************/
CREATE PROCEDURE [dbo].[selEFTProcessCenterACHExportText]
 @CenterFeeBatchGUID UNIQUEIDENTIFIER

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ACHPayCycleTransactionTypeDescriptionShort nvarchar(10) = 'ACH'

/*
    sb.Append(l + x.LastName + s)
            sb.Append(x.FirstName + l + s)
            sb.Append(l + x.ClientIdentifier.ToString + l + s)
            sb.Append(l + x.BankRoutingNumber + l + s)
            sb.Append(l + x.BankAccountNumber + l + s)
            sb.Append(l + x.trancode.ToString + l + s)
            sb.Append(l + Format(x.ChargeAmount, "0.00") + l)
            sb.AppendLine()
*/

DECLARE @FeeDate AS DATETIME, @FileName AS VARCHAR(200) = ''

SELECT TOP 1
@FeeDate = CONVERT(VARCHAR,CONVERT(DATETIME,CAST(cfb.FeeYear AS VARCHAR) + '-' + CAST(cfb.FeeMonth AS VARCHAR) + '-' + CAST(pc.FeePayCycleValue AS VARCHAR),120),120)
,@FileName = CAST(cfb.CenterID AS VARCHAR) + '_' +
			DATENAME(MONTH, @FeeDate) +
			'_MICROCASH_' +
			CASE WHEN DATEPART(MONTH, @FeeDate)<10 THEN '0'ELSE ''END + CAST(DATEPART(MONTH, @FeeDate) AS VARCHAR) +
			CASE WHEN DATEPART(DAY, @FeeDate)<10 THEN '0'ELSE ''END + CAST(DATENAME(DAY, @FeeDate) AS VARCHAR) +
			CAST(DATENAME(YEAR, @FeeDate) AS VARCHAR)
FROM [datCenterFeeBatch] cfb
INNER JOIN lkpFeePayCycle pc ON cfb.FeePayCycleID = pc.FeePayCycleID
WHERE cfb.CenterFeeBatchGUID = @CenterFeeBatchGUID

	SELECT
		'"' + c.LastName + ', ' + c.FirstName + '","' +
		CAST(c.ClientIdentifier AS VARCHAR) + '","' +
		RTRIM(LTRIM(ceft.[BankRoutingNumber])) + '","' +
		RTRIM(LTRIM(ceft.[BankAccountNumber])) + '","' +
		CASE WHEN at.[EFTAccountTypeDescriptionShort] = 'Checking' THEN '27'
			WHEN at.[EFTAccountTypeDescriptionShort] = 'Savings' THEN '37'
		END + '","' +
		CAST(pct.ChargeAmount AS VARCHAR) + '"' AS DATA
		,@FileName AS [FILENAME]

	FROM datPayCycleTransaction pct
		INNER JOIN datClient c ON c.ClientGUID = pct.ClientGUID
		INNER JOIN datClientEFT ceft ON c.ClientGUID = ceft.ClientGUID
		--LEFT JOIN [HCSQL2\SQL2005].[EFT].[dbo].[hcmtbl_EFT] f ON f.Center = c.CenterID AND f.client_no = c.ClientNumber_Temp
		INNER JOIN lkpPayCycleTransactionType ptype ON ptype.PayCycleTransactionTypeID = pct.PayCycleTransactionTypeID
		INNER JOIN lkpFeePayCycle pc ON pc.FeePayCycleID = ceft.FeePayCycleID
		INNER JOIN lkpEFTAccountType at ON at.EFTAccountTypeID = ceft.EFTAccountTypeID
		INNER JOIN [datCenterFeeBatch] cfb ON cfb.CenterFeeBatchGUID = pct.CenterFeeBatchGUID
	WHERE pct.CenterFeeBatchGUID = @CenterFeeBatchGUID
			AND pct.CenterDeclineBatchGUID IS NULL -- exclude declines
			AND pct.IsSuccessfulFlag = 1
			AND ptype.PayCycleTransactionTypeDescriptionShort = @ACHPayCycleTransactionTypeDescriptionShort
			AND pct.ChargeAmount > 0
	ORDER BY c.LastName

END
GO
