
create function LOS_QUE_VAN_A_APROBAR.ObtenerNuevoRolInsertado()
returns int as
begin
return (select TOP(1) IdRol from LOS_QUE_VAN_A_APROBAR.Rol order by IdRol DESC)
end

