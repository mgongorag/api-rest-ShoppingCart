/*****************************************************************/
/*************************** FUNCIONES **************************/
/****************************************************************/


use ShoppingCart;
/*
	Funcion Verificar el estado del token
	Fecha Creacion 11/24/2020
	Autor: Miguel Gongora
*/
DROP FUNCTION VerificarEstadoToken

CREATE FUNCTION VerificarEstadoToken	(
											@_token NVARCHAR(256)
										)
RETURNS BIT
AS 
BEGIN
	DECLARE @_Resultado				BIT,
			@_fechaYHoraCreacion	DATETIME,
			@_vigenciaMinutos		INT,
			@_tiempoSinUso			INT;

		SELECT @_fechaYHoraCreacion = t.fechaIngreso
		FROM TokenCliente t
		WHERE token = @_token 
		AND estado = 1;

		SET @_fechaYHoraCreacion = ISNULL(@_fechaYHoraCreacion, '2001-01-01 01:01:01.001') 


		SET @_vigenciaMinutos = 60
		

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


CREATE PROC Sesion.SPActualizarVigenciaToken	(
													@_token	NVARCHAR(250)
												)
AS
BEGIN
	--ELIMINAR TOKENS EXPIRADOS
	DELETE TokenCliente
	WHERE estado = 0

	UPDATE	TokenCliente
	SET		FechaIngreso				= GETDATE()
	WHERE	token						= @_token
			AND estado				= 1
END









SELECT * FROM TokenCliente;

BEGIN
	DECLARE @_valido BIT;

	SELECT @_valido = dbo.VerificarEstadoToken('icM0EwULfvqlEASX6UjstJw6PhCMkGFHfGDMzo5JHI55mL53mhPgNbt0eawGpwiB4B8jDBiXiZapwwP4r4liCQKK');
	SELECT @_valido
END
