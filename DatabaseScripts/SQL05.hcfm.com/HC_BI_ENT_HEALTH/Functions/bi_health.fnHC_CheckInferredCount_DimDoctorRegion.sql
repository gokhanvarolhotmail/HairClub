/* CreateDate: 05/12/2010 11:28:43.250 , ModifyDate: 05/13/2010 14:46:55.410 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimDoctorRegion] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimDoctorRegion]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimDoctorRegion]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, FieldKey bigint
					, FieldSSID varchar(150)
					)  AS
BEGIN



	DECLARE	  @TableName				varchar(150)	-- Name of table

 	SET @TableName = N'[bi_cms_dds].[DimDoctorRegion]'


	INSERT INTO @tbl
		SELECT @TableName, DoctorRegionKey, CAST(DoctorRegionSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimDoctorRegion] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimDoctorRegion] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
