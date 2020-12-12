/********************************************************/
/*****************STORE PROCEDURE************************/
/********************************************************/

/*
	Fecha Creacion 11/22/2020
	Autor: Miguel Gongora
*/
CREATE PROCEDURE obtenerDepartamentos
AS
BEGIN  
	SELECT * FROM DEPARTAMENTO
END


/*
	Fecha Creacion 11/22/2020
	Autor: Miguel Gongora
*/

CREATE PROCEDURE obtenerDepartamento(
										@_idDepartamento INT
									)
AS
BEGIN
		SELECT * 
		FROM Departamento
		WHERE id_departamento = @_idDepartamento;
END



/*
	Obtener municipios por departamento
	Fecha Creacion 11/22/2020
	Autor: Miguel Gongora
*/
CREATE PROCEDURE obtenerMunicipios(
									@_idDepartamento INT
									)
AS
BEGIN
		SELECT id_municipio, municipio, codigoPostal
		FROM Municipio
		WHERE id_departamento = @_idDepartamento
END

/*
	GUARDAR NUEVO CLIENTE
	Fecha Creacion 11/22/2020
	Autor: Miguel Gongora
*/

CREATE PROCEDURE SPRegistroCliente (
									@_nombre			NVARCHAR(50),
									@_apellido			NVARCHAR(50),
									@_fechaNacimiento	DATE,
									@_email				NVARCHAR(100),
									@_password			NVARCHAR(256),
									@_telefono			NVARCHAR(8),
									@_telefono2			NVARCHAR(8) = NULL,
									@_token				NVARCHAR(256)
									)
AS
	DECLARE @_idCliente		INT,
			@_estado		BIT,
			@_message		NVARCHAR(100),
			@_codigoError	INT,
			@_messageError	NVARCHAR(250),
			@_ultimoId		INT,
			@_filasAfectadas INT, 
			@_idToken		INT,
			@_expiration	INT;
BEGIN
	
	BEGIN TRANSACTION
		SELECT @_ultimoId = ISNULL(MAX(id_cliente), 0)
		FROM Cliente;
		SET @_estado = 0;

		SELECT @_idToken = ISNULL(MAX(id_token),0)
		FROM TokenCliente;

		SELECT @_expiration = CAST(valor AS INTEGER) FROM Parametros;

		BEGIN TRY
			INSERT INTO Cliente ( 
									id_cliente,
									nombre,
									apellido,
									fechaNacimiento,
									fechaIngreso,
									email,
									password,
									ultimaSession,
									telefono,
									telefono2
								)
			VALUES				(
									@_ultimoId + 1,
									@_nombre,
									@_apellido,
									@_fechaNacimiento,
									GETDATE(),
									@_email,
									@_password,
									GETDATE(),
									@_telefono,
									@_telefono2
								);
			SET @_filasAfectadas = @@ROWCOUNT;

			INSERT INTO TokenCliente	(
										id_token,
										token,
										expiracion,
										id_cliente,
										fechaIngreso,
										estado
										)
			VALUES						(
										@_idToken + 1,
										@_token,
										@_expiration,
										@_ultimoId + 1,
										GETDATE(),
										1
										);

		SET @_filasAfectadas += @@ROWCOUNT;

		END TRY
		BEGIN CATCH
			SET @_messageError = ERROR_MESSAGE();
			SET @_codigoError = ERROR_NUMBER();
			SET @_message = 'Ha ocurrido un error, por favor intenta mas tarde.';
			SET @_filasAfectadas = 0;
			 
		END CATCH

		IF @_filasAfectadas > 0
			BEGIN
				SET @_estado = 1;
				SET @_message = 'Registro realizado exitosamente';
				SELECT @_estado AS Estado, 
					   @_message AS Message, 
					   @_filasAfectadas AS Filas_Afectadas,
					   @_token AS Token;
				COMMIT;
			END
		ELSE
			BEGIN
				SELECT	@_estado AS Estado, 
						@_message AS Message, 
						@_messageError AS Message_Error, 
						@_codigoError AS Number_error,
						NULL AS Token
						ROLLBACK;
			END
END


/*
	Actualizar Datos Cliente
	Fecha Creacion 11/22/2020
	Autor: Miguel Gongora
*/
CREATE PROCEDURE ModificarCliente (
									@_idCliente			INT,
									@_nombre			NVARCHAR(50),
									@_apellido			NVARCHAR(50),
									@_fechaNacimiento	DATE,
									@_telefono			NVARCHAR(8),
									@_telefono2			NVARCHAR(8) 
									)
AS
	DECLARE @_estado		BIT,
			@_message		NVARCHAR(100),
			@_codigoError	INT,
			@_messageError	NVARCHAR(100),
			@_ultimoId		INT,
			@_filasAfectadas INT
