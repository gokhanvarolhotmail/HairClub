/* CreateDate: 07/30/2015 15:49:41.780 , ModifyDate: 07/30/2015 15:49:41.780 */
GO
create procedure [sp_MSins_dboCampaignResults]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 varchar(40),
    @c5 int,
    @c6 varchar(50),
    @c7 smalldatetime,
    @c8 varchar(10),
    @c9 tinyint,
    @c10 varchar(10),
    @c11 varchar(10),
    @c12 varchar(25),
    @c13 varchar(30),
    @c14 varchar(60),
    @c15 varchar(60),
    @c16 varchar(60),
    @c17 char(2),
    @c18 varchar(25),
    @c19 char(20),
    @c20 varchar(30),
    @c21 tinyint,
    @c22 varchar(50),
    @c23 tinyint,
    @c24 varchar(30),
    @c25 tinyint,
    @c26 char(50),
    @c27 varchar(30),
    @c28 varchar(30),
    @c29 smalldatetime,
    @c30 smalldatetime,
    @c31 varchar(50),
    @c32 int,
    @c33 varchar(100),
    @c34 varchar(50),
    @c35 varchar(30),
    @c36 varchar(30),
    @c37 int
as
begin
	insert into [dbo].[CampaignResults](
		[ResultsID],
		[CampaignID],
		[Center],
		[CenterName],
		[RegionID],
		[Region],
		[ApptDate],
		[Gender],
		[GenderID],
		[RecordID],
		[ContactID],
		[FirstName],
		[LastName],
		[Address1],
		[Address2],
		[City],
		[State],
		[Zip],
		[Phone],
		[Ethnicity],
		[EthnicityID],
		[Age],
		[AgeID],
		[MaritalStatus],
		[MaritalStatusID],
		[Email],
		[Member1],
		[Member2],
		[CreationDate],
		[CancelTrxDate],
		[NoSaleReason],
		[CancelReasonID],
		[CancelReason],
		[Occupation],
		[Ludwig],
		[Norwood],
		[Client_No]
	) values (
    @c1,
    @c2,
    @c3,
    @c4,
    @c5,
    @c6,
    @c7,
    @c8,
    @c9,
    @c10,
    @c11,
    @c12,
    @c13,
    @c14,
    @c15,
    @c16,
    @c17,
    @c18,
    @c19,
    @c20,
    @c21,
    @c22,
    @c23,
    @c24,
    @c25,
    @c26,
    @c27,
    @c28,
    @c29,
    @c30,
    @c31,
    @c32,
    @c33,
    @c34,
    @c35,
    @c36,
    @c37	)
end
GO
