/* ============================================================
   SCRIPT 02 - IMPLEMENTACION FASE 3

   Script complementario al script generado por Oracle Data Modeler.
   Incluye organizacion por esquemas, indices, seguridad, objetos
   programables, reportes y pruebas.
   ============================================================ */

USE SonoraInc;
GO

/* ============================================================
   SECCION 1 - CREACION DE ESQUEMAS
   Objetivo:
   Organizar los objetos de la base de datos segun su funcion.
   ============================================================ */

	-- Creacion de esquemas
	CREATE SCHEMA Seguridad;
	GO

	CREATE SCHEMA Catalogo;
	GO

	CREATE SCHEMA Interaccion;
	GO

	CREATE SCHEMA Finanzas;
	GO

	CREATE SCHEMA Procesos;
	GO

	CREATE SCHEMA Reportes;
	GO

	--Movemos tablas a esquemas 

	-- SEGURIDAD
	ALTER SCHEMA Seguridad TRANSFER dbo.Usuario;

	-- CATALOGO
	ALTER SCHEMA Catalogo TRANSFER dbo.Cancion;
	ALTER SCHEMA Catalogo TRANSFER dbo.Album;
	ALTER SCHEMA Catalogo TRANSFER dbo.Artista;
	ALTER SCHEMA Catalogo TRANSFER dbo.Genero;
	ALTER SCHEMA Catalogo TRANSFER dbo.Productora;

	-- INTERACCION
	ALTER SCHEMA Interaccion TRANSFER dbo.Playlist;
	ALTER SCHEMA Interaccion TRANSFER dbo.CancionPlaylist;
	ALTER SCHEMA Interaccion TRANSFER dbo.UsuarioCancion;
	ALTER SCHEMA Interaccion TRANSFER dbo.UsuarioArtista;
	ALTER SCHEMA Interaccion TRANSFER dbo.Reproduccion;
	ALTER SCHEMA Interaccion TRANSFER dbo.ArtistaCancion;

	-- FINANZAS
	ALTER SCHEMA Finanzas TRANSFER dbo.Suscripcion;
	ALTER SCHEMA Finanzas TRANSFER dbo.Pago;
	ALTER SCHEMA Finanzas TRANSFER dbo.Regalia;



/* ============================================================
   SECCION 2 - INDICES
   Objetivo:
   Mejorar el rendimiento de consultas frecuentes y reportes.
   ============================================================ */

	USE SonoraInc;
	GO

	/* 
	   INDICES - CATALOGO
		*/

	-- Mejora busquedas de canciones por genero
	CREATE NONCLUSTERED INDEX IDX_Cancion_Genero
	ON Catalogo.Cancion (Genero_idGenero);
	GO

	-- Mejora busquedas de canciones por album
	CREATE NONCLUSTERED INDEX IDX_Cancion_Album
	ON Catalogo.Cancion (Album_idAlbum);
	GO

	-- Mejora busquedas de artistas por productora
	CREATE NONCLUSTERED INDEX IDX_Artista_Productora
	ON Catalogo.Artista (Productora_idProductora);
	GO

	-- Mejora busquedas por titulo de cancion
	CREATE NONCLUSTERED INDEX IDX_Cancion_Titulo
	ON Catalogo.Cancion (tituloCancion);
	GO

	-- Mejora busquedas por nombre de artista
	CREATE NONCLUSTERED INDEX IDX_Artista_Nombre
	ON Catalogo.Artista (nombreArtista);
	GO


	/* 
	   INDICES - INTERACCION
	   */

	-- Mejora busquedas de playlists por usuario
	CREATE NONCLUSTERED INDEX IDX_Playlist_Usuario
	ON Interaccion.Playlist (Usuario_idUsuario);
	GO

	-- Mejora consultas de reproducciones por usuario
	CREATE NONCLUSTERED INDEX IDX_Reproduccion_Usuario
	ON Interaccion.Reproduccion (Usuario_idUsuario);
	GO

	-- Mejora consultas de reproducciones por cancion
	CREATE NONCLUSTERED INDEX IDX_Reproduccion_Cancion
	ON Interaccion.Reproduccion (Cancion_idCancion);
	GO

	-- Mejora reportes de reproducciones por cancion y fecha
	CREATE NONCLUSTERED INDEX IDX_Reproduccion_Cancion_Fecha
	ON Interaccion.Reproduccion (Cancion_idCancion, fechaReproduccion);
	GO

	-- Mejora reportes de actividad por usuario y fecha
	CREATE NONCLUSTERED INDEX IDX_Reproduccion_Usuario_Fecha
	ON Interaccion.Reproduccion (Usuario_idUsuario, fechaReproduccion);
	GO

	-- Mejora consultas de canciones dentro de playlists
	CREATE NONCLUSTERED INDEX IDX_CancionPlaylist_Playlist
	ON Interaccion.CancionPlaylist (Playlist_idPlaylist);
	GO

	-- Mejora consultas de playlists donde aparece una cancion
	CREATE NONCLUSTERED INDEX IDX_CancionPlaylist_Cancion
	ON Interaccion.CancionPlaylist (Cancion_idCancion);
	GO

	-- Mejora consultas de likes por usuario
	CREATE NONCLUSTERED INDEX IDX_UsuarioCancion_Usuario
	ON Interaccion.UsuarioCancion (Usuario_idUsuario);
	GO

	-- Mejora consultas de likes por cancion
	CREATE NONCLUSTERED INDEX IDX_UsuarioCancion_Cancion
	ON Interaccion.UsuarioCancion (Cancion_idCancion);
	GO

	-- Mejora consultas de artistas seguidos por usuario
	CREATE NONCLUSTERED INDEX IDX_UsuarioArtista_Usuario
	ON Interaccion.UsuarioArtista (Usuario_idUsuario);
	GO

	-- Mejora consultas de seguidores por artista
	CREATE NONCLUSTERED INDEX IDX_UsuarioArtista_Artista
	ON Interaccion.UsuarioArtista (Artista_idArtista);
	GO

	-- Mejora consultas de canciones por artista
	CREATE NONCLUSTERED INDEX IDX_ArtistaCancion_Artista
	ON Interaccion.ArtistaCancion (Artista_idArtista);
	GO

	-- Mejora consultas de artistas por cancion
	CREATE NONCLUSTERED INDEX IDX_ArtistaCancion_Cancion
	ON Interaccion.ArtistaCancion (Cancion_idCancion);
	GO


	/*
	   INDICES - FINANZAS
		*/

	-- Mejora busquedas de suscripciones por usuario
	CREATE NONCLUSTERED INDEX IDX_Suscripcion_Usuario
	ON Finanzas.Suscripcion (Usuario_idUsuario);
	GO

	-- Mejora consultas de pagos por suscripcion
	CREATE NONCLUSTERED INDEX IDX_Pago_Suscripcion
	ON Finanzas.Pago (Suscripcion_idSuscripcion);
	GO

	-- Mejora reportes de pagos por fecha
	CREATE NONCLUSTERED INDEX IDX_Pago_Fecha
	ON Finanzas.Pago (fechaPago);
	GO

	-- Mejora consultas de regalias por cancion
	CREATE NONCLUSTERED INDEX IDX_Regalia_Cancion
	ON Finanzas.Regalia (Cancion_idCancion);
	GO

	-- Mejora reportes de regalias por fecha
	CREATE NONCLUSTERED INDEX IDX_Regalia_Fecha
	ON Finanzas.Regalia (fechaCalculoRegalia);
	GO


/* ============================================================
   SECCION 3 - SEGURIDAD, LOGIN, USUARIO Y PERMISOS
   Objetivo:
   Crear credenciales para conexion desde Python y asignar permisos.
   ============================================================ */

	USE master;
	GO

	-- Creacion del login a nivel de servidor
	CREATE LOGIN loginSonoraInc
	WITH PASSWORD = 'Sonora123*';
	GO

	USE SonoraInc;
	GO

	-- Creacion del usuario de base de datos asociado al login
	CREATE USER userSonoraInc FOR LOGIN loginSonoraInc;
	GO

	-- Permiso de lectura sobre la base de datos
	ALTER ROLE db_datareader ADD MEMBER userSonoraInc;
	GO

	-- Permiso de escritura sobre la base de datos
	ALTER ROLE db_datawriter ADD MEMBER userSonoraInc;
	GO

	-- Permiso para ejecutar procedimientos almacenados y funciones
	GRANT EXECUTE TO userSonoraInc;
	GO

/* ============================================================
   SECCION 4 - FUNCIONES
   Objetivo:
   Implementar calculos reutilizables para reportes y reglas
   de negocio dentro de la base de datos SonoraInc.
   ============================================================ */

	USE SonoraInc;
	GO

	/* 
	   FUNCION 1 - TOTAL DE REPRODUCCIONES POR CANCION
	   Objetivo:
	   Retornar la cantidad total de reproducciones registradas
	   para una cancion especifica.
	*/

	CREATE FUNCTION Procesos.fn_TotalReproduccionesCancion
	(
		@idCancion INT
	)
	RETURNS INT
	AS
	BEGIN
		DECLARE @total INT;

		SELECT @total = COUNT(*)
		FROM Interaccion.Reproduccion
		WHERE Cancion_idCancion = @idCancion;

		RETURN ISNULL(@total, 0);
	END;
	GO


	/* 
	   FUNCION 2 - TOTAL DE LIKES POR CANCION
	   Objetivo:
	   Retornar la cantidad total de likes registrados para una
	   cancion especifica.
	*/

	CREATE FUNCTION Procesos.fn_TotalLikesCancion
	(
		@idCancion INT
	)
	RETURNS INT
	AS
	BEGIN
		DECLARE @total INT;

		SELECT @total = COUNT(*)
		FROM Interaccion.UsuarioCancion
		WHERE Cancion_idCancion = @idCancion;

		RETURN ISNULL(@total, 0);
	END;
	GO


	/*   FUNCION 3 - TOTAL DE SEGUIDORES POR ARTISTA
	   Objetivo:
	   Retornar la cantidad total de usuarios que siguen a un
	   artista especifico.
	*/

	CREATE FUNCTION Procesos.fn_TotalSeguidoresArtista
	(
		@idArtista INT
	)
	RETURNS INT
	AS
	BEGIN
		DECLARE @total INT;

		SELECT @total = COUNT(*)
		FROM Interaccion.UsuarioArtista
		WHERE Artista_idArtista = @idArtista;

		RETURN ISNULL(@total, 0);
	END;
	GO


	/* 	   FUNCION 4 - TOTAL PAGADO POR SUSCRIPCION
	   Objetivo:
	   Retornar el monto total pagado asociado a una suscripcion.
	  */

	CREATE FUNCTION Procesos.fn_TotalPagadoSuscripcion
	(
		@idSuscripcion INT
	)
	RETURNS DECIMAL(10,2)
	AS
	BEGIN
		DECLARE @total DECIMAL(10,2);

		SELECT @total = SUM(montoPago)
		FROM Finanzas.Pago
		WHERE Suscripcion_idSuscripcion = @idSuscripcion;

		RETURN ISNULL(@total, 0);
	END;
	GO


	/*    FUNCION 5 - CALCULO DE REGALIA POR CANCION
	   Objetivo:
	   Calcular el monto de regalia generado por una cancion,
	   tomando como base la cantidad de reproducciones y un valor
	   definido por reproduccion.
	 */

	CREATE FUNCTION Procesos.fn_CalcularRegaliaCancion
	(
		@idCancion INT,
		@valorPorReproduccion DECIMAL(10,2)
	)
	RETURNS DECIMAL(10,2)
	AS
	BEGIN
		DECLARE @totalReproducciones INT;
		DECLARE @montoRegalia DECIMAL(10,2);

		SELECT @totalReproducciones = COUNT(*)
		FROM Interaccion.Reproduccion
		WHERE Cancion_idCancion = @idCancion;

		SET @montoRegalia = ISNULL(@totalReproducciones, 0) * @valorPorReproduccion;

		RETURN ISNULL(@montoRegalia, 0);
	END;
	GO


/* ============================================================
   SECCION 5 - PROCEDIMIENTOS ALMACENADOS
   Objetivo:
   Implementar operaciones principales del sistema.
   ============================================================ */
    USE SonoraInc;
    GO

    /* ============================================================
       SP 1 - REGISTRAR USUARIO
       Caso de uso:
       Registrar usuario
       ============================================================ */

    CREATE PROCEDURE Procesos.sp_RegistrarUsuario
        @nombreUsuario VARCHAR(50),
        @apellidoUsuario VARCHAR(50),
        @segundoNombreUsuario VARCHAR(50) = NULL,
        @segundoApellidoUsuario VARCHAR(50) = NULL,
        @correoUsuario VARCHAR(50),
        @fechaRegistroUsuario DATE
    AS
    BEGIN
        SET NOCOUNT ON;

        IF EXISTS (
            SELECT 1
            FROM Seguridad.Usuario
            WHERE correoUsuario = @correoUsuario
        )
        BEGIN
            THROW 50001, 'El correo ingresado ya se encuentra registrado.', 1;
        END;

        DECLARE @idUsuario INT;

        SELECT @idUsuario = ISNULL(MAX(idUsuario), 0) + 1
        FROM Seguridad.Usuario;

        INSERT INTO Seguridad.Usuario
        (
            idUsuario,
            nombreUsuario,
            apellidoUsuario,
            segundoNombreUsuario,
            segundoApellidoUsuario,
            correoUsuario,
            fechaRegistroUsuario
        )
        VALUES
        (
            @idUsuario,
            @nombreUsuario,
            @apellidoUsuario,
            @segundoNombreUsuario,
            @segundoApellidoUsuario,
            @correoUsuario,
            @fechaRegistroUsuario
        );

        SELECT 'Usuario registrado correctamente' AS Mensaje, @idUsuario AS idUsuario;
    END;
    GO


    /* ============================================================
       SP 2 - INICIAR SESION
       Caso de uso:
       Iniciar sesion
       Nota:
       Como el modelo actual no almacena contrasena, se valida el
       acceso mediante correo registrado.
       ============================================================ */

    CREATE PROCEDURE Procesos.sp_IniciarSesion
        @correoUsuario VARCHAR(50)
    AS
    BEGIN
        SET NOCOUNT ON;

        IF NOT EXISTS (
            SELECT 1
            FROM Seguridad.Usuario
            WHERE correoUsuario = @correoUsuario
        )
        BEGIN
            THROW 50002, 'No existe un usuario registrado con ese correo.', 1;
        END;

        SELECT
            idUsuario,
            nombreUsuario,
            apellidoUsuario,
            correoUsuario,
            fechaRegistroUsuario
        FROM Seguridad.Usuario
        WHERE correoUsuario = @correoUsuario;
    END;
    GO


    /* ============================================================
       SP 3 - CREAR PLAYLIST
       Caso de uso:
       Crear playlist
       ============================================================ */

    CREATE PROCEDURE Procesos.sp_CrearPlaylist
        @Usuario_idUsuario INT,
        @nombrePlaylist VARCHAR(50),
        @fechaCreacionPlaylist DATE,
        @privacidadPlaylist VARCHAR(50) = 'Privada',
        @descripcionPlaylist VARCHAR(50) = NULL
    AS
    BEGIN
        SET NOCOUNT ON;

        IF NOT EXISTS (
            SELECT 1
            FROM Seguridad.Usuario
            WHERE idUsuario = @Usuario_idUsuario
        )
        BEGIN
            THROW 50003, 'El usuario no existe.', 1;
        END;

        IF @privacidadPlaylist NOT IN ('Privada', 'Publica')
        BEGIN
            THROW 50004, 'La privacidad debe ser Privada o Publica.', 1;
        END;

        IF EXISTS (
            SELECT 1
            FROM Interaccion.Playlist
            WHERE Usuario_idUsuario = @Usuario_idUsuario
              AND nombrePlaylist = @nombrePlaylist
        )
        BEGIN
            THROW 50005, 'El usuario ya tiene una playlist con ese nombre.', 1;
        END;

        DECLARE @idPlaylist INT;

        SELECT @idPlaylist = ISNULL(MAX(idPlaylist), 0) + 1
        FROM Interaccion.Playlist;

        INSERT INTO Interaccion.Playlist
        (
            idPlaylist,
            nombrePlaylist,
            fechaCreacionPlaylist,
            privacidadPlaylist,
            descripcionPlaylist,
            Usuario_idUsuario
        )
        VALUES
        (
            @idPlaylist,
            @nombrePlaylist,
            @fechaCreacionPlaylist,
            @privacidadPlaylist,
            @descripcionPlaylist,
            @Usuario_idUsuario
        );

        SELECT 'Playlist creada correctamente' AS Mensaje, @idPlaylist AS idPlaylist;
    END;
    GO


    /* ============================================================
       SP 4 - AGREGAR CANCION A PLAYLIST
       Caso de uso:
       Agregar cancion a playlist
       ============================================================ */

    CREATE PROCEDURE Procesos.sp_AgregarCancionPlaylist
        @Playlist_idPlaylist INT,
        @Cancion_idCancion INT
    AS
    BEGIN
        SET NOCOUNT ON;

        IF NOT EXISTS (
            SELECT 1
            FROM Interaccion.Playlist
            WHERE idPlaylist = @Playlist_idPlaylist
        )
        BEGIN
            THROW 50006, 'La playlist no existe.', 1;
        END;

        IF NOT EXISTS (
            SELECT 1
            FROM Catalogo.Cancion
            WHERE idCancion = @Cancion_idCancion
        )
        BEGIN
            THROW 50007, 'La cancion no existe.', 1;
        END;

        IF EXISTS (
            SELECT 1
            FROM Interaccion.CancionPlaylist
            WHERE Playlist_idPlaylist = @Playlist_idPlaylist
              AND Cancion_idCancion = @Cancion_idCancion
        )
        BEGIN
            THROW 50008, 'La cancion ya pertenece a esta playlist.', 1;
        END;

        INSERT INTO Interaccion.CancionPlaylist
        (
            Cancion_idCancion,
            Playlist_idPlaylist
        )
        VALUES
        (
            @Cancion_idCancion,
            @Playlist_idPlaylist
        );

        SELECT 'Cancion agregada correctamente a la playlist' AS Mensaje;
    END;
    GO


    /* ============================================================
       SP 5 - REGISTRAR REPRODUCCION
       Caso de uso:
       Reproducir cancion
       ============================================================ */

    CREATE PROCEDURE Procesos.sp_RegistrarReproduccion
        @Usuario_idUsuario INT,
        @Cancion_idCancion INT,
        @fechaReproduccion DATE,
        @duracionReproduccion FLOAT
    AS
    BEGIN
        SET NOCOUNT ON;

        IF NOT EXISTS (
            SELECT 1
            FROM Seguridad.Usuario
            WHERE idUsuario = @Usuario_idUsuario
        )
        BEGIN
            THROW 50009, 'El usuario no existe.', 1;
        END;

        IF NOT EXISTS (
            SELECT 1
            FROM Catalogo.Cancion
            WHERE idCancion = @Cancion_idCancion
        )
        BEGIN
            THROW 50010, 'La cancion no existe.', 1;
        END;

        IF @duracionReproduccion < 0
        BEGIN
            THROW 50011, 'La duracion de reproduccion no puede ser negativa.', 1;
        END;

        DECLARE @idReproduccion INT;

        SELECT @idReproduccion = ISNULL(MAX(idReproduccion), 0) + 1
        FROM Interaccion.Reproduccion;

        INSERT INTO Interaccion.Reproduccion
        (
            idReproduccion,
            fechaReproduccion,
            duracionReproduccion,
            Usuario_idUsuario,
            Cancion_idCancion
        )
        VALUES
        (
            @idReproduccion,
            @fechaReproduccion,
            @duracionReproduccion,
            @Usuario_idUsuario,
            @Cancion_idCancion
        );

        SELECT 'Reproduccion registrada correctamente' AS Mensaje, @idReproduccion AS idReproduccion;
    END;
    GO


    /* ============================================================
       SP 6 - DAR LIKE A UNA CANCION
       Caso de uso:
       Dar like a una cancion
       ============================================================ */

    CREATE PROCEDURE Procesos.sp_DarLikeCancion
        @Usuario_idUsuario INT,
        @Cancion_idCancion INT
    AS
    BEGIN
        SET NOCOUNT ON;

        IF NOT EXISTS (
            SELECT 1
            FROM Seguridad.Usuario
            WHERE idUsuario = @Usuario_idUsuario
        )
        BEGIN
            THROW 50012, 'El usuario no existe.', 1;
        END;

        IF NOT EXISTS (
            SELECT 1
            FROM Catalogo.Cancion
            WHERE idCancion = @Cancion_idCancion
        )
        BEGIN
            THROW 50013, 'La cancion no existe.', 1;
        END;

        IF EXISTS (
            SELECT 1
            FROM Interaccion.UsuarioCancion
            WHERE Usuario_idUsuario = @Usuario_idUsuario
              AND Cancion_idCancion = @Cancion_idCancion
        )
        BEGIN
            THROW 50014, 'El usuario ya dio like a esta cancion.', 1;
        END;

        INSERT INTO Interaccion.UsuarioCancion
        (
            Usuario_idUsuario,
            Cancion_idCancion
        )
        VALUES
        (
            @Usuario_idUsuario,
            @Cancion_idCancion
        );

        SELECT 'Like registrado correctamente' AS Mensaje;
    END;
    GO


    /* ============================================================
       SP 7 - SEGUIR ARTISTA
       Caso de uso:
       Seguir artista
       ============================================================ */

    CREATE PROCEDURE Procesos.sp_SeguirArtista
        @Usuario_idUsuario INT,
        @Artista_idArtista INT
    AS
    BEGIN
        SET NOCOUNT ON;

        IF NOT EXISTS (
            SELECT 1
            FROM Seguridad.Usuario
            WHERE idUsuario = @Usuario_idUsuario
        )
        BEGIN
            THROW 50015, 'El usuario no existe.', 1;
        END;

        IF NOT EXISTS (
            SELECT 1
            FROM Catalogo.Artista
            WHERE idArtista = @Artista_idArtista
        )
        BEGIN
            THROW 50016, 'El artista no existe.', 1;
        END;

        IF EXISTS (
            SELECT 1
            FROM Interaccion.UsuarioArtista
            WHERE Usuario_idUsuario = @Usuario_idUsuario
              AND Artista_idArtista = @Artista_idArtista
        )
        BEGIN
            THROW 50017, 'El usuario ya sigue a este artista.', 1;
        END;

        INSERT INTO Interaccion.UsuarioArtista
        (
            Usuario_idUsuario,
            Artista_idArtista
        )
        VALUES
        (
            @Usuario_idUsuario,
            @Artista_idArtista
        );

        SELECT 'Artista seguido correctamente' AS Mensaje;
    END;
    GO


    /* ============================================================
       SP 8 - REGISTRAR SUSCRIPCION
       Caso de uso:
       Seleccionar suscripcion
       ============================================================ */

    CREATE PROCEDURE Procesos.sp_RegistrarSuscripcion
        @Usuario_idUsuario INT,
        @tipoPlanSuscripcion VARCHAR(50),
        @fechaInicioSuscripcion DATE,
        @fechaFinSuscripcion DATE = NULL,
        @estadoSuscripcion VARCHAR(50) = 'Activa'
    AS
    BEGIN
        SET NOCOUNT ON;

        IF NOT EXISTS (
            SELECT 1
            FROM Seguridad.Usuario
            WHERE idUsuario = @Usuario_idUsuario
        )
        BEGIN
            THROW 50018, 'El usuario no existe.', 1;
        END;

        IF @tipoPlanSuscripcion NOT IN ('Gratis', 'Premium')
        BEGIN
            THROW 50019, 'El tipo de plan debe ser Gratis o Premium.', 1;
        END;

        IF @estadoSuscripcion NOT IN ('Activa', 'Cancelada', 'Vencida')
        BEGIN
            THROW 50020, 'El estado de suscripcion no es valido.', 1;
        END;

        DECLARE @idSuscripcion INT;

        SELECT @idSuscripcion = ISNULL(MAX(idSuscripcion), 0) + 1
        FROM Finanzas.Suscripcion;

        INSERT INTO Finanzas.Suscripcion
        (
            idSuscripcion,
            tipoPlanSuscripcion,
            fechaInicioSuscripcion,
            fechaFinSuscripcion,
            estadoSuscripcion,
            Usuario_idUsuario
        )
        VALUES
        (
            @idSuscripcion,
            @tipoPlanSuscripcion,
            @fechaInicioSuscripcion,
            @fechaFinSuscripcion,
            @estadoSuscripcion,
            @Usuario_idUsuario
        );

        SELECT 'Suscripcion registrada correctamente' AS Mensaje, @idSuscripcion AS idSuscripcion;
    END;
    GO


    /* ============================================================
       SP 9 - REGISTRAR PAGO DE SUSCRIPCION
       Caso de uso:
       Registrar pago de suscripcion
       ============================================================ */

    CREATE PROCEDURE Procesos.sp_RegistrarPago
        @Suscripcion_idSuscripcion INT,
        @fechaPago DATE,
        @montoPago DECIMAL(10,2)
    AS
    BEGIN
        SET NOCOUNT ON;

        IF NOT EXISTS (
            SELECT 1
            FROM Finanzas.Suscripcion
            WHERE idSuscripcion = @Suscripcion_idSuscripcion
        )
        BEGIN
            THROW 50021, 'La suscripcion no existe.', 1;
        END;

        IF @montoPago <= 0
        BEGIN
            THROW 50022, 'El monto del pago debe ser mayor a cero.', 1;
        END;

        DECLARE @idPago INT;

        SELECT @idPago = ISNULL(MAX(idPago), 0) + 1
        FROM Finanzas.Pago;

        INSERT INTO Finanzas.Pago
        (
            idPago,
            fechaPago,
            montoPago,
            Suscripcion_idSuscripcion
        )
        VALUES
        (
            @idPago,
            @fechaPago,
            @montoPago,
            @Suscripcion_idSuscripcion
        );

        SELECT 'Pago registrado correctamente' AS Mensaje, @idPago AS idPago;
    END;
    GO


    /* ============================================================
       SP 10 - CALCULAR REGALIA
       Caso de uso:
       Calcular regalias
       ============================================================ */

    CREATE PROCEDURE Procesos.sp_CalcularRegaliaCancion
        @Cancion_idCancion INT,
        @valorPorReproduccion DECIMAL(10,2),
        @fechaCalculoRegalia DATE
    AS
    BEGIN
        SET NOCOUNT ON;

        IF NOT EXISTS (
            SELECT 1
            FROM Catalogo.Cancion
            WHERE idCancion = @Cancion_idCancion
        )
        BEGIN
            THROW 50023, 'La cancion no existe.', 1;
        END;

        IF @valorPorReproduccion <= 0
        BEGIN
            THROW 50024, 'El valor por reproduccion debe ser mayor a cero.', 1;
        END;

        DECLARE @cantidadReproducciones INT;
        DECLARE @montoGeneradoRegalia DECIMAL(10,2);
        DECLARE @idRegalia INT;

        SELECT @cantidadReproducciones = COUNT(*)
        FROM Interaccion.Reproduccion
        WHERE Cancion_idCancion = @Cancion_idCancion;

        SET @montoGeneradoRegalia = @cantidadReproducciones * @valorPorReproduccion;

        SELECT @idRegalia = ISNULL(MAX(idRegalia), 0) + 1
        FROM Finanzas.Regalia;

        INSERT INTO Finanzas.Regalia
        (
            idRegalia,
            cantidadReproduccionesRegalia,
            montoGeneradoRegalia,
            fechaCalculoRegalia,
            Cancion_idCancion
        )
        VALUES
        (
            @idRegalia,
            @cantidadReproducciones,
            @montoGeneradoRegalia,
            @fechaCalculoRegalia,
            @Cancion_idCancion
        );

        SELECT 
            'Regalia calculada correctamente' AS Mensaje,
            @idRegalia AS idRegalia,
            @cantidadReproducciones AS cantidadReproducciones,
            @montoGeneradoRegalia AS montoGeneradoRegalia;
    END;
    GO

/* ============================================================
   SECCION 6 - TRIGGERS
   Objetivo:
   Automatizar validaciones o acciones posteriores a cambios en datos.
   ============================================================ */


    USE SonoraInc;
    GO

    /* ============================================================
       TRIGGER 1 - VALIDAR PAGO DE SUSCRIPCION
       Regla:
       El monto de un pago debe ser mayor a cero.
       ============================================================ */

    CREATE TRIGGER Finanzas.trg_ValidarMontoPago
    ON Finanzas.Pago
    AFTER INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

        IF EXISTS (
            SELECT 1
            FROM inserted
            WHERE montoPago <= 0
        )
        BEGIN
            THROW 50101, 'El monto del pago debe ser mayor a cero.', 1;
        END;
    END;
    GO


    /* ============================================================
       TRIGGER 2 - VALIDAR PAGO SOLO PARA PLAN PREMIUM
       Regla:
       Solo las suscripciones Premium deben registrar pagos.
       ============================================================ */

    CREATE TRIGGER Finanzas.trg_ValidarPagoPremium
    ON Finanzas.Pago
    AFTER INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

        IF EXISTS (
            SELECT 1
            FROM inserted I
            INNER JOIN Finanzas.Suscripcion S
                ON I.Suscripcion_idSuscripcion = S.idSuscripcion
            WHERE S.tipoPlanSuscripcion <> 'Premium'
        )
        BEGIN
            THROW 50102, 'Solo las suscripciones Premium pueden registrar pagos.', 1;
        END;
    END;
    GO


    /* ============================================================
       TRIGGER 3 - ACTUALIZAR SUSCRIPCION TRAS PAGO
       Regla:
       Cuando se registra un pago valido, la suscripcion se mantiene
       como Activa.
       ============================================================ */

    CREATE TRIGGER Finanzas.trg_ActualizarEstadoSuscripcionPago
    ON Finanzas.Pago
    AFTER INSERT
    AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE S
        SET estadoSuscripcion = 'Activa'
        FROM Finanzas.Suscripcion S
        INNER JOIN inserted I
            ON S.idSuscripcion = I.Suscripcion_idSuscripcion;
    END;
    GO


    /* ============================================================
       TRIGGER 4 - VALIDAR DURACION DE REPRODUCCION
       Regla:
       La duracion reproducida no puede ser negativa ni mayor que
       la duracion total de la cancion.
       ============================================================ */

    CREATE TRIGGER Interaccion.trg_ValidarDuracionReproduccion
    ON Interaccion.Reproduccion
    AFTER INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

        IF EXISTS (
            SELECT 1
            FROM inserted I
            INNER JOIN Catalogo.Cancion C
                ON I.Cancion_idCancion = C.idCancion
            WHERE I.duracionReproduccion < 0
               OR I.duracionReproduccion > C.duracionCancion
        )
        BEGIN
            THROW 50103, 'La duracion de reproduccion no puede ser negativa ni mayor a la duracion de la cancion.', 1;
        END;
    END;
    GO


    /* ============================================================
       TRIGGER 5 - VALIDAR REGALIA
       Regla:
       La cantidad de reproducciones y el monto generado por regalia
       no pueden ser negativos.
       ============================================================ */

    CREATE TRIGGER Finanzas.trg_ValidarRegalia
    ON Finanzas.Regalia
    AFTER INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

        IF EXISTS (
            SELECT 1
            FROM inserted
            WHERE cantidadReproduccionesRegalia < 0
               OR montoGeneradoRegalia < 0
        )
        BEGIN
            THROW 50104, 'La regalia no puede tener reproducciones o montos negativos.', 1;
        END;
    END;
    GO


    /* ============================================================
       TRIGGER 6 - VALIDAR FECHAS DE SUSCRIPCION
       Regla:
       La fecha fin de suscripcion no puede ser menor que la fecha
       de inicio.
       ============================================================ */

    CREATE TRIGGER Finanzas.trg_ValidarFechasSuscripcion
    ON Finanzas.Suscripcion
    AFTER INSERT, UPDATE
    AS
    BEGIN
        SET NOCOUNT ON;

        IF EXISTS (
            SELECT 1
            FROM inserted
            WHERE fechaFinSuscripcion IS NOT NULL
              AND fechaFinSuscripcion < fechaInicioSuscripcion
        )
        BEGIN
            THROW 50105, 'La fecha fin de suscripcion no puede ser menor que la fecha de inicio.', 1;
        END;
    END;
    GO


/* ============================================================
   SECCION 7 - CURSORES
   Objetivo:
   Implementar procesos secuenciales, como calculo de regalias.
   ============================================================ */
 
   CREATE PROCEDURE Procesos.sp_CalcularRegaliasGlobal
        @valorPorReproduccion DECIMAL(10,2),
        @fechaCalculoRegalia DATE
    AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @idCancion INT;
        DECLARE @cantidadReproducciones INT;
        DECLARE @montoRegalia DECIMAL(10,2);
        DECLARE @idRegalia INT;

        DECLARE cursorCanciones CURSOR FOR
            SELECT idCancion
            FROM Catalogo.Cancion;

        OPEN cursorCanciones;

        FETCH NEXT FROM cursorCanciones INTO @idCancion;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SELECT @cantidadReproducciones = COUNT(*)
            FROM Interaccion.Reproduccion
            WHERE Cancion_idCancion = @idCancion;

            SET @montoRegalia = ISNULL(@cantidadReproducciones, 0) * @valorPorReproduccion;

            SELECT @idRegalia = ISNULL(MAX(idRegalia), 0) + 1
            FROM Finanzas.Regalia;

            INSERT INTO Finanzas.Regalia
            (
                idRegalia,
                cantidadReproduccionesRegalia,
                montoGeneradoRegalia,
                fechaCalculoRegalia,
                Cancion_idCancion
            )
            VALUES
            (
                @idRegalia,
                ISNULL(@cantidadReproducciones, 0),
                @montoRegalia,
                @fechaCalculoRegalia,
                @idCancion
            );

            FETCH NEXT FROM cursorCanciones INTO @idCancion;
        END;

        CLOSE cursorCanciones;
        DEALLOCATE cursorCanciones;

        SELECT 'Regalias calculadas correctamente' AS Mensaje;
    END;
    GO

    CREATE PROCEDURE Procesos.sp_ActualizarSuscripcionesVencidas
    AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @idSuscripcion INT;

        DECLARE cursorSuscripciones CURSOR FOR
            SELECT idSuscripcion
            FROM Finanzas.Suscripcion
            WHERE fechaFinSuscripcion IS NOT NULL
              AND fechaFinSuscripcion < CAST(GETDATE() AS DATE)
              AND estadoSuscripcion <> 'Vencida';

        OPEN cursorSuscripciones;

        FETCH NEXT FROM cursorSuscripciones INTO @idSuscripcion;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            UPDATE Finanzas.Suscripcion
            SET estadoSuscripcion = 'Vencida'
            WHERE idSuscripcion = @idSuscripcion;

            FETCH NEXT FROM cursorSuscripciones INTO @idSuscripcion;
        END;

        CLOSE cursorSuscripciones;
        DEALLOCATE cursorSuscripciones;

        SELECT 'Suscripciones vencidas actualizadas correctamente' AS Mensaje;
    END;
    GO

      CREATE PROCEDURE Procesos.sp_GenerarPlaylistAutomaticaUsuarios
        AS
        BEGIN
            SET NOCOUNT ON;

            DECLARE @idUsuario INT;
            DECLARE @idPlaylist INT;

            DECLARE cursorUsuarios CURSOR FOR
                SELECT idUsuario
                FROM Seguridad.Usuario;

            OPEN cursorUsuarios;

            FETCH NEXT FROM cursorUsuarios INTO @idUsuario;

            WHILE @@FETCH_STATUS = 0
            BEGIN
                SELECT @idPlaylist = ISNULL(MAX(idPlaylist), 0) + 1
                FROM Interaccion.Playlist;

                INSERT INTO Interaccion.Playlist
                (
                    idPlaylist,
                    nombrePlaylist,
                    fechaCreacionPlaylist,
                    privacidadPlaylist,
                    descripcionPlaylist,
                    Usuario_idUsuario
                )
                VALUES
                (
                    @idPlaylist,
                    'Playlist Auto Usuario ' + CAST(@idUsuario AS VARCHAR),
                    CAST(GETDATE() AS DATE),
                    'Privada',
                    'Generada automaticamente',
                    @idUsuario
                );

                INSERT INTO Interaccion.CancionPlaylist (Cancion_idCancion, Playlist_idPlaylist)
                SELECT DISTINCT
                    Cancion_idCancion,
                    @idPlaylist
                FROM Interaccion.Reproduccion
                WHERE Usuario_idUsuario = @idUsuario;

                FETCH NEXT FROM cursorUsuarios INTO @idUsuario;
            END;

            CLOSE cursorUsuarios;
            DEALLOCATE cursorUsuarios;

            SELECT 'Playlists generadas correctamente' AS Mensaje;
        END;
        GO


        CREATE PROCEDURE Procesos.sp_ResumenActividadUsuarios
    AS
    BEGIN
        SET NOCOUNT ON;

        DECLARE @idUsuario INT;
        DECLARE @totalReproducciones INT;
        DECLARE @totalLikes INT;

        DECLARE @resultado TABLE
        (
            idUsuario INT,
            totalReproducciones INT,
            totalLikes INT
        );

        DECLARE cursorUsuarios CURSOR FOR
            SELECT idUsuario
            FROM Seguridad.Usuario;

        OPEN cursorUsuarios;

        FETCH NEXT FROM cursorUsuarios INTO @idUsuario;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SELECT @totalReproducciones = COUNT(*)
            FROM Interaccion.Reproduccion
            WHERE Usuario_idUsuario = @idUsuario;

            SELECT @totalLikes = COUNT(*)
            FROM Interaccion.UsuarioCancion
            WHERE Usuario_idUsuario = @idUsuario;

            INSERT INTO @resultado
            VALUES
            (
                @idUsuario,
                ISNULL(@totalReproducciones, 0),
                ISNULL(@totalLikes, 0)
            );

            FETCH NEXT FROM cursorUsuarios INTO @idUsuario;
        END;

        CLOSE cursorUsuarios;
        DEALLOCATE cursorUsuarios;

        SELECT * FROM @resultado;
    END;
    GO

/* ============================================================
   SECCION 8 - VISTAS Y REPORTES
   Objetivo:
   Crear consultas reutilizables para los informes del sistema.
   ============================================================ */

    USE SonoraInc;
    GO

    /* ============================================================
       VISTA 1 - CANCIONES MAS REPRODUCIDAS
       ============================================================ */

    CREATE VIEW Reportes.vCancionesMasReproducidas
    AS
    SELECT
        C.idCancion,
        C.tituloCancion,
        COUNT(R.idReproduccion) AS totalReproducciones
    FROM Catalogo.Cancion C
    LEFT JOIN Interaccion.Reproduccion R
        ON C.idCancion = R.Cancion_idCancion
    GROUP BY
        C.idCancion,
        C.tituloCancion;
    GO


    /* ============================================================
       VISTA 2 - USUARIOS CON MAYOR ACTIVIDAD
       ============================================================ */

    CREATE VIEW Reportes.vActividadUsuarios
    AS
    SELECT
        U.idUsuario,
        U.nombreUsuario,
        U.apellidoUsuario,
        COUNT(R.idReproduccion) AS totalReproducciones
    FROM Seguridad.Usuario U
    LEFT JOIN Interaccion.Reproduccion R
        ON U.idUsuario = R.Usuario_idUsuario
    GROUP BY
        U.idUsuario,
        U.nombreUsuario,
        U.apellidoUsuario;
    GO


    /* ============================================================
       VISTA 3 - CANCIONES CON MAS LIKES
       ============================================================ */

    CREATE VIEW Reportes.vCancionesConMasLikes
    AS
    SELECT
        C.idCancion,
        C.tituloCancion,
        COUNT(UC.Usuario_idUsuario) AS totalLikes
    FROM Catalogo.Cancion C
    LEFT JOIN Interaccion.UsuarioCancion UC
        ON C.idCancion = UC.Cancion_idCancion
    GROUP BY
        C.idCancion,
        C.tituloCancion;
    GO


    /* ============================================================
       VISTA 4 - ARTISTAS MAS SEGUIDOS
       ============================================================ */

    CREATE VIEW Reportes.vArtistasMasSeguidos
    AS
    SELECT
        A.idArtista,
        A.nombreArtista,
        COUNT(UA.Usuario_idUsuario) AS totalSeguidores
    FROM Catalogo.Artista A
    LEFT JOIN Interaccion.UsuarioArtista UA
        ON A.idArtista = UA.Artista_idArtista
    GROUP BY
        A.idArtista,
        A.nombreArtista;
    GO


    /* ============================================================
       VISTA 5 - HISTORIAL DE REPRODUCCIONES
       ============================================================ */

    CREATE VIEW Reportes.vHistorialReproducciones
    AS
    SELECT
        R.idReproduccion,
        U.idUsuario,
        U.nombreUsuario,
        U.apellidoUsuario,
        C.idCancion,
        C.tituloCancion,
        R.fechaReproduccion,
        R.duracionReproduccion
    FROM Interaccion.Reproduccion R
    INNER JOIN Seguridad.Usuario U
        ON R.Usuario_idUsuario = U.idUsuario
    INNER JOIN Catalogo.Cancion C
        ON R.Cancion_idCancion = C.idCancion;
    GO


    /* ============================================================
       VISTA 6 - INGRESOS POR SUSCRIPCION
       ============================================================ */

    CREATE VIEW Reportes.vIngresosPorSuscripcion
    AS
    SELECT
        S.idSuscripcion,
        U.idUsuario,
        U.nombreUsuario,
        U.apellidoUsuario,
        S.tipoPlanSuscripcion,
        S.estadoSuscripcion,
        SUM(P.montoPago) AS totalPagado
    FROM Finanzas.Suscripcion S
    INNER JOIN Seguridad.Usuario U
        ON S.Usuario_idUsuario = U.idUsuario
    LEFT JOIN Finanzas.Pago P
        ON S.idSuscripcion = P.Suscripcion_idSuscripcion
    GROUP BY
        S.idSuscripcion,
        U.idUsuario,
        U.nombreUsuario,
        U.apellidoUsuario,
        S.tipoPlanSuscripcion,
        S.estadoSuscripcion;
    GO


    /* ============================================================
       VISTA 7 - REGALIAS POR CANCION
       ============================================================ */

    CREATE VIEW Reportes.vRegaliasPorCancion
    AS
    SELECT
        C.idCancion,
        C.tituloCancion,
        SUM(RG.cantidadReproduccionesRegalia) AS totalReproduccionesRegalia,
        SUM(RG.montoGeneradoRegalia) AS totalRegalias
    FROM Catalogo.Cancion C
    LEFT JOIN Finanzas.Regalia RG
        ON C.idCancion = RG.Cancion_idCancion
    GROUP BY
        C.idCancion,
        C.tituloCancion;
    GO


    /* ============================================================
       VISTA 8 - CANCIONES POR GENERO
       ============================================================ */

    CREATE VIEW Reportes.vCancionesPorGenero
    AS
    SELECT
        G.idGenero,
        G.nombreGenero,
        COUNT(C.idCancion) AS totalCanciones
    FROM Catalogo.Genero G
    LEFT JOIN Catalogo.Cancion C
        ON G.idGenero = C.Genero_idGenero
    GROUP BY
        G.idGenero,
        G.nombreGenero;
    GO


    /* ============================================================
       VISTA 9 - PLAYLISTS POR USUARIO
       ============================================================ */

    CREATE VIEW Reportes.vPlaylistsPorUsuario
    AS
    SELECT
        U.idUsuario,
        U.nombreUsuario,
        U.apellidoUsuario,
        COUNT(P.idPlaylist) AS totalPlaylists
    FROM Seguridad.Usuario U
    LEFT JOIN Interaccion.Playlist P
        ON U.idUsuario = P.Usuario_idUsuario
    GROUP BY
        U.idUsuario,
        U.nombreUsuario,
        U.apellidoUsuario;
    GO


    /* ============================================================
       VISTA 10 - DETALLE DE PLAYLISTS
       ============================================================ */

    CREATE VIEW Reportes.vDetallePlaylists
    AS
    SELECT
        P.idPlaylist,
        P.nombrePlaylist,
        U.idUsuario,
        U.nombreUsuario,
        U.apellidoUsuario,
        C.idCancion,
        C.tituloCancion
    FROM Interaccion.Playlist P
    INNER JOIN Seguridad.Usuario U
        ON P.Usuario_idUsuario = U.idUsuario
    INNER JOIN Interaccion.CancionPlaylist CP
        ON P.idPlaylist = CP.Playlist_idPlaylist
    INNER JOIN Catalogo.Cancion C
        ON CP.Cancion_idCancion = C.idCancion;
    GO
/* ============================================================
   SECCION 9 - PRUEBAS
   Objetivo:
   Validar procedimientos, funciones, triggers, reportes y reglas.
   ============================================================* */
