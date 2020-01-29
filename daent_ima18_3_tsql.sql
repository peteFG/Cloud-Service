/*
##########################################################################################
#                                                                                        #
#       Projekt DAENT | IMA18 | WS19/20                       							 #
#                                                                                        #
#       Gruppe 3														                 #
#                                                                                        #
#       Gruppenmitglieder:  Kristan Thomas                                               #
#                           Feldgrill Peter                                              #
#                           Nemetz Christoph                                             #
#                                                                                        #
#       Thema: Cloud-Dienst														         #
#                                                                                        #
##########################################################################################*/



-- #######################################################################################
--  Tabellen
-- #######################################################################################

-- Tabelle 1: dbo.files
-- Kurzbeschreibung: Dient dem Speichern der einzelnen Dateien bzw. Ordner und gibt darueber Information, ob eine Datei fuer andere User freigegeben wurde
CREATE TABLE dbo.files ( 
	file_id int IDENTITY(1, 1) CONSTRAINT pk_files PRIMARY KEY,
	filename varchar(30) NOT NULL,
	size int NOT NULL, -- Angabe in Megabyte
	date_created datetime NOT NULL CONSTRAINT date_created DEFAULT SYSDATETIME(),
	date_modified datetime NOT NULL CONSTRAINT date_modified DEFAULT SYSDATETIME(),
	filetype varchar(6),
	username varchar(20) NOT NULL,
	shared bit,
	share int,
	parent_folder varchar(100)
)

ALTER TABLE dbo.files
	--ADD CONSTRAINT fk_files_share FOREIGN KEY (share) REFERENCES dbo.share (share_id)
	ADD CONSTRAINT fk_files_filetype FOREIGN KEY (filetype) REFERENCES dbo.filetypes (filetype)
	--ADD CONSTRAINT fk_files_users FOREIGN KEY (username) REFERENCES dbo.users (username)

-- Tabelle 1 - INSERTS
INSERT INTO dbo.files (filename, size, Filetype, shared, share, username, parent_folder)
VALUES	('Foliensaetze-DAENT', 0, 'FLDR', 0, NULL, 'beerdrinker', NULL),
		('VO', 0, 'FLDR', 0, NULL, 'beerdrinker', 'Foliensaetze-DAENT'),
		('UE', 0, 'FLDR', 0, NULL, 'beerdrinker', 'Foliensaetze-DAENT'),
		('VO-1', 150, 'PDF', 0, NULL, 'beerdrinker', 'VO'),
		('VO-2', 450, 'PDF', 0, NULL, 'beerdrinker', 'VO'),
		('VO-3', 300, 'PDF', 0, NULL, 'beerdrinker', 'VO'),
		('UE-1', 780, 'PDF', 0, NULL, 'beerdrinker', 'UE'),
		('UE-2', 120, 'PDF', 0, NULL, 'beerdrinker', 'UE'),
		('UE-3', 490, 'PDF', 0, NULL, 'beerdrinker', 'UE'),
		('UE-4', 150, 'PDF', 0, NULL, 'beerdrinker', 'UE'),
		('UE-5', 450, 'PDF', 0, NULL, 'beerdrinker', 'UE'),
		('UE-6', 300, 'PDF', 0, NULL, 'beerdrinker', 'UE'),
		('SQl-Queries', 0, 'FLDR', 0, NULL, 'beerdrinker', NULL),
		('G1', 30, 'SQL', 0, NULL, 'beerdrinker', 'SQL-Queries'),
		('G2', 40, 'SQL', 0, NULL, 'beerdrinker', 'SQL-Queries'),
		('G3', 30, 'SQL', 0, NULL, 'beerdrinker', 'SQL-Queries'),
		('Bewerbung', 90, 'DOCX', 0, NULL, 'kristant', NULL),
		('CV', 50, 'DOCX', 0, NULL, 'kristant', NULL),
		('Motivationsschreiben', 80, 'DOCX', 0, NULL, 'kristant', NULL),
		('ITISD-VO', 930, 'PDF', 0, NULL, 'feldgrillp', NULL),
		('DAENT-VOs-combined', 900, 'PDF', 0, NULL, 'feldgrillp', NULL),
		('Tetris', 1500, 'EXE', 0, NULL, 'nemetzc', NULL)

SELECT * FROM dbo.files 





-- Tabelle 2: dbo.filetypes
-- Kurzbeschreibung: Enthaelt moegliche Filetypes fuer Files 
CREATE TABLE dbo.filetypes (
	filetype varchar(6) CONSTRAINT pk_filetypes PRIMARY KEY
)

