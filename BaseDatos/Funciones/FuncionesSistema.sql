/*****************************************************************/
/*************************** FUNCIONES **************************/
/****************************************************************/


use ShoppingCart;
/*
	Funcion Verificar el estado del token de los usuarios
	Fecha Creacion 11/24/2020
	Autor: Miguel Gongora
*/

CREATE FUNCTION VerificarEstadoTokenUsuario	(
											@_token			NVARCHAR(256),
											@_idUsuario		INT
										)
RETURNS BIT
AS 
BEGIN
	DECLARE @_Resultado				BIT,
			@_fechaYHoraCreacion	DATETIME,
			@_vigenciaMinutos		INT,
			@_tiempoSinUso			INT;
		
		SELECT @_fechaYHoraCreacion = t.fechaIngreso
		FROM TokenUsuario t
		WHERE t.token = @_token
		AND t.id_usuario = @_idUsuario
		AND t.estado = 1;

		SET @_fechaYHoraCreacion = ISNULL(@_fechaYHoraCreacion, '2001-01-01 01:01:01.001') 


		SET @_vigenciaMinutos = 30
		

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


CREATE PROC	SPActualizarVigenciaTokenUsuario	(
													@_token	NVARCHAR(250)
												)
AS
BEGIN
	--Actualizar Token
	UPDATE	TokenUsuario
	SET		FechaIngreso				= GETDATE()
	WHERE	token						= @_token
			AND estado					= 1
END


CREATE FUNCTION FNObtenerIdUsuario(
									@_token NVARCHAR(256)
									) RETURNS INT
AS
BEGIN
	DECLARE @_idUsuario INT;
	SELECT  @_idUsuario = id_usuario
	FROM TokenUsuario
	WHERE	token = @_token
	AND		estado = 1;

	RETURN ISNULL(@_idUsuario, 0);
END

CREATE PROCEDURE SPCambiarEstadoTokenUsuario	(
												@_token	NVARCHAR(256)
												)
AS
BEGIN
	UPDATE TokenUsuario
	SET estado = 0
	WHERE token = @_token;
END