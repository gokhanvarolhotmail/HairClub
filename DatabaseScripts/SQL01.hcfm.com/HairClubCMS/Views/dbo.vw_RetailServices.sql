CREATE VIEW [dbo].[vw_RetailServices]
AS

WITH [Init] AS (SELECT q.ClientIdentifier
				,	q.InitialAssignmentDate
				FROM (SELECT CLT.CenterID
						,	CLT.FirstName
						,	CLT.LastName
						,	CLT.ClientIdentifier
						,	SC.SalesCodeDescriptionShort
						,	SC.SalesCodeDescription
						,	SO.OrderDate  AS 'InitialAssignmentDate'
						,	ROW_NUMBER() OVER (PARTITION BY CLT.ClientIdentifier ORDER BY SO.OrderDate DESC) AS 'Ranking'
						FROM dbo.datSalesOrderDetail SOD
						INNER JOIN dbo.datSalesOrder SO
							ON SO.SalesOrderGUID = SOD.SalesOrderGUID
							INNER JOIN datClient CLT
								ON SO.ClientGUID = CLT.ClientGUID
							INNER JOIN dbo.cfgSalesCode SC
								ON SC.SalesCodeID = SOD.SalesCodeID
						WHERE SOD.SalesCodeID IN(SELECT SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'INITASG')
						AND LTRIM(RTRIM(CLT.ClientIdentifier)) IN(557466,
						608687,
						607185,
						607630,
						537405,
						574596,
						544999,
						585272,
						584434,
						608359,
						608199,
						604218,
						608167,
						34032,
						608309)

						)q
				WHERE q.Ranking = 1
				)


SELECT SO.CenterID
,	CLT.FirstName
,	CLT.LastName
,	LTRIM(RTRIM(CLT.ClientIdentifier)) AS 'ClientIdentifier'
,	SO.InvoiceNumber
,	SO.OrderDate
,	SO.IsRefundedFlag
,	SO.IsWrittenOffFlag
,	InitialAssignmentDate

FROM dbo.datSalesOrder SO
	INNER JOIN datClient CLT
		ON SO.ClientGUID = CLT.ClientGUID
	LEFT OUTER JOIN [Init]
		ON [Init].ClientIdentifier = CLT.ClientIdentifier
WHERE InvoiceNumber IN('250-180407-7840',
'209-180330-5253',
'209-180404-5660',
'250-180407-7965',
'250-180406-7813',
'250-180407-7870',
'250-180407-7848',
'250-180407-7915',
'250-180407-7847',
'209-180405-5747',
'287-180405-4014',
'211-180404-2552',
'240-180407-6664',
'274-180411-1374',
'287-180407-4076',
'209-180406-5792',
'288-180407-2045')
