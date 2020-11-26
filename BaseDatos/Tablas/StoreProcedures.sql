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

DROP PROCEDURE SPRegistroCliente
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

CREATE PROCEDURE cambiarPassword (
									@_idCliente		INT,
									@_password		NVARCHAR(256),
									@_nuevaPassword	NVARCHAR(256)

								 )
AS
	DECLARE @_estado		BIT,
			@_message		NVARCHAR(100),
			@_codigoError	INT,
			@_messageError	NVARCHAR(100),
			@_filasAfectadas INT,
			@_passwordDB	NVARCHAR(100);
BEGIN
	SET @_estado = 0;
	
	BEGIN TRANSACTION
		BEGIN TRY
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
					SET @_message = 'La contraseña es incorrecta';
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
		END CATCH

		IF @_filasAfectadas > 0
		BEGIN
			SET @_estado = 1;
				SET @_message = 'Contraseña actualizada exitosamente';
				SELECT @_estado AS Estado, @_message AS Message, @_filasAfectadas AS Filas_Afectadas;
				COMMIT;
		END
END
