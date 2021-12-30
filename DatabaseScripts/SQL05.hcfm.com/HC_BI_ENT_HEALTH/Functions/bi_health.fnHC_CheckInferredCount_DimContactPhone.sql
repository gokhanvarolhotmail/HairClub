/* CreateDate: 05/12/2010 10:57:03.777 , ModifyDate: 05/13/2010 14:46:14.350 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimContactPhone] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimContactPhone]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimContactPhone]()
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

 	SET @TableName = N'[bi_mktg_dds].[DimContactPhone]'


	INSERT INTO @tbl
		SELECT @TableName, ContactPhoneKey, ContactPhoneSSID
		FROM [bi_health].[synHC_DDS_DimContactPhone] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimContactPhone] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