BEGIN
	
	BEGIN TRANSACTION
		SET @_estado = 0;
		BEGIN TRY

			UPDATE Cliente 
			SET				nombre		= @_nombre,
							apellido	= @_apellido,
							fechaNacimiento = @_fechaNacimiento,
							telefono	= @_telefono,
							telefono2	= @_telefono2
			WHERE			id_cliente = @_idCliente;
			

			SET @_filasAfectadas = @@ROWCOUNT;
		END TRY
		BEGIN CATCH
			SET @_messageError = ERROR_MESSAGE();
			SET @_codigoError = ERROR_NUMBER();
			SET @_message = 'Ha ocurrido un error, por favor intenta mas tarde.';
			SET @_filasAfectadas = 0;
			 
		END CATCH

		IF @_filasAfectadas > 0
			BEGIN
				SET @_estado = 1;
				SET @_message = 'Datos actualizados exitosamente';
				SELECT @_estado AS Estado, @_message AS Message, @_filasAfectadas AS Filas_Afectadas;
				COMMIT;
			END
		ELSE
			BEGIN
				SELECT	@_estado AS Estado, 
						@_message AS Message, 
						@_messageError AS Message_Error, 
						@_codigoError AS Number_error;
						ROLLBACK;
			END
END

/*
	Cambiar Password
	Fecha Creacion 11/22/2020
	Autor: Miguel Gongora
*/
DROP PROCEDURE SPCambiarPassword
CREATE PROCEDURE SPCambiarPassword (
									@_password		NVARCHAR(256),
									@_nuevaPassword	NVARCHAR(256),
									@_token			NVARCHAR(256),
									@_idCliente		INT
								 )
AS
	DECLARE @_estado		BIT,
			@_message		NVARCHAR(100),
			@_codigoError	INT,
			@_messageError	NVARCHAR(100),
			@_filasAfectadas INT,
			@_estadoToken	INTEGER,
			@_passwordDB	NVARCHAR(256)
BEGIN
	SET @_estado = 0;


	SELECT @_estadoToken = dbo.VerificarEstadoToken(@_token, @_idCliente);
	-- ESTADO 0 = TokenExpirado
	-- ESTADO 1 = TokenVigente
	IF(@_estadoToken = 1)
	BEGIN	
		BEGIN TRY
		BEGIN TRANSACTION

				SELECT @_passwordDB = password 
				FROM CLIENTE 
				WHERE id_cliente = @_idCliente;
				IF @_password = @_passwordDB
					BEGIN
						UPDATE Cliente
						SET				password = @_nuevaPassword
						WHERE id_cliente = @_idCliente;

						SET @_filasAfectadas = @@ROWCOUNT;
					END
				ELSE
					BEGIN
						SET @_estado = 0;
						SET @_message = 'La contraseña no coincide con nuestros registros';
						SELECT @_estado AS Estado, @_message AS Message
						ROLLBACK;
					END
		END TRY
		BEGIN CATCH
				SET @_messageError = ERROR_MESSAGE();
				SET @_codigoError = ERROR_NUMBER();
				SET @_message = 'Ha ocurrido un error, por favor intenta mas tarde.';
				SET @_filasAfectadas = 0;

				SELECT	@_estado AS Estado, 
							@_message AS Message, 
							@_messageError AS Message_Error, 
							@_codigoError AS Number_error;
				ROLLBACK;
			END CATCH;
			IF @_filasAfectadas > 0
			BEGIN
				SET @_estado = 1;
					SET @_message = 'Contraseña actualizada exitosamente';
					EXEC SPActualizarVigenciaToken @_token
					SELECT @_estado AS Estado, @_message AS Message, @_filasAfectadas AS Filas_Afectadas;
					COMMIT;
			END
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

/*
	Agregar datos de Envio
	Fecha Creacion 11/22/2020
	Autor: Miguel Gongora
*/

DROP PROCEDURE SPGuardarDatosEnvio
CREATE PROCEDURE SPGuardarDatosEnvio	(
											@_nombre		NVARCHAR(25),
											@_direccion		NVARCHAR(50),
											@_detalles		NVARCHAR(50),
											@_idMunicipio	SMALLINT = NULL,
											@_idCliente		INT,
											@_token			NVARCHAR(256)
										)
AS
	DECLARE @_estado		BIT,
			@_message		NVARCHAR(100),
			@_codigoError	INT,
			@_messageError	NVARCHAR(100),
			@_estadoToken	INTEGER,
			@_idDireccion	INT,
			@_filasAfectadas INT;
BEGIN
	SET @_estado = 0;

	SELECT @_estadoToken = dbo.VerificarEstadoToken(@_token, @_idCliente);
	-- ESTADO 0 = TokenExpirado
	-- ESTADO 1 = TokenVigente
	IF(@_estadoToken = 1)
	BEGIN
		BEGIN TRY
		BEGIN TRANSACTION
			
			SELECT @_idDireccion = ISNULL(MAX (id_direccion), 0)
			FROM DireccionesEnvio


			INSERT INTO	 DireccionesEnvio	(
												id_direccion,
												nombre,
												direccion,
												detalles, 
												id_municipio,
												id_cliente,
												estado
											)
						VALUES				(
												@_idDireccion + 1,
												@_nombre,
												@_direccion,
												@_detalles,
												@_idMunicipio,
												@_idCliente,
												1
											)
			
			SET @_filasAfectadas = @@ROWCOUNT;

			
										
						
		END TRY
		BEGIN CATCH
			SET @_filasAfectadas = 0
		END CATCH

		IF(@_filasAfectadas > 0)
		BEGIN
			SET @_estado = 1;
			SET @_message = 'Se ha guardado la direccion de envío correctamente'
			
			EXEC SPActualizarVigenciaToken @_token
			
			SELECT @_estado as Estado,
						@_message as Message;
			COMMIT
		END
		ELSE
		BEGIN
			SET @_messageError = ERROR_MESSAGE();
				SET @_codigoError = ERROR_NUMBER();
				SET @_message = 'Ha ocurrido un error, por favor intenta mas tarde.';
				SET @_filasAfectadas = 0;

				SELECT		@_estado AS Estado, 
							@_message AS Message, 
							@_messageError AS Message_Error, 
							@_codigoError AS Number_error;
				ROLLBACK;

		END

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

/*
	Modificar datos de Envio
	Fecha Creacion 11/22/2020
	Autor: Miguel Gongora
*/
CREATE PROCEDURE SPModificarDireccionEnvio	(
												@_idDireccion	INT,
												@_nombre		NVARCHAR(25),
												@_direccion		NVARCHAR(50),
												@_detalles		NVARCHAR(50) = NULL,
												@_idMunicipio	SMALLINT,
												@_idCliente		INT,
												@_token			NVARCHAR(256)
											)
AS
	DECLARE @_estado		BIT,
			@_message		NVARCHAR(100),
			@_codigoError	INT,
			@_messageError	NVARCHAR(100),
			@_estadoToken	INTEGER,
			@_filasAfectadas INT;
BEGIN
	SET @_estado = 0;

	SELECT @_estadoToken = dbo.VerificarEstadoToken(@_token, @_idCliente);
	-- ESTADO 0 = TokenExpirado
	-- ESTADO 1 = TokenVigente
	IF(@_estadoToken = 1)
	BEGIN
		BEGIN TRY
		BEGIN TRANSACTION

			UPDATE	 DireccionesEnvio
			SET		nombre		= @_nombre,
					direccion	= @_direccion,
					detalles	= @_detalles,
					id_municipio= @_idMunicipio
			WHERE	id_direccion= @_idDireccion
			AND		id_cliente	= @_idCliente
			AND		estado		= 1;
			
			SET @_filasAfectadas = @@ROWCOUNT;

			
										
						
		END TRY
		BEGIN CATCH
			SET @_filasAfectadas = 0
		END CATCH

		IF(@_filasAfectadas > 0)
		BEGIN
			SET @_estado = 1;
			SET @_message = 'Se ha actualizado la direccion de envío correctamente'
			EXEC SPActualizarVigenciaToken @_token
			SELECT @_estado as Estado,
						@_message as Message;
			COMMIT
		END
		ELSE
		BEGIN
			SET @_messageError = ERROR_MESSAGE();
				SET @_codigoError = ERROR_NUMBER();
				SET @_message = 'Ha ocurrido un error, por favor intenta mas tarde.';
				SET @_filasAfectadas = 0;

				SELECT		@_estado AS Estado, 
							@_message AS Message, 
							@_messageError AS Message_Error, 
							@_codigoError AS Number_error;
				ROLLBACK;

		END

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


/*
	Obtener datos de Envio
	Fecha Creacion 11/22/2020
	Autor: Miguel Gongora
*/
CREATE PROCEDURE SPObtenerDireccionesEnvio (
												@_idCliente INT,
												@_token		NVARCHAR(256)
											)
AS
DECLARE		@_estado			BIT,
			@_message			NVARCHAR(100),
			@_codigoError		INT,
			@_messageError		NVARCHAR(100),
			@_estadoToken		INTEGER,
			@_filasAfectadas	INT,
			@_totalDirecciones	INT;
