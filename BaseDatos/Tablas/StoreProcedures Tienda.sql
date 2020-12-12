/********************************************************/
/*****************STORE PROCEDURE************************/
/********************************************************/

--PROCEDIMIENTOS ALMACENADOS
CREATE PROCEDURE SPModificarInformacionTienda (
												@_idUsuario			INT,
												@_token				NVARCHAR(256),
												@_nombreTienda		NVARCHAR(100),
												@_eslogan			NVARCHAR(250),
												@_mision			NVARCHAR(250),
												@_vision			NVARCHAR(250) 
												)
AS
	DECLARE @_estado			BIT,
			@_message			NVARCHAR(100),
			@_codigoError		INT,
			@_messageError		NVARCHAR(100),
			@_filasAfectadas	INT,
			@_estadoToken		INTEGER,
			@_permiso			BIT;
BEGIN
	SET @_estado = 0;
	
	--Verificamos Estado Token
	SELECT @_estadoToken = dbo.VerificarEstadoTokenUsuario(@_token, @_idUsuario);

	--ESTADO 0 EXPIRADO
	--ESTADO 1 VIGENTE
	IF (@_estadoToken = 1)
	BEGIN
		--VERIFICAMOS SI TIENE PERMISO PARA MODIFICAR
		BEGIN TRY
			BEGIN TRANSACTION
				SELECT @_permiso = actualizarInformacion 
				FROM Permisos 
				WHERE id_usuario = @_idUsuario;

				IF @_permiso = 1
				BEGIN
					UPDATE Tienda
					SET nombre = @_nombreTienda,
						eslogan = @_eslogan,
						mision = @_mision,
						vision = @_vision
					WHERE id_tienda = 1;

					SET @_filasAfectadas = @@ROWCOUNT;

					IF(@_filasAfectadas > 0)
					BEGIN
						SET @_message = 'Se ha actualizado la información correctamente';
						SET @_filasAfectadas = 1;
						EXEC SPActualizarVigenciaTokenUsuario @_token;
						COMMIT;
					END
				
				END
				ELSE
				BEGIN
					SET @_message = 'No tienes permiso para actualizar esta información';
					SET @_filasAfectadas = 0;
				END 
		END TRY
		BEGIN CATCH
				SET @_messageError = ERROR_MESSAGE();
				SET @_codigoError = ERROR_NUMBER();
				SET @_message = 'Ha ocurrido un error, por favor intenta mas tarde.';
				SET @_filasAfectadas = 0;
				ROLLBACK;
		END CATCH
		SELECT	@_estado AS Estado,
				@_message AS Message,
				@_filasAfectadas AS filasAfectadas,
				@_messageError as MessageError,
				@_codigoError AS ErrorCode;
	END
	ELSE
	BEGIN
		EXEC SPCambiarEstadoToken @_token;
		SET @_message = 'Sesión expirada :(';
		SET @_estado = 0
		SELECT	@_estado as Estado,
				@_message as Message;
	END
END
 