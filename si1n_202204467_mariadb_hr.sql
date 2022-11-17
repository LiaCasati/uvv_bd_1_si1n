#criando usuario e garantindo privilegios
CREATE USER 'lia'@'localhost' IDENTIFIED BY '1234';
GRANT ALL PRIVILEGES ON * . * TO 'lia'@'localhost';
FLUSH PRIVILEGES;

#criando o banco de dados uvv
CREATE DATABASE `hr`;
GRANT ALL ON `hr`.* TO 'lia'@'localhost';
FLUSH PRIVILEGES;

#Logando no banco de dados
USE hr;

/*
----------------------------------------
|         CRIANDO AS TABELAS           |
----------------------------------------
*/

#Criando a tabela regiões
CREATE TABLE regioes (
                id_regiao INT NOT NULL,
                nome VARCHAR(25) NOT NULL,
                PRIMARY KEY (id_regiao)
);

ALTER TABLE regioes COMMENT 'Tabela de regiões. Inclui os identificadores e os nomes das regiões.';
ALTER TABLE regioes MODIFY COLUMN id_regiao INTEGER COMMENT 'Identificador da tabela regiões.';
ALTER TABLE regioes MODIFY COLUMN nome VARCHAR(25) COMMENT 'Refere-se ao nome da região';


CREATE UNIQUE INDEX nome
 ON regioes
 ( nome );


#Criando a tabela países
CREATE TABLE paises (
                id_pais CHAR(2) NOT NULL,
                nome VARCHAR(50) NOT NULL,
                id_regiao INT NOT NULL,
                PRIMARY KEY (id_pais)
);

ALTER TABLE paises COMMENT 'Tabela com os países.';
ALTER TABLE paises MODIFY COLUMN id_pais CHAR(2) COMMENT 'Identificador de países.';
ALTER TABLE paises MODIFY COLUMN nome VARCHAR(50) COMMENT 'Nome do país em que a empresa se localiza.';
ALTER TABLE paises MODIFY COLUMN id_regiao INTEGER COMMENT 'Chave estrangeira para a tabela regiões.';


CREATE UNIQUE INDEX nome_pais USING CTXCAT
 ON paises
 ( nome );



#Criando a tabela localizações
CREATE TABLE localizacoes (
                id_localizacao INT NOT NULL,
                endereco VARCHAR(50),
                cep VARCHAR(12),
                cidade VARCHAR(50),
                uf VARCHAR(25),
                id_pais CHAR(2) NOT NULL,
                PRIMARY KEY (id_localizacao)
);

ALTER TABLE localizacoes COMMENT 'Tabela com as localizacões das empresas.';
ALTER TABLE localizacoes MODIFY COLUMN id_localizacao INTEGER COMMENT 'Identificador da tabela localizacoes';
ALTER TABLE localizacoes MODIFY COLUMN endereco VARCHAR(50) COMMENT 'Endereço de uma empresa.';
ALTER TABLE localizacoes MODIFY COLUMN cep VARCHAR(12) COMMENT 'CEP da localização da empresa.';
ALTER TABLE localizacoes MODIFY COLUMN cidade VARCHAR(50) COMMENT 'Cidade em que a empresa se localiza.';
ALTER TABLE localizacoes MODIFY COLUMN uf VARCHAR(25) COMMENT 'Estado em que a empresa se localiza.';
ALTER TABLE localizacoes MODIFY COLUMN id_pais CHAR(2) COMMENT 'Chave estrangeira para a tabela países.';


#Criando a tabela departamentos
CREATE TABLE departamentos (
                id_departamento INT NOT NULL,
                nome VARCHAR(50) NOT NULL,
                id_localizacao INT NOT NULL,
                PRIMARY KEY (id_departamento)
);

ALTER TABLE departamentos COMMENT 'Tabela que contem os departamentos de determinada empresa.';
ALTER TABLE departamentos MODIFY COLUMN id_departamento INTEGER COMMENT 'Identificador da tabela departamentos.';
ALTER TABLE departamentos MODIFY COLUMN nome VARCHAR(50) COMMENT 'Nome do departamento da empresa.';
ALTER TABLE departamentos MODIFY COLUMN id_localizacao INTEGER COMMENT 'Chave estrangeira para a tabela localizações.';


CREATE UNIQUE INDEX nome_deparatamento USING CTXCAT
 ON departamentos
 ( nome );


 #Criando a tabela empregados
CREATE TABLE empregados (
                id_empregado INT NOT NULL,
                nome VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL,
                data_contratacao DATE NOT NULL,
                salario DECIMAL(8,2),
                comissao DECIMAL(4,2),
                telefone VARCHAR(20),
                id_gerente INT,
                id_cargo VARCHAR(10) NOT NULL,
                id_departamento INT,
                PRIMARY KEY (id_empregado)
);

ALTER TABLE empregados COMMENT 'Tabela que contem as informações dos empregados da empresa.';
ALTER TABLE empregados MODIFY COLUMN id_empregado INTEGER COMMENT 'Identificador da tabela empregados.';
ALTER TABLE empregados MODIFY COLUMN nome VARCHAR(75) COMMENT 'Nome do empregado.';
ALTER TABLE empregados MODIFY COLUMN email VARCHAR(35) COMMENT 'Email do empregado.';
ALTER TABLE empregados MODIFY COLUMN data_contratacao DATE COMMENT 'Data de contratação do empregado';
ALTER TABLE empregados MODIFY COLUMN salario DECIMAL(8, 2) COMMENT 'Salario do empregado.';
ALTER TABLE empregados MODIFY COLUMN comissao DECIMAL(4, 2) COMMENT 'Comissão do empregado.';
ALTER TABLE empregados MODIFY COLUMN telefone VARCHAR(20) COMMENT 'Telefone do empregado.';
ALTER TABLE empregados MODIFY COLUMN id_gerente INTEGER COMMENT 'Chave estrangeira responsável pelo autorelacionamento da tabela empregados';
ALTER TABLE empregados MODIFY COLUMN id_cargo VARCHAR(10) COMMENT 'Chave estrangeira para a tabela cargos.';
ALTER TABLE empregados MODIFY COLUMN id_departamento INTEGER COMMENT 'Identificador da tabela departamentos.';


CREATE UNIQUE INDEX email USING CTXCAT
 ON empregados
 ( email );


#Criando a tabela cargos
CREATE TABLE cargos (
                id_cargo VARCHAR(10) NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_minimo DECIMAL(8,2),
                salario_maximo DECIMAL(8,2),
                PRIMARY KEY (id_cargo)
);

ALTER TABLE cargos COMMENT 'Tabela com o cargo atual do empregado.';
ALTER TABLE cargos MODIFY COLUMN id_cargo VARCHAR(10) COMMENT 'Identificador da tabela cargos.';
ALTER TABLE cargos MODIFY COLUMN cargo VARCHAR(35) COMMENT 'Cargo atual do empregado.';
ALTER TABLE cargos MODIFY COLUMN salario_minimo DECIMAL(8, 2) COMMENT 'Salario minimo do cargo.';
ALTER TABLE cargos MODIFY COLUMN salario_maximo DECIMAL(8, 2) COMMENT 'Salario maximo do cargo';


CREATE UNIQUE INDEX cargo USING CTXCAT
 ON cargos
 ( cargo );


#Criando a tabela historico de cargos
CREATE TABLE historico_cargos (
                data_inicial DATE NOT NULL,
                id_empregado INT NOT NULL,
                data_final DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                id_departamento INT NOT NULL,
                PRIMARY KEY (data_inicial, id_empregado)
);

ALTER TABLE historico_cargos COMMENT 'Tabela com informações do historico de cargos de um empregado.';
ALTER TABLE historico_cargos MODIFY COLUMN data_inicial DATE COMMENT 'Parte da chave primaria. Contem a data inicial do empregado em um cargo.';
ALTER TABLE historico_cargos MODIFY COLUMN id_empregado INTEGER COMMENT 'Parte da chave primaria da tabela historico_cargos e chave estrangeira para empregados';
ALTER TABLE historico_cargos MODIFY COLUMN data_final DATE COMMENT 'Data final do empregado neste cargo.';
ALTER TABLE historico_cargos MODIFY COLUMN id_cargo VARCHAR(10) COMMENT 'Chave estrangeira para a tabela cargos.';
ALTER TABLE historico_cargos MODIFY COLUMN id_departamento INTEGER COMMENT 'Identificador da tabela departamentos.';

/*
----------------------------------------
|      RELACIONANDO AS TABELAS         |
----------------------------------------
*/

ALTER TABLE historico_cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo)
REFERENCES cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo)
REFERENCES cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE paises ADD CONSTRAINT regioes_paises_fk
FOREIGN KEY (id_regiao)
REFERENCES regioes (id_regiao)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE localizacoes ADD CONSTRAINT paises_localizacoes_fk
FOREIGN KEY (id_pais)
REFERENCES paises (id_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE departamentos ADD CONSTRAINT localizacoes_departamentos_fk
FOREIGN KEY (id_localizacao)
REFERENCES localizacoes (id_localizacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE historico_cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregado)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_gerente)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

/*
--------------------------------------
|       POPULANDO AS TABELAS          |
--------------------------------------
*/

#Populando a tabela regioes
INSERT INTO hr.regioes (id_regiao, nome) 
VALUES  ( 1, 'Europe' ), 
	 	( 2, 'Americas'),
    ( 3 , 'Asia' ),
		( 4 , 'Middle East and Africa' );

#Populando a tabela países
INSERT INTO hr.paises (id_pais, nome, id_regiao) 
VALUES  ( 'IT', 'Italy', 1 ), 
        ( 'JP', 'Japan', 3),
        ( 'US', 'United States of America', 2 ), 
        ( 'CA', 'Canada', 2 ), 
        ( 'CN', 'China', 3 ), 
        ( 'IN', 'India', 3), 
        ( 'AU', 'Australia', 3 ), 
        ( 'ZW', 'Zimbabwe', 4), 
        ( 'SG', 'Singapore', 3 ),
        ( 'UK', 'United Kingdom', 1  ), 
        ( 'FR', 'France', 1),
        ( 'DE', 'Germany', 1 ),
        ( 'ZM', 'Zambia', 4 ), 
        ( 'EG', 'Egypt', 4), 
        ( 'BR', 'Brazil', 2 ),
        ( 'CH', 'Switzerland', 1 ),
        ( 'NL', 'Netherlands', 1 ),
        ( 'MX', 'Mexico', 2 ), 
        ( 'KW' , 'Kuwait', 4), 
        ( 'IL', 'Israel', 4),
        ( 'DK', 'Denmark', 1 ),
        ( 'ML', 'Malaysia', 3 ), 
        ( 'NG', 'Nigeria', 4 ),
        ( 'AR', 'Argentina', 2 ), 
        ( 'BE', 'Belgium', 1 );


#Populando a tabela localizacoes
INSERT INTO hr.localizacoes (id_localizacao, endereco, cep, cidade, uf, id_pais) VALUES 
        ( 1000, '1297 Via Cola di Rie' , '00989', 'Roma', NULL, 'IT'),
        ( 1100 , '93091 Calle della Testa', '10934', 'Venice', NULL, 'IT'),
        ( 1200 , '2017 Shinjuku-ku', '1689', 'Tokyo', 'Tokyo Prefecture', 'JP'),
        ( 1300 , '9450 Kamiya-cho', '6823', 'Hiroshima', NULL, 'JP'),
        ( 1400 , '2014 Jabberwocky Rd', '26192', 'Southlake', 'Texas', 'US'),
        ( 1500 , '2011 Interiors Blvd', '99236', 'South San Francisco', 'California', 'US'),
        ( 1600 , '2007 Zagora St', '50090', 'South Brunswick', 'New Jersey', 'US'),
        ( 1700 , '2004 Charade Rd', '98199', 'Seattle', 'Washington', 'US'),
        ( 1800 , '147 Spadina Ave', 'M5V 2L7', 'Toronto', 'Ontario', 'CA'),
        ( 1900 , '6092 Boxwood St', 'YSW 9T2', 'Whitehorse', 'Yukon', 'CA'),
        ( 2000, '40-5-12 Laogianggen', '190518', 'Beijing', NULL, 'CN'),
        ( 2100, '1298 Vileparle (E)', '490231', 'Bombay', 'Maharashtra', 'IN'),
        ( 2200, '12-98 Victoria Street', '2901', 'Sydney', 'New South Wales', 'AU'),
		    ( 2300, '198 Clementi North', '540198', 'Singapore', NULL, 'SG'),
        ( 2400, '8204 Arthur St', NULL, 'London', NULL, 'UK'),
        ( 2500 , 'Magdalen Centre, The Oxford Science Park', 'OX9 9ZB', 'Oxford', 'Oxford', 'UK'), 
        ( 2600, '9702 Chester Road', '09629850293', 'Stretford', 'Manchester', 'UK'),
        ( 2700, 'Schwanthalerstr. 7031', '80925', 'Munich', 'Bavaria', 'DE'), 
        ( 2800, 'Rua Frei Caneca 1360 ', '01307-002', 'Sao Paulo', 'Sao Paulo', 'BR'),
        ( 2900, '20 Rue des Corps-Saints' , '1730', 'Geneva', 'Geneve', 'CH'), 
        ( 3000, 'Murtenstrasse 921', '3095', 'Bern', 'BE', 'CH'),
        ( 3100, 'Pieter Breughelstraat 837', '3029SK', 'Utrecht', 'Utrecht', 'NL'),
        ( 3200, 'Mariano Escobedo 9991', '11932', 'Mexico City', 'Distrito Federal', 'MX');

#Populando a tabela departamentos
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao)  VALUES 
        ( 10, 'Administration', 1700),
        ( 20, 'Marketing', 1800),
        ( 30, 'Purchasing', 1700),
        ( 40, 'Human Resources', 2400),
        ( 50, 'Shipping', 1500),
        ( 60, 'IT', 1400),
        ( 70, 'Public Relations', 2700),
        ( 80, 'Sales', 2500),
        ( 90, 'Executive', 1700),
        ( 100, 'Finance', 1700),
        ( 110, 'Accounting', 1700),
		    ( 120, 'Treasury', 1700),
		    ( 130, 'Corporate Tax', 1700),
		    ( 140, 'Control And Credit', 1700),
		    ( 150, 'Shareholder Services', 1700),
        ( 160, 'Benefits', 1700),
        ( 170, 'Manufacturing', 1700),
        ( 180, 'Construction', 1700),
        ( 190, 'Contracting', 1700),
        ( 200, 'Operations', 1700),
        ( 210, 'IT Support', 1700),
        ( 220, 'NOC', 1700),
        ( 230, 'IT Helpdesk', 1700),
        ( 240, 'Government Sales', 1700),
        ( 250, 'Retail Sales', 1700),
		    ( 260, 'Recruiting', 1700),
     	  ( 270, 'Payroll', 1700);

#Populando a tabela cargos
INSERT INTO hr.cargos (id_cargo, cargo, salario_minimo, salario_maximo) VALUES 
        ( 'AD_PRES', 'President', 20080, 40000),
        ( 'AD_VP', 'Administration Vice President', 15000, 30000),
        ( 'AD_ASST', 'Administration Assistant', 3000, 6000),
        ( 'FI_MGR', 'Finance Manager', 8200, 16000),
        ( 'FI_ACCOUNT', 'Accountant', 4200, 9000),
        ( 'AC_MGR', 'Accounting Manager', 8200, 16000),
        ( 'AC_ACCOUNT', 'Public Accountant', 4200, 9000),
        ( 'SA_MAN', 'Sales Manager', 10000, 20080),
        ( 'SA_REP', 'Sales Representative', 6000, 12008),
        ( 'PU_MAN', 'Purchasing Manager', 8000, 15000),
        ( 'PU_CLERK', 'Purchasing Clerk', 2500, 5500),
        ( 'ST_MAN', 'Stock Manager', 5500, 8500),
        ( 'ST_CLERK', 'Stock Clerk', 2008, 5000),
        ( 'SH_CLERK', 'Shipping Clerk', 2500, 5500),
        ( 'IT_PROG', 'Programmer', 4000, 10000),
        ( 'MK_MAN', 'Marketing Manager', 9000, 15000),
        ( 'MK_REP', 'Marketing Representative', 4000, 9000),
        ( 'HR_REP', 'Human Resources Representative', 4000, 9000),
        ( 'PR_REP', 'Public Relations Representative', 4500, 10500);

#Populando a tabela empregados
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao, id_gerente, id_departamento) VALUES 
        ( 100, 'Steven King', 'SKING', '515.123.4567', TO_DATE('17-06-2003', 'dd-MM-yyyy'), 'AD_PRES', 24000, NULL, NULL, 90), 
        ( 101, 'Neena Kochhar', 'NKOCHHAR', '515.123.4568', TO_DATE('21-09-2005', 'dd-MM-yyyy'), 'AD_VP', 17000, NULL, 100, 90), 
        ( 102, 'Lex De Haan', 'LDEHAAN', '515.123.4569', TO_DATE('13-01-2001', 'dd-MM-yyyy'), 'AD_VP', 17000, NULL, 100, 90), 
        ( 103, 'Alexander Hunold', 'AHUNOLD', '590.423.4567', TO_DATE('03-01-2006', 'dd-MM-yyyy'), 'IT_PROG', 9000, NULL, 102, 60), 
        ( 104, 'Bruce Ernst', 'BERNST', '590.423.4568', TO_DATE('21-05-2007', 'dd-MM-yyyy'), 'IT_PROG', 6000, NULL, 103, 60), 
        ( 105, 'David Austin', 'DAUSTIN', '590.423.4569', TO_DATE('25-06-2005', 'dd-MM-yyyy'), 'IT_PROG', 4800, NULL, 103, 60), 
        ( 106, 'Valli Pataballa', 'VPATABAL', '590.423.4560', TO_DATE('05-02-2006', 'dd-MM-yyyy'), 'IT_PROG', 4800, NULL, 103, 60), 
        ( 107, 'Diana Lorentz', 'DLORENTZ', '590.423.5567', TO_DATE('07-02-2007', 'dd-MM-yyyy'), 'IT_PROG', 4200, NULL, 103, 60), 
        ( 108, 'Nancy Greenberg', 'NGREENBE', '515.124.4569', TO_DATE('17-08-2002', 'dd-MM-yyyy'), 'FI_MGR', 12008, NULL, 101, 100), 
        ( 109, 'Daniel Faviet', 'DFAVIET', '515.124.4169', TO_DATE('16-08-2002', 'dd-MM-yyyy'), 'FI_ACCOUNT', 9000, NULL, 108, 100), 
        ( 110, 'John Chen', 'JCHEN', '515.124.4269', TO_DATE('28-09-2005', 'dd-MM-yyyy'), 'FI_ACCOUNT', 8200, NULL, 108, 100), 
        ( 111, 'Ismael Sciarra', 'ISCIARRA', '515.124.4369', TO_DATE('30-09-2005', 'dd-MM-yyyy'), 'FI_ACCOUNT', 7700, NULL, 108, 100), 
        ( 112, 'Jose Manuel Urman', 'JMURMAN', '515.124.4469', TO_DATE('07-03-2006', 'dd-MM-yyyy'), 'FI_ACCOUNT', 7800, NULL, 108, 100), 
        ( 113, 'Luis Popp', 'LPOPP', '515.124.4567', TO_DATE('07-12-2007', 'dd-MM-yyyy'), 'FI_ACCOUNT', 6900, NULL, 108, 100), 
        ( 114, 'Den Raphaely', 'DRAPHEAL', '515.127.4561', TO_DATE('07-12-2002', 'dd-MM-yyyy'), 'PU_MAN', 11000, NULL, 100, 30), 
        ( 115, 'Alexander Khoo', 'AKHOO', '515.127.4562', TO_DATE('18-05-2003', 'dd-MM-yyyy'), 'PU_CLERK', 3100, NULL, 114, 30), 
        ( 116, 'Shelli Baida', 'SBAIDA', '515.127.4563', TO_DATE('24-12-2005', 'dd-MM-yyyy'), 'PU_CLERK', 2900, NULL, 114, 30), 
        ( 117, 'Sigal Tobias', 'STOBIAS', '515.127.4564', TO_DATE('24-07-2005', 'dd-MM-yyyy'), 'PU_CLERK', 2800, NULL, 114, 30), 
        ( 118, 'Guy Himuro', 'GHIMURO', '515.127.4565', TO_DATE('15-11-2006', 'dd-MM-yyyy'), 'PU_CLERK', 2600, NULL, 114, 30), 
        ( 119, 'Karen Colmenares', 'KCOLMENA', '515.127.4566', TO_DATE('10-08-2007', 'dd-MM-yyyy'), 'PU_CLERK', 2500, NULL, 114, 30), 
        ( 120, 'Matthew Weiss', 'MWEISS', '650.123.1234', TO_DATE('18-07-2004', 'dd-MM-yyyy'), 'ST_MAN', 8000, NULL, 100, 50), 
        ( 121, 'Adam Fripp', 'AFRIPP', '650.123.2234', TO_DATE('10-04-2005', 'dd-MM-yyyy'), 'ST_MAN', 8200, NULL, 100, 50), 
        ( 122, 'Payam Kaufling', 'PKAUFLIN', '650.123.3234', TO_DATE('01-05-2003', 'dd-MM-yyyy'), 'ST_MAN', 7900, NULL, 100, 50), 
        ( 123, 'Shanta Vollman', 'SVOLLMAN' , '650.123.4234', TO_DATE('10-10-2005', 'dd-MM-yyyy'), 'ST_MAN', 6500, NULL, 100, 50), 
        ( 124, 'Kevin Mourgos', 'KMOURGOS', '650.123.5234', TO_DATE('16-11-2007', 'dd-MM-yyyy'), 'ST_MAN', 5800, NULL, 100, 50), 
        ( 125, 'Julia Nayer', 'JNAYER', '650.124.1214', TO_DATE('16-07-2005', 'dd-MM-yyyy'), 'ST_CLERK', 3200, NULL, 120, 50),
        ( 126, 'Irene Mikkilineni', 'IMIKKILI', '650.124.1224', TO_DATE('28-09-2006', 'dd-MM-yyyy'), 'ST_CLERK', 2700, NULL, 120, 50), 
        ( 127, 'James Landry', 'JLANDRY', '650.124.1334', TO_DATE('14-01-2007', 'dd-MM-yyyy'), 'ST_CLERK', 2400, NULL, 120, 50), 
        ( 128, 'Steven Markle', 'SMARKLE', '650.124.1434', TO_DATE('08-03-2008', 'dd-MM-yyyy'), 'ST_CLERK', 2200, NULL, 120, 50), 
        ( 129, 'Laura Bissot', 'LBISSOT', '650.124.5234', TO_DATE('20-08-2005', 'dd-MM-yyyy'), 'ST_CLERK', 3300, NULL, 121, 50), 
        ( 130, 'Mozhe Atkinson', 'MATKINSO', '650.124.6234', TO_DATE('30-10-2005', 'dd-MM-yyyy'), 'ST_CLERK', 2800, NULL, 121, 50), 
        ( 131, 'James Marlow', 'JAMRLOW', '650.124.7234', TO_DATE('16-02-2005', 'dd-MM-yyyy'), 'ST_CLERK', 2500, NULL, 121, 50), 
        ( 132, 'TJ Olson', 'TJOLSON', '650.124.8234', TO_DATE('10-04-2007', 'dd-MM-yyyy'), 'ST_CLERK', 2100, NULL, 121, 50), 
        ( 133, 'Jason Mallin', 'JMALLIN', '650.127.1934', TO_DATE('14-06-2004', 'dd-MM-yyyy'), 'ST_CLERK', 3300, NULL, 122, 50), 
        ( 134, 'Michael Rogers', 'MROGERS', '650.127.1834', TO_DATE('26-08-2006', 'dd-MM-yyyy'), 'ST_CLERK', 2900, NULL, 122, 50), 
        ( 135, 'Ki Gee', 'KGEE', '650.127.1734', TO_DATE('12-12-2007', 'dd-MM-yyyy'), 'ST_CLERK', 2400, NULL, 122, 50), 
        ( 136, 'Hazel Philtanker', 'HPHILTAN', '650.127.1634', TO_DATE('06-02-2008', 'dd-MM-yyyy'), 'ST_CLERK', 2200, NULL, 122, 50), 
        ( 137, 'Renske Ladwig' , 'RLADWIG', '650.121.1234', TO_DATE('14-07-2003', 'dd-MM-yyyy'), 'ST_CLERK', 3600, NULL, 123, 50), 
        ( 138, 'Stephen Stiles', 'SSTILES', '650.121.2034', TO_DATE('26-10-2005', 'dd-MM-yyyy'), 'ST_CLERK', 3200, NULL, 123, 50), 
        ( 139, 'John Seo', 'JSEO', '650.121.2019', TO_DATE('12-02-2006', 'dd-MM-yyyy'), 'ST_CLERK', 2700, NULL, 123, 50), 
        ( 140, 'Joshua Patel', 'JPATEL', '650.121.1834', TO_DATE('06-04-2006', 'dd-MM-yyyy'), 'ST_CLERK', 2500, NULL, 123, 50), 
        ( 141, 'Trenna Rajs', 'TRAJS', '650.121.8009', TO_DATE('17-10-2003', 'dd-MM-yyyy'), 'ST_CLERK', 3500, NULL, 124, 50), 
        ( 142, 'Curtis Davies', 'CDAVIES', '650.121.2994', TO_DATE('29-01-2005', 'dd-MM-yyyy'), 'ST_CLERK', 3100, NULL, 124, 50), 
        ( 143, 'Randall Matos', 'RMATOS', '650.121.2874', TO_DATE('15-03-2006', 'dd-MM-yyyy'), 'ST_CLERK', 2600, NULL, 124, 50), 
        ( 144, 'Peter Vargas', 'PVARGAS', '650.121.2004', TO_DATE('09-07-2006', 'dd-MM-yyyy'), 'ST_CLERK', 2500, NULL, 124, 50), 
        ( 145, 'John Russell', 'JRUSSEL', '011.44.1344.429268', TO_DATE('01-10-2004', 'dd-MM-yyyy'), 'SA_MAN', 14000, .4, 100, 80), 
        ( 146, 'Karen Partners', 'KPARTNER', '011.44.1344.467268', TO_DATE('05-01-2005', 'dd-MM-yyyy'), 'SA_MAN', 13500, .3, 100, 80), 
        ( 147, 'Alberto Errazuriz', 'AERRAZUR', '011.44.1344.429278', TO_DATE('10-03-2005', 'dd-MM-yyyy'), 'SA_MAN', 12000, .3, 100, 80),
        ( 148, 'Gerald Cambrault', 'GCAMBRAU', '011.44.1344.619268', TO_DATE('15-10-2007', 'dd-MM-yyyy'), 'SA_MAN', 11000, .3, 100, 80), 
        ( 149, 'Eleni Zlotkey', 'EZLOTKEY', '011.44.1344.429018', TO_DATE('29-01-2008', 'dd-MM-yyyy'), 'SA_MAN', 10500, .2, 100, 80), 
        ( 150, 'Peter Tucker', 'PTUCKER', '011.44.1344.129268', TO_DATE('30-01-2005', 'dd-MM-yyyy'), 'SA_REP', 10000, .3, 145, 80), 
        ( 151, 'David Bernstein', 'DBERNSTE', '011.44.1344.345268', TO_DATE('24-03-2005', 'dd-MM-yyyy'), 'SA_REP', 9500, .25, 145, 80), 
        ( 152, 'Peter Hall', 'PHALL', '011.44.1344.478968', TO_DATE('20-08-2005', 'dd-MM-yyyy'), 'SA_REP', 9000, .25, 145, 80), 
        ( 153, 'Christopher Olsen', 'COLSEN', '011.44.1344.498718', TO_DATE('30-03-2006', 'dd-MM-yyyy'), 'SA_REP', 8000, .2, 145, 80), 
        ( 154, 'Nanette Cambrault', 'NCAMBRAU', '011.44.1344.987668', TO_DATE('09-12-2006', 'dd-MM-yyyy'), 'SA_REP', 7500, .2, 145, 80), 
        ( 155, 'Oliver Tuvault', 'OTUVAULT', '011.44.1344.486508', TO_DATE('23-11-2007', 'dd-MM-yyyy'), 'SA_REP', 7000, .15, 145, 80), 
        ( 156, 'Janette King', 'JKING', '011.44.1345.429268', TO_DATE('30-01-2004', 'dd-MM-yyyy'), 'SA_REP', 10000, .35, 146, 80), 
        ( 157, 'Patrick Sully', 'PSULLY', '011.44.1345.929268', TO_DATE('04-03-2004', 'dd-MM-yyyy'), 'SA_REP', 9500, .35, 146, 80), 
        ( 158, 'Allan McEwen', 'AMCEWEN', '011.44.1345.829268', TO_DATE('01-08-2004', 'dd-MM-yyyy'), 'SA_REP', 9000, .35, 146, 80), 
        ( 159, 'Lindsey Smith', 'LSMITH', '011.44.1345.729268', TO_DATE('10-03-2005', 'dd-MM-yyyy'), 'SA_REP', 8000, .3, 146, 80), 
        ( 160, 'Louise Doran', 'LDORAN', '011.44.1345.629268', TO_DATE('15-12-2005', 'dd-MM-yyyy'), 'SA_REP', 7500, .3, 146, 80),
        ( 161, 'Sarath Sewall', 'SSEWALL', '011.44.1345.529268', TO_DATE('03-11-2006', 'dd-MM-yyyy'), 'SA_REP', 7000, .25, 146, 80),
        ( 162, 'Clara Vishney', 'CVISHNEY', '011.44.1346.129268', TO_DATE('11-11-2005', 'dd-MM-yyyy'), 'SA_REP', 10500, .25, 147, 80),
        ( 163, 'Danielle Greene', 'DGREENE', '011.44.1346.229268', TO_DATE('19-03-2007', 'dd-MM-yyyy'), 'SA_REP', 9500, .15, 147, 80),
        ( 164, 'Mattea Marvins', 'MMARVINS', '011.44.1346.329268', TO_DATE('24-01-2008', 'dd-MM-yyyy'), 'SA_REP', 7200, .10, 147, 80),
        ( 165, 'David Lee', 'DLEE', '011.44.1346.529268', TO_DATE('23-02-2008', 'dd-MM-yyyy'), 'SA_REP', 6800, .1, 147, 80),
        ( 166, 'Sundar Ande', 'SANDE', '011.44.1346.629268', TO_DATE('24-03-2008', 'dd-MM-yyyy'), 'SA_REP', 6400, .10, 147, 80),
        ( 167, 'Amit Banda', 'ABANDA', '011.44.1346.729268', TO_DATE('21-04-2008', 'dd-MM-yyyy'), 'SA_REP', 6200, .10, 147, 80),
        ( 168, 'Lisa Ozer', 'LOZER', '011.44.1343.929268', TO_DATE('11-03-2005', 'dd-MM-yyyy'), 'SA_REP', 11500, .25, 148, 80),
        ( 169  , 'Harrison Bloom', 'HBLOOM', '011.44.1343.829268', TO_DATE('23-03-2006', 'dd-MM-yyyy'), 'SA_REP', 10000, .20, 148, 80),
        ( 170, 'Tayler Fox', 'TFOX', '011.44.1343.729268', TO_DATE('24-01-2006', 'dd-MM-yyyy'), 'SA_REP', 9600, .20, 148, 80),
        ( 171, 'William Smith', 'WSMITH', '011.44.1343.629268', TO_DATE('23-02-2007', 'dd-MM-yyyy'), 'SA_REP', 7400, .15, 148, 80),
        ( 172, 'Elizabeth Bates', 'EBATES', '011.44.1343.529268', TO_DATE('24-03-2007', 'dd-MM-yyyy'), 'SA_REP', 7300, .15, 148, 80),
        ( 173, 'Sundita Kumar', 'SKUMAR', '011.44.1343.329268', TO_DATE('21-04-2008', 'dd-MM-yyyy'), 'SA_REP', 6100, .10, 148, 80),
        ( 174, 'Ellen Abel', 'EABEL', '011.44.1644.429267', TO_DATE('11-05-2004', 'dd-MM-yyyy'), 'SA_REP', 11000, .30, 149, 80),
        ( 175, 'Alyssa Hutton', 'AHUTTON', '011.44.1644.429266', TO_DATE('19-03-2005', 'dd-MM-yyyy'), 'SA_REP', 8800, .25, 149, 80),
        ( 176, 'Jonathon Taylor', 'JTAYLOR', '011.44.1644.429265', TO_DATE('24-03-2006', 'dd-MM-yyyy'), 'SA_REP', 8600, .20, 149, 80),
        ( 177, 'Jack Livingston', 'JLIVINGS', '011.44.1644.429264', TO_DATE('23-04-2006', 'dd-MM-yyyy'), 'SA_REP', 8400, .20, 149, 80), 
        ( 178, 'Kimberely Grant', 'KGRANT', '011.44.1644.429263', TO_DATE('24-05-2007', 'dd-MM-yyyy'), 'SA_REP', 7000, .15, 149, NULL),
        ( 179, 'Charles Johnson', 'CJOHNSON', '011.44.1644.429262', TO_DATE('04-01-2008', 'dd-MM-yyyy'), 'SA_REP', 6200, .10, 149, 80),
        ( 180, 'Winston Taylor', 'WTAYLOR', '650.507.9876', TO_DATE('24-01-2006', 'dd-MM-yyyy'), 'SH_CLERK', 3200, NULL, 120, 50),
        ( 181, 'Jean Fleaur', 'JFLEAUR', '650.507.9877', TO_DATE('23-02-2006', 'dd-MM-yyyy'), 'SH_CLERK', 3100, NULL, 120, 50),
        ( 182, 'Martha Sullivan', 'MSULLIVA', '650.507.9878', TO_DATE('21-06-2007', 'dd-MM-yyyy'), 'SH_CLERK', 2500, NULL, 120, 50),
        ( 183, 'Girard Geoni', 'GGEONI', '650.507.9879', TO_DATE('03-02-2008', 'dd-MM-yyyy'), 'SH_CLERK', 2800, NULL, 120, 50),
        ( 184, 'Nandita Sarchand', 'NSARCHAN', '650.509.1876', TO_DATE('27-01-2004', 'dd-MM-yyyy'), 'SH_CLERK', 4200, NULL, 121, 50),
        ( 185, 'Alexis Bull', 'ABULL', '650.509.2876', TO_DATE('20-02-2005', 'dd-MM-yyyy'), 'SH_CLERK', 4100, NULL, 121, 50),
        ( 186, 'Julia Dellinger', 'JDELLING', '650.509.3876', TO_DATE('24-06-2006', 'dd-MM-yyyy'), 'SH_CLERK', 3400, NULL, 121, 50),
        ( 187, 'Anthony Cabrio', 'ACABRIO', '650.509.4876', TO_DATE('07-02-2007', 'dd-MM-yyyy'), 'SH_CLERK', 3000, NULL, 121, 50),
        ( 188, 'Kelly Chung', 'KCHUNG', '650.505.1876', TO_DATE('14-06-2005', 'dd-MM-yyyy'), 'SH_CLERK', 3800, NULL, 122, 50),
        ( 189, 'Jennifer Dilly', 'JDILLY', '650.505.2876', TO_DATE('13-08-2005', 'dd-MM-yyyy'), 'SH_CLERK', 3600, NULL, 122, 50),
        ( 190, 'Timothy Gates', 'TGATES', '650.505.3876', TO_DATE('11-07-2006', 'dd-MM-yyyy'), 'SH_CLERK', 2900, NULL, 122, 50),
        ( 191, 'Randall Perkins', 'RPERKINS', '650.505.4876', TO_DATE('19-12-2007', 'dd-MM-yyyy'), 'SH_CLERK', 2500, NULL, 122, 50),
        ( 192, 'Sarah Bell', 'SBELL', '650.501.1876', TO_DATE('04-02-2004', 'dd-MM-yyyy'), 'SH_CLERK', 4000, NULL, 123, 50),
        ( 193, 'Britney Everett', 'BEVERETT', '650.501.2876', TO_DATE('03-03-2005', 'dd-MM-yyyy'), 'SH_CLERK', 3900, NULL, 123, 50),
        ( 194, 'Samuel McCain', 'SMCCAIN', '650.501.3876', TO_DATE('01-07-2006', 'dd-MM-yyyy'), 'SH_CLERK', 3200, NULL, 123, 50),
        ( 195, 'Vance Jones', 'VJONES', '650.501.4876', TO_DATE('17-03-2007', 'dd-MM-yyyy'), 'SH_CLERK', 2800, NULL, 123, 50),
        ( 196, 'Alana Walsh', 'AWALSH', '650.507.9811', TO_DATE('24-04-2006', 'dd-MM-yyyy'), 'SH_CLERK', 3100, NULL, 124, 50),
        ( 197, 'Kevin Feeney', 'KFEENEY', '650.507.9822', TO_DATE('23-05-2006', 'dd-MM-yyyy'), 'SH_CLERK', 3000, NULL, 124, 50),
        ( 198, 'Donald OConnell', 'DOCONNEL', '650.507.9833', TO_DATE('21-06-2007', 'dd-MM-yyyy'), 'SH_CLERK', 2600, NULL, 124, 50),
        ( 199, 'Douglas Grant', 'DGRANT', '650.507.9844', TO_DATE('13-01-2008', 'dd-MM-yyyy'), 'SH_CLERK', 2600, NULL, 124, 50),
        ( 200, 'Jennifer Whalen', 'JWHALEN', '515.123.4444', TO_DATE('17-09-2003', 'dd-MM-yyyy'), 'AD_ASST', 4400, NULL, 101, 10),
        ( 201, 'Michael Hartstein', 'MHARTSTE', '515.123.5555', TO_DATE('17-02-2004', 'dd-MM-yyyy'), 'MK_MAN', 13000, NULL, 100, 20),
        ( 202, 'Pat Fay', 'PFAY', '603.123.6666', TO_DATE('17-08-2005', 'dd-MM-yyyy'), 'MK_REP', 6000, NULL, 201, 20),
        ( 203, 'Susan Mavris', 'SMAVRIS', '515.123.7777', TO_DATE('07-06-2002', 'dd-MM-yyyy'), 'HR_REP', 6500, NULL, 101, 40),
        ( 204, 'Hermann Baer', 'HBAER', '515.123.8888', TO_DATE('07-06-2002', 'dd-MM-yyyy'), 'PR_REP', 10000, NULL, 101, 70),
        ( 205, 'Shelley Higgins', 'SHIGGINS', '515.123.8080', TO_DATE('07-06-2002', 'dd-MM-yyyy'), 'AC_MGR', 12008, NULL, 101, 110),
        ( 206, 'William Gietz', 'WGIETZ', '515.123.8181', TO_DATE('07-06-2002', 'dd-MM-yyyy'), 'AC_ACCOUNT', 8300, NULL, 205, 110);

#Populando a tabela historico_cargos  
INSERT INTO hr.historico_cargos (id_empregado, data_inicial, data_final, id_cargo , id_departamento )
VALUES (102, TO_DATE('13-01-2001', 'dd-MM-yyyy'), TO_DATE('24-07-2006', 'dd-MM-yyyy'), 'IT_PROG', 60),
		(101, TO_DATE('21-09-1997', 'dd-MM-yyyy'), TO_DATE('27-10-2001', 'dd-MM-yyyy'), 'AC_ACCOUNT', 110),
		(101, TO_DATE('28-10-2001', 'dd-MM-yyyy'), TO_DATE('15-03-2005', 'dd-MM-yyyy'), 'AC_MGR', 110),
		(201, TO_DATE('17-02-2004', 'dd-MM-yyyy'), TO_DATE('19-12-2007', 'dd-MM-yyyy'), 'MK_REP', 20),
		 (114, TO_DATE('24-03-2006', 'dd-MM-yyyy'), TO_DATE('31-12-2007', 'dd-MM-yyyy'), 'ST_CLERK', 50),
		 (122, TO_DATE('01-01-2007', 'dd-MM-yyyy'), TO_DATE('31-12-2007', 'dd-MM-yyyy'), 'ST_CLERK', 50),
		 (200, TO_DATE('17-09-1995', 'dd-MM-yyyy'), TO_DATE('17-06-2001', 'dd-MM-yyyy'), 'AD_ASST', 90),
		 (176, TO_DATE('24-03-2006', 'dd-MM-yyyy'), TO_DATE('31-12-2006', 'dd-MM-yyyy'), 'SA_REP', 80),
		 (176, TO_DATE('01-01-2007', 'dd-MM-yyyy'), TO_DATE('31-12-2007', 'dd-MM-yyyy'), 'SA_MAN', 80),
		 (200, TO_DATE('01-07-2002', 'dd-MM-yyyy'), TO_DATE('31-12-2006', 'dd-MM-yyyy'), 'AC_ACCOUNT', 90);
        
