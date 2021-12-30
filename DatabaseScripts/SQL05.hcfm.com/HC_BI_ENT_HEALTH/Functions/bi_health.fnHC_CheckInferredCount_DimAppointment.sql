/* CreateDate: 10/24/2011 13:27:33.660 , ModifyDate: 10/24/2011 13:28:56.673 */
GO
CREATE   FUNCTION [bi_health].[fnHC_CheckInferredCount_DimAppointment] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimAppointment]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimAppointment]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0	10/23/11  KMurdoch     Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, FieldKey bigint
					, FieldSSID varchar(150)
					)  AS
BEGIN



	DECLARE	  @TableName				varchar(150)	-- Name of table

 	SET @TableName = N'[bi_cms_dds].[DimAppointment]'


	INSERT INTO @tbl
		SELECT @TableName, AppointmentKey, CAST(AppointmentSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimAppointment] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimAppointment] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