-- Tabelle 2 - INSERTS
--INSERT INTO ...
INSERT INTO dbo.filetypes (filetype)
VALUES	('FLDR'),
		('DOCX'),
		('BMP'),
		('HTML'),
		('JPG'),
		('KT'),
		('MP3'),
		('MP4'),
		('PDF'),
		('PNG'),
		('SQL'),
		('TXT'),
		('XML'),
		('EXE'),
		('XLSX'),
		('PPTX')

SELECT * FROM dbo.filetypes





-- Tabelle 3: dbo.share_permission
-- Kurzbeschreibung: Dient dem Speichern der moeglichen Zugriffsberechtigungen
CREATE TABLE dbo.share_permission (
	permission_id int IDENTITY (1, 1) CONSTRAINT pk_permission PRIMARY KEY,
	permission bit NOT NULL, -- 1 = Write, 0 = Read
	share int,
	username varchar(20)
)

ALTER TABLE dbo.share_permission
	ADD CONSTRAINT fk_sharep_users FOREIGN KEY (username) REFERENCES dbo.users (username);

SELECT * FROM dbo.share_permission






-- Tabelle 4: dbo.share
-- Kurzbeschreibung: Zwischenentitaet, die zusammenfasst welcher User was und wem freigegeben hat
CREATE TABLE dbo.share (
	share_id int IDENTITY (1, 1) NOT NULL,
	permission_id int NOT NULL,
	file_id int NOT NULL 
	CONSTRAINT pk_share PRIMARY KEY(share_id,permission_id,file_id),
	CONSTRAINT fk_share_permission FOREIGN KEY (permission_id) REFERENCES dbo.share_permission (permission_id),
	CONSTRAINT fk_share_files FOREIGN KEY (file_id) REFERENCES dbo.files (file_id)
)

SELECT * FROM dbo.share





-- Tabelle 5: dbo.users
-- Kurzbeschreibung: Dient dem Speichern abo_start Userdaten, die fuer den Ablauf der User-Authentifizierung notwendig sind
CREATE TABLE dbo.users ( 
	username varchar(20) CONSTRAINT pk_users PRIMARY KEY,
	passhash binary(64) NOT NULL,
	email varchar(60) NOT NULL, --CONSTRAINT ck_email CHECK (email = '%_@__%.__%'),
	firstname varchar(20) NOT NULL,
	lastname varchar(20) NOT NULL,
	size_of_all_files int NOT NULL CONSTRAINT size_of_all_files DEFAULT 0,
	user_abo_id int,
	abo_modell_id int CONSTRAINT abo_modell_id DEFAULT 1,
	salt UNIQUEIDENTIFIER 
	)

ALTER TABLE dbo.users
	ADD CONSTRAINT fk_users_userabo FOREIGN KEY (user_abo_id) REFERENCES dbo.user_abo (user_abo_id);

ALTER TABLE dbo.users
	ADD CONSTRAINT fk_users_abomodell FOREIGN KEY (abo_modell_id) REFERENCES dbo.abo_modell (abo_modell_id) --ON UPDATE CASCADE;
	
-- Tabelle 5 - INSERTS
--INSERT INTO ...
EXEC sp_useradd
			@pLogin = 'beerdrinker',
			@pPassword = 'Pa55w.rd',
			@pFirstName = 'klemens',
			@pLastName = 'konopasek',
			@pEmail = 'klemens.konopasek@fh-joanneum.at'

EXEC sp_useradd
          @pLogin = 'feldgrillp',
          @pPassword = 'Pa55w.rd',
          @pFirstName = 'peter',
          @pLastName = 'feldgrill',
		  @pEmail = 'peter.feldgrill@fh-joanneum.at'

EXEC sp_useradd
          @pLogin = 'kristant',
          @pPassword = 'Pa55w.rd',
          @pFirstName = 'thomas',
          @pLastName = 'kristan',
		  @pEmail = 'thomas.kristant@fh-joanneum.at'

EXEC sp_useradd
          @pLogin = 'nemetzc',
          @pPassword = 'Pa55w.rd',
          @pFirstName = 'christoph',
          @pLastName = 'nemetz',
		  @pEmail = 'christoph.nemetz@fh-joanneum.at'

EXEC sp_aboUpDowngrade 'beerdrinker', 2
EXEC sp_aboUpDowngrade 'feldgrillp', 1
EXEC sp_aboUpDowngrade 'kristant', 3
EXEC sp_aboUpDowngrade 'nemetzc', 2

