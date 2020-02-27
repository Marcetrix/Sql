/*1 - Crie um BD com nome Clinica*/
create database Clinica;
set sql_safe_updates=0;
/*use Clinica;*/
/*2 - Crie as seguintes tabelas neste BD, considerando que os atributos sublinhados 
são chaves primárias e os em itálico são chaves estrangeiras: */
use Clinica;


create table Ambulatorios(
	nroa int not null primary key,
    andar numeric(3) not null,
    capacidade smallint
    );

create table Medicos(
	codm int primary key,
    nome varchar(40) not null,
    especialidade char(20),
    idade smallint not null,
    cpf numeric(11) unique,
    cidade varchar(30),
    nroa int,
    foreign key (nroa) references Ambulatorios(nroa) on update cascade
    );
    
create table Funcionarios(
    codf int primary key,
    nome varchar(40) not null,
    idade smallint,
    cidade varchar(30),
    cargo varchar(20),
    salario numeric(10),
    cpf numeric(11) unique
    );

create table Pacientes(
	codp int primary key,
	nome varchar(40) not null,
    idade smallint not null,
    cidade char(30),
    cpf numeric(11) unique,
    doenca varchar(40) not null
    );

create table Consultas(
	codm int,
    codp int,
    dia date,
    hora time,
    primary key (codm, codp, dia, hora),
    foreign key (codp) references Pacientes(codp) on update cascade,
    foreign key (codm) references Medicos(codm) on update cascade
    );
    
/*3 - Crie a coluna nroa (int) na tabela Funcionarios*/    
alter table Funcionarios add column nroa int references Ambulatorios(nroa);

/*4 - Crie os seguintes índices:
Medicos: CPF (único)
Pacientes: doenca  */  
create unique index indcpf on Medicos(cpf);
create unique index inddoenca on Pacientes(doenca);

/*5- Remover o índice doenca em Pacientes*/
drop index inddoenca on Pacientes;

/*6 - Remover as colunas cargo e nroa da tabela de Funcionarios*/
alter table Funcionarios drop column cargo, drop column nroa;

/*Ordem: nroa, andar, capacidade  */
insert into Ambulatorios Values (1, 1, 30);
insert into Ambulatorios Values (2, 1, 50);
insert into Ambulatorios Values (3, 2, 40);
insert into Ambulatorios Values (4, 2, 25);
insert into Ambulatorios Values (5, 2, 55);

/*Ordem: codm, nome, especialidade, idade, cpf, cidade, nroa */
insert into Medicos Values (1, 'João', 'ortopedia', 40, 10000100000, 'Florianopolis', 1);
insert into Medicos Values (2, 'Maria', 'traumatologia', 42, 10000110000, 'Blumenau', 2);
insert into Medicos Values (3, 'Pedro', 'pediatria', 51, 11000100000, 'São José', 2);
insert into Medicos Values (4, 'Carlos', 'ortopedia', 28, 11000110000, 'Joinville', null);
insert into Medicos Values (5, 'Marcia', 'neurologia', 33, 11000111000, 'Biguacu', 3);

/*Ordem: codp, nome, idade, cidade, cpf, doenca  */
insert into Pacientes Values (1,'Ana', 20, 'Florianopolis', 20000200000, 'gripe');
insert into Pacientes Values (2, 'Paulo', 24, 'Palhoca', 20000220000, 'fratura');
insert into Pacientes Values (3, 'Lucia', 30, 'Biguacu', 22000200000, 'tendinite');
insert into Pacientes Values (4, 'Carlos', 28, 'Joinville', 11000110000, 'sarampo');

/*Ordem: codf, nome, idade, cidade, salario, cpf  */
insert into Funcionarios Values (1, 'Rita', 32, 'Sao Jose', 1200, 20000100000);
insert into Funcionarios Values (2, 'Maria', 55, 'Palhoca', 1220, 30000110000);
insert into Funcionarios Values (3, 'Caio', 45, 'Florianopolis', 1100, 41000110000);
insert into Funcionarios Values (4, 'Carlos', 44, 'Florianopolis', 1200, 51000110000);
insert into Funcionarios Values (5, 'Paula', 33, 'Florianopolis', 2500, 61000111000);

/*Ordem: codm, codp, dia, hora   */
insert into Consultas Values (1, 1, '2006/06/12', 1400);
insert into Consultas Values (4, 1, '2006/06/13', 1000);
insert into Consultas Values (1, 2, '2006/06/13', 0900);
insert into Consultas Values (2, 2, '2006/06/13', 1100);
insert into Consultas Values (3, 2, '2006/06/14', 1400);
insert into Consultas Values (4, 2, '2006/06/14', 1700);
insert into Consultas Values (1, 3, '2006/06/19', 1800);
insert into Consultas Values (3, 3, '2006/06/19', 1000);
insert into Consultas Values (4, 3, '2006/06/20', 1100);
insert into Consultas Values (4, 4, '2006/06/12', 1100);
insert into Consultas Values (4, 4 ,'2006/06/22', 1930);

/*1) O paciente Paulo mudou-se para Ilhota*/
update Pacientes
set cidade = 'Ilhota'
where nome = 'Paulo';

/*2) A consulta do médico 1 com o paciente 4  passou para às 12:00 horas do dia 4 de Julho de 2006*/
update Consultas
set dia='2006/06/04', hora =1200
where codm = 4 and codp = 1;

/*3) A paciente Ana fez aniversário e sua doença agora é cancer*/
update Pacientes
set idade= idade + 1, doenca ='Cancer'
where nome='Ana';

/*4) A consulta do médico Pedro (codm = 3) com o paciente Carlos (codp = 4) passou para uma hora e meia depois*/
update Consultas
set hora = hora + 130
where codm = 3 and codp = 4;

/*5) O funcionário Carlos (codf = 4) deixou a clínica*/
delete from Funcionarios
where nome ='Carlos' and codf = 4; 

/*6) As consultas marcadas após as 19 horas foram canceladas*/
delete from Consultas
where hora >= 1900;

/*7) Os pacientes com câncer ou idade inferior a 10 anos deixaram a clínica*/
SET FOREIGN_KEY_CHECKS=0;
delete from Pacientes
where doenca='Cancer' or idade < 10;
SET FOREIGN_KEY_CHECKS=1;

/*8) Os médicos que residem em Biguacu e Palhoca deixaram a clínica*/
delete from Medicos
where cidade = 'Biguacu' or cidade = 'Palhoca';

/*1) Buscar o nome e o CPF dos médicos com menos de 40 anos ou com especialidade diferente de traumatologia */
select nome, cpf from Medicos where idade < 40 and especialidade <> 'traumatologia';

/*2) Buscar todos os dados das consultas marcadas no período da tarde após o dia 19/06/2006*/
select * from Consultas where hora > 1200 and dia > '2006/06/19';

/*3) Buscar o nome e a idade dos pacientes que não residem em Florianópolis*/
select nome, cpf from Pacientes where cidade <> 'Florianopolis';

/*4) Buscar a hora das consultas marcadas antes do dia 14/06/2006 e depois do dia 20/06/2006*/
select hora from Consultas where dia < '2006/06/14' and dia > '2006/06/20';

/*5) Buscar o nome e a idade (em meses) dos pacientes*/
select nome, idade*12 as Idade from Pacientes;

/*6) Em quais cidades residem os funcionários?*/
select distinct cidade from Funcionarios;

/*7) Qual o menor e o maior salário dos funcionários da Florianópolis?*/
select min(salario) as minimo, max(salario) as maximo from Funcionarios where cidade = 'Florianopolis';

/*10) Qual o horário da última consulta marcada para o dia 13/06/2006?*/
select max(hora) as hora from Consultas where dia ='2006/06/13';

/*11) Qual a média de idade dos médicos e o total de ambulatórios atendidos por eles?*/
select avg(idade) as media,sum(nroa) as nroa from Medicos;

/*12) Buscar o código, o nome e o salário líquido dos funcionários.
 O salário líquido é obtido pela diferença entre o salário cadastrado menos 20% deste mesmo salário*/
select codf, nome, salario-(salario*0.20) as salario from Funcionarios;

/*13) Buscar o nome dos funcionários que terminam com a letra “a”*/
select nome from Funcionarios where nome like '%a';

/*14) Buscar o nome e CPF dos funcionários que não possuam a seqüência “00000” em seus CPFs*/
select cpf, nome from Funcionarios where cpf not like '%00000%';

/*15) Buscar o nome e a especialidade dos médicos cuja segunda e a última letra de seus nomes seja a letra “o”*/
select nome, especialidade from Medicos where substring(nome,2,1)='o' and nome like '%o' ;

/*16) Buscar os códigos e nomes dos pacientes com mais de 25 anos que estão com tendinite, fratura, gripe e sarampo*/
select codp, nome from Pacientes where idade >25 and doenca in ('tendinite', 'fratura', 'gripe', 'sarampo');