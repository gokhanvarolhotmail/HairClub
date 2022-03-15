/****** Object:  View [dbo].[VWFactSalesRevenue]    Script Date: 3/15/2022 2:11:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWFactSalesRevenue] AS with FactSalesRevenue_cte as
                (
                    select case when concat(de.FirstName,' ',de.LastName) =' ' then   concat(deo.FirstName,' ',deo.LastName) else concat(de.FirstName,' ',de.LastName) end              as PerformerName,
                           isnull(convert(varchar(250), ae.EmployeeGUID),convert(varchar(250), sod.Employee1GUID)) as PerformerID,
                           --c.Region1,
                           --c.Region2,
                           a.SalesforceTaskID                     as appointmentID,
                           c.CenterNumber                         as PerformerHomeCenter,
                           su.CenterId                            as PerformerHomeCenterID,
                           c.CenterKey                            as PerformerHomeCenterKey,
                           so.SalesOrderGUID,
                           so.OrderDate,
                           d.DateKey as OrderDateKey,
                           a.AppointmentDate,
                           sc.SalesCodeID,
                          -- m.MembershipID,
                          -- m.MembershipDescription,
                           --m.MembershipDescriptionShort,
                           --m.BusinessSegmentID,
                           sc.SalesCodeDescriptionShort,
                           sc.SalesCodeDescription,
                          -- m.RevenueGroupID,
                           sc.SalesCodeDepartmentID,


                           CASE
                               WHEN (
                                            (sc.SalesCodeDepartmentID IN (2020) AND m.RevenueGroupID = 1)
                                            AND m.BusinessSegmentID = 1 --BusSeg (BIO)
                                            AND
                                            m.MembershipDescriptionShort IN
                                            ('TRADITION', 'NALACARTE', 'NFOLLIGRFT', 'HWBRIO')
                                        )
                                   OR
                                    (
                                                sc.salescodedescriptionshort IN
                                                ('NB1REVWO', 'EXTREVWO', 'SURCREDITPCP', 'SURCREDITNB1')
                                            AND m.MembershipDescriptionShort NOT IN
                                                ('EXT6', 'EXT12', 'EXT18', 'EXTENH6', 'EXTENH12', 'EXTENH9',
                                                 'EXTMEM', 'EXTMEMSOL', 'EXTINITIAL', 'EXTPREMMEN', 'EXTPREMWOM',
                                                 'GRAD',
                                                 'GRDSVEZ', 'GRAD12', 'GRDSVEZ', 'GRADSOL12', 'GRADSOL6', 'GRADSOL12',
                                                 'GRDSV12', 'GRDSVSOL12',
                                                 'GRDSV', 'GRDSVSOL', 'ELITENB', 'ELITENBSOL', 'NSILVER',
                                                 'NMINIPREM', 'NGOLD', 'NPLATINUM', 'NDIAMOND', 'NPREMIERE',
                                                 'NSUPERPREM',
                                                 'NULTRAPREM', 'NPREM24', 'NPREM36',
                                                 'NPREM48', 'NPREM60', 'NPREM72', 'POSTEXT', 'EXTFLEX', 'EXTFLEXSOL')
                                        )
                                        AND sc.SalesCodeDepartmentID <> 3065 --Exclude Laser
                                   THEN sod.ExtendedPriceCalc
                               ELSE 0
                               END                                AS 'NB_TradAmt',
                           CASE
                               WHEN (
                                       ((sc.SalesCodeDepartmentID IN (2020) OR
                                         sc.SalesCodeDescriptionShort LIKE 'SURCREDIT%')
                                           AND m.MembershipDescriptionShort IN
                                               ('GRAD', 'GRAD12', 'GRDSVEZ', 'GRADSOL12', 'GRADSOL6', 'GRADSOL12',
                                                'GRDSV12',
                                                'GRDSVSOL12', 'GRDSV',
                                                'GRDSVSOL', 'ELITENB', 'ELITENBSOL', 'NSILVER', 'NMINIPREM', 'NGOLD',
                                                'NPLATINUM', 'NDIAMOND', 'NPREMIERE', 'NSUPERPREM',
                                                'NULTRAPREM', 'NPREM24', 'NPREM36', 'NPREM48', 'NPREM60', 'NPREM72',
                                                'HWSILVER', 'HWGOLD', 'HWPLAT')
                                           AND sc.SalesCodeDescriptionShort NOT IN ('EFTFEE', 'PCPREVWO')
                                           AND sc.SalesCodeDepartmentID <> 3065)
                                       OR (sc.SalesCodeDepartmentID IN (2020)
                                       AND m.MembershipDescriptionShort IN ('GRDSVEZ'))
                                   )
                                   THEN
                                   sod.ExtendedPriceCalc
                               ELSE 0
                               END                                AS 'NB_GradAmt',
                           CASE
                               WHEN (
                                       (sc.SalesCodeDepartmentID IN (2020) OR
                                        (sc.SalesCodeDescriptionShort LIKE 'SURCREDIT%'))
                                       AND m.MembershipDescriptionShort IN
                                           ('EXT6', 'EXT12', 'EXT18', 'EXTENH6', 'EXTENH12', 'EXTENH9', 'EXTINITIAL',
                                            'NRESTORWK', 'NRESTBIWK',
                                            'NRESTORE', 'LASER82', 'HWEXTBAS', 'HWEXTPLUS', 'HWANAGEN')
                                       AND sc.SalesCodeDescriptionShort NOT IN ('EFTFEE', 'PCPREVWO', 'PCPMBRPMT')
                                       AND sc.SalesCodeDepartmentID <> 3065 --Exclude Laser
                                   )
                                   THEN
                                   sod.ExtendedPriceCalc
                               ELSE 0
                               END                                AS 'NB_ExtAmt',
                           CASE
                               WHEN (sc.[SalesCodeDepartmentID] IN (2025) --Add-on Salescodes in Dept 2025 5/1/2017 km
                                   AND m.BusinessSegmentID in (2, 3)
                                   AND sc.[SalesCodeDescriptionShort] NOT IN
                                       ('BOSMEMADJTG', 'BOSMEMADJTGBPS', 'MEDADDONPMTTRI'))
                                   OR
                                    (sc.salescodedepartmentid IN (2020)
                                        AND m.membershipID = 13)
                                   OR
                                    (sc.salescodedescriptionshort IN ('NB1REVWO', 'EXTREVWO')
                                        AND m.MembershipDescriptionShort IN ('POSTEXT'))
                                   THEN sod.[ExtendedPriceCalc]
                               ELSE 0
                               END                                AS 'S_PostExtAmt',
                           CASE
                               WHEN (
                                       sc.SalesCodeDepartmentID IN (2020)
                                       AND m.RevenueGroupID = 1
                                       AND m.BusinessSegmentID = 6
                                       AND sc.SalesCodeDepartmentID <> 3065 --Exclude Laser
                                   )
                                   THEN sod.ExtendedPriceCalc
                               ELSE 0
                               END                                AS 'NB_XtrAmt',
                           CASE
                               WHEN sc.[SalesCodeDepartmentID] = 5062 AND
                                    sc.SalesCodeDescriptionShort NOT IN ('ADDONMDP', 'SVCSMP')
                                   THEN sod.ExtendedPriceCalc
                               WHEN sc.SalesCodeDepartmentID = 2020 AND m.MembershipDescriptionShort = 'MDP'
                                   THEN sod.ExtendedPriceCalc
                               WHEN sc.SalesCodeDepartmentID IN (2030) AND
                                    sc.salescodedescriptionshort = 'MEDADDONPMTSMP'
                                   THEN sod.ExtendedPriceCalc --Added Bosley SMP
                               ELSE 0
                               END                                AS 'NB_MDPAmt',
                           CASE
                               WHEN (sc.SalesCodeDepartmentID IN (3065) AND m.RevenueGroupID = 1 AND
                                     m.MembershipDescriptionShort NOT IN
                                     ('EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP', 'EMPLOYEE6'))
                                   then sod.ExtendedPriceCalc
                               WHEN (sc.SalesCodeDescription LIKE '%cap%' AND sc.SalesCodeDepartmentID = 2020 AND
                                     m.RevenueGroupID = 1 AND m.MembershipDescriptionShort NOT IN
                                                              ('EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP', 'EMPLOYEE6'))
                                   THEN sod.ExtendedPriceCalc
                               WHEN (sc.SalesCodeDescription LIKE '%laser%' AND sc.SalesCodeDepartmentID = 2020 AND
                                     m.RevenueGroupID = 1 AND m.MembershipDescriptionShort NOT IN
                                                              ('EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP', 'EMPLOYEE6'))
                                   THEN sod.ExtendedPriceCalc
                               ELSE 0
                               END                                AS 'NB_LaserAmt',
                           CASE
                               WHEN sc.SalesCodeDepartmentID IN (2020)
                                   AND sod.SalesCodeID NOT IN
                                       (912, 913, 1653, 1654, 1655, 1656, 1661, 1662, 1664, 1665) --These are Tri-Gen or PRP Add-Ons
                                   AND m.BusinessSegmentID = 3
                                   THEN sod.ExtendedPriceCalc
                               ELSE 0
                               END                                AS 'S_SurAmt',
                           CASE
                               WHEN (sc.SalesCodeID IN
                                     (912, 913, 1653, 1654, 1655, 1656, 1661, 1662, 1664, 1665) --These are Tri-Gen or PRP Add-Ons
                                   AND m.membershipid in
                                       (43, 44, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 316, 317))
                                   THEN sod.[ExtendedPriceCalc]
                               ELSE 0
                               END                                AS 'S_PRPAmt',
							   so.IsClosedFlag  ,
							   so.IsVoidedFlag
                    from ods.CNCT_datSalesOrder so
                             inner join ods.CNCT_datSalesOrderDetail sod on sod.SalesOrderGUID = so.SalesOrderGUID
                             inner join ods.CNCT_cfgSalesCode sc on sod.SalesCodeID = sc.SalesCodeID
                             inner join ods.CNCT_datClientMembership cm
                                        on cm.ClientMembershipGUID = so.ClientMembershipGUID
                             left join ods.CNCT_cfgMembership m on m.MembershipID = cm.MembershipID
                             left join ods.CNCT_datAppointment a on so.AppointmentGUID = a.AppointmentGUID
                             left join ods.CNCT_datAppointmentDetail ad on ad.AppointmentGUID = a.AppointmentGUID
                             left join ods.CNCT_datAppointmentEmployee ae on ae.AppointmentGUID = a.AppointmentGUID
                             left join ODS.CNCT_DatEmployee de on de.EmployeeGUID = ae.EmployeeGUID
							  left join ODS.CNCT_DatEmployee deo on deo.EmployeeGUID = sod.Employee1GUID
                             left join DimSystemUser su on su.UserId = convert(varchar(250), ae.EmployeeGUID)
                             left join DimCenter c
                                       on c.CenterID = su.CenterId and c.IsDeleted = 0 and c.IsActiveFlag = 1
                             left join DimDate d on d.FullDate = convert(date,so.OrderDate)


                )
       select PerformerName,
              PerformerID,
              --Region1,
             -- Region2,
              appointmentID,
              PerformerHomeCenter,
              PerformerHomeCenterID,
              PerformerHomeCenterKey,
              SalesOrderGUID,
              OrderDate,
              OrderDateKey,
              AppointmentDate,
              SalesCodeID,
             -- MembershipID,
             -- MembershipDescription,
             -- MembershipDescriptionShort,
             -- BusinessSegmentID,
              SalesCodeDescriptionShort,
              SalesCodeDescription,
             -- RevenueGroupID,
              SalesCodeDepartmentID,

              NB_TradAmt,
              NB_GradAmt,
              NB_ExtAmt,
              S_PostExtAmt,
              NB_XtrAmt,
              NB_MDPAmt,
              NB_LaserAmt,
              S_SurAmt,
              S_PRPAmt,
			  IsVoidedFlag ,
			  IsClosedFlag
       from FactSalesRevenue_cte;
GO