SELECT * FROM dbo.users





-- Tabelle 6: dbo.user_abo
-- Kurzbeschreibung: Zwischenentitaet, die Informationen darueber enthaelt welcher User welches Abo-Modell ausgewaehlt hat und wie lang dieses Abo noch gueltig ist
CREATE TABLE dbo.user_abo ( 
	user_abo_id int IDENTITY(1, 1) CONSTRAINT pk_user_abo PRIMARY KEY, 
	abo_start date NOT NULL CONSTRAINT abo_start DEFAULT SYSDATETIME(),
	abo_end date NOT NULL CONSTRAINT abo_end DEFAULT DATEADD (month, 1, SYSDATETIME()),
	active bit NOT NULL,
	price smallmoney NOT NULL,
	abo_modell_id int
)

ALTER TABLE dbo.user_abo
	ADD CONSTRAINT fk_userabo_abomodell FOREIGN KEY (abo_modell_id) REFERENCES dbo.abo_modell (abo_modell_id)





-- Tabelle 7: dbo.abo_modell
-- Kurzbeschreibung: Dient dem Speichern der zwei moeglichen Abo-Modelle „Free“, „Premium“ und „Enterprise“
CREATE TABLE dbo.abo_modell (
	abo_modell_id int CONSTRAINT pk_abo PRIMARY KEY,
	abo_description varchar(10) NOT NULL,
	price smallmoney,
	available_space int NOT NULL)

-- Tabelle 7 - INSERTS
--INSERT INTO ...

INSERT INTO dbo.abo_modell (abo_modell_id, abo_description, price, available_space)
VALUES	(1, 'Free', 0, 5000),
		(2, 'Premium', 9.99, 50000),
		(3, 'Enterprise', 49.99, 1000000)

SELECT * FROM dbo.abo_modell





-- Tabelle 8: dbo.protocol
--Kruzbeschreibung: Dient der Protokollierung von Information darueber wie viel und fuer wie lang ein User fuer ein Abo bezahlt hat.
CREATE TABLE dbo.protocol (
	protocol_id int IDENTITY(1, 1) CONSTRAINT pk_protocol PRIMARY KEY,
	content varchar(max),
	date datetime NOT NULL CONSTRAINT df_protocol_date DEFAULT SYSDATETIME(),
	username varchar(20)
)

SELECT * FROM dbo.protocol





-- #######################################################################################
--  Trigger
-- #######################################################################################
 USE daent_projekt_03
-- Trigger 1: spaceCheck_iud
-- Kurzbeschreibung: Beim Erstellen einer neue Datei, wird ueberprueft ob genuegend Speicherplatz zur Verfuegung steht.
GO
CREATE TRIGGER dbo.spaceCheck_iud
ON dbo.files
FOR INSERT, UPDATE, DELETE
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @username varchar(30), @increase int, @decrease int;

	DECLARE increase CURSOR LOCAL STATIC
		FOR
			SELECT SUM(size), username FROM inserted GROUP BY username

	DECLARE decrease CURSOR LOCAL STATIC
		FOR
			SELECT SUM(size), username FROM deleted GROUP BY username
	
	OPEN increase;
	OPEN decrease;
	--Berechnen des vebrauchten Speicherplatzes beim Loeschen einer Datei
	FETCH NEXT FROM decrease INTO @decrease, @username; 
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @current_total_size int = (SELECT size_of_all_files FROM dbo.users WHERE username = @username)--verbrauchter Speicherplatz vor dem Loeschen
		DECLARE @new_total_size int = @current_total_size - @decrease --verbrauchter Speicherplatz nach dem Loeschen
		UPDATE dbo.users 
			SET size_of_all_files = @new_total_size WHERE username = @username 
	FETCH NEXT FROM decrease INTO @decrease, @username;
	END
	CLOSE decrease;
	DEALLOCATE decrease;

	
	--Berechnen des vebrauchten Speicherplatzes beim Erstellen / Aendern einer Datei
	FETCH NEXT FROM increase INTO @increase, @username;
	WHILE @@FETCH_STATUS = 0 
	BEGIN
	DECLARE @intermediate_total_size int = (SELECT size_of_all_files FROM dbo.users WHERE username = @username)--verbrauchter Speicherplatz vor dem Erstellen / Aendern
	DECLARE @final_total_size int = @intermediate_total_size + @increase--vebrauchter Speicherplatz nach dem Erstellen / Aendern
	DECLARE @max_size int = (SELECT m.available_space FROM dbo.users u--verfuegbarer Speicherplatz fuer User (abhaengig von Abo-Modell)
								INNER JOIN dbo.user_abo a ON u.user_abo_id = a.user_abo_id
								INNER JOIN dbo.abo_modell m ON a.abo_modell_id = m.abo_modell_id
								WHERE username = @username)
	IF @final_total_size > @max_size--Ueberpruefen ob neue Dateien den veruefgbaren Speicherplatz ueberschreiten
		THROW 50004, 'Not enough space!', 1; --Fehlermeldung, wenn zu wenig Speicherplatz zur Verfuegung steht
	ELSE
	BEGIN
		UPDATE dbo.users --Erstellung / Aenderung der Datei wird bei genuegend Speicherplatz durchgefuehrt
		SET size_of_all_files = @final_total_size WHERE username = @username 
		FETCH NEXT FROM increase INTO @increase, @username;
	END
	END

	CLOSE increase;
	DEALLOCATE increase;
