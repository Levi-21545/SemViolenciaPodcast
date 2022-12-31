create user 'semviolencia';

create database semviolenciadb;

create table episodiosnepgs(
    id int auto_increment,
    programa varchar(50) not null,
    titulo varchar(100) not null,
    dia varchar(20) not null,
    duracao varchar(10) not null,
    arq varchar(50) not null,
    thumb varchar(50),    
    primary key (id)
);

create table programas(
	id int auto_increment,
    nome varchar(30) not null,
    descricao longtext,
    descComp longtext,
    imagem varchar(50),
    primary key (id)
);

create table usuarios(
	id int auto_increment,
    tipo varchar(20) not null,
    nome varchar(100) not null,
    email varchar(100) not null,
    senha varchar(30) not null,
    perfil varchar(100),
    primary key (id)
);