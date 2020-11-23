/********************************************************/
/*****************BASE DE DATOS *************************/
/********************************************************/

CREATE TABLE Departamento (
	id_departamento SMALLINT NOT NULL,
	departamento NVARCHAR(60) NOT NULL,
	CONSTRAINT id_departamentoPK PRIMARY KEY (id_departamento)
						  )

CREATE TABLE Municipio (
	id_municipio SMALLINT NOT NULL,
	municipio NVARCHAR(60) NOT NULL,
	codigoPostal INT NOT NULL,
	id_departamento SMALLINT NOT NULL,
	CONSTRAINT id_municipioPK PRIMARY KEY (id_municipio),
	CONSTRAINT id_departamentoFK FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento)
	)

CREATE TABLE Cliente (
	id_cliente		INT NOT NULL,
	nombre			NVARCHAR(50) NOT NULL,
	apellido		NVARCHAR(50) NOT NULL,
	fechaNacimiento	DATE NOT NULL,
	fechaIngreso	DATE NOT NULL,
	email			NVARCHAR(100) NOT NULL UNIQUE,
	password		NVARCHAR(256) NOT NULL,
	ultimaSession	DATETIME NOT NULL,
	telefono		NVARCHAR(8),
	telefono2		NVARCHAR(8),
	estado			BIT NOT NULL DEFAULT 1,
	CONSTRAINT id_clientePK PRIMARY KEY (id_cliente)
	)


CREATE TABLE DireccionesEnvio (
	id_direccion	INT NOT NULL,
	nombre			NVARCHAR(35) NOT NULL,
	direccion		NVARCHAR(35) NOT NULL,
	detalles		NVARCHAR(50),
	id_municipio	SMALLINT NOT NULL,
	id_cliente		INT NOT NULL,
	CONSTRAINT id_direccionPK PRIMARY KEY (id_direccion),
	FOREIGN KEY (id_municipio) REFERENCES Municipio(id_municipio),
	FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
	)