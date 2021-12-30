/* CreateDate: 01/03/2018 16:31:33.633 , ModifyDate: 01/03/2018 16:31:33.633 */
GO
create procedure [dbo].[sp_MSins_dboonca_job_function]
    @c1 nchar(10),
    @c2 nchar(50),
    @c3 nchar(1)
as
begin
	insert into [dbo].[onca_job_function](
		[job_function_code],
		[description],
		[active]
	) values (
    @c1,
    @c2,
    @c3	)
end
GO