END;
GO

-- Testaufrufe
-- Variante 1: Dateien werden geloescht -> size_of_all_files werden neu berechnet
BEGIN TRANSACTION
	SELECT * FROM dbo.files WHERE username = 'beerdrinker'
	SELECT * FROM dbo.users WHERE username = 'beerdrinker'
	DELETE FROM dbo.files WHERE parent_folder IN ('VO', 'UE')
	SELECT * FROM dbo.users WHERE username = 'beerdrinker'
ROLLBACK

-- Variante 2: Einfuegen einer zu großen Datei -> Fehlermeldung und ROLLBACK
SELECT * FROM dbo.files
SELECT * FROM dbo.users
INSERT INTO dbo.files (filename, size, filetype, username, parent_folder)
	VALUES ('DAENT-Projekt', 5030220, 'SQL', 'kristant', NULL)

SELECT * FROM dbo.users

--Variante 3: Erfolgreiches Einfuegen einer Datei
BEGIN TRANSACTION
	SELECT * FROM dbo.users WHERE username = 'kristant'
	INSERT INTO dbo.files (filename, size, filetype, username, parent_folder)
		VALUES ('DAENT-Projekt', 200, 'SQL', 'kristant', NULL)
	SELECT * FROM dbo.files WHERE username = 'kristant'
	SELECT * FROM dbo.users WHERE username = 'kristant'
ROLLBACK


-- Trigger 2: FolderExist_i
-- Kurzbeschreibung: ueberpruefen, ob bei der Erstellung einer File / eines Folders der angegebene Parent-Folder existiert.
GO
CREATE TRIGGER FolderExist_i 
ON dbo.files
FOR INSERT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @username varchar(20), @foldername varchar(30);

	DECLARE folderexistance CURSOR STATIC LOCAL
		FOR
			SELECT username, parent_folder
			FROM inserted
		
	OPEN folderexistance

	FETCH NEXT FROM folderexistance INTO @username, @foldername
	WHILE @@FETCH_STATUS = 0
	BEGIN
	IF @foldername IS NOT NULL --ueberpruefen, ob sich die zu erstellende Datei in einem Ordner befindet
		BEGIN
		--Wenn der Parentfolder nicht existiert -> ROLLBACK & Fehlermeldung
		IF  (SELECT COUNT (*) FROM dbo.files WHERE filename = @foldername AND Filetype ='FLDR' AND @username = username) = 0 
			BEGIN
			ROLLBACK;
			THROW 50001, 'Folder does not exist.', 1 
			END
		END
	FETCH NEXT FROM folderexistance INTO @username, @foldername
	END

	CLOSE folderexistance;
	DEALLOCATE folderexistance
END
GO	

-- Testaufrufe
-- Variante 1: Einfuegen einer Datei in einen Parent-Folder der nicht existiert

SELECT * FROM dbo.files
SELECT * FROM dbo.users
INSERT INTO dbo.files (filename, size, filetype, username, parent_folder)
	VALUES ('DAENT-Projekt', 500, 'SQL', 'kristant', 'DAENT')






-- Trigger 3: folderDelete_d
-- Kurzbeschreibung: Wird ein Ordner geloescht, so werden auch alle untergeordneten Dateien und Ordner geloescht.
ALTER DATABASE daent_projekt_03
SET RECURSIVE_TRIGGERS ON WITH NO_WAIT;--Wenn ein zu loeschender Ordner weitere Ordner enthaelt, muessen deren Dateien ebenfalls geloescht werden

