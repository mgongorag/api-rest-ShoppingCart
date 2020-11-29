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
											@_token			NVARCHAR(256),
											@_idCliente		INT
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
		WHERE t.token = @_token
		AND t.id_cliente = @_idCliente
		AND t.estado = 1;

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


CREATE PROC	SPActualizarVigenciaToken	(
													@_token	NVARCHAR(250)
												)
AS
BEGIN
	--Actualizar Token
	UPDATE	TokenCliente
	SET		FechaIngreso				= GETDATE()
	WHERE	token						= @_token
			AND estado					= 1
END


CREATE FUNCTION FNObtenerId(
								@_token NVARCHAR(256)
							) RETURNS INT
AS
BEGIN
	DECLARE @_id_cliente INT;
	SELECT  @_id_cliente = id_cliente
	FROM TokenCliente
	WHERE	token = @_token
	AND		estado = 1;

	RETURN ISNULL(@_id_cliente, 0);
END

CREATE PROCEDURE SPCambiarEstadoToken	(
											@_token	NVARCHAR(256)
										)
AS
BEGIN
	UPDATE TokenCliente
	SET estado = 0
	WHERE token = @_token;
END