CREATE DATABASE EconomicManagementDB
GO
USE EconomicManagementDB
GO

CREATE TABLE [Users](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Email] [Varchar](256) NOT NULL,
	[StandarEmail] [Varchar](256) NOT NULL,
	[Password] [Varchar](max) NOT NULL,
)
GO

CREATE TABLE [AccountTypes](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Name] [Varchar](50) NOT NULL,
	[UserId] [int] NOT NULL,
	[OrderAccount] [int] NOT NULL,
	CONSTRAINT [FK_AccountTypes_Users] FOREIGN KEY (UserId) REFERENCES Users(Id)
)
GO

CREATE TABLE [Accounts](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Name] [Varchar](50) NOT NULL,
	[AccountTypeId] [int] NOT NULL,
	[Balance] [decimal](18, 2) NOT NULL,
	[Description] [Varchar](1000) NULL,
    CONSTRAINT [FK_AccountType] FOREIGN KEY (AccountTypeId) REFERENCES AccountTypes(Id)
)
GO

CREATE TABLE [OperationTypes](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Description] [Varchar](50) NOT NULL,
)
GO

CREATE TABLE Categories(
	[Id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[Name] [Varchar](50) NOT NULL,
	[OperationTypeId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
  CONSTRAINT [FK_Categories_Operations] FOREIGN KEY (OperationTypeId) REFERENCES OperationTypes(Id),
	CONSTRAINT [FK_Categories_Users] FOREIGN KEY (UserId) REFERENCES Users(Id)
)
GO

CREATE TABLE [Transactions](
	[Id] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
	[UserId] [int] NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[Total] [decimal](18, 2) NOT NULL,
	[Description] [Varchar](1000) NULL,
	[AccountId] [int] NOT NULL,
	[CategoryId] [int] NOT NULL,
	CONSTRAINT [FK_Transactions_Users] FOREIGN KEY (UserId) REFERENCES Users(Id),
	CONSTRAINT [FK_Transactions_Account] FOREIGN KEY (AccountId) REFERENCES Accounts(Id),
	CONSTRAINT [FK_Transactions_Categories] FOREIGN KEY (CategoryId) REFERENCES Categories(Id)
)
GO

-- Insert obligatorio, ya que las operaciones llevan valores fijos.

INSERT INTO OperationTypes 
		VALUES('Ingreso'),
				('Gasto');
Go
/**************************************************/
/*SP para eliminar la categoria (en cadena por FK */
/**************************************************/

CREATE PROCEDURE sp_delete_cateorie
@id int
AS
BEGIN
	SET NOCOUNT ON;
		If exists (Select 1 from Transactions where CategoryId = @id )
		BEGIN 
			DELETE FROM Transactions where CategoryId = @id
		END
		DELETE FROM Categories WHERE Id = @id
END
GO

/**********************************/
/*SP para insertar la transaccion */
/**********************************/

CREATE PROCEDURE sp_insert_transaction
	@UserId int,
	@TransactionDate date,
	@Total decimal(18,2),
  @CategoryId int,
  @AccountId int,
	@Description Varchar(1000) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO Transactions(UserId, TransactionDate, Total, CategoryId, AccountId, Description)
	VALUES(@UserId, @TransactionDate, ABS(@Total), @CategoryId, @AccountId, @Description)

  UPDATE Accounts
  SET Balance += @Total
  WHERE Id = @AccountId;

  SELECT SCOPE_IDENTITY();
END
GO

/************************************/
/*SP para actualizar la transaccion */
/************************************/

CREATE PROCEDURE sp_update_transaction
	@Id int,
	@TransactionDate datetime,
	@Total decimal(18,2),
	@PreviousTotal decimal(18,2),
	@AccountId int,
	@PreviousAccountId int,
	@CategoryId int,
	@Description Varchar(max) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	-- Revierte la transaccion
	UPDATE Accounts
	SET Balance -= @PreviousTotal
	WHERE Id = @PreviousAccountId;

	-- crea una transaccion
	UPDATE Accounts
	SET Balance += @Total
	WHERE Id = @AccountId;
	
	-- asigna la nueva transaccion, el monto se muestra en valor absoluto y actualiza la fecha.
	UPDATE Transactions
	SET Total = ABS(@Total), TransactionDate = @TransactionDate,
	CategoryId = @CategoryId, AccountId = @AccountId, Description = @Description
	WHERE Id = @Id;
END
GO

/**********************************/
/*SP para eliminar la transaccion */
/**********************************/

CREATE PROCEDURE sp_delete_transaction
	@Id int
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Total decimal(18,2);
	DECLARE @AccountId int;
	DECLARE @OperationTypeId int;

	SELECT @Total = Total, @AccountId = AccountId, @OperationTypeId = cate.OperationTypeId
	FROM Transactions
	INNER JOIN Categories cate
	ON cate.Id = Transactions.CategoryId
	WHERE Transactions.Id = @Id;

	DECLARE @MultiplicativeFactor int = 1;

	IF (@OperationTypeId = 2)
		SET @MultiplicativeFactor = -1;

	SET @Total = @Total * @MultiplicativeFactor;

	UPDATE Accounts
	SET Balance -= @Total
	WHERE Id = @AccountId;

	DELETE Transactions
	WHERE Id = @Id;
END
GO

