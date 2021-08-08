Use MASTER

DROP DATABASE IF EXISTS [SchoolDB]
GO

CREATE DATABASE [SchoolDB];
GO

--DROP SCHEMA IF EXISTS School

USE [SchoolDB]
GO

CREATE SCHEMA [School]
GO

CREATE TABLE [School].[Students] (
    [ID_Student] INT           NOT NULL,
    [FirstName]  NVARCHAR (20) NULL,
    [LastName]   NVARCHAR (20) NULL,
    CONSTRAINT [PK_Students] PRIMARY KEY CLUSTERED ([ID_Student] ASC)
);

CREATE TABLE [School].[Teachers] (
    [ID_Teacher] INT           NOT NULL,
    [FirstName]  NVARCHAR (50) NULL,
    [LastName]   NVARCHAR (50) NULL,
    CONSTRAINT [PK_Teachers] PRIMARY KEY CLUSTERED ([ID_Teacher] ASC)
);

CREATE TABLE [School].[Lessons] (
    [ID_Lesson]  INT           NOT NULL,
    [LessonName] NVARCHAR (20) NULL,
    [ID_Teacher] INT           NULL,
    CONSTRAINT [PK_Lessons] PRIMARY KEY CLUSTERED ([ID_Lesson] ASC),
    CONSTRAINT [FK_Lessons_Teachers] FOREIGN KEY ([ID_Teacher]) REFERENCES [School].[Teachers] ([ID_Teacher])
);

CREATE TABLE [School].[StudentsLessons] (
    [ID_Student] INT NOT NULL,
    [ID_Lesson]  INT NOT NULL,
    CONSTRAINT [PK_StudentsLessons] PRIMARY KEY CLUSTERED ([ID_Student] ASC, [ID_Lesson] ASC),
    CONSTRAINT [FK_StudentsLessons_Lessons] FOREIGN KEY ([ID_Lesson]) REFERENCES [School].[Lessons] ([ID_Lesson]),
    CONSTRAINT [FK_StudentsLessons_Students] FOREIGN KEY ([ID_Student]) REFERENCES [School].[Students] ([ID_Student])
);


INSERT INTO [School].[STUDENTS]
([ID_Student], [FirstName], [LastName]) 
VALUES 
(1, 'Anton', 'Forcade'),
(2, 'Anton', 'Ferne'),
(3, 'Hendrika','Sollas'),
(4, 'Anton', 'Dorset'),
(5, 'Irina','Bausmann'),
(6, 'Irina', 'Room'),
(7, 'Irina', 'Ridewood'),
(8, 'Irina', 'Rizzardo'),
(9, 'Augustin','Esilmon'),
(10, 'Irina', 'Aplin'),
(11, 'Anton', 'Ivanov');

INSERT INTO [School].[TEACHERS]
([ID_Teacher], [FirstName], [LastName])
VALUES
(1, 'Pamelina', 'Zimek'),
(2, 'Allx', 'Parcells'),
(3, 'Blake', 'Reinmar'),
(4, 'Lee', 'Carnachen'),
(5, 'Dorita', 'Kermode');

INSERT INTO [School].[LESSONS]
([ID_Lesson], [LessonName], [ID_Teacher])
VALUES
(1, 'English', 1),
(2, 'RegionalLanguage', 1),
(3, 'Maths', 5),
(4, 'Science', 1),
(5, 'Social Sciences', 5),
(6, 'Physical Education', 2),
(7, 'Computer Basics', 4),
(8, 'Arts (Drawing)', 3);

INSERT INTO [School].[StudentsLessons]
([ID_Student], [ID_Lesson])
VALUES
(1, 1),
(1, 3),
(1, 4),
(1, 8),
(2, 1),
(2, 8),
(3, 1),
(3, 3),
(3, 5),
(4, 1),
(4, 7),
(5, 6),
(5, 7),
(5, 8),
(6, 6),
(6, 7),
(7, 1),
(7, 3),
(7, 7),
(8, 3),
(8, 5),
(8, 8),
(9, 1),
(10, 2),
(10, 3),
(10, 8),
(11, 1),
(11, 2),
(11, 6),
(11, 7),
(11, 8);

--/////////////////

SELECT 
    [ST].[FIRSTNAME],
    [ST].[LASTNAME],
    [LS].[LESSONNAME],
    [T].[FIRSTNAME],
    [T].[LASTNAME]
FROM 
    [School].[STUDENTS] [ST]
JOIN [School].[STUDENTSLESSONS] [SL] ON [ST].[ID_Student] = [SL].[ID_Student]
RIGHT JOIN [School].[LESSONS] [LS] ON LS.[ID_Lesson] = [SL].[ID_Lesson]
RIGHT JOIN [School].[TEACHERS] [T] ON T.[ID_Teacher] = LS.[ID_Teacher]

--3. Для всех студентов выведите число изучаемых ими предметов и число преподавателей
SELECT 
    ST.[FIRSTNAME], 
	ST.[LASTNAME],
	COUNT(LS.LESSONNAME) LESSONSNUMBER,
	COUNT(DISTINCT T.FIRSTNAME) TEACHERSNUMBER
FROM 
    [School].[STUDENTS] ST
INNER JOIN [School].[STUDENTSLESSONS] SL ON ST.[ID_Student] = SL.[ID_Student]
RIGHT JOIN [School].[LESSONS] LS ON LS.[ID_Lesson] = SL.[ID_Lesson]
RIGHT JOIN [School].[TEACHERS] T ON T.[ID_Teacher] = LS.[ID_Teacher]
GROUP BY ST.[FIRSTNAME], ST.[LASTNAME]

--4. Посчитайте число студентов для каждого преподавателя.
SELECT 
    T.[FIRSTNAME],
	COUNT(SL.[ID_Student]) STUDENTSNUMBER
FROM [School].[TEACHERS] T
RIGHT JOIN [School].[LESSONS] LS ON T.[ID_Teacher] = LS.[ID_Teacher]
RIGHT JOIN [School].[STUDENTSLESSONS] SL ON SL.[ID_Lesson] = LS.[ID_Lesson]
GROUP BY T.[FIRSTNAME]
ORDER BY T.[FIRSTNAME]

--5. Выведите студентов, имена которых встречаются больше трёх раз (Дима 3 шт., Саша 5 шт. и т.д.).
SELECT 
    ST.[ID_STUDENT], 
	ST.[FIRSTNAME], 
	ST.[LASTNAME],
	COUNT(*) OVER (PARTITION BY ST.[FIRSTNAME]) as TOTALNAMESNUMBER
FROM
    [School].[STUDENTS] ST
WHERE ST.[FIRSTNAME] IN (
    SELECT 
	    ST.[FIRSTNAME] 
	FROM [School].[STUDENTS] ST 
	GROUP BY ST.[FIRSTNAME] 
	HAVING COUNT (ST.[FIRSTNAME]) > 3
	)
ORDER BY ST.[FIRSTNAME] 
