/*****************************************************************/
/*************************** FUNCIONES **************************/
/****************************************************************/



/*
	Funcion Verificar el estado del token
	Fecha Creacion 11/24/2020
	Autor: Miguel Gongora
*/
CREATE FUNCTION VerificarEstadoToken	(
											@_token NVARCHAR(256)
										)
RETURNS BIT
AS 
BEGIN
	DECLARE @_Resultado				BIT,
			@_fechaYHoraCreacion	DATETIME,
			@_vigenciaMinutos		INT,
			@_tiempoSinUso			DATETIME;

		SELECT @_fechaYHoraCreacion = t.fechaIngreso 
		FROM TokenCliente t
		WHERE token = @_token 
		AND estado = 1;

		SELECT @_vigenciaMinutos = CAST(valor AS INTEGER) 
		FROM Parametros 
		where id_parametro = 1;

		SET @_tiempoSinUso = DATEDIFF(MINUTE, @_fechaYHoraCreacion, GETDATE());

		IF(@_tiempoSinUso > @_vigenciaMinutos) 
			BEGIN
				SET @_Resultado = 0;
			END
		ELSE
			BEGIN
				SET @_Resultado = 1
			END
	RETURN @_Resultado;
END




