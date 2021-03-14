create database Produtos
go
use Produtos

create table Produtos(
codigo int,
nome varchar(100),
valor decimal(4,2)
primary key(codigo))

create table entrada(
codigo_transacao int,
codigo_produto int,
quantidade int,
valor_total decimal(4,2)
primary key(codigo_transacao),
foreign key(codigo_produto) references Produtos(codigo))

create table saida(
codigo_transacao int,
codigo_produto int,
quantidade int,
valor_total decimal(4,2)
primary key(codigo_transacao),
foreign key(codigo_produto) references Produtos(codigo))


CREATE PROCEDURE sp_insereproduto(@codigoProduto INT,@codigoTransacao int, @qnt int ,@tipo varchar(1))
AS
	declare @query varchar(max),
			@valorProduto decimal(4,2),
			@tabela varchar(50),
			@erro varchar(max)
	set @valorProduto = (select valor from Produtos where codigo = @codigoProduto)
	set @valorProduto = (@valorProduto * @qnt)
	IF (@tipo = 'e')
	BEGIN
		set @tabela = 'entrada'
	END
	ELSE
	BEGIN
		set @tabela = 'saida'
	END
	set @query = 'insert into '+@tabela+' values ('+CAST(@codigoTransacao as varchar(10))+','+CAST(@codigoProduto as varchar(10))+','+CAST(@qnt as varchar(10))+','+CAST(@valorProduto as varchar(10))+')'
	print @query
	BEGIN TRY
		EXEC (@query)
	END TRY
	begin catch
		set @erro = ERROR_MESSAGE()
		if(@erro like '%primary%')
		begin 
			RAISERROR('ID produto duplicado',16,1)
		end
		begin
			RAISERROR('Erro de processamento',16,1)
		end
	end catch

	insert into Produtos values(1,'Produto1',10)
	insert into Produtos values(2,'Produto2',20)
	insert into Produtos values(3,'Produto3',30)
	insert into Produtos values(4,'Produto4',40)

	select * from Produtos

	drop procedure sp_insereproduto


	EXEC sp_insereproduto 1, 1, 1,'e'
	EXEC sp_insereproduto 2, 2, 2,'e'
	EXEC sp_insereproduto 2, 2, 2,'s'

	select * from entrada
	select * from saida