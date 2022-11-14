/*
---------------------------------------
|         CRIANDO AS TABELAS           |
---------------------------------------
*/

--Criando a tabela regiões--
CREATE TABLE hr.regioes (
                id_regiao INTEGER NOT NULL,
                nome VARCHAR(25) NOT NULL,
                CONSTRAINT id_regiao PRIMARY KEY (id_regiao)
);
COMMENT ON TABLE hr.regioes IS 'Tabela de regiões. Inclui os identificadores e os nomes das regiões';
COMMENT ON COLUMN hr.regioes.id_regiao IS 'Identificador da tabela regiões.';
COMMENT ON COLUMN hr.regioes.nome IS 'Refere-se ao nome da região';


CREATE UNIQUE INDEX nome
 ON hr.regioes
 ( nome );


--Criando a tabela países--
CREATE TABLE hr.paises (
                id_pais CHAR(2) NOT NULL,
                nome VARCHAR(50) NOT NULL,
                id_regiao INTEGER NOT NULL,
                CONSTRAINT id_pais PRIMARY KEY (id_pais)
);
COMMENT ON TABLE hr.paises. IS "Tabela com as localizacões das empresas."
COMMENT ON COLUMN hr.paises.id_pais IS 'Identificador de países.';
COMMENT ON COLUMN hr.paises.nome IS 'Nome do país em que a empresa se localiza.';
COMMENT ON COLUMN hr.paises.id_regiao IS 'Chave estrangeira para a tabela regiões.';


CREATE UNIQUE INDEX nome_pais
 ON hr.paises  
 ( nome );


--Criando a tabela localizações--
CREATE TABLE hr.localizacoes (
                id_localizacao INTEGER NOT NULL,
                endereco VARCHAR(50),
                cep VARCHAR(12),
                cidade VARCHAR(50),
                uf VARCHAR(25),
                id_pais CHAR(2) NOT NULL,
                CONSTRAINT id_localizacao PRIMARY KEY (id_localizacao)
);
COMMENT ON COLUMN hr.localizacoes.id_localizacao IS 'Identificador da tabela localizacoes';
COMMENT ON COLUMN hr.localizacoes.endereco IS 'Endereço de uma empresa.';
COMMENT ON COLUMN hr.localizacoes.cep IS 'CEP da localização da empresa.';
COMMENT ON COLUMN hr.localizacoes.cidade IS 'Cidade em que a empresa se localiza.';
COMMENT ON COLUMN hr.localizacoes.uf IS 'Estado em que a empresa se localiza.';
COMMENT ON COLUMN hr.localizacoes.id_pais IS 'Chave estrangeira para a tabela países.';


--Criando a tabela departamentos--
CREATE TABLE hr.departamentos (
                id_departamento INTEGER NOT NULL,
                nome VARCHAR(50) NOT NULL,
                id_localizacao INTEGER NOT NULL,
                CONSTRAINT id_departamento PRIMARY KEY (id_departamento)
);
COMMENT ON TABLE hr.departamentos IS 'Tabela que contem os departamentos de determinada empresa.';
COMMENT ON COLUMN hr.departamentos.id_departamento IS 'Identificador da tabela departamentos.';
COMMENT ON COLUMN hr.departamentos.nome IS 'Nome do departamento da empresa.';
COMMENT ON COLUMN hr.departamentos.id_localizacao IS 'Chave estrangeira para a tabela localizações.';


CREATE UNIQUE INDEX nome_deparatamento
 ON hr.departamentos  
 ( nome );


 --Criando a tabela empregados--
CREATE TABLE hr.empregados (
                id_empregado INTEGER NOT NULL,
                nome VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL,
                data_contratacao DATE NOT NULL,
                salario NUMERIC(8,2),
                comissao NUMERIC(4,2),
                telefone VARCHAR(20),
                id_gerente INTEGER NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                id_departamento INTEGER NOT NULL,
                CONSTRAINT id_empregado PRIMARY KEY (id_empregado)
);
COMMENT ON TABLE hr.empregados IS 'Tabela que contem as informações dos empregados da empresa.';
COMMENT ON COLUMN hr.empregados.id_empregado IS 'Identificador da tabela empregados.';
COMMENT ON COLUMN hr.empregados.nome IS 'Nome do empregado.';
COMMENT ON COLUMN hr.empregados.email IS 'Email do empregado.';
COMMENT ON COLUMN hr.empregados.data_contratacao IS 'Data de contratação do empregado';
COMMENT ON COLUMN hr.empregados.salario IS 'Salario do empregado.';
COMMENT ON COLUMN hr.empregados.comissao IS 'Comissão do empregado.';
COMMENT ON COLUMN hr.empregados.telefone IS 'Telefone do empregado.';
COMMENT ON COLUMN hr.empregados.id_gerente IS 'Chave estrangeira responsável pelo autorelacionamento da tabela empregados';
COMMENT ON COLUMN hr.empregados.id_cargo IS 'Chave estrangeira para a tabela cargos.';
COMMENT ON COLUMN hr.empregados.id_departamento IS 'Identificador da tabela departamentos.';


