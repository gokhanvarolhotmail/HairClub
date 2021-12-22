/* CreateDate: 04/28/2021 10:18:40.583 , ModifyDate: 05/21/2021 13:43:53.140 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spSvc_GenerateLifeTimeValue]
as
-------------------------------------------------------------------------
-- [spSVC_GenerateLifeTimeValue] is used to generated Lifetime value for
-- leads/clients
--
--
--   exec [dbo].[spSVC_GenerateLifeTimeValue]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/28/2021  KMurdoch     Initial Creation
--			05/11/2021  KMurdoch     Removed Acquired from membership lists
--			05/11/2021  Kmurdoch     Changed Order by to Client Identifier
--			05/21/2021  Kmurdoch     Fixed Days calculation to use Getdate for current memberships rather than end date
--			05/15/2021  Kmurdoch     Added Last Cancel Date
-------------------------------------------------------------------------
begin


    if object_id(N'tempdb..#MemberFirst') is not null
    begin
        drop table #MemberFirst;
    end;

    if object_id(N'tempdb..#MemberCurrent') is not null
    begin
        drop table #MemberCurrent;
    end;

    if object_id(N'tempdb..#MemberRevenue') is not null
    begin
        drop table #MemberRevenue;
    end;

    /*

Select All memberships for Clients with hashed Email; Get the first Membership

*/
    select row_number() over (partition by dc.ClientIdentifier
                              order by clm.ClientMembershipBeginDate,clm.ClientMembershipIdentifier asc
                             )                                  as 'RowID'
         , dc.ClientIdentifier                                  as 'ClientIdentifier'
         , clm.ClientMembershipKey                              as 'MembershipKey'
         , mem.MembershipDescription                            as 'Membership'
         , bs.BusinessSegmentDescription                        as 'BusinessSegment'
         , case
               when bs.BusinessSegmentSSID in ( 1, 6, 7 ) then
                   'Replace'
               when bs.BusinessSegmentSSID = 2 then
                   'Regrow'
               when bs.BusinessSegmentSSID = 3 then
                   'Restore'
               else
                   'Unknown'
           end                                                  as 'BusinessLine'
         , clm.ClientMembershipStatusDescription                as 'MembershipStatus'
         , convert(varchar, clm.ClientMembershipBeginDate, 112) as 'MembershipBeginDate'
         , cast(clm.ClientMembershipBeginDate as date)          as 'InitMbrBegDate'
         , clm.ClientMembershipContractPrice                    as 'ContractPrice'
         , rg.RevenueGroupDescription                           as 'RevenueGroup'
         , rg.RevenueGroupDescriptionShort                      as 'RevenueGroupShort'
         , rg.RevenueGroupSSID                                  as 'RevenueGroupID'
    into #MemberFirst
    from [HC_BI_CMS_DDS].[bi_cms_dds].[vwDimClient]                    dc
        left outer join [HC_BI_CMS_DDS].bi_cms_dds.DimClientMembership clm
            on clm.ClientKey = dc.ClientKey
        left outer join [HC_BI_CMS_DDS].bi_cms_dds.DimMembership       mem
            on mem.MembershipKey = clm.MembershipKey
        left outer join HC_BI_ENT_DDS.bi_ent_dds.DimBusinessSegment    bs
            on bs.BusinessSegmentKey = mem.BusinessSegmentKey
        left outer join HC_BI_ENT_DDS.bi_ent_dds.DimRevenueGroup       rg
            on rg.RevenueGroupSSID = mem.RevenueGroupSSID
    where bs.BusinessSegmentDescriptionShort in ( 'BIO', 'EXT', 'SUR', 'XTR', 'RESTORINK' )
          and mem.MembershipKey not in ( 64, 67, 110, 111, 260, 257, 95 ) --Initial memberships like shownosale
		  and dc.CenterSSID <> 1001


    --SELECT * FROM HC_BI_CMS_DDS.bi_cms_dds.DimMembership
    --WHERE MembershipKey IN (64, 65, 67, 110, 111, 260, 257, 95)

    --SELECT * FROM #MemberFirst WHERE RowID = 1 AND MembershipBeginDate > '20170101'

    --SELECT * FROM #MemberFirst WHERE ClientIdentifier = 56182
    /*

Select All memberships for Clients with hashed Email; Get the last membership and that membership's status

*/
    select row_number() over (partition by dc.ClientIdentifier
                              order by clm.ClientMembershipEndDate desc
                             )                                  as 'RowID'
         , dc.ClientIdentifier                                  as 'ClientIdentifier'
         , clm.ClientMembershipKey                              as 'MembershipKey'
         , mem.MembershipDescription                            as 'Membership'
         , bs.BusinessSegmentDescription                        as 'BusinessSegment'
         , clm.ClientMembershipStatusDescription                as 'MembershipStatus'
         , convert(varchar, clm.ClientMembershipBeginDate, 112) as 'MembershipBeginDate'
         , cast(clm.ClientMembershipBeginDate as date)          as 'RRMbrBegDate'
         , convert(varchar, clm.ClientMembershipEndDate, 112)   as 'MembershipEndDate'
         , cast(clm.ClientMembershipEndDate as date)            as 'RRMbrEndDate'

    into #MemberCurrent
    from [HC_BI_CMS_DDS].[bi_cms_dds].[vwDimClient]                    dc
        left outer join [HC_BI_CMS_DDS].bi_cms_dds.DimClientMembership clm
            on clm.ClientKey = dc.ClientKey
        left outer join [HC_BI_CMS_DDS].bi_cms_dds.DimMembership       mem
            on mem.MembershipKey = clm.MembershipKey
        left outer join HC_BI_ENT_DDS.bi_ent_dds.DimBusinessSegment    bs
            on bs.BusinessSegmentKey = mem.BusinessSegmentKey
        left outer join HC_BI_ENT_DDS.bi_ent_dds.DimRevenueGroup       rg
            on rg.RevenueGroupSSID = mem.RevenueGroupSSID
    where bs.BusinessSegmentDescriptionShort in ( 'BIO', 'EXT', 'SUR', 'XTR', 'RESTORINK' )
          and mem.MembershipKey not in ( 64, 65, 67, 110, 111, 260, 257, 95 )
		  and clm.ClientMembershipBeginDate > '01/01/2007'
		  and dc.CenterSSID <> 1001

    --ORDER BY dc.ClientIdentifier
    /*

Select all sales orders from the BI environment, group by clientidentifier and break out revenue into New Business, NonProgram & Recurring membership. Also, some Product
Service and Laser Revenue

*/

    select dc.ClientIdentifier as 'ClientIdentifier'
         , dc.ClientFullName   as 'ClientName'
		 , max(case when dscd.SalesCodeDepartmentSSID = 1099 then dd.FullDate else null end) as 'LastCancelDate'
         , sum(   case
                      when dscd.SalesCodeDepartmentSSID like '2%'
                           and drg.RevenueGroupDescriptionShort = 'NB' then
                          fst.ExtendedPrice
                      else
                          0
                  end
              )                as 'NBMembershipRevenue'
         , sum(   case
                      when dscd.SalesCodeDepartmentSSID like '2%'
                           and drg.RevenueGroupDescriptionShort in ( 'NP' ) then
                          fst.ExtendedPrice
                      else
                          0
                  end
              )                as 'NPMembershipRevenue'
         , sum(   case
                      when dscd.SalesCodeDepartmentSSID like '2%'
                           and drg.RevenueGroupDescriptionShort in ( 'PCP' ) then
                          fst.ExtendedPrice
                      else
                          0
                  end
              )                as 'RRMembershipRevenue'
         , sum(   case
                      when year(dd.FullDate) = 2008
                           and dscd.SalesCodeDepartmentSSID like '2%'
                           and drg.RevenueGroupDescriptionShort in ( 'PCP' ) then
                          fst.ExtendedPrice
                      else
                          0
                  end
              )                as '2008RRev'
         , sum(   case
                      when year(dd.FullDate) = 2009
                           and dscd.SalesCodeDepartmentSSID like '2%'
                           and drg.RevenueGroupDescriptionShort in ( 'PCP' ) then
                          fst.ExtendedPrice
                      else
                          0
                  end
              )                as '2009RRev'
         , sum(   case
                      when year(dd.FullDate) = 2010
                           and dscd.SalesCodeDepartmentSSID like '2%'
                           and drg.RevenueGroupDescriptionShort in ( 'PCP' ) then
                          fst.ExtendedPrice
                      else
                          0
                  end
              )                as '2010RRev'
         , sum(   case
                      when year(dd.FullDate) = 2011
                           and dscd.SalesCodeDepartmentSSID like '2%'
                           and drg.RevenueGroupDescriptionShort in ( 'PCP' ) then
                          fst.ExtendedPrice
                      else
                          0
                  end
              )                as '2011RRev'
         , sum(   case
                      when year(dd.FullDate) = 2012
                           and dscd.SalesCodeDepartmentSSID like '2%'
                           and drg.RevenueGroupDescriptionShort in ( 'PCP' ) then
                          fst.ExtendedPrice
                      else
                          0
                  end
              )                as '2012RRev'
         , sum(   case
                      when year(dd.FullDate) = 2013
                           and dscd.SalesCodeDepartmentSSID like '2%'
                           and drg.RevenueGroupDescriptionShort in ( 'PCP' ) then
                          fst.ExtendedPrice
                      else
                          0
                  end
              )                as '2013RRev'
         , sum(   case
                      when year(dd.FullDate) = 2014
                           and dscd.SalesCodeDepartmentSSID like '2%'
                           and drg.RevenueGroupDescriptionShort in ( 'PCP' ) then
                          fst.ExtendedPrice
                      else
                          0
                  end
              )                as '2014RRev'
         , sum(   case
                      when year(dd.FullDate) = 2015
                           and dscd.SalesCodeDepartmentSSID like '2%'
                           and drg.RevenueGroupDescriptionShort in ( 'PCP' ) then
                          fst.ExtendedPrice
                      else
                          0
                  end
              )                as '2015RRev'
         , sum(   case
                      when year(dd.FullDate) = 2016
                           and dscd.SalesCodeDepartmentSSID like '2%'
                           and drg.RevenueGroupDescriptionShort in ( 'PCP' ) then
                          fst.ExtendedPrice
                      else
                          0
                  end
              )                as '2016RRev'
         , sum(   case
                      when year(dd.FullDate) = 2017
                           and dscd.SalesCodeDepartmentSSID like '2%'
                           and drg.RevenueGroupDescriptionShort in ( 'PCP' ) then
                          fst.ExtendedPrice
                      else
                          0
                  end
              )                as '2017RRev'
         , sum(   case
                      when year(dd.FullDate) = 2018
                           and dscd.SalesCodeDepartmentSSID like '2%'
                           and drg.RevenueGroupDescriptionShort in ( 'PCP' ) then
                          fst.ExtendedPrice
                      else
                          0
                  end
              )                as '2018RRev'
         , sum(   case
                      when year(dd.FullDate) = 2019
                           and dscd.SalesCodeDepartmentSSID like '2%'
                           and drg.RevenueGroupDescriptionShort in ( 'PCP' ) then
                          fst.ExtendedPrice
                      else
                          0
                  end
              )                as '2019RRev'
         , sum(   case
                      when year(dd.FullDate) = 2020
                           and dscd.SalesCodeDepartmentSSID like '2%'
                           and drg.RevenueGroupDescriptionShort in ( 'PCP' ) then
                          fst.ExtendedPrice
                      else
                          0
                  end
              )                as '2020RRev'
         , sum(   case
                      when year(dd.FullDate) = 2021
                           and dscd.SalesCodeDepartmentSSID like '2%'
                           and drg.RevenueGroupDescriptionShort in ( 'PCP' ) then
                          fst.ExtendedPrice
                      else
                          0
                  end
              )                as '2021RRev'
         , sum(   case
                      when dscd.SalesCodeDepartmentSSID in ( 1099,3010, 3020, 3030, 3040, 3050, 3060, 3070, 3080, 7052 ) then
                          fst.ExtendedPrice
                      else
                          0
                  end
              )                'ProductRevenue'
         , sum(   case
                      when dscd.SalesCodeDepartmentSSID in ( 3065 ) then
                          fst.ExtendedPrice
                      else
                          0
                  end
              )                'LaserRevenue'
         , sum(   case
                      when dscd.SalesCodeDepartmentSSID like '5%' then
                          fst.ExtendedPrice
                      else
                          0
                  end
              )                as 'ServiceRevenue'
    into #MemberRevenue
    from HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction             fst
        inner join HC_BI_CMS_DDS.bi_cms_dds.DimClient              dc
            on dc.ClientKey = fst.ClientKey
        inner join HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership    clm
            on clm.ClientMembershipKey = fst.ClientMembershipKey
        inner join HC_BI_CMS_DDS.bi_cms_dds.DimMembership          mem
            on mem.MembershipKey = fst.MembershipKey
        inner join HC_BI_ENT_DDS.bi_ent_dds.DimRevenueGroup        drg
            on drg.RevenueGroupSSID = mem.RevenueGroupSSID
        inner join HC_BI_ENT_DDS.bief_dds.DimDate                  dd
            on fst.OrderDateKey = dd.DateKey
        inner join HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode           dsc
            on fst.SalesCodeKey = dsc.SalesCodeKey
        inner join HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment dscd
            on dscd.SalesCodeDepartmentKey = dsc.SalesCodeDepartmentKey
        inner join HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision   dscdiv
            on dscd.SalesCodeDivisionKey = dscdiv.SalesCodeDivisionKey
        left outer join HC_BI_MKTG_DDS.bi_mktg_dds.FactLead        fl
            on dc.contactkey = fl.ContactKey
        left outer join HC_BI_ENT_DDS.bief_dds.DimDate             lcdd
            on fl.LeadCreationDateKey = lcdd.DateKey
    where isnull(fst.IsVoided, 0) = 0
          and dscd.SalesCodeDepartmentSSID not in (1005,1006,1007,1010,1015,1020,1025,1030,1040,1045,1050,1060,1070,1080,1090,1095)
          and fst.SalesOrderTypeKey not in ( 7 )
    group by dc.ClientIdentifier
           , dc.ClientFullName
    order by dc.ClientIdentifier
           , dc.ClientFullName;

