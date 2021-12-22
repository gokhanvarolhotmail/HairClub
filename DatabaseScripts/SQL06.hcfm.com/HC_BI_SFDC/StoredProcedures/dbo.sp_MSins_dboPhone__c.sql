/* CreateDate: 10/04/2019 14:09:30.390 , ModifyDate: 10/04/2019 14:09:30.390 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSins_dboPhone__c]
    @c1 nvarchar(18),
    @c2 nvarchar(18),
    @c3 nchar(10),
    @c4 nchar(10),
    @c5 nvarchar(80),
    @c6 nvarchar(50),
    @c7 bit,
    @c8 bit,
    @c9 bit,
    @c10 bit,
    @c11 datetime,
    @c12 bit,
    @c13 bit,
    @c14 int,
    @c15 nvarchar(50),
    @c16 bit,
    @c17 nvarchar(50),
    @c18 bit,
    @c19 nvarchar(18),
    @c20 datetime,
    @c21 nvarchar(18),
    @c22 datetime
as
begin
	insert into [dbo].[Phone__c] (
		[Id],
		[Lead__c],
		[ContactPhoneID__c],
		[OncContactID__c],
		[Name],
		[PhoneAbr__c],
		[DoNotCall__c],
		[DoNotText__c],
		[DNCFlag__c],
		[EBRDNC__c],
		[EBRDNCDate__c],
		[Wireless__c],
		[Primary__c],
		[SortOrder__c],
		[Status__c],
		[ValidFlag__c],
		[Type__c],
		[IsDeleted],
		[CreatedById],
		[CreatedDate],
		[LastModifiedById],
		[LastModifiedDate]
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
		@c22	)
end
GO
