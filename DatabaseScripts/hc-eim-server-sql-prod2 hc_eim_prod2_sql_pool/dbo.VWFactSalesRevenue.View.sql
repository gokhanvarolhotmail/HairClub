/****** Object:  View [dbo].[VWFactSalesRevenue]    Script Date: 3/23/2022 10:16:56 AM ******/਍匀䔀吀 䄀一匀䤀开一唀䰀䰀匀 伀一ഀഀ
GO਍匀䔀吀 儀唀伀吀䔀䐀开䤀䐀䔀一吀䤀䘀䤀䔀刀 伀一ഀഀ
GO਍䌀刀䔀䄀吀䔀 嘀䤀䔀圀 嬀搀戀漀崀⸀嬀嘀圀䘀愀挀琀匀愀氀攀猀刀攀瘀攀渀甀攀崀 䄀匀 眀椀琀栀 䘀愀挀琀匀愀氀攀猀刀攀瘀攀渀甀攀开挀琀攀 愀猀ഀഀ
                (਍                    猀攀氀攀挀琀 挀愀猀攀 眀栀攀渀 挀漀渀挀愀琀⠀搀攀⸀䘀椀爀猀琀一愀洀攀Ⰰ✀ ✀Ⰰ搀攀⸀䰀愀猀琀一愀洀攀⤀ 㴀✀ ✀ 琀栀攀渀   挀漀渀挀愀琀⠀搀攀漀⸀䘀椀爀猀琀一愀洀攀Ⰰ✀ ✀Ⰰ搀攀漀⸀䰀愀猀琀一愀洀攀⤀ 攀氀猀攀 挀漀渀挀愀琀⠀搀攀⸀䘀椀爀猀琀一愀洀攀Ⰰ✀ ✀Ⰰ搀攀⸀䰀愀猀琀一愀洀攀⤀ 攀渀搀              愀猀 倀攀爀昀漀爀洀攀爀一愀洀攀Ⰰഀഀ
                           isnull(convert(varchar(250), ae.EmployeeGUID),convert(varchar(250), sod.Employee1GUID)) as PerformerID,਍                           ⴀⴀ挀⸀刀攀最椀漀渀㄀Ⰰഀഀ
                           --c.Region2,਍                           愀⸀匀愀氀攀猀昀漀爀挀攀吀愀猀欀䤀䐀                     愀猀 愀瀀瀀漀椀渀琀洀攀渀琀䤀䐀Ⰰഀഀ
                           c.CenterNumber                         as PerformerHomeCenter,਍                           猀甀⸀䌀攀渀琀攀爀䤀搀                            愀猀 倀攀爀昀漀爀洀攀爀䠀漀洀攀䌀攀渀琀攀爀䤀䐀Ⰰഀഀ
                           c.CenterKey                            as PerformerHomeCenterKey,਍                           猀漀⸀匀愀氀攀猀伀爀搀攀爀䜀唀䤀䐀Ⰰഀഀ
                           so.OrderDate,਍                           搀⸀䐀愀琀攀䬀攀礀 愀猀 伀爀搀攀爀䐀愀琀攀䬀攀礀Ⰰഀഀ
                           a.AppointmentDate,਍                           猀挀⸀匀愀氀攀猀䌀漀搀攀䤀䐀Ⰰഀഀ
                          -- m.MembershipID,਍                          ⴀⴀ 洀⸀䴀攀洀戀攀爀猀栀椀瀀䐀攀猀挀爀椀瀀琀椀漀渀Ⰰഀഀ
                           --m.MembershipDescriptionShort,਍                           ⴀⴀ洀⸀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀Ⰰഀഀ
                           sc.SalesCodeDescriptionShort,਍                           猀挀⸀匀愀氀攀猀䌀漀搀攀䐀攀猀挀爀椀瀀琀椀漀渀Ⰰഀഀ
                          -- m.RevenueGroupID,਍                           猀挀⸀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀䐀Ⰰഀഀ
਍ഀഀ
                           CASE਍                               圀䠀䔀一 ⠀ഀഀ
                                            (sc.SalesCodeDepartmentID IN (2020) AND m.RevenueGroupID = 1)਍                                            䄀一䐀 洀⸀䈀甀猀椀渀攀猀猀匀攀最洀攀渀琀䤀䐀 㴀 ㄀ ⴀⴀ䈀甀猀匀攀最 ⠀䈀䤀伀⤀ഀഀ
                                            AND਍                                            洀⸀䴀攀洀戀攀爀猀栀椀瀀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀 䤀一ഀഀ
                                            ('TRADITION', 'NALACARTE', 'NFOLLIGRFT', 'HWBRIO')਍                                        ⤀ഀഀ
                                   OR਍                                    ⠀ഀഀ
                                                sc.salescodedescriptionshort IN਍                                                ⠀✀一䈀㄀刀䔀嘀圀伀✀Ⰰ ✀䔀堀吀刀䔀嘀圀伀✀Ⰰ ✀匀唀刀䌀刀䔀䐀䤀吀倀䌀倀✀Ⰰ ✀匀唀刀䌀刀䔀䐀䤀吀一䈀㄀✀⤀ഀഀ
                                            AND m.MembershipDescriptionShort NOT IN਍                                                ⠀✀䔀堀吀㘀✀Ⰰ ✀䔀堀吀㄀㈀✀Ⰰ ✀䔀堀吀㄀㠀✀Ⰰ ✀䔀堀吀䔀一䠀㘀✀Ⰰ ✀䔀堀吀䔀一䠀㄀㈀✀Ⰰ ✀䔀堀吀䔀一䠀㤀✀Ⰰഀഀ
                                                 'EXTMEM', 'EXTMEMSOL', 'EXTINITIAL', 'EXTPREMMEN', 'EXTPREMWOM',਍                                                 ✀䜀刀䄀䐀✀Ⰰഀഀ
                                                 'GRDSVEZ', 'GRAD12', 'GRDSVEZ', 'GRADSOL12', 'GRADSOL6', 'GRADSOL12',਍                                                 ✀䜀刀䐀匀嘀㄀㈀✀Ⰰ ✀䜀刀䐀匀嘀匀伀䰀㄀㈀✀Ⰰഀഀ
                                                 'GRDSV', 'GRDSVSOL', 'ELITENB', 'ELITENBSOL', 'NSILVER',਍                                                 ✀一䴀䤀一䤀倀刀䔀䴀✀Ⰰ ✀一䜀伀䰀䐀✀Ⰰ ✀一倀䰀䄀吀䤀一唀䴀✀Ⰰ ✀一䐀䤀䄀䴀伀一䐀✀Ⰰ ✀一倀刀䔀䴀䤀䔀刀䔀✀Ⰰഀഀ
                                                 'NSUPERPREM',਍                                                 ✀一唀䰀吀刀䄀倀刀䔀䴀✀Ⰰ ✀一倀刀䔀䴀㈀㐀✀Ⰰ ✀一倀刀䔀䴀㌀㘀✀Ⰰഀഀ
                                                 'NPREM48', 'NPREM60', 'NPREM72', 'POSTEXT', 'EXTFLEX', 'EXTFLEXSOL')਍                                        ⤀ഀഀ
                                        AND sc.SalesCodeDepartmentID <> 3065 --Exclude Laser਍                                   吀䠀䔀一 猀漀搀⸀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀ഀഀ
                               ELSE 0਍                               䔀一䐀                                䄀匀 ✀一䈀开吀爀愀搀䄀洀琀✀Ⰰഀഀ
                           CASE਍                               圀䠀䔀一 ⠀ഀഀ
                                       ((sc.SalesCodeDepartmentID IN (2020) OR਍                                         猀挀⸀匀愀氀攀猀䌀漀搀攀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀 䰀䤀䬀䔀 ✀匀唀刀䌀刀䔀䐀䤀吀─✀⤀ഀഀ
                                           AND m.MembershipDescriptionShort IN਍                                               ⠀✀䜀刀䄀䐀✀Ⰰ ✀䜀刀䄀䐀㄀㈀✀Ⰰ ✀䜀刀䐀匀嘀䔀娀✀Ⰰ ✀䜀刀䄀䐀匀伀䰀㄀㈀✀Ⰰ ✀䜀刀䄀䐀匀伀䰀㘀✀Ⰰ ✀䜀刀䄀䐀匀伀䰀㄀㈀✀Ⰰഀഀ
                                                'GRDSV12',਍                                                ✀䜀刀䐀匀嘀匀伀䰀㄀㈀✀Ⰰ ✀䜀刀䐀匀嘀✀Ⰰഀഀ
                                                'GRDSVSOL', 'ELITENB', 'ELITENBSOL', 'NSILVER', 'NMINIPREM', 'NGOLD',਍                                                ✀一倀䰀䄀吀䤀一唀䴀✀Ⰰ ✀一䐀䤀䄀䴀伀一䐀✀Ⰰ ✀一倀刀䔀䴀䤀䔀刀䔀✀Ⰰ ✀一匀唀倀䔀刀倀刀䔀䴀✀Ⰰഀഀ
                                                'NULTRAPREM', 'NPREM24', 'NPREM36', 'NPREM48', 'NPREM60', 'NPREM72',਍                                                ✀䠀圀匀䤀䰀嘀䔀刀✀Ⰰ ✀䠀圀䜀伀䰀䐀✀Ⰰ ✀䠀圀倀䰀䄀吀✀⤀ഀഀ
                                           AND sc.SalesCodeDescriptionShort NOT IN ('EFTFEE', 'PCPREVWO')਍                                           䄀一䐀 猀挀⸀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀䐀 㰀㸀 ㌀　㘀㔀⤀ഀഀ
                                       OR (sc.SalesCodeDepartmentID IN (2020)਍                                       䄀一䐀 洀⸀䴀攀洀戀攀爀猀栀椀瀀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀 䤀一 ⠀✀䜀刀䐀匀嘀䔀娀✀⤀⤀ഀഀ
                                   )਍                                   吀䠀䔀一ഀഀ
                                   sod.ExtendedPriceCalc਍                               䔀䰀匀䔀 　ഀഀ
                               END                                AS 'NB_GradAmt',਍                           䌀䄀匀䔀ഀഀ
                               WHEN (਍                                       ⠀猀挀⸀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀䐀 䤀一 ⠀㈀　㈀　⤀ 伀刀ഀഀ
                                        (sc.SalesCodeDescriptionShort LIKE 'SURCREDIT%'))਍                                       䄀一䐀 洀⸀䴀攀洀戀攀爀猀栀椀瀀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀 䤀一ഀഀ
                                           ('EXT6', 'EXT12', 'EXT18', 'EXTENH6', 'EXTENH12', 'EXTENH9', 'EXTINITIAL',਍                                            ✀一刀䔀匀吀伀刀圀䬀✀Ⰰ ✀一刀䔀匀吀䈀䤀圀䬀✀Ⰰഀഀ
                                            'NRESTORE', 'LASER82', 'HWEXTBAS', 'HWEXTPLUS', 'HWANAGEN')਍                                       䄀一䐀 猀挀⸀匀愀氀攀猀䌀漀搀攀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀 一伀吀 䤀一 ⠀✀䔀䘀吀䘀䔀䔀✀Ⰰ ✀倀䌀倀刀䔀嘀圀伀✀Ⰰ ✀倀䌀倀䴀䈀刀倀䴀吀✀⤀ഀഀ
                                       AND sc.SalesCodeDepartmentID <> 3065 --Exclude Laser਍                                   ⤀ഀഀ
                                   THEN਍                                   猀漀搀⸀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀ഀഀ
                               ELSE 0਍                               䔀一䐀                                䄀匀 ✀一䈀开䔀砀琀䄀洀琀✀Ⰰഀഀ
                           CASE਍                               圀䠀䔀一 ⠀猀挀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀䐀崀 䤀一 ⠀㈀　㈀㔀⤀ ⴀⴀ䄀搀搀ⴀ漀渀 匀愀氀攀猀挀漀搀攀猀 椀渀 䐀攀瀀琀 ㈀　㈀㔀 㔀⼀㄀⼀㈀　㄀㜀 欀洀ഀഀ
                                   AND m.BusinessSegmentID in (2, 3)਍                                   䄀一䐀 猀挀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀崀 一伀吀 䤀一ഀഀ
                                       ('BOSMEMADJTG', 'BOSMEMADJTGBPS', 'MEDADDONPMTTRI'))਍                                   伀刀ഀഀ
                                    (sc.salescodedepartmentid IN (2020)਍                                        䄀一䐀 洀⸀洀攀洀戀攀爀猀栀椀瀀䤀䐀 㴀 ㄀㌀⤀ഀഀ
                                   OR਍                                    ⠀猀挀⸀猀愀氀攀猀挀漀搀攀搀攀猀挀爀椀瀀琀椀漀渀猀栀漀爀琀 䤀一 ⠀✀一䈀㄀刀䔀嘀圀伀✀Ⰰ ✀䔀堀吀刀䔀嘀圀伀✀⤀ഀഀ
                                        AND m.MembershipDescriptionShort IN ('POSTEXT'))਍                                   吀䠀䔀一 猀漀搀⸀嬀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀ഀഀ
                               ELSE 0਍                               䔀一䐀                                䄀匀 ✀匀开倀漀猀琀䔀砀琀䄀洀琀✀Ⰰഀഀ
                           CASE਍                               圀䠀䔀一 ⠀ഀഀ
                                       sc.SalesCodeDepartmentID IN (2020)਍                                       䄀一䐀 洀⸀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀 㴀 ㄀ഀഀ
                                       AND m.BusinessSegmentID = 6਍                                       䄀一䐀 猀挀⸀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀䐀 㰀㸀 ㌀　㘀㔀 ⴀⴀ䔀砀挀氀甀搀攀 䰀愀猀攀爀ഀഀ
                                   )਍                                   吀䠀䔀一 猀漀搀⸀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀ഀഀ
                               ELSE 0਍                               䔀一䐀                                䄀匀 ✀一䈀开堀琀爀䄀洀琀✀Ⰰഀഀ
                           CASE਍                               圀䠀䔀一 猀挀⸀嬀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀䐀崀 㴀 㔀　㘀㈀ 䄀一䐀ഀഀ
                                    sc.SalesCodeDescriptionShort NOT IN ('ADDONMDP', 'SVCSMP')਍                                   吀䠀䔀一 猀漀搀⸀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀ഀഀ
                               WHEN sc.SalesCodeDepartmentID = 2020 AND m.MembershipDescriptionShort = 'MDP'਍                                   吀䠀䔀一 猀漀搀⸀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀ഀഀ
                               WHEN sc.SalesCodeDepartmentID IN (2030) AND਍                                    猀挀⸀猀愀氀攀猀挀漀搀攀搀攀猀挀爀椀瀀琀椀漀渀猀栀漀爀琀 㴀 ✀䴀䔀䐀䄀䐀䐀伀一倀䴀吀匀䴀倀✀ഀഀ
                                   THEN sod.ExtendedPriceCalc --Added Bosley SMP਍                               䔀䰀匀䔀 　ഀഀ
                               END                                AS 'NB_MDPAmt',਍                           䌀䄀匀䔀ഀഀ
                               WHEN (sc.SalesCodeDepartmentID IN (3065) AND m.RevenueGroupID = 1 AND਍                                     洀⸀䴀攀洀戀攀爀猀栀椀瀀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀 一伀吀 䤀一ഀഀ
                                     ('EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP', 'EMPLOYEE6'))਍                                   琀栀攀渀 猀漀搀⸀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀ഀഀ
                               WHEN (sc.SalesCodeDescription LIKE '%cap%' AND sc.SalesCodeDepartmentID = 2020 AND਍                                     洀⸀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀 㴀 ㄀ 䄀一䐀 洀⸀䴀攀洀戀攀爀猀栀椀瀀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀 一伀吀 䤀一ഀഀ
                                                              ('EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP', 'EMPLOYEE6'))਍                                   吀䠀䔀一 猀漀搀⸀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀ഀഀ
                               WHEN (sc.SalesCodeDescription LIKE '%laser%' AND sc.SalesCodeDepartmentID = 2020 AND਍                                     洀⸀刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀 㴀 ㄀ 䄀一䐀 洀⸀䴀攀洀戀攀爀猀栀椀瀀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀 一伀吀 䤀一ഀഀ
                                                              ('EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP', 'EMPLOYEE6'))਍                                   吀䠀䔀一 猀漀搀⸀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀ഀഀ
                               ELSE 0਍                               䔀一䐀                                䄀匀 ✀一䈀开䰀愀猀攀爀䄀洀琀✀Ⰰഀഀ
                           CASE਍                               圀䠀䔀一 猀挀⸀匀愀氀攀猀䌀漀搀攀䐀攀瀀愀爀琀洀攀渀琀䤀䐀 䤀一 ⠀㈀　㈀　⤀ഀഀ
                                   AND sod.SalesCodeID NOT IN਍                                       ⠀㤀㄀㈀Ⰰ 㤀㄀㌀Ⰰ ㄀㘀㔀㌀Ⰰ ㄀㘀㔀㐀Ⰰ ㄀㘀㔀㔀Ⰰ ㄀㘀㔀㘀Ⰰ ㄀㘀㘀㄀Ⰰ ㄀㘀㘀㈀Ⰰ ㄀㘀㘀㐀Ⰰ ㄀㘀㘀㔀⤀ ⴀⴀ吀栀攀猀攀 愀爀攀 吀爀椀ⴀ䜀攀渀 漀爀 倀刀倀 䄀搀搀ⴀ伀渀猀ഀഀ
                                   AND m.BusinessSegmentID = 3਍                                   吀䠀䔀一 猀漀搀⸀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀ഀഀ
                               ELSE 0਍                               䔀一䐀                                䄀匀 ✀匀开匀甀爀䄀洀琀✀Ⰰഀഀ
                           CASE਍                               圀䠀䔀一 ⠀猀挀⸀匀愀氀攀猀䌀漀搀攀䤀䐀 䤀一ഀഀ
                                     (912, 913, 1653, 1654, 1655, 1656, 1661, 1662, 1664, 1665) --These are Tri-Gen or PRP Add-Ons਍                                   䄀一䐀 洀⸀洀攀洀戀攀爀猀栀椀瀀椀搀 椀渀ഀഀ
                                       (43, 44, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 316, 317))਍                                   吀䠀䔀一 猀漀搀⸀嬀䔀砀琀攀渀搀攀搀倀爀椀挀攀䌀愀氀挀崀ഀഀ
                               ELSE 0਍                               䔀一䐀                                䄀匀 ✀匀开倀刀倀䄀洀琀✀Ⰰഀഀ
							   so.IsClosedFlag  , ਍ऀऀऀऀऀऀऀ   猀漀⸀䤀猀嘀漀椀搀攀搀䘀氀愀最 ഀഀ
                    from ods.CNCT_datSalesOrder so਍                             椀渀渀攀爀 樀漀椀渀 漀搀猀⸀䌀一䌀吀开搀愀琀匀愀氀攀猀伀爀搀攀爀䐀攀琀愀椀氀 猀漀搀 漀渀 猀漀搀⸀匀愀氀攀猀伀爀搀攀爀䜀唀䤀䐀 㴀 猀漀⸀匀愀氀攀猀伀爀搀攀爀䜀唀䤀䐀ഀഀ
                             inner join ods.CNCT_cfgSalesCode sc on sod.SalesCodeID = sc.SalesCodeID਍                             椀渀渀攀爀 樀漀椀渀 漀搀猀⸀䌀一䌀吀开搀愀琀䌀氀椀攀渀琀䴀攀洀戀攀爀猀栀椀瀀 挀洀ഀഀ
                                        on cm.ClientMembershipGUID = so.ClientMembershipGUID਍                             氀攀昀琀 樀漀椀渀 漀搀猀⸀䌀一䌀吀开挀昀最䴀攀洀戀攀爀猀栀椀瀀 洀 漀渀 洀⸀䴀攀洀戀攀爀猀栀椀瀀䤀䐀 㴀 挀洀⸀䴀攀洀戀攀爀猀栀椀瀀䤀䐀ഀഀ
                             left join ods.CNCT_datAppointment a on so.AppointmentGUID = a.AppointmentGUID਍                             氀攀昀琀 樀漀椀渀 漀搀猀⸀䌀一䌀吀开搀愀琀䄀瀀瀀漀椀渀琀洀攀渀琀䐀攀琀愀椀氀 愀搀 漀渀 愀搀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䜀唀䤀䐀 㴀 愀⸀䄀瀀瀀漀椀渀琀洀攀渀琀䜀唀䤀䐀ഀഀ
                             left join ods.CNCT_datAppointmentEmployee ae on ae.AppointmentGUID = a.AppointmentGUID਍                             氀攀昀琀 樀漀椀渀 伀䐀匀⸀䌀一䌀吀开䐀愀琀䔀洀瀀氀漀礀攀攀 搀攀 漀渀 搀攀⸀䔀洀瀀氀漀礀攀攀䜀唀䤀䐀 㴀 愀攀⸀䔀洀瀀氀漀礀攀攀䜀唀䤀䐀ഀഀ
							  left join ODS.CNCT_DatEmployee deo on deo.EmployeeGUID = sod.Employee1GUID਍                             氀攀昀琀 樀漀椀渀 䐀椀洀匀礀猀琀攀洀唀猀攀爀 猀甀 漀渀 猀甀⸀唀猀攀爀䤀搀 㴀 挀漀渀瘀攀爀琀⠀瘀愀爀挀栀愀爀⠀㈀㔀　⤀Ⰰ 愀攀⸀䔀洀瀀氀漀礀攀攀䜀唀䤀䐀⤀ഀഀ
                             left join DimCenter c਍                                       漀渀 挀⸀䌀攀渀琀攀爀䤀䐀 㴀 猀甀⸀䌀攀渀琀攀爀䤀搀 愀渀搀 挀⸀䤀猀䐀攀氀攀琀攀搀 㴀 　 愀渀搀 挀⸀䤀猀䄀挀琀椀瘀攀䘀氀愀最 㴀 ㄀ഀഀ
                             left join DimDate d on d.FullDate = convert(date,so.OrderDate)਍ഀഀ
਍                ⤀ഀഀ
       select PerformerName,਍              倀攀爀昀漀爀洀攀爀䤀䐀Ⰰഀഀ
              --Region1,਍             ⴀⴀ 刀攀最椀漀渀㈀Ⰰഀഀ
              appointmentID,਍              倀攀爀昀漀爀洀攀爀䠀漀洀攀䌀攀渀琀攀爀Ⰰഀഀ
              PerformerHomeCenterID,਍              倀攀爀昀漀爀洀攀爀䠀漀洀攀䌀攀渀琀攀爀䬀攀礀Ⰰഀഀ
              SalesOrderGUID,਍              伀爀搀攀爀䐀愀琀攀Ⰰഀഀ
              OrderDateKey,਍              䄀瀀瀀漀椀渀琀洀攀渀琀䐀愀琀攀Ⰰഀഀ
              SalesCodeID,਍             ⴀⴀ 䴀攀洀戀攀爀猀栀椀瀀䤀䐀Ⰰഀഀ
             -- MembershipDescription,਍             ⴀⴀ 䴀攀洀戀攀爀猀栀椀瀀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀Ⰰഀഀ
             -- BusinessSegmentID,਍              匀愀氀攀猀䌀漀搀攀䐀攀猀挀爀椀瀀琀椀漀渀匀栀漀爀琀Ⰰഀഀ
              SalesCodeDescription,਍             ⴀⴀ 刀攀瘀攀渀甀攀䜀爀漀甀瀀䤀䐀Ⰰഀഀ
              SalesCodeDepartmentID,਍ഀഀ
              NB_TradAmt,਍              一䈀开䜀爀愀搀䄀洀琀Ⰰഀഀ
              NB_ExtAmt,਍              匀开倀漀猀琀䔀砀琀䄀洀琀Ⰰഀഀ
              NB_XtrAmt,਍              一䈀开䴀䐀倀䄀洀琀Ⰰഀഀ
              NB_LaserAmt,਍              匀开匀甀爀䄀洀琀Ⰰഀഀ
              S_PRPAmt,਍ऀऀऀ  䤀猀嘀漀椀搀攀搀䘀氀愀最 Ⰰഀഀ
			  IsClosedFlag਍       昀爀漀洀 䘀愀挀琀匀愀氀攀猀刀攀瘀攀渀甀攀开挀琀攀㬀ഀഀ
GO਍
