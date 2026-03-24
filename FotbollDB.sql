CREATE DATABASE IF NOT EXISTS fotbolldb;
USE fotbolldb;

-- TABELL: Lag
CREATE TABLE `Lag` (
    LagID INT AUTO_INCREMENT PRIMARY KEY,
    Namn VARCHAR(100) NOT NULL,
    Stad VARCHAR(100)
);
-- TABELL: Spelare
CREATE TABLE `Spelare` (
    SpelareID INT AUTO_INCREMENT PRIMARY KEY,
    Namn VARCHAR(100) NOT NULL,
    Position VARCHAR(50),
    LagID INT,
    FOREIGN KEY (LagID) REFERENCES `Lag`(LagID)
);
-- TABELL: Matcher
CREATE TABLE Matcher (
    MatchID INT AUTO_INCREMENT PRIMARY KEY,
    HemmalagID INT NOT NULL,
    BortalagID INT NOT NULL,
    Datum DATE NOT NULL,

    FOREIGN KEY (HemmalagID) REFERENCES `Lag`(LagID),
    FOREIGN KEY (BortalagID) REFERENCES `Lag`(LagID)
);
-- TABELL: Mal
CREATE TABLE Mal (
    MalID INT AUTO_INCREMENT PRIMARY KEY,
    SpelareID INT NOT NULL,
    MatchID INT NOT NULL,
    Minut INT,
    FOREIGN KEY (SpelareID) REFERENCES Spelare(SpelareID),
    FOREIGN KEY (MatchID) REFERENCES Matcher(MatchID)
);

-- TABELL: Logg
CREATE TABLE Logg (
    LoggID INT AUTO_INCREMENT PRIMARY KEY,
    Meddelande TEXT,
    Tid DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- TRIGGER
DELIMITER //
CREATE TRIGGER mal_logg
AFTER INSERT ON Mal
FOR EACH ROW
BEGIN
    INSERT INTO Logg (Meddelande)
    VALUES ('Ett mål registrerades i databasen');
END//
DELIMITER ;

-- STORED PROCEDURE
DELIMITER //
CREATE PROCEDURE SpelarStatistik()
BEGIN
    SELECT Spelare.Namn, COUNT(Mal.MalID) AS AntalMal
    FROM Spelare
    LEFT JOIN Mal ON Spelare.SpelareID = Mal.SpelareID
    GROUP BY Spelare.Namn
    ORDER BY AntalMal DESC;
END//
DELIMITER ;

-- INDEX
CREATE INDEX idx_spelare_lag ON Spelare(LagID);
CREATE INDEX idx_mal_spelare ON Mal(SpelareID);
CREATE INDEX idx_mal_match ON Mal(MatchID);

-- Infoga DATA
INSERT INTO `Lag` (Namn, Stad)
VALUES
('AIK','Stockholm'),
('Barcelona','Barcelona'),
('Manchester City','Manchester');

INSERT INTO Spelare (Namn,Position,LagID)
VALUES
('Zlatan Ibrahimovic','Forward',1),
('Robert Lewandowski','Forward',2),
('Erling Haaland','Forward',3);

INSERT INTO Matcher (HemmalagID,BortalagID,Datum)
VALUES
(1,2,'2026-04-01'),
(2,3,'2026-04-10');

INSERT INTO Mal (SpelareID,MatchID,Minut)
VALUES
(1,1,23),
(2,1,40),
(3,2,55);

-- Säkerhet
CREATE USER IF NOT EXISTS 'admin'@'localhost'
IDENTIFIED BY 'password';

GRANT ALL PRIVILEGES
ON FotbollDB.*
TO 'admin'@'localhost';

CREATE USER IF NOT EXISTS 'viewer'@'localhost'
IDENTIFIED BY 'password';

GRANT SELECT
ON FotbollDB.*
TO 'viewer'@'localhost';

-- Visa spelare och lag
SELECT Spelare.Namn, `Lag`.Namn
FROM Spelare
JOIN `Lag`
ON Spelare.LagID = `Lag`.LagID;

-- Visa mål per spelare
SELECT Spelare.Namn, COUNT(*) AS AntalMal
FROM Mal
JOIN Spelare
ON Mal.SpelareID = Spelare.SpelareID
GROUP BY Spelare.Namn;