/*

Convert hashed email to text from varbinary, remove first 2 characters, convert to lowercase
Get base client information, join on temp tables to determine initial & current or last membership depending on the membership status
Concatenate all of that together to create a string

*/


    select ct.CenterTypeDescription                                as 'CenterType'
         , c.CenterDescriptionNumber                               as 'Center'
         , c.CenterNumber
         , dc.ClientFullNameCalc                                   as 'Client'
         , dc.CountryRegionDescription                             as 'Country'
         , dc.StateProvinceDescription                             as 'State'
         , dc.City                                                 as 'City'
         , upper(dc.[PostalCode])                                  as 'PostalCode'
         , convert(varchar, dc.[ClientDateOfBirth], 23)            as 'DateOfBirth'
         , dc.[ClientGenderDescription]                            as 'Gender'
         , dc.[ClientMaritalStatusDescription]                     as 'MaritalStatus'
         , dc.[ClientOccupationDescription]                        as 'Occupation'
         , dc.[ClientEthinicityDescription]                        as 'Ethnicity'
         , dcon.ContactPromotonSSID                                as 'PromoCode'
         , dsource.OwnerType                                       as 'Agency'
         , dsource.Level04Format                                   as 'Format'
         , dsource.Channel                                         as 'Channel'
         , dsource.Media                                           as 'Media'
         , dsource.Level02Location                                 as 'Location'
         , dsource.Level03Language                                 as 'Language'
         , hlt.HairLossTypeDescription                             as 'HairLossType'
         , mf.Membership                                           as 'InitialMembership'
         , mf.BusinessSegment                                      as 'InitialBusinessSegment'
         , mf.BusinessLine                                         as 'InitialBusinessLine'
         , convert(varchar, cast(mf.ContractPrice as money))       as 'InitialMbrContractPrice'
         , mc.MembershipStatus                                     as 'CurrMbrStatus'
         , mc.Membership                                           as 'CurrentMembership'
         , mc.BusinessSegment                                      as 'CurrentMbrBusSeg'
         , case
               when mc.MembershipStatus = 'Active' then
                   'Y'
               else
                   'N'
           end                                                     as 'CurrentMbrActiveFlag'
         , mc.RRMbrBegDate                                         as 'CurrMbrStartDate'
		 , cast(mr.NBMembershipRevenue as money)				   as 'NewBusinessRevenue'
         , cast(mr.RRMembershipRevenue as money)                   as 'RecurringRevenue'
         , cast(mr.NPMembershipRevenue as money)                   as 'NonPgmRevenue'
         , cast(mr.ProductRevenue as money)                        as 'ProductRevenue'
         , cast(mr.ServiceRevenue as money)                        as 'ServiceRevenue'
         , cast(mr.LaserRevenue as money)                          as 'LaserRevenue'

         , case
               when mc.MembershipStatus like 'Cancel%' then
                   'Y'
               else
                   'N'
           end                                                     as 'CancelFlag'
         , case
               when mc.MembershipStatus like 'Cancel%' then
                   mc.RRMbrEndDate
               else
                   null
           end                                                     as 'CancelDate'
         , fldd.FullDate                                           as 'LeadCreateDate'
         , mf.InitMbrBegDate                                       as 'InitMbrBeginDate'
         , mc.RRMbrBegDate
         , mc.RRMbrEndDate
         , datediff(day, fldd.FullDate, mf.InitMbrBegDate)         as 'daysfromLeadCreatetoFirstMbr'
         , case when mc.RRMbrEndDate <= getdate() then datediff(day, fldd.FullDate, mc.RRMbrEndDate)
					else datediff(day, fldd.FullDate, getdate()) end as 'daysfromLeadCreatetoEndMbr'
         , case when mc.RRMbrEndDate <= getdate() then datediff(day, mf.InitMbrBegDate, mc.RRMbrEndDate)
					else datediff(day, mf.InitMbrBegDate, getdate()) end as 'DaysfromInitMbrtoEnd'
         , mr.[2008RRev]
         , mr.[2009RRev]
         , mr.[2010RRev]
         , mr.[2011RRev]
         , mr.[2012RRev]
         , mr.[2013RRev]
         , mr.[2014RRev]
         , mr.[2015RRev]
         , mr.[2016RRev]
         , mr.[2017RRev]
         , mr.[2018RRev]
         , mr.[2019RRev]
         , mr.[2020RRev]
         , mr.[2021RRev]
		 , mr.LastCancelDate
    from [HC_BI_CMS_DDS].[bi_cms_dds].[vwDimClient]              dc
        inner join HC_BI_ENT_DDS.bi_ent_dds.DimCenter            c
            on c.CenterSSID = dc.CenterSSID
        inner join HC_BI_ENT_DDS.bi_ent_dds.DimCenterType        ct
            on ct.CenterTypeKey = c.CenterTypeKey
        left outer join HC_BI_MKTG_DDS.bi_mktg_dds.DimContact    dcon
            on dcon.SFDC_LeadID = dc.SFDC_Leadid
        left outer join HC_BI_MKTG_DDS.bi_mktg_dds.FactLead      fl
            on fl.ContactKey = dcon.ContactKey
        left outer join HC_BI_ENT_DDS.bief_dds.DimDate           fldd
            on fl.LeadCreationDateKey = fldd.DateKey
        left outer join HC_BI_ENT_DDS.bi_ent_dds.DimHairLossType hlt
            on fl.HairLossTypeKey = hlt.HairLossTypeKey
        left outer join #MemberFirst                             mf
            on dc.ClientIdentifier = mf.ClientIdentifier
               and mf.RowID = 1
        left outer join #MemberCurrent                           mc
            on dc.ClientIdentifier = mc.ClientIdentifier
               and mf.BusinessSegment = mc.BusinessSegment
               and mc.RowID = 1
        left outer join #MemberRevenue                           mr
            on dc.ClientIdentifier = mr.ClientIdentifier
        left outer join HC_BI_MKTG_DDS.bi_mktg_dds.DimSource     dsource
            on fl.SourceKey = dsource.SourceKey
    where (
              mc.ClientIdentifier is not null
              and mr.ClientIdentifier is not null
          );

end;
GO
