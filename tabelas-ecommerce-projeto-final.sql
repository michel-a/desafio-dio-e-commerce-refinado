-- criação do banco de dados para o cenário do E-commerce
-- drop database ecommerce;
create database ecommerce;
use ecommerce;
show tables;

-- criar tabela tipo de cliente
create table customer_type (
	idCustomerType int auto_increment primary key,
    CustomerType ENUM('Pessoa Física', 'Pessoa Jurídica') default 'Pessoa Física'
);
alter table customer_type auto_increment = 1;
-- desc customer_type;

-- criar tabela cliente
create table clients(
	idClient int auto_increment primary key,
    idClientCustomerType int,
    Fname varchar(20),
    Minit char(3),
    Lname varchar(20),
    CPF char(11),
    CNPJ char(15),
    BirthDate date,
    Address varchar(100),
    constraint unique_cpf_client unique(cpf),
    constraint fk_clients_customer_type foreign key (idClientCustomerType)
		references customer_type (idCustomerType)
);
alter table clients auto_increment = 1;
-- desc clients;

-- criar tabela produto
create table product(
	idProduct int auto_increment primary key,
    Pname varchar(50) not null,
    Classification_kids bool default false,
    Category enum('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') not null default 'Eletrônico',
    Description varchar(100),
    Evaluation float default 0,
    Size varchar(20),
    Price float
);
alter table product auto_increment = 1;
-- desc product;

-- criar tabela pagamento
create table payments(
	idPayment int auto_increment primary key,
    TypePayment enum('Boleto', 'Cartão', 'Dois cartões') default 'Cartão',
    LimitAvailable float
);
alter table payments auto_increment = 1;
-- desc payments;

-- creiar tabela entrega
create table delivery (
	idDelivery int auto_increment primary key,
    StatusDelivery enum('Em Separação', 'Enviado', 'Entregue') default 'Em Separação',
    TrackingCode varchar(30)
);
alter table delivery auto_increment = 1;
-- desc delivery;

-- criar tabela pedido
create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    idOrderPayment int,
    idOrderDelivery int,
    OrderStatus enum('Em processamento', 'Confirmado', 'Cancelado') default 'Em processamento',
    OrderDescription varchar(255),
    SendValue float default 10,
    constraint fk_orders_client foreign key (idOrderClient) references clients(idClient)
		on update cascade,
	constraint fk_orders_payment foreign key (idOrderPayment) references payments (idPayment),
	constraint fk_orders_delivery foreign key (idOrderDelivery) references delivery (idDelivery)
);
alter table orders auto_increment = 1;
-- desc orders;

-- criar tabela estoque
create table product_storage(
	idProdStorage int auto_increment primary key,
    StorageLocation varchar(255),
    Quantity int default 0
);
alter table product_storage auto_increment = 1;
-- desc product_storage;

-- criar tabela fornecedor
create table supplier(
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);
alter table supplier auto_increment = 1;
-- desc supplier;

-- criar tabela vendedor
create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    Location varchar(255),
    CNPJ char(15),
    CPF char(11),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
);
alter table seller auto_increment = 1;
-- desc seller;

create table product_seller (
	idPSeller int,
    idPProduct int,
    ProdQuantity int default 1,
    primary key (idPSeller, idPProduct),
    constraint fk_product_seller foreign key (idPSeller) references seller (idSeller),
    constraint fk_product_product foreign key (idPProduct) references product (idProduct)
);
-- desc product_seller;

create table product_order (
	idPOProduct int,
    idPOOrder int,
    POQuantity int default 1,
    POStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOProduct, idPOOrder),
    constraint fk_product_order_product foreign key (idPOProduct) references product (idProduct),
    constraint fk_product_order_orders foreign key (idPOOrder) references orders (idOrder)
);
-- desc product_order;

create table storage_location (
	idLProduct int,
    idLStorage int,
    Location varchar(255) not null,
    primary key (idLProduct, idLStorage),
    constraint fk_storage_location_product foreign key (idLProduct) references product (idProduct),
    constraint fk_storage_location_storage foreign key (idLStorage) references product_storage (idProdStorage)
);
-- desc storage_location;

create table product_supplier (
	idPsSupplier int,
    idPsProduct int,
    Quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier (idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references product (idProduct)
);
-- desc product_supplier;

-- Exibir as tabelas
show tables;

-- Selecionar cada uma das tabelas
select * from customer_type;
select * from clients;
select * from product;
select * from payments;
select * from delivery;
select * from orders;
select * from product_storage;
select * from supplier;
select * from seller;
select * from product_seller;
select * from product_order;
select * from storage_location;
select * from product_supplier;

insert into customer_type (CustomerType)
	values ('Pessoa Física'),
    ('Pessoa Jurídica');
    
insert into clients (idClientCustomerType, Fname, Minit, Lname, CPF, CNPJ, BirthDate, Address)
	values (1, 'Maria', 'M', 'Silva', 123456789, null, '1987-03-11', 'Rua Silva de Prata, 29, Carangola - Cidade das Flores'),
	(2, 'Matheus', 'O', 'Pimentel', null, 987654123212121, '1977-09-17', 'Rua Almeida, 299, Centro - Cidade das Flores'),
    (2, 'Ricardo', 'F', 'Silva', null, 456789123123457, '1983-07-12', 'Avenida Alameda Vinha, 1009, Centro - Cidade das Flores'),
    (1, 'Marcia', 'S', 'França', 789123456, null, '1991-03-13', 'Rua Larejeiras, 861, Centro - Cidade das Flores'),
    (1, 'Roberta', 'G', 'Assis', 987456321, null, '1979-07-29', 'Avenida Coller, 19, Centro - Cidade das Flores'),
    (2, 'Isabela', 'M', 'Cruz', null, 654987123213213, '1988-04-19', 'Rua Alameda das Flores, 28, Centro - Cidade das Flores');

insert into product (Pname, Classification_kids, Category, Description, Evaluation, Size, Price)
	values('Fone de Ouvido', false, 'Eletrônico', 'Descrição do produto', 4, 'Médio', 10.0),
    ('Barbie Elsa', true, 'Brinquedos', 'Boneca Barbie', 3, '30cm', 110.90),
    ('Body Carters', false, 'Vestimenta', 'Roupa infanto-juvenil', 5, 'Tamanho M', 22.0),
    ('Microfone Vedo - Youtuber', false, 'Eletrônico', 'Microfone de mesa', 4, '100cm', 300.40),
    ('Sofá Retrátil', false, 'Móveis', 'Sofá para quarto ou sala', 3, '3x57x80', 490.20),
    ('Farinha de Arroz', false, 'Alimentos', 'Produto alimentar', 2, null, 12.0),
    ('Fire stick Amazon', false, 'Eletrônico', null, 3, null, 77.0);

insert into orders (idOrderClient, OrderStatus, OrdeDescription, SendValue, PaymentCash)
	values (1, null, 'compra via aplicativo', null, 1),
    (2, null, 'compra via aplicativo', 50, 0),
    (3, 'Confirmado', null, null, 1),
    (4, null, 'compra via web site', 150, 0);

insert into payments (TypePayment, LimitAvailable)
	values ('Boleto', 1200),
    ('Cartão', 1400),
    ('cartão', 1200),
    ('Dois cartões', 3200),
    ('Boleto', 800);

insert into delivery (StatusDelivery, TrackingCode)
	values ('Em Separação', null),
    ('Enviado', 'AB12344321CD'),
    ('Entregue', 'CB43211234FD'),
    ('Enviado', 'WB41231243ZD'),
    ('Em Separação', null);

insert into orders (idOrderClient, idOrderPayment, idOrderDelivery, OrderStatus, OrderDescription, SendValue)
	values (2, 1, 6, default, 'compra via aplicativo', 100);
insert into orders (idOrderClient, idOrderPayment, idOrderDelivery, OrderStatus, OrderDescription, SendValue)
	values (1, 1, 6, default, 'compra via aplicativo', 60),
    (2, 2, 7, 'Em processamento', 'compra via aplicativo', 70),
    (3, 3, 8, 'Confirmado', 'compra via web site', 80),
    (4, 4, 9, 'Confirmado', 'compra via web site', 90),
    (5, 5, 9, 'Confirmado', 'compra via aplicativo', 100),
    (3, 4, 8, 'Confirmado', 'compra via web site', 90),
    (1, 3, 7, default, 'compra via aplicativo', 80),
    (1, 2, 7, 'Cancelado', 'compra via web site', 10);

insert into product_order (idPOProduct, idPOOrder, PoQuantity, PoStatus)
	values (1, 1, 2, null),
    (2, 1, 1, null),
    (3, 1, 1, null);

insert into product_storage (StorageLocation, Quantity)
	values ('Rio de Janeiro', 1000),
    ('Rio de Janeiro', 500),
    ('São Paulo', 10),
    ('São Paulo', 100),
    ('São Paulo', 10),
    ('Brasília', 600);

insert into storage_location (idLProduct, idLStorage, Location)
	values (1, 2, 'RJ'),
    (2, 6, 'GO');

insert into supplier (SocialName, CNPJ, contact)
    values ('Almeida e Filhos', 123456789123112, '21985474'),
    ('Eletrônicos Silva', 854519649143457, '21985474'),
    ('Eletrônicos Silva', 934567893934695, '21985474');
insert into supplier (SocialName, CNPJ, contact)
	values ('Kids World', '456789123654485', '1198657484');

insert into product_supplier (idPsSupplier, idPsProduct, Quantity)
	values (1, 1, 500),
    (1, 2, 400),
    (2, 4, 633),
    (3, 3, 5),
    (2, 5, 10);

insert into seller (SocialName, AbstName, CNPJ, CPF, Location, contact)
	values ('Tech Eletronics', null, 123456789456321, null, 'Rio de Janeiro', 219946287),
    ('Botique Durgas', null, null, 123456783, 'Rio de Janeiro', 219567895),
    ('Kids World', null, 456789123654485, null, 'São Paulo', 1198657484);

insert into product_seller (idPSeller, idPProduct, ProdQuantity)
	values (1, 6, 80),
    (2, 7, 10);

-- Recuperar pedido com produto associado
select * from clients c
	inner join orders o on c.idClient = o.idOrderClient
	inner join product_order p on p.idPoOrder = o.idOrder;

-- Recuperar quantos pedidos foram realizados pelos clientes
select c.idClient, count(*) as Number_of_orders from clients c
	inner join orders o on c.idClient = o.idOrderClient
	inner join product_order p on p.idPoOrder = o.idOrder
    group by c.idClient;

-- Recuperações simples com SELECT Statement
select * from clients;

-- Filtros com WHERE Statement
select * from product where category = "Eletrônico";

-- Crie expressões para gerar atributos derivados
select idClient, concat(Fname, ' ', Minit, '. ', Lname) as Complete_Name, BirthDate, Address from clients;

-- Defina ordenações dos dados com ORDER BY
select * from product order by Pname desc;

-- Condições de filtros aos grupos – HAVING Statement
select c.idClient, c.Fname, count(o.idOrderClient) as Qtd_Pedidos
	from clients c 
    inner join orders o on c.idClient = o.idOrderClient 
    group by o.idOrderClient
    having count(o.idOrderClient) >= 2;

-- Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados
-- Seleção de produto e produto_estoque onde o id do produto seja igual ao id do produto no estoque
select * from product, product_storage where idProduct = idProdStorage;

-- Quantos pedidos foram feitos por cada cliente?
select c.idClient, concat(c.Fname, ' ', Minit, '. ', c.Lname) as Nome_Completo, count(o.idOrderClient) as Qtd_Pedidos
	from clients c 
    inner join orders o on c.idClient = o.idOrderClient 
    group by o.idOrderClient;

-- Algum vendedor também é fornecedor?
select * from seller v inner join supplier f on v.cnpj = f.cnpj;

-- Relação de produtos fornecedores e estoques;
select * from product_storage ps inner join storage_location sl on ps.idProdStorage = sl.idLStorage;

-- Relação de nomes dos fornecedores e nomes dos produtos;    
select p.Pname, s.SocialName, idSupplier from product p, supplier s, product_supplier ps
	where p.idProduct = ps.idPsProduct and s.idSupplier = ps.idPsSupplier;
