/* CreateDate: 05/12/2010 11:13:08.690 , ModifyDate: 05/13/2010 14:50:06.207 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimMembership] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimMembership]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimMembership]()
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

 	SET @TableName = N'[bi_cms_dds].[DimMembership]'


	INSERT INTO @tbl
		SELECT @TableName, MembershipKey, CAST(MembershipSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimMembership] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimMembership] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
