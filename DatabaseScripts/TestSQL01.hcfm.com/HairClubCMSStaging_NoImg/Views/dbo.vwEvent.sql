/* CreateDate: 02/25/2009 12:08:21.830 , ModifyDate: 10/11/2012 10:31:19.183 */
GO
CREATE VIEW [dbo].[vwEvent]
AS
SELECT dr.ExternalSchedulerResourceID AS ResourceID,
	ISNULL(c.LastName, '') + ', ' + ISNULL(c.FirstName, '')
			+ '<BR>' + 'FROM:' + CAST(c.CenterID AS varchar) + '<BR>' + 'TO:' + CAST(a.CenterID AS varchar)
			+ '<BR>' + REPLACE('GRF:' + LTRIM(CAST(ISNULL(cma.TotalAccumQuantity, 0) AS varchar)), 'GRF:0', 'GRF:0000')
			+ '<BR>' + REPLACE(dbo.APPT_DETAILS(a.CenterID, a.AppointmentGUID), 'SURPOST', 'SURAPPT') AS Description,
	'CLEAR THIS' AS Notes,
	a.StartDateTimeCalc AS SchFrom, a.EndDateTimeCalc AS SchTo, 1 AS LoginID, a.AppointmentDate AS Created, 'kmurdoch@hcfm.com' AS Email,
	CASE				--	1		3		4		16		7		8		9		10		11		12		13		14		15
		WHEN a.CenterID IN (313,			305,	311,	361,	332,	301,	330,	691,	307,	364,	545,	328) THEN 'darkgreen'
		WHEN a.CenterID IN (349,	370,	306,	314,	379,	333,	303,	335,			308,	386,			329) THEN 'indigo'
		WHEN a.CenterID IN (350,	371,	310,	375,	380,	340,	304,	337,			309,	387,			365) THEN 'navy'
		WHEN a.CenterID IN (390,	374,	312,	376,	381,	355,	316,	358,			382						   ) THEN 'royalblue'
		WHEN a.CenterID IN (394,	378,	320,	395,	388,	360,	325,	363										   ) THEN 'deepskyblue'
		WHEN a.CenterID IN (396,			359, 	315,	391,			326,	383,							546		   ) THEN 'darkred'
		WHEN a.CenterID IN (				368,			392,			367,	384,							547		   ) THEN 'brown'
		WHEN a.CenterID IN (																385,					548		   ) THEN 'darkolivegreen'
		ELSE 'grey' END AS Color,
	'|||||||||' AS Misc, 0 AS RepeatID, 0 AS EmailSent, 60 AS Remind, 0 AS AllDay
FROM datAppointment AS a
	INNER JOIN datClient AS c ON a.ClientGUID = c.ClientGUID
	INNER JOIN datClientMembership AS cm ON a.ClientMembershipGUID = cm.ClientMembershipGUID
	INNER JOIN cfgCenter AS ctr ON a.CenterID = ctr.CenterID
	INNER JOIN datAppointmentEmployee AS ae ON a.AppointmentGUID = ae.AppointmentGUID
	INNER JOIN datEmployee AS e ON ae.EmployeeGUID = e.EmployeeGUID
	INNER JOIN cfgEmployeePositionJoin AS epj ON e.EmployeeGUID = epj.EmployeeGUID
	INNER JOIN lkpEmployeePosition AS ep ON epj.EmployeePositionID = ep.EmployeePositionID
	LEFT JOIN lkpDoctorRegion AS dr ON ctr.DoctorRegionID = dr.DoctorRegionID
	LEFT JOIN datClientMembershipAccum AS cma ON cm.ClientMembershipGUID = cma.ClientMembershipGUID AND cma.AccumulatorID = 12
WHERE (NOT (ctr.SurgeryHubCenterID IS NULL))
	AND (ep.EmployeePositionDescriptionShort = 'Doctor')
	AND (a.IsNonAppointmentFlag IS NULL OR a.IsNonAppointmentFlag = 0)
	AND (a.IsDeletedFlag IS NULL OR a.IsDeletedFlag <> 1)
GO
