/* CreateDate: 10/04/2019 14:09:30.420 , ModifyDate: 10/04/2019 14:09:30.420 */
GO
create procedure [sp_MSins_dboPromoCode__c]
    @c1 int,
    @c2 nvarchar(50),
    @c3 nvarchar(50),
    @c4 bit,
    @c5 nvarchar(18),
    @c6 datetime,
    @c7 nvarchar(18),
    @c8 datetime
as
begin
	insert into [dbo].[PromoCode__c] (
		[Id],
		[PromoCode__c],
		[PromoCodeDescription__c],
		[IsActiveFlag],
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
		@c8	)
end
GO