CREATE UNIQUE INDEX email
 ON hr.empregados  
 ( email );


--Criando a tabela cargos--
CREATE TABLE hr.cargos (
                id_cargo VARCHAR(10) NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_minimo NUMERIC(8,2),
                salario_maximo NUMERIC(8,2),
                CONSTRAINT cargos_pk PRIMARY KEY (id_cargo)
);
COMMENT ON TABLE hr.cargos IS 'Tabela com o cargo atual do empregado.';
COMMENT ON COLUMN hr.cargos.id_cargo IS 'Identificador da tabela cargos.';
COMMENT ON COLUMN hr.cargos.cargo IS 'Cargo atual do empregado.';
COMMENT ON COLUMN hr.cargos.salario_minimo IS 'Salario minimo do cargo.';
COMMENT ON COLUMN hr.cargos.salario_maximo IS 'Salario maximo do cargo';


CREATE UNIQUE INDEX cargo
 ON hr.cargos  
 ( cargo );


--Criando a tabela historico de cargos--
CREATE TABLE hr.historico_cargos (
                data_inicial DATE NOT NULL,
                id_empregado INTEGER NOT NULL,
                data_final DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                id_departamento INTEGER NOT NULL,
                CONSTRAINT historico_cargos_pk PRIMARY KEY (data_inicial, id_empregado)
);
COMMENT ON TABLE hr.historico_cargos IS 'Tabela com informações do historico de cargos de um empregado.';
COMMENT ON COLUMN hr.historico_cargos.data_inicial IS 'Parte da chave primaria. Contem a data inicial do empregado em um cargo.';
COMMENT ON COLUMN hr.historico_cargos.id_empregado IS 'Parte da chave primaria da tabela historico_cargos e chave estrangeira para empregados';
COMMENT ON COLUMN hr.historico_cargos.data_final IS 'Data final do empregado neste cargo.';
COMMENT ON COLUMN hr.historico_cargos.id_cargo IS 'Chave estrangeira para a tabela cargos.';
COMMENT ON COLUMN hr.historico_cargos.id_departamento IS 'Identificador da tabela departamentos.';

/*
---------------------------------------
|      RELACIONANDO AS TABELAS         |
---------------------------------------
*/

--Relacionando historico_cargos com cargos--
ALTER TABLE hr.historico_cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo)
REFERENCES hr.cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Relacionando empregados com cargos--
ALTER TABLE hr.empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo)
REFERENCES hr.cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Relacionando paises com regioes--
ALTER TABLE hr.paises ADD CONSTRAINT regioes_paises_fk
FOREIGN KEY (id_regiao)
REFERENCES hr.regioes (id_regiao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Relacionando localizações com países--
ALTER TABLE hr.localizacoes ADD CONSTRAINT paises_localizacoes_fk
FOREIGN KEY (id_pais)
REFERENCES hr.paises (id_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Relacionando departamentos com localizações--
ALTER TABLE hr.departamentos ADD CONSTRAINT localizacoes_departamentos_fk
FOREIGN KEY (id_localizacao)
REFERENCES hr.localizacoes (id_localizacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Relacionando empregados com departamentos--
ALTER TABLE hr.empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES hr.departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Relacionando hitorico_cargos com departamentos--
ALTER TABLE hr.historico_cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (id_departamento)
REFERENCES hr.departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Relacionando hitorico_cargos com empregados--
ALTER TABLE hr.historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregado)
REFERENCES hr.empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Autorelacionamento da tabela empregados--
ALTER TABLE hr.empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_gerente)
REFERENCES hr.empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

/*
---------------------------------------
|       POPULANDO AS TABELAS          |
---------------------------------------
*/

--Populando a tabela regioes--
INSERT INTO regioes(id_regiao, nome) 
VALUES  ( 1, 'Europe' ), 
	 	( 2, 'Americas'),
    ( 3 , 'Asia' ),
		( 4 , 'Middle East and Africa' );

