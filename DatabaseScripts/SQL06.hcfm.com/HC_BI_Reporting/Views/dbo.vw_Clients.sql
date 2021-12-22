/* CreateDate: 01/04/2014 10:04:43.883 , ModifyDate: 08/04/2015 16:13:43.697 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Clients]
AS
SELECT  DC.CenterID
,       DC.CenterDescription
,       DC.LeadID
,       DC.ClientIdentifier
,       DC.FirstName
,       DC.LastName
,       DC.FullName
,       DC.Address1
,       DC.Address2
,       DC.State
,       DC.City
,       DC.ZipCode
,       DC.Country
,       DC.HomePhone
,       DC.WorkPhone
,       DC.CellPhone
,       DC.DateOfBirth
,       DC.EmailAddress
,       DC.SiebelID
,       DC.Gender
,       DC.Age
,       DC.Ethinicity
,       DC.Occupation
,       DC.MaritalStatus
,       DC.ARBalance
,       DC.InitialSaleDate
,       DC.MembershipSold
,       DC.SoldBy
,       DC.InitialApplicationDate
,       DC.ConversionDate
,       DC.ConvertedTo
,       DC.ConvertedBy
,       DC.FirstAppointmentDate
,       DC.LastAppointmentDate
,       DC.NextAppointmentDate
,       DC.BIO_Membership
,       DC.BIO_BeginDate
,       DC.BIO_EndDate
,       DC.BIO_MembershipStatus
,       DC.BIO_MonthlyFee
,       DC.BIO_ContractPrice
,       DC.BIO_FirstPaymentDate
,       DC.BIO_LastPaymentDate
,       DC.BIO_TotalPayments
,       DC.BIO_CancelDate
,       DC.BIO_CancelReason
,       DC.EXT_Membership
,       DC.EXT_BeginDate
,       DC.EXT_EndDate
,       DC.EXT_MembershipStatus
,       DC.EXT_MonthlyFee
,       DC.EXT_ContractPrice
,       DC.EXT_FirstPaymentDate
,       DC.EXT_LastPaymentDate
,       DC.EXT_TotalPayments
,       DC.EXT_CancelDate
,       DC.EXT_CancelReason
,       DC.SUR_Membership
,       DC.SUR_BeginDate
,       DC.SUR_EndDate
,       DC.SUR_MembershipStatus
,       DC.SUR_MonthlyFee
,       DC.SUR_ContractPrice
,       DC.SUR_FirstPaymentDate
,       DC.SUR_LastPaymentDate
,       DC.SUR_TotalPayments
,       DC.SUR_CancelDate
,       DC.SUR_CancelReason
,       DC.XTR_Membership
,       DC.XTR_BeginDate
,       DC.XTR_EndDate
,       DC.XTR_MembershipStatus
,       DC.XTR_MonthlyFee
,       DC.XTR_ContractPrice
,       DC.XTR_FirstPaymentDate
,       DC.XTR_LastPaymentDate
,       DC.XTR_TotalPayments
,       DC.XTR_CancelDate
,       DC.XTR_CancelReason
,       DC.DoNotCallFlag
,       DC.DoNotContactFlag
FROM    HC_Accounting.dbo.dbaClient DC
GO