GO
ALTER TRIGGER folderDelete_d 
ON dbo.files
AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @username varchar(20);
	DECLARE @type varchar(20), @filename varchar(30);
	DECLARE files CURSOR LOCAL STATIC
        FOR
			SELECT filename, Filetype, username
			FROM deleted;
        OPEN files;
        FETCH NEXT FROM files INTO @filename, @type, @username;

        WHILE @@FETCH_STATUS = 0
        BEGIN
			IF @type = 'FLDR' --ueberpruefen, ob zu loeschende Datei ein Ordner ist
			--Loeschen der untergeordneten Dateien
				DELETE FROM dbo.files
				WHERE parent_folder = @filename AND username = @username;
			FETCH NEXT FROM files INTO @filename, @type, @username;
        END
        CLOSE files;
    DEALLOCATE files;
END
GO		

-- Testaufrufe
-- Variante 1: Parent-Folder mit Child-Files wird geloescht -> Child-Files werden mitgeloescht ( -> size_of_all_files wird neu berechnet)
BEGIN TRANSACTION
	SELECT * FROM dbo.files WHERE username = 'beerdrinker'
	SELECT * FROM dbo.users WHERE username = 'beerdrinker'
	DELETE FROM dbo.files WHERE filename = 'Foliensaetze-DAENT'
	SELECT * FROM dbo.files WHERE username = 'beerdrinker'
	SELECT * FROM dbo.users WHERE username = 'beerdrinker'
ROLLBACK






-- Trigger 4: protocol_ins
-- Kurzbeschreibung: Verhindert, dass Zeilen manuell in die Protokolltabelle eingefuegt werden
GO
CREATE TRIGGER protocol_ins 
ON dbo.protocol
FOR INSERT
AS
BEGIN
    SET NOCOUNT ON;
	IF TRIGGER_NESTLEVEL() = 1 
	BEGIN
		ROLLBACK;
        THROW 50002, 'Kein direktes Einfuegen in die Protokolltabelle!', 1;
	END; 
END;

--Testaufruf: Kein Insert moeglich
SELECT * FROM dbo.protocol

INSERT INTO dbo.protocol (content, username)
VALUES ('1234', '5678');






--Trigger 5: protocol_upd_del
-- Kurzbeschreibung: Verhindert, dass Protokolleintraege nachtraeglich nicht mehr manipuliert werden koennen.
GO
CREATE TRIGGER protocol_upd_del 
ON dbo.protocol
FOR UPDATE, DELETE
AS
BEGIN
	SET NOCOUNT ON;
	ROLLBACK;
	THROW 50003, 'Kein Aendern/Loeschen von Protokolleintraegen!', 1;
END;

--Testaufruf:loeschen nicht moeglich
DELETE FROM dbo.protocol WHERE protocol_id = 1






--Trigger 6: protocol_user_abo 
-- Kurzbeschreibung: Protokolliert Aenderungen in der Tabelle user_abo
GO
CREATE TRIGGER protocol_user_abo ON dbo.user_abo
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @username varchar(20);
	SELECT @username = u.username FROM inserted i
		INNER JOIN dbo.users u ON u.user_abo_id = i.user_abo_id
	INSERT INTO dbo.protocol (content, username)
		SELECT 'von: ' + CONVERT(varchar, abo_start) + '; '
		+ 'bis: ' + CONVERT(varchar, abo_end) + '; '
		+ 'aktiv: ' + CONVERT(varchar, active) + '; '
		+ 'Preis: ' + CONVERT(varchar, price),
		@username
		FROM inserted;
END;

--Testaufruf: Protokoll Aenderungen in der Tabelle
BEGIN TRANSACTION
	SELECT * FROM dbo.protocol
	UPDATE dbo.user_abo
	SET abo_start = SYSDATETIME() WHERE user_abo_id = 3
	SELECT * FROM dbo.protocol
ROLLBACK






-- #######################################################################################
--  Prozeduren
-- #######################################################################################



-- Prozedur 1: sp_aboUpDowngrade
-- Kurzbeschreibung: Dient dem Up- und Downgrade eines User-Abos


SELECT * FROM dbo.users
SELECT * FROM dbo.abo_modell
GO

ALTER PROCEDURE sp_aboUpDowngrade
	
	@username varchar(20),
	@new_abo int 

AS
BEGIN
	SET NOCOUNT ON;
		
		BEGIN TRAN;
			
			DECLARE @abo_alt int;
			DECLARE @price smallmoney;
			DECLARE @erg tinyint;
			DECLARE @user_abo_id_alt int;

			IF (SELECT username FROM dbo.users WHERE username = @username) IS NULL -- ungueltiger username
			
			BEGIN 
				ROLLBACK TRAN;
				SET @erg = 90
			END

			ELSE IF (SELECT abo_modell_id FROM dbo.abo_modell WHERE abo_modell_id = @new_abo) IS NULL -- ungueltige abonummer
			
			BEGIN
				ROLLBACK TRAN;
				SET @erg = 91
			END

			ELSE IF (SELECT abo_modell_id FROM dbo.abo_modell WHERE abo_modell_id = @new_abo) IS NOT NULL 
			AND (SELECT username FROM dbo.users WHERE username = @username) IS NOT NULL

			BEGIN
				SELECT @price = price
				FROM dbo.abo_modell
				WHERE abo_modell_id = @new_abo

				SELECT @user_abo_id_alt = user_abo_id
				FROM dbo.users
				WHERE @username = username

				SELECT @abo_alt = a.abo_modell_id
				FROM dbo.user_abo a INNER JOIN dbo.users u ON a.user_abo_id = u.user_abo_id
				WHERE u.username = @username 
				AND SYSDATETIME() BETWEEN a.abo_start AND a.abo_end

				IF @@ROWCOUNT > 0 -- wenn der User existiert.
				BEGIN
			
					UPDATE dbo.user_abo
					SET abo_end = SYSDATETIME(), active = 0 -- altes Abo wird beendet und ende auf SYSDATETIME() gesetzt.
					WHERE user_abo_id = @user_abo_id_alt

					INSERT INTO dbo.user_abo (abo_modell_id, active, price) --neues Abo mit Preis einfuegen
					VALUES (@new_abo, 1, @price)

					UPDATE dbo.users 
					SET user_abo_id = SCOPE_IDENTITY(), abo_modell_id = @new_abo
					WHERE username = @username

					COMMIT TRAN;
					SET @erg = 0
				END
			END

			ELSE 
			
			BEGIN 
				ROLLBACK TRAN;
				SET @erg = 99
			END
SELECT @erg AS ergebnis
END

-- 0 = OK
-- 90 = User invalid
-- 91 = Abo_modell_id invalid
-- 99 = Unknown error

SELECT * FROM dbo.users
-- Testaufruf  Abo up bzw. Downgrade
-- Variante: Erfolgreiches Upgrade (0)
EXEC sp_aboUpDowngrade 'beerdrinker', 2

BEGIN TRANSACTION

SELECT * FROM dbo.users
EXEC sp_aboUpDowngrade 'feldgrillp', 3;
EXEC sp_aboUpDowngrade 'kristant', 3;
EXEC sp_aboUpDowngrade 'nemetzc', 3;
SELECT * FROM dbo.users

ROLLBACK

-- Variante: ungueltiger Username (90)
EXEC sp_aboUpDowngrade 'b33rdr1nk3r', 3

-- Variante: ungueltige Abo_Modell_id (91)
EXEC sp_aboUpDowngrade 'beerdrinker', 4

-- Variante: Downgrade auf Free
EXEC sp_aboUpDowngrade 'beerdrinker', 1






-- Prozedur 2: sp_useradd
-- Kurzbeschreibung: Anlegen eines neuen Users, Passwort wird in Hash umgewandelt, Salt wird generiert
GO
ALTER PROCEDURE sp_useradd
    @pLogin VARCHAR(20), 
    @pPassword VARCHAR(20),
    @pFirstName VARCHAR(20) = NULL, 
    @pLastName VARCHAR(20) = NULL,
	@pEmail VARCHAR(60)

AS   
BEGIN
    SET NOCOUNT ON

    DECLARE @salt UNIQUEIDENTIFIER=NEWID();
	DECLARE @erg tinyint;
    BEGIN TRY

        INSERT INTO dbo.users (username, passhash, salt, email, firstname, lastname)
        VALUES(@pLogin, HASHBYTES('SHA2_512', @pPassword+CAST(@salt AS NVARCHAR(36))), @salt, @pEmail, @pFirstName, @pLastName)
		--SHA2_512 -> Algorithmus zum Verschluesseln von Daten
	   SET @erg = 0
    END TRY
    BEGIN CATCH
		IF ERROR_MESSAGE() LIKE '%pk_users%' -- user already exists
			SET @erg = 90
		ELSE PRINT ERROR_MESSAGE() 
    END CATCH
	SELECT @erg AS ergebnis
END

SELECT * FROM dbo.users
-- 0 = user has been added.
-- 90 = user already exists.




-- Prozedur 3: sp_userLogin
-- Kurzbeschreibung: Simuliert einen User-Login

GO
ALTER PROCEDURE sp_userLogin
    @pLoginName VARCHAR(254),
    @pPassword VARCHAR(50)
    
AS
BEGIN

    SET NOCOUNT ON

    DECLARE @userID varchar(20);
	DECLARE @erg tinyint;

    IF EXISTS (SELECT TOP 1 username FROM dbo.users WHERE username=@pLoginName)
    BEGIN
        SET @userID=(SELECT username FROM dbo.users WHERE username=@pLoginName AND passhash=HASHBYTES('SHA2_512', @pPassword+CAST(salt AS NVARCHAR(36))))
		SET @erg = 0
		IF(@userID IS NULL)
           SET @erg = 90 --'Incorrect password'
       --ELSE 
		   --PRINT 'User successfully logged in'
    END
    ELSE
       SET @erg = 91 --PRINT 'Invalid login'
	SELECT @erg AS ergebnis
END

-- 0 = successfull login
-- 90 = Incorrect password
-- 91 = Incorrect Username


--Testaufruf User Login:

--Correct login and password
EXEC	sp_userLogin
		@pLoginName = 'beerdrinker',
		@pPassword = 'Pa55w.rd'
		
--Incorrect password
EXEC	sp_userLogin
		@pLoginName = 'beerdrinker', 
		@pPassword = 'Passwort'

--Incorrect Username
EXEC	sp_userLogin
		@pLoginName = 'TEST', 
		@pPassword = 'Pa55w.rd'
	






-- Prozedur 4: sp_passwordChange
-- Kurzbeschreibung: Bei der Aenderung des Passworts wird der Hash des neuen mit dem Hash des alten Passworts verlgichen.
--					 Dammit nicht jeder Benutzer jedes Passwort aendern kann, muss sich der Benutzer mit seinen Accountdaten anmelden.  
GO
ALTER PROCEDURE sp_passwordChange
		@username varchar(20),
		@password_old varchar(20),
		@password_new varchar(20)
		
AS
BEGIN
    SET NOCOUNT ON
	DECLARE @userID varchar(20);
	DECLARE @salt UNIQUEIDENTIFIER=NEWID();
	DECLARE @old_hash BINARY(64) ;
	DECLARE @old_salt UNIQUEIDENTIFIER;
	DECLARE @erg tinyint;

-- Zwischenspeichern des aktuellen salts und dem aktuellen Passwort Hashes
	SELECT @old_hash = passhash FROM dbo.users WHERE username=@username
	SELECT @old_salt = salt FROM dbo.users WHERE username=@username
    IF EXISTS (SELECT TOP 1 username FROM dbo.users WHERE username=@username) --ueberpruefung ob User vorhanden
    BEGIN
        SET @userID=(SELECT username FROM dbo.users WHERE username=@username AND passhash=HASHBYTES('SHA2_512', @password_new+CAST(salt AS NVARCHAR(36))))
		IF(@userID IS NULL)
			BEGIN
			-- ueberpruefung ob das aktuelle Pw richtig ist
				IF (@old_hash =  (HASHBYTES('SHA2_512', @password_old+CAST(@old_salt AS NVARCHAR(36))))) 
				BEGIN
					SET @erg = 0--PRINT 'Password changed.'
					UPDATE dbo.users 
					SET passhash = HASHBYTES('SHA2_512', @password_new+CAST(@salt AS NVARCHAR(36)))
						,salt = @salt
					WHERE @username = username				
				END
				ELSE
				BEGIN
					SET @erg = 90 --PRINT 'ERROR Password or username incorrect'
				END
			END
		ELSE
		BEGIN
			SET @erg = 91 --PRINT 'ERROR Password cant be the same'
		END
	END
	ELSE
		SET @erg = 92--PRINT 'Invalid username'
SELECT @erg AS ergebnis
END

-- 0 = password changed successfully
-- 90 = password or username incorrect
-- 91 = password can not be the same as the old password
-- 92 = username is invalid

--Testaufrufe   
--Correct login and password 0
BEGIN TRANSACTION
EXEC	sp_passwordChange
		@username = 'beerdrinker',
		@password_old = 'Pa55w.rd',
		@password_new = 'beerdrinker123'
