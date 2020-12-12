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

CREATE TABLE TokenCliente (
	id_token			INT NOT NULL,
	token			NVARCHAR(256) NOT NULL,
	expiracion		INT NOT NULL,
	id_cliente		INT NOT NULL,
	fechaIngreso	DATETIME NOT NULL,
	estado			BIT DEFAULT 1,
	CONSTRAINT idTokenclientePK PRIMARY KEY (id_token),
	FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
	)

CREATE TABLE DireccionesEnvio (
	id_direccion	INT NOT NULL,
	nombre			NVARCHAR(35) NOT NULL,
	direccion		NVARCHAR(50) NOT NULL,
	detalles		NVARCHAR(50),
	id_municipio	SMALLINT NOT NULL,
	id_cliente		INT NOT NULL,
	estado			BIT DEFAULT 1,
	CONSTRAINT id_direccionPK PRIMARY KEY (id_direccion),
	FOREIGN KEY (id_municipio) REFERENCES Municipio(id_municipio),
	FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
	);

CREATE TABLE Parametros(
	id_parametro INT NOT NULL,
	parametro NVARCHAR(50) NOT NULL,
	valor NVARCHAR(50) NOT NULL,
	descripcion NVARCHAR(100) NOT NULL,
	llave NVARCHAR(20) NOT NULL UNIQUE,
	CONSTRAINT id_parametroPK PRIMARY KEY (id_parametro)
	)

CREATE TABLE Categorias(
	id_categoria	INT NOT NULL,
	categoria		NVARCHAR(50) NOT NULL,
	descripcion		NVARCHAR(100) NOT NULL
	CONSTRAINT id_categoriaPK PRIMARY KEY(id_categoria)
	)

CREATE TABLE SubCategorias(
	id_subCategoria	INT NOT NULL,
	subCategoria	NVARCHAR(50) NOT NULL,
	descripcion		NVARCHAR(100) NOT NULL
	CONSTRAINT id_subCategoriaPK PRIMARY KEY(id_subCategoria),
	FOREIGN KEY (id_subCategoria) REFERENCES Categorias (id_categoria)
	)

CREATE TABLE  Marca (
	id_marca INT NOT NULL,
	marca	 NVARCHAR(150) NOT NULL,
	CONSTRAINT id_marcaPK PRIMARY KEY(id_marca)
)

CREATE TABLE Tienda (
	id_tienda	INT NOT NULL,
	nombre		NVARCHAR(100) NOT NULL,
	eslogan		NVARCHAR(250) NOT NULL,
	mision		NVARCHAR(250) NOT NULL,
	vision		NVARCHAR(250) NOT NULL,
	PRIMARY KEY (id_tienda)
)

CREATE TABLE Sucursales(
	id_sucursal	INT NOT NULL,
	sucursal	NVARCHAR(100) NOT NULL,
	direccion	NVARCHAR(100) NOT NULL,
	telefono	NVARCHAR(8) NOT NULL,
	estado		BIT DEFAULT 1 NOT NULL,
	id_tienda	INT NOT NULL,
	PRIMARY KEY(id_sucursal),
	FOREIGN KEY(id_tienda) REFERENCES Tienda(id_tienda)
)

CREATE TABLE Coordenada(
	id_coordenada	INT NOT NULL,
	altitud			DECIMAL(15,4) NOT NULL,
	latitud			DECIMAL(15,4) NOT NULL,
	id_sucursal		INT NOT NULL,
	PRIMARY KEY (id_coordenada),
	FOREIGN KEY (id_sucursal) REFERENCES Sucursales (id_sucursal)

)

CREATE TABLE DepartamentoEmpresa (
	id_departamento	INT NOT NULL,
	departamento	NVARCHAR(50) NOT NULL,
	estado			BIT,
	PRIMARY KEY (id_departamento)
)

CREATE TABLE Puesto  (
id_puesto	INT NOT NULL,
puesto		NVARCHAR(50) NOT NULL,
descripcion	NVARCHAR(100) NOT NULL,
estado		BIT,
id_departamento INT NOT NULL,
PRIMARY KEY (id_puesto),
FOREIGN KEY (id_departamento) REFERENCES DepartamentoEmpresa(id_departamento)
)

CREATE TABLE Usuario (
	id_usuario		INT NOT NULL,
	nombre			NVARCHAR(50) NOT NULL,
	apellido		NVARCHAR(50) NOT NULL,
	dpi				NVARCHAR(13) NOT NULL,
	cumpleanio		DATE NOT NULL,
	fechaIngreso	DATE NOT NULL,
	ultimaSession	DATETIME NOT NULL,
	id_puesto		INT NOT NULL,
	id_sucursal		INT NOT NULL,
	usuarioAgrega	int NOT NULL,
	PRIMARY KEY (id_usuario),
	FOREIGN KEY (id_puesto) REFERENCES Puesto (id_puesto),
	FOREIGN KEY (id_sucursal) REFERENCES Sucursales(id_sucursal),
	FOREIGN KEY (usuarioAgrega) REFERENCES Usuario(id_usuario)
	)

CREATE TABLE TokenUsuario (
	id_token		INT NOT NULL,
	token			NVARCHAR(256) NOT NULL,
	expiracion		SMALLINT NOT NULL,
	id_usuario		INT NOT NULL,
	fechaIngreso	DATETIME NOT NULL,
	estado			BIT NOT NULL,
	PRIMARY KEY (id_token),
	FOREIGN KEY (id_usuario) REFERENCES Usuario (id_usuario)
)

CREATE TABLE Pemisos (
	id_permiso				INT NOT NULL,
	actualizarInformacion	BIT NOT NULL,
	agregarUsuarios			BIT NOT NULL,
	actualizarUsuarios		BIT NOT NULL,
	agregarProductos		BIT NOT NULL,
	confirmarVenta			BIT NOT NULL,
	verVenta				BIT NOT NULL,
	verSaldos				BIT NOT NULL,
	verInventario			BIT NOT NULL,
	actualizarInventario	BIT NOT NULL,
	procesarCompra			BIT NOT NULL,
	eliminarCompra			BIT NOT NULL,
	actualizarCompra		BIT NOT NULL,
	agregarCuentas			BIT NOT NULL,
	cambiarPassword			BIT NOT NULL,
	id_usuario				INT FOREIGN KEY REFERENCES Usuario(id_usuario)
)