BEGIN
	SET @_estado = 0;

	SELECT @_estadoToken = dbo.VerificarEstadoToken(@_token, @_idCliente);
	-- ESTADO 0 = TokenExpirado
	-- ESTADO 1 = TokenVigente
	IF(@_estadoToken = 1)
	BEGIN
		SELECT @_totalDirecciones = count(1)
		FROM DireccionesEnvio 
		WHERE id_cliente = 3
		AND estado = 1;

		IF @_totalDirecciones > 0
		BEGIN
			SELECT	de.id_direccion,
					de.nombre,
					de.direccion,
					de.detalles,
					de.id_municipio,
					m.municipio,
					d.id_departamento,
					d.departamento
			FROM DireccionesEnvio de
			INNER JOIN Municipio m
			ON de.id_municipio = m.id_municipio
			INNER JOIN Departamento d
			ON d.id_departamento = m.id_departamento
			WHERE de.id_cliente = @_idCliente
			AND	  de.estado = 1;
		END
		ELSE
		BEGIN
			SET @_message = 'Parace que no tienes ninguna dirección guardada, haz click acá para agregar una nueva';
			SET @_estado  = 1
			SELECT @_estado AS Estado,
					@_message AS Message;
		END
		EXEC SPActualizarVigenciaToken @_token
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


/*
	Obtener Direccion de Envio
	Fecha Creacion 11/22/2020
	Autor: Miguel Gongora
*/
CREATE PROCEDURE SPObtenerDireccionEnvio (
												@_idDireccion	INT,
												@_idCliente		INT,
												@_token			NVARCHAR(256)
											)
AS
DECLARE		@_estado			BIT,
			@_message			NVARCHAR(100),
			@_codigoError		INT,
			@_messageError		NVARCHAR(100),
			@_estadoToken		INTEGER,
			@_filasAfectadas	INT,
			@_totalDirecciones	INT;
BEGIN
	SET @_estado = 0;

	SELECT @_estadoToken = dbo.VerificarEstadoToken(@_token, @_idCliente);
	-- ESTADO 0 = TokenExpirado
	-- ESTADO 1 = TokenVigente
	IF(@_estadoToken = 1)
	BEGIN
			SELECT	de.id_direccion,
					de.nombre,
					de.direccion,
					de.detalles,
					de.id_municipio,
					m.municipio,
					d.id_departamento,
					d.departamento
			FROM DireccionesEnvio de
			INNER JOIN Municipio m
			ON de.id_municipio = m.id_municipio
			INNER JOIN Departamento d
			ON d.id_departamento = m.id_departamento
			WHERE de.id_cliente = @_idCliente
			AND  de.id_direccion = @_idDireccion
			AND	  de.estado = 1;
		
		EXEC SPActualizarVigenciaToken @_token
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


/*
	Eliminar Direccion de Envio
	Fecha Creacion 11/22/2020
	Autor: Miguel Gongora
*/
CREATE PROCEDURE SPEliminarDireccionEnvio (
												@_idDireccion	INT,
												@_idCliente		INT,
												@_token			NVARCHAR(256)
											)
AS
DECLARE		@_estado			BIT,
			@_message			NVARCHAR(100),
			@_codigoError		INT,
			@_messageError		NVARCHAR(100),
			@_estadoToken		INTEGER,
			@_filasAfectadas	INT,
			@_totalDirecciones	INT;
BEGIN
	SET @_estado = 0;

	SELECT @_estadoToken = dbo.VerificarEstadoToken(@_token, @_idCliente);
	-- ESTADO 0 = TokenExpirado
	-- ESTADO 1 = TokenVigente
	IF(@_estadoToken = 1)
	BEGIN
		BEGIN TRY
		BEGIN TRANSACTION

			UPDATE DireccionesEnvio
			SET estado = 0
			WHERE id_cliente = @_idCliente
			AND id_direccion = @_idDireccion
			EXEC SPActualizarVigenciaToken @_token

			SET @_filasAfectadas = @@ROWCOUNT;

			EXEC SPActualizarVigenciaToken @_token

		END TRY
		BEGIN CATCH
			SET @_estado = 0;
			SET @_filasAfectadas = 0
			SET @_messageError = ERROR_MESSAGE();
			SET @_codigoError = ERROR_NUMBER();
			SET @_message = 'Ha ocurrido un error, por favor intenta mas tarde.';
			SET @_filasAfectadas = 0;
		END CATCH
		
		IF(@_filasAfectadas > 0)
		BEGIN
			SET @_estado = 1;
			SET @_message = 'Se ha actualizado la direccion de envío correctamente'
			SELECT	@_estado as Estado,
					@_message as Message;
			COMMIT;
		END
		ELSE
		BEGIN
			SELECT	@_estado AS Estado, 
					@_message AS Message, 
					@_messageError AS Message_Error, 
					@_codigoError AS Number_error;
				ROLLBACK;
		END


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