ROLLBACK

--password or username incorrect 90
BEGIN TRANSACTION
EXEC	sp_passwordChange
		@username = 'beerdrinker',
		@password_old = 'Pa55w.rd!',
		@password_new = 'beerdrinker123'
ROLLBACK

--password can not be the same as the old password 91
BEGIN TRANSACTION
EXEC	sp_passwordChange
		@username = 'beerdrinker',
		@password_old = 'Pa55w.rd',
		@password_new = 'Pa55w.rd'
ROLLBACK

--Username is invalid 92
EXEC	sp_passwordChange
		@username = 'TEST1',
		@password_old = '4510',
		@password_new = '458'






-- Prozedur 5: sp_sharePermissions
-- Kurzbeschreibung: Ermoeglicht das Teilen einer File mit einem anderen User. Moegliche Berechtigungen: Write, Read
GO

ALTER PROCEDURE sp_sharePermissions
	
	@username varchar(20), -- der Benutzer, dem das File gehoert
	@filename varchar(30),
	@filetype varchar(6),
	@shared_user varchar(20), -- der Benutzer, fuer den das File freigegeben wird
	@permission bit -- 1 = Write Berechtigung, 0 = Read Berechtigung

AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

			DECLARE @file_id int;
			DECLARE @permission_id int;
			DECLARE @share_id int;
			DECLARE @erg tinyint;

			
			SELECT @file_id = file_id 
			FROM dbo.files 
			WHERE @username = username AND @filename = filename AND @filetype = filetype --alle Eigenschaften muessen zusammenpassen um Konflikte zu vermeiden

			
			SELECT @filename = filename 
			FROM dbo.files 
			WHERE @username = username
			
			IF @@ROWCOUNT < 1 -- wenn es keine Eintraege mit diesem Namen gibt
				
				SET @erg = 90 

			ELSE
				BEGIN

					INSERT INTO dbo.share_permission (permission, username)
					VALUES(@permission, @shared_user)

					SELECT @permission_id = permission_id 
					FROM dbo.share_permission 
					WHERE @permission = permission AND @shared_user = username

					INSERT INTO dbo.share (permission_id, file_id)
					VALUES(@permission_id, @file_id)
			
					SELECT @share_id = share_id -- aktuellste share_id
					FROM dbo.share 
					WHERE @file_id = file_id

					UPDATE dbo.files
					SET shared = 1 -- es wird geteilt
					WHERE @file_id = file_id

					UPDATE dbo.share_permission 
					SET share = @share_id -- auch in dieser Tabelle muss die share_id aktualisiert werden
					WHERE permission_id = @permission_id

					UPDATE dbo.files
					SET share = @share_id -- dasselbe hier
					WHERE file_id = @file_id

					SET @erg = 0 -- kein Fehler
				END

	END TRY
	BEGIN CATCH
	
	IF ERROR_MESSAGE() LIKE '%file_id%'
		SET @erg = 91
	ELSE
		SET @erg = 99
	END CATCH
SELECT @erg as ergebnis
END

-- 0 = filesharing completed successfully
-- 90 = user does not exist
-- 91 = file does not exist
-- 99 = unexpected error

--Testaufrufe
-- Share von Folder erfolgreich 0
BEGIN TRANSACTION
SELECT * FROM dbo.share
SELECT * FROM dbo.share_permission
SELECT * FROM dbo.files

EXEC sp_sharePermissions
	@username = 'nemetzc',
	@filename = 'Tetris',
	@filetype = 'EXE',
	@shared_user = 'beerdrinker',
	@permission = 1

SELECT * FROM dbo.share
SELECT * FROM dbo.share_permission
SELECT f.file_id, f.filename, f.filetype, f.username, f.share, p.permission, p.username AS recipient FROM dbo.files f INNER JOIN dbo.share s ON s.share_id = f.share
	INNER JOIN dbo.share_permission p ON p.permission_id = s.permission_id
ROLLBACK

-- Invalider Username 90

EXEC sp_sharePermissions
	@username = 'nemetzca',
	@filename = 'Tetris',
	@filetype = 'EXE',
	@shared_user = 'beerdrinker',
	@permission = 0	
	
SELECT * FROM dbo.share_permission

-- File does not exist 91

EXEC sp_sharePermissions
	@username = 'nemetzc',
	@filename = 'Tetrist',
	@filetype = 'EXE',
	@shared_user = 'beerdrinker',
	@permission = 0	
	
SELECT * FROM dbo.share_permission