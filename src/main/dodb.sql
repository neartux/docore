CREATE TABLE status (
  id bigserial not null,
  description character varying(20),
  CONSTRAINT status_pkey PRIMARY KEY (id)
);

insert into status (description) values ('Active');
insert into status (description) values ('Inactive');

CREATE TABLE bloodtype (
  id bigserial not null,
  description character varying(20),
  CONSTRAINT bloodtype_pkey PRIMARY KEY (id)
);

  CREATE TABLE personaldata (
    id bigserial not null,
    bloodtypeid bigint,
    firstname character varying(100),
    lastname character varying(100),
    birthdate timestamp without time zone,
    identifier character varying(100),
    sex character varying(100),
    civilstatus character varying(100),
    CONSTRAINT personaldata_pkey PRIMARY KEY (id),
    CONSTRAINT personaldata_bloodtypeid FOREIGN KEY (bloodtypeid)
    REFERENCES bloodtype (id) MATCH SIMPLE
    ON UPDATE RESTRICT ON DELETE RESTRICT
  );

CREATE TABLE country (
  id bigserial not null,
  statusid bigint not null,
  description character varying(100),
  CONSTRAINT country_pkey PRIMARY KEY (id),
  CONSTRAINT country_statusid FOREIGN KEY (statusid)
  REFERENCES status (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE state (
  id bigserial not null,
  statusid bigint not null,
  countryid bigint not null,
  description character varying(100),
  CONSTRAINT state_pkey PRIMARY KEY (id),
  CONSTRAINT state_statusid FOREIGN KEY (statusid)
  REFERENCES status (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT state_countryid FOREIGN KEY (countryid)
  REFERENCES country (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE city (
  id bigserial not null,
  statusid bigint not null,
  stateid bigint not null,
  description character varying(100),
  CONSTRAINT city_pkey PRIMARY KEY (id),
  CONSTRAINT city_statusid FOREIGN KEY (statusid)
  REFERENCES status (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT city_stateid FOREIGN KEY (stateid)
  REFERENCES state (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE locationdata (
  id bigserial not null,
  cityid bigint,
  address character varying(150),
  zipcode character varying(20),
  cellphone character varying(20),
  phone character varying(20),
  email character varying(50),
  CONSTRAINT locationdata_pkey PRIMARY KEY (id),
  CONSTRAINT locationdata_bloodtypeid FOREIGN KEY (cityid)
  REFERENCES city (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE fiscalregime (
  id bigserial not null,
  statusid bigint,
  code character varying(20),
  description character varying(255),
  CONSTRAINT fiscalregime_pkey PRIMARY KEY (id),
  CONSTRAINT fiscalregime_statusid FOREIGN KEY (statusid)
  REFERENCES status (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE usecfdi (
  id bigserial not null,
  statusid bigint,
  code character varying(20),
  description character varying(255),
  CONSTRAINT usecfdi_pkey PRIMARY KEY (id),
  CONSTRAINT usecfdi_statusid FOREIGN KEY (statusid)
  REFERENCES status (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE billingdata (
  id bigserial not null,
  statusid bigint not null,
  usecfdiid bigint,
  fiscalregimeid bigint,
  rfc character varying(100),
  businessname character varying(100),
  expeditionplace character varying(100),
  ciec character varying(100),
  CONSTRAINT billingdata_pkey PRIMARY KEY (id),
  CONSTRAINT billingdata_statusid FOREIGN KEY (statusid)
  REFERENCES status (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT billingdata_usecfdi FOREIGN KEY (usecfdiid)
  REFERENCES usecfdi (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT billingdata_fiscalregimeid FOREIGN KEY (fiscalregimeid)
  REFERENCES fiscalregime (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE company (
  id bigserial not null,
  statusid bigint not null,
  personaldataid bigint,
  locationdataid bigint,
  billingdataid bigint,
  description character varying(255),
  createdat timestamp without time zone,
  CONSTRAINT company_pkey PRIMARY KEY (id),
  CONSTRAINT company_statusid FOREIGN KEY (statusid)
  REFERENCES status (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT company_personaldataid FOREIGN KEY (personaldataid)
  REFERENCES personaldata (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT company_locationdataid FOREIGN KEY (locationdataid)
  REFERENCES locationdata (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT company_billingdataid FOREIGN KEY (billingdataid)
  REFERENCES billingdata (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE companyconfiguration (
  id bigserial not null,
  officesnumber bigint not null,
  companyid bigint,
  CONSTRAINT companyconfiguration_pkey PRIMARY KEY (id),
  CONSTRAINT companyconfiguration_companyid FOREIGN KEY (companyid)
  REFERENCES company (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
);

create table role (
  id bigserial not null,
  name character varying(50) not null,
  constraint role_pkey primary key (id)
);

insert into role (name) values ('generico');
insert into role (name) values ('superuser');
insert into role (name) values ('administrator');
insert into role (name) values ('doctor');

CREATE TABLE usuario (
  id bigserial not null,
  statusid bigint not null,
  personaldataid bigint,
  locationdataid bigint,
  companyid bigint,
  username character varying(100) not null unique,
  password character varying(100),
  createdat timestamp without time zone,
  CONSTRAINT usuario_pkey PRIMARY KEY (id),
  CONSTRAINT usuario_statusid FOREIGN KEY (statusid)
  REFERENCES status (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT usuario_personaldataid FOREIGN KEY (personaldataid)
  REFERENCES personaldata (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT usuario_locationdataid FOREIGN KEY (locationdataid)
  REFERENCES locationdata (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT usuario_companyid FOREIGN KEY (companyid)
  REFERENCES company (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE roleuser (
  idrole bigint not null,
  iduser bigint not null,
  constraint roleuser_pk primary key (iduser, idrole),
  constraint roleuser_idrole foreign key (idrole)
  references role (id) match simple
  on update restrict on delete restrict ,
  constraint roleuser_iduser foreign key (iduser)
  references usuario (id) match simple
  on update restrict on delete restrict
);

CREATE TABLE patient (
  id bigserial not null,
  statusid bigint not null,
  personaldataid bigint,
  locationdataid bigint,
  companyid bigint not null,
  expedient character varying(20) not null,
  profileimage character varying(255),
  createdat timestamp without time zone,
  CONSTRAINT patient_pkey PRIMARY KEY (id),
  CONSTRAINT patient_statusid FOREIGN KEY (statusid)
  REFERENCES status (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT patient_personaldataid FOREIGN KEY (personaldataid)
  REFERENCES personaldata (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT patient_locationdataid FOREIGN KEY (locationdataid)
  REFERENCES locationdata (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT patient_companyid FOREIGN KEY (companyid)
  REFERENCES company (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT patient_companyid_expedient UNIQUE (companyid, expedient)
);

CREATE TABLE doctor (
  id bigserial not null,
  statusid bigint not null,
  userid bigint not null,
  personaldataid bigint,
  locationdataid bigint,
  companyid bigint not null,
  professionalcard character varying(20) unique,
  profileimage character varying(255),
  signimage character varying(255),
  createdat timestamp without time zone,
  CONSTRAINT doctor_pkey PRIMARY KEY (id),
  CONSTRAINT doctor_statusid FOREIGN KEY (statusid)
  REFERENCES status (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT doctor_useris FOREIGN KEY (userid)
  REFERENCES usuario (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT doctor_personaldataid FOREIGN KEY (personaldataid)
  REFERENCES personaldata (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT doctor_locationdataid FOREIGN KEY (locationdataid)
  REFERENCES locationdata (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT doctor_companyid FOREIGN KEY (companyid)
  REFERENCES company (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE doctorsoffice (
  id bigserial not null,
  statusid bigint not null,
  doctorid bigint,
  companyid bigint not null,
  description character varying(255),
  createdat timestamp without time zone,
  CONSTRAINT createdat_pkey PRIMARY KEY (id),
  CONSTRAINT createdat_statusid FOREIGN KEY (statusid)
  REFERENCES status (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT createdat_doctorid FOREIGN KEY (doctorid)
  REFERENCES doctor (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT doctorsoffice_companyid FOREIGN KEY (companyid)
  REFERENCES company (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
);

INSERT INTO country (statusid, description) VALUES (1, 'México');

INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Aguascalientes');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Aguascalientes');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Calvillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cosío');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Llano');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jesús María');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pabellón de Arteaga');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Rincón de Romos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco de los Romo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San José de Gracia');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepezalá');

INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Baja California');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ensenada');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mexicali');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Playas de Rosarito');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tecate');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tijuana');

INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Baja California Sur');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Comondú');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Paz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Loreto');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Los Cabos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mulegé');

INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Campeche');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Calakmul');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Calkiní');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Campeche');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Candelaria');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Carmen');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Champotón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Escárcega');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hecelchakán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hopelchén');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Palizada');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tenabo');

INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Chiapas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acacoyagua');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acapetahua');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Aldama');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Altamirano');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Amatán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Amatenango de la Frontera');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Amatenango del Valle');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ángel Albino Corzo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Arriaga');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Bejucal de Ocampo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Bella Vista');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Benemérito de las Américas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Berriozábal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Bochil');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cacahoatán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chalchihuitán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chamula');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chanal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chapultenango');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Catazajá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chenalhó');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chiapa de Corzo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chiapilla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chicoasén');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chicomosuelo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cintalpa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coapilla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Comitán de Domínguez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Copainalá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Bosque');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Porvenir');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Escuintla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Francisco León');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Frontera Comalapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Frontera Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huehuetán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huitiupán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huixtán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huixtla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixhuatán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixtacomitán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixtapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixtapangajoya');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jiquipilas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jitotol');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Concordia');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Grandeza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Independencia');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Libertad');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Trinitaria');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Larráinzar');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Las Margaritas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Las Rosas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mapastepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Maravilla Tenejapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Marqués de Comillas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mazapa de Madero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mazatán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Metapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mitontic');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Montecristo de Guerrero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Motozintla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nicolás Ruíz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ocosingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ocotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ocozocoautla de Espinosa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ostuacán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Osumacinta');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Oxchuc');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Palenque');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pantelhó');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pantepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pichucalco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pijijiapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pueblo Nuevo Solistahuacán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Rayón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Reforma');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sabanilla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Salto de Agua');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Andrés Duraznal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Cristóbal de las Casas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Fernando');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Cancuc');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Lucas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago el Pinar');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Siltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Simojovel');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sitalá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Socoltenango');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Solosuchiapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Soyaló');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Suchiapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Suchiate');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sunuapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tapachula');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tapalapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tapilula');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tecpatán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tenejapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Teopisca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tila');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tonalá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Totolapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tumbalá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tuxtla Chico');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tuxtla Gutiérrez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tuzantán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tzimol');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Unión Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Venustiano Carranza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa Comaltitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa Corzo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villaflores');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Yajalón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zinacantán');

INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Chihuahua');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ahumada');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Aldama');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Allende');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Aquiles Serdán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ascensión');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Bachíniva');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Balleza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Batopilas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Bocoyna');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Buenaventura');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Camargo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Carichí');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Casas Grandes');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chihuahua');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chínipas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coronado');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coyame del Sotol');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuauhtémoc');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cusihuiriachi');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Delicias');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Belisario Domínguez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Tule');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Galeana');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Gómez Farías');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Gran Morelos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guachochi');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guadalupe');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guadalupe y Calvo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guazapares');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guerrero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hidalgo del Parral');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huejotitán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ignacio Zaragoza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Janos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jiménez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Julimes');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Cruz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'López');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Madera');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Maguarichi');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Manuel Benavides');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Matachí');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Matamoros');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Meoqui');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Morelos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Moris');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Namiquipa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nonoava');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nuevo Casas Grandes');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ocampo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ojinaga');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Praxedis G. Guerrero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Riva Palacio');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Rosales');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Rosario');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco de Borja');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco de Conchos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco del Oro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Bárbara');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Isabel');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Satevó');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Saucillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Temósachic');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Urique');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Uruachi');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Valle de Zaragoza');

INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Ciudad de México');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Álvaro Obregón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Azcapotzalco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Benito Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coyoacán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuajimalpa de Morelos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuauhtémoc');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Gustavo A. Madero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Iztacalco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Iztapalapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Magdalena Contreras');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Miguel Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Milpa Alta');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tláhuac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlalpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Venustiano Carranza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xochimilco');

INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Coahuila');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Abasolo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acuña');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Allende');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Arteaga');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Candela');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Castaños');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuatrociénegas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Escobedo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Francisco I. Madero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Frontera');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'General Cepeda');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guerrero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jiménez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Lamadrid');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Matamoros');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Monclova');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Morelos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Múzquiz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nadadores');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nava');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ocampo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Parras');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Piedras Negras');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Progreso');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ramos Arizpe');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Saltillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Buenaventura');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan de Sabinas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sierra Mojada');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Torreón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Viesca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa Unión');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zaragoza');


INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Colima');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Armería');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Colima');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Comala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coquimatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuauhtémoc');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixtlahuacán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Manzanillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Minatitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tecomán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa de Álvarez');

INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Durango');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Canatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Canelas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coneto de Comonfort');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuencamé');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Durango');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Oro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Gómez Palacio');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Gral. Simón Bolívar');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guadalupe Victoria');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guanaceví');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Indé');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Lerdo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mapimí');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mezquital');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nazas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nombre de Dios');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nuevo Ideal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ocampo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Otáez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pánuco de Coronado');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Peñón Blanco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Poanas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pueblo Nuevo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Rodeo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Bernardo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Dimas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan de Guadalupe');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan del Río');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Luis del Cordero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro del Gallo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Clara');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Papasquiaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Súchil');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tamazula');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepehuanes');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlahualilo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Topia');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Vicente Guerrero');


INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Guanajuato');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Abasolo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acámbaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Apaseo el Alto');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Apaseo el Grande');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atarjea');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Celaya');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Comonfort');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coroneo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cortazar');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuerámaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Doctor Mora');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Dolores Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guanajuato');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huanímaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Irapuato');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jaral del Progreso');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jerécuaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'León');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Manuel Doblado');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Moroleón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ocampo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pénjamo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pueblo Nuevo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Purísima del Rincón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Romita');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Salamanca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Salvatierra');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Diego de la Unión');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Felipe');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco del Rincón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San José Iturbide');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Luis de la Paz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel de Allende');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Catarina');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Cruz de Juventino Rosas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Maravatío');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Silao');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tarandacuao');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tarimoro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tierra Blanca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Uriangato');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Valle de Santiago');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Victoria');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villagrán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xichú');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Yuriria');



INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Guerrero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acapulco de Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ahuacuotzingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ajuchitlán del Progreso');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Alcozauca de Guerrero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Alpoyeca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Apaxtla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Arcelia');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atenango del Río');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atlamajalcingo del Monte');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atlixtac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atoyac de Álvarez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ayutla de los Libres');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Azoyú');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Benito Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Buenavista de Cuéllar');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chilapa de Álvarez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chilpancingo de los Bravo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coahuayutla de José María Izazaga');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cochoapa el Grande');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cocula');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Copala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Copalillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Copanatoyac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coyuca de Benítez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coyuca de Catalán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuajinicuilapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cualác');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuautepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuetzala del Progreso');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cutzamala de Pinzón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Eduardo Neri');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Florencio Villarreal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'General Canuto A. Neri');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'General Heliodoro Castillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huamuxtitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huitzuco de los Figueroa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Iguala de la Independencia');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Igualapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Iliatenco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixcateopan de Cuauhtémoc');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'José Joaquin de Herrera');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Juan R. Escudero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Juchitán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Unión de Isidoro Montes de Oca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Leonardo Bravo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Malinaltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Marquelia');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mártir de Cuilapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Metlatónoc');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mochitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Olinalá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ometepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pedro Ascencio Alquisiras');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Petatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pilcaya');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pungarabato');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Quechultenango');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Luis Acatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Marcos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Totolapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Taxco de Alarcón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tecoanapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Técpan de Galeana');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Teloloapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepecoacuilco de Trujano');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tetipac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tixtla de Guerrero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlacoachistlahuaca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlacoapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlalchapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlalixtaquilla de Maldonado');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlapa de Comonfort');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlapehuala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xalpatláhuac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xochihuehuetlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xochistlahuaca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zapotitlán Tablas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zihuatanejo de Azueta');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zirándaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zitlala');


INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acaxochitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Actopan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Agua Blanca de Iturbide');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ajacuba');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Alfajayucan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Almoloya');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Apan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atitalaquia');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atlapexco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atotonilco de Tula');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atotonilco el Grande');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Calnali');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cardonal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chapantongo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chapulhuacán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chilcuautla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuautepec de Hinojosa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Arenal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Eloxochitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Emiliano Zapata');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Epazoyucan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Francisco I. Madero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huasca de Ocampo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huautla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huazalingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huehuetla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huejutla de Reyes');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huichapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixmiquilpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jacala de Ledezma');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jaltocán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Juárez Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Misión');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Lolotla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Metepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Metztitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mineral de la Reforma');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mineral del Chico');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mineral del Monte');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mixquiahuala de Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Molango de Escamilla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nicolás Flores');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nopala de Villagrán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Omitlán de Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pachuca de Soto');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pacula');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pisaflores');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Progreso de Obregón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Agustín Metzquititlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Agustín Tlaxiaca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Bartolo Tutotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Felipe Orizatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Salvador');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago de Anaya');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Tulantepec de Lugo Guerrero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Singuilucan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tasquillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tecozautla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tenango de Doria');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepeapulco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepehuacán de Guerrero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepeji del Río de Ocampo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepetitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tetepango');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tezontepec de Aldama');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tianguistengo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tizayuca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlahuelilpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlahuiltepa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlanalapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlanchinol');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlaxcoapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tolcayuca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tula de Allende');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tulancingo de Bravo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa de Tezontepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xochiatipan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xochicoatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Yahualica');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zacualtipán de Ángeles');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zapotlán de Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zempoala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zimapán');


INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Jalisco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acatic');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acatlán de Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ahualulco de Mercado');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Amacueca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Amatitán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ameca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Arandas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atemajac de Brizuela');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atengo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atenguillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atotonilco el Alto');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atoyac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Autlán de Navarro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ayotlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ayutla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Bolaños');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cabo Corrientes');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cañadas de Obregón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Casimiro Castillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chapala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chimaltitán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chiquilistlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cihuatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cocula');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Colotlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Concepción de Buenos Aires');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuautitlán de García Barragán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuautla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuquío');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Degollado');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ejutla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Arenal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Grullo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Limón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Salto');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Encarnación de Díaz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Etzatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Gómez Farías');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guachinango');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guadalajara');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hostotipaquillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huejúcar');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huejuquilla el Alto');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixtlahuacán de los Membrillos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixtlahuacán del Río');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jalostotitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jamay');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jesús María');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jilotlán de los Dolores');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jocotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Juanacatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Juchitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Barca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Lagos de Moreno');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Huerta');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Manzanilla de la Paz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Magdalena');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mascota');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mazamitla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mexticacán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mezquitic');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mixtlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ocotlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ojuelos de Jalisco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pihuamo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Poncitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Puerto Vallarta');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Quitupan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Cristóbal de la Barranca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Diego de Alejandría');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Gabriel');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Ignacio Cerro Gordo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan de los Lagos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juanito de Escobedo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Julián');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Marcos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Martín de Bolaños');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Martín Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel el Alto');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Tlaquepaque');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Sebastián del Oeste');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María del Oro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María de los Ángeles');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sayula');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Talpa de Allende');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tamazula de Gordiano');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tapalpa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tecalitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Techaluta de Montenegro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tecolotlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tenamaxtlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Teocaltiche');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Teocuitatlán de Corona');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepatitlán de Morelos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tequila');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Teuchitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tizapán el Alto');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlajomulco de Zúñiga');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tolimán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tomatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tonalá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tonaya');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tonila');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Totatiche');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tototlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tuxcacuesco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tuxcueca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tuxpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Unión de San Antonio');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Unión de Tula');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Valle de Guadalupe');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Valle de Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa Corona');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa Guerrero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa Purificación');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Yahualica de González Gallo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zacoalco de Torres');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zapopan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zapotiltic');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zapotitlán de Vadillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zapotlán del Rey');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zapotlanejo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zapotlán el Grande');



INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'México');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acambay');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acolman');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Aculco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Almoloya de Alquisiras');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Almoloya de Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Almoloya del Río');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Amanalco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Amatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Amecameca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Apaxco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atenco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atizapán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atizapán de Zaragoza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atlacomulco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atlautla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Axapusco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ayapango');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Calimaya');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Capulhuac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chalco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chapa de Mota');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chapultepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chiautla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chicoloapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chiconcuac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chimalhuacán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coacalco de Berriozábal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coatepec Harinas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cocotitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coyotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuautitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuautitlán Izcalli');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Donato Guerra');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ecatepec de Morelos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ecatzingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Oro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huehuetoca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hueypoxtla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huixquilucan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Isidro Fabela');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixtapaluca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixtapan de la Sal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixtapan del Oro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixtlahuaca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jaltenco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jilotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jilotzingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jiquipilco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jocotitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Joquicingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Juchitepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Paz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Lerma');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Luvianos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Malinalco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Melchor Ocampo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Metepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mexicaltzingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Morelos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Naucalpan de Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nextlalpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nezahualcóyotl');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nicolás Romero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nopaltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ocoyoacac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ocuilan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Otumba');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Otzoloapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Otzolotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ozumba');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Papalotla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Polotitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Rayón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Antonio la Isla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Felipe del Progreso');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San José del Rincón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Martín de las Pirámides');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Mateo Atenco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Simón de Guerrero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Tomás');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Soyaniquilpan de Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sultepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tecámac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tejupilco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Temamatla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Temascalapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Temascalcingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Temascaltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Temoaya');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tenancingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tenango del Aire');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tenango del Valle');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Teoloyucán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Teotihuacán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepetlaoxtoc');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepetlixpa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepotzotlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tequixquiac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Texcaltitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Texcalyacac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Texcoco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tezoyuca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tianguistenco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Timilpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlalmanalco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlalnepantla de Baz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlatlaya');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Toluca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tonanitla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tonatico');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tultepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tultitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Valle de Bravo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Valle de Chalco Solidaridad');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa de Allende');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa del Carbón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa Guerrero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa Victoria');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xalatlaco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xonacatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zacazonapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zacualpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zinacantepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zumpahuacán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zumpango');



INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Michoacán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acuitzio');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Aguililla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Álvaro Obregón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Angamacutiro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Angangueo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Apatzingán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Aporo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Aquila');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ario');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Arteaga');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Briseñas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Buenavista');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Carácuaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Charapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Charo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chavinda');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cherán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chilchota');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chinicuila');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chucándiro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Churintzio');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Churumuco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coahuayana');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coalcomán de Vázquez Pallares');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coeneo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cojumatlán de Régules');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Contepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Copándaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cotija');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuitzeo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ecuandureo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Epitacio Huerta');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Erongarícuaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Gabriel Zamora');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huandacareo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huaniqueo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huetamo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huiramba');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Indaparapeo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Irimbo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixtlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jacona');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jiménez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jiquilpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'José Sixto Verduzco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jungapeo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Lagunillas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Huacana');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Piedad');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Lázaro Cárdenas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Los Reyes');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Madero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Maravatío');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Marcos Castellanos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Morelia');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Morelos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Múgica');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nahuatzen');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nocupétaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nuevo Parangaricutiro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nuevo Urecho');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Numarán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ocampo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pajacuarán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Panindícuaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Paracho');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Parácuaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pátzcuaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Penjamillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Peribán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Purépero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Puruándiro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Queréndaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Quiroga');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sahuayo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Salvador Escalante');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Lucas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Ana Maya');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Senguio');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Susupuato');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tacámbaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tancítaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tangamandapio');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tangancícuaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tanhuato');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Taretan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tarímbaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepalcatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tingambato');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tingüindín');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tiquicheo de Nicolás Romero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlalpujahua');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlazazalca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tocumbo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tumbiscatío');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Turicato');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tuxpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tuzantla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tzintzuntzan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tzitzio');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Uruapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Venustiano Carranza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villamar');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Vista Hermosa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Yurécuaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zacapu');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zamora');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zináparo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zinapécuaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ziracuaretiro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zitácuaro');



INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Morelos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Amacuzac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atlatlahucan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Axochiapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ayala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coatlán del Río');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuautla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuernavaca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Emiliano Zapata');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huitzilac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jantetelco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jiutepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jojutla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jonacatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mazatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Miacatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ocuituco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Puente de Ixtla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Temixco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Temoac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepalcingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepoztlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tetecala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tetela del Volcán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlalnepantla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlaltizapán de Zapata');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlaquiltenango');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlayacapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Totolapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xochitepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Yautepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Yecapixtla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zacatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zacualpan');


INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Nayarit');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acaponeta');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ahuacatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Amatlán de Cañas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Bahía de Banderas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Compostela');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Del Nayar');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huajicori');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixtlán del Río');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Yesca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Rosamorada');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ruíz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Blas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Lagunillas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María del Oro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Ixcuintla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tecuala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepic');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tuxpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xalisco');


INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Nuevo León');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Abasolo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Agualeguas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Allende');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Anáhuac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Apodaca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Aramberri');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Bustamante');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cadereyta Jiménez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cerralvo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'China');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ciénega de Flores');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Dr. Arroyo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Dr. Coss');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Dr. González');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Carmen');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Galeana');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'García');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'General Bravo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'General Escobedo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'General Terán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'General Treviño');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'General Zaragoza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'General Zuazua');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guadalupe');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Higueras');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hualahuises');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Iturbide');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Lampazos de Naranjo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Linares');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Los Aldamas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Los Herreras');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Los Ramones');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Marín');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Melchor Ocampo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mier y Noriega');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mina');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Montemorelos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Monterrey');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Parás');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pesquería');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Rayones');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sabinas Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Salinas Victoria');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Nicolás de los Garza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Garza García');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Catarina');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Vallecillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villaldama');


INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Oaxaca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Abejones');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acatlán de Pérez Figueroa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ánimas Trujano');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Asunción Cacalotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Asunción Cuyotepeji');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Asunción Ixtaltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Asunción Nochixtlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Asunción Ocotlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Asunción Tlacolulita');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ayoquezco de Aldama');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ayotzintepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Calihualá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Candelaria Loxicha');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Capulálpam de Méndez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chahuites');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chalcatongo de Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chiquihuitlán de Benito Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ciénega de Zimatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ciudad Ixtepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coatecas Altas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coicoyán de las Flores');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Concepción Buenavista');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Concepción Pápalo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Constancia del Rosario');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cosolapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cosoltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuilápam de Guerrero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuyamecalco Villa de Zaragoza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Barrio de la Soledad');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Espinal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Eloxochitlán de Flores Magón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Fresnillo de Trujano');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guadalupe de Ramírez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guadalupe Etla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guelatao de Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guevea de Humboldt');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Heroica Ciudad de Ejutla de Crespo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Heroica Ciudad de Huajuapan de León');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Heroica Ciudad de Juchitán de Zaragoza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Heroica Ciudad de Tlaxiaco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huautepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huautla de Jiménez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixpantepec Nieves');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixtlán de Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Compañía');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Pe');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Reforma');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Trinidad Vista Hermosa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Loma Bonita');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Magdalena Apasco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Magdalena Jaltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Magdalena Mixtepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Magdalena Ocotlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Magdalena Peñasco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Magdalena Teitipac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Magdalena Tequisistlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Magdalena Tlacotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Magdalena Yodocono de Porfirio Díaz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Magdalena Zahuatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mariscala de Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mártires de Tacubaya');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Matías Romero Avendaño');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mazatlán Villa de Flores');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mesones Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Miahuatlán de Porfirio Díaz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mixistlán de la Reforma');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Monjas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Natividad');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nazareno Etla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nejapa de Madero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nuevo Zoquiápam');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Oaxaca de Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ocotlán de Morelos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pinotepa de Don Luis');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pluma Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Putla Villa de Guerrero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Reforma de Pineda');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Reyes Etla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Rojas de Cuauhtémoc');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Salina Cruz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Agustín Amatengo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Agustín Atenango');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Agustín Chayuco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Agustín de las Juntas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Agustín Etla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Agustín Loxicha');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Agustín Tlacotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Agustín Yatareni');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Andrés Cabecera Nueva');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Andrés Dinicuiti');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Andrés Huaxpaltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Andrés Huayápam');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Andrés Ixtlahuaca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Andrés Lagunas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Andrés Nuxiño');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Andrés Paxtlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Andrés Sinaxtla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Andrés Solaga');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Andrés Teotilálpam');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Andrés Tepetlapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Andrés Yaá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Andrés Zabache');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Andrés Zautla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Antonino Castillo Velasco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Antonino el Alto');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Antonino Monte Verde');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Antonio Acutla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Antonio de la Cal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Antonio Huitepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Antonio Nanahuatípam');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Antonio Sinicahua');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Antonio Tepetlapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Baltazar Chichicápam');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Baltazar Loxicha');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Baltazar Yatzachi el Bajo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Bartolo Coyotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Bartolomé Ayautla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Bartolomé Loxicha');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Bartolomé Quialana');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Bartolomé Yucuañe');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Bartolomé Zoogocho');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Bartolo Soyaltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Bartolo Yautepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Bernardo Mixtepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Blas Atempa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Carlos Yautepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Cristóbal Amatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Cristóbal Amoltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Cristóbal Lachirioag');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Cristóbal Suchixtlahuaca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Dionisio del Mar');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Dionisio Ocotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Dionisio Ocotlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Esteban Atatlahuca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Felipe Jalapa de Díaz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Felipe Tejalápam');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Felipe Usila');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco Cahuacuá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco Cajonos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco Chapulapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco Chindúa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco del Mar');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco Huehuetlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco Ixhuatán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco Jaltepetongo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco Lachigoló');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco Logueche');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco Nuxaño');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco Ozolotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco Sola');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco Telixtlahuaca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco Teopan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco Tlapancingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Gabriel Mixtepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Ildefonso Amatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Ildefonso Sola');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Ildefonso Villa Alta');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Jacinto Amilpas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Jacinto Tlacotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Jerónimo Coatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Jerónimo Silacayoapilla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Jerónimo Sosola');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Jerónimo Taviche');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Jerónimo Tecóatl');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Jerónimo Tlacochahuaya');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Jorge Nuchita');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San José Ayuquila');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San José Chiltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San José del Peñasco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San José del Progreso');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San José Estancia Grande');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San José Independencia');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San José Lachiguiri');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San José Tenango');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Achiutla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Atepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Bautista Atatlahuca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Bautista Coixtlahuaca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Bautista Cuicatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Bautista Guelache');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Bautista Jayacatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Bautista Lo de Soto');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Bautista Suchitepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Bautista Tlachichilco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Bautista Tlacoatzintepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Bautista Tuxtepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Bautista Valle Nacional');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Cacahuatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Chicomezúchil');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Chilateca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Cieneguilla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Coatzóspam');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Colorado');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Comaltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Cotzocón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan del Estado');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan de los Cués');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan del Río');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Diuxi');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Evangelista Analco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Guelavía');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Guichicovi');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Ihualtepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Juquila Mixes');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Juquila Vijanos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Lachao');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Lachigalla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Lajarcia');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Lalana');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Mazatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Mixtepec - Dto. 08');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Mixtepec - Dto. 26');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Ñumí');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Ozolotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Petlapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Quiahije');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Quiotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Sayultepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Tabaá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Tamazola');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Teita');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Teitipac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Tepeuxila');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Teposcolula');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Yaeé');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Yatzona');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Yucuita');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Lorenzo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Lorenzo Albarradas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Lorenzo Cacaotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Lorenzo Cuaunecuiltitla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Lorenzo Texmelúcan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Lorenzo Victoria');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Lucas Camotlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Lucas Ojitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Lucas Quiaviní');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Lucas Zoquiápam');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Luis Amatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Marcial Ozolotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Marcos Arteaga');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Martín de los Cansecos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Martín Huamelélpam');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Martín Itunyoso');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Martín Lachilá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Martín Peras');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Martín Tilcajete');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Martín Toxpalan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Martín Zacatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Mateo Cajonos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Mateo del Mar');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Mateo Etlatongo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Mateo Nejápam');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Mateo Peñasco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Mateo Piñas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Mateo Río Hondo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Mateo Sindihui');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Mateo Tlapiltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Mateo Yoloxochitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Mateo Yucutindó');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Melchor Betaza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Achiutla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Ahuehuetitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Aloápam');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Amatitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Amatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Chicahua');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Chimalapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Coatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel del Puerto');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel del Río');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Ejutla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel el Grande');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Huautla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Mixtepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Panixtlahuaca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Peras');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Piedras');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Quetzaltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Santa Flor');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Soyaltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Suchixtepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Tecomatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Tenango');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Tequixtepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Tilquiápam');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Tlacamama');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Tlacotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Tulancingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Yotao');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Nicolás');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Nicolás Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pablo Coatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pablo Cuatro Venados');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pablo Etla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pablo Huitzo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pablo Huixtepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pablo Macuiltianguis');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pablo Tijaltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pablo Villa de Mitla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pablo Yaganiza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Amuzgos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Apóstol');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Atoyac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Cajonos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Comitancillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Coxcaltepec Cántaros');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro el Alto');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Huamelula');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Huilotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Ixcatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Ixtlahuaca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Jaltepetongo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Jicayán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Jocotipac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Juchatengo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Mártir');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Mártir Quiechapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Mártir Yucuxaco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Mixtepec - Dto. 22');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Mixtepec - Dto. 26');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Molinos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Nopala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Ocopetatillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Ocotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Pochutla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Quiatoni');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Sochiápam');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Tapanatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Taviche');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Teozacoalco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Teutila');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Tidaá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Topiltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Totolápam');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Yaneri');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Yólox');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro y San Pablo Ayutla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro y San Pablo Teposcolula');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro y San Pablo Tequixtepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Yucunama');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Raymundo Jalpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Sebastián Abasolo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Sebastián Coatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Sebastián Ixcapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Sebastián Nicananduta');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Sebastián Río Hondo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Sebastián Tecomaxtlahuaca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Sebastián Teitipac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Sebastián Tutla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Simón Almolongas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Simón Zahuatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Ana');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Ana Ateixtlahuaca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Ana Cuauhtémoc');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Ana del Valle');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Ana Tavela');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Ana Tlapacoyan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Ana Yareni');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Ana Zegache');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Catalina Quierí');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Catarina Cuixtla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Catarina Ixtepeji');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Catarina Juquila');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Catarina Lachatao');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Catarina Loxicha');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Catarina Mechoacán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Catarina Minas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Catarina Quiané');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Catarina Quioquitani');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Catarina Tayata');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Catarina Ticuá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Catarina Yosonotú');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Catarina Zapoquila');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Cruz Acatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Cruz Amilpas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Cruz de Bravo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Cruz Itundujia');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Cruz Mixtepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Cruz Nundaco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Cruz Papalutla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Cruz Tacache de Mina');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Cruz Tacahua');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Cruz Tayata');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Cruz Xitla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Cruz Xoxocotlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Cruz Zenzontepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Gertrudis');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Inés del Monte');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Inés de Zaragoza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Inés Yatzeche');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Lucía del Camino');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Lucía Miahuatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Lucía Monteverde');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Lucía Ocotlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Magdalena Jicotlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Alotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Apazco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Atzompa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Camotlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Chachoápam');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Chilchotla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Chimalapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Colotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Cortijo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Coyotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María del Rosario');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María del Tule');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Ecatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Guelacé');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Guienagati');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Huatulco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Huazolotitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Ipalapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Ixcatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Jacatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Jalapa del Marqués');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Jaltianguis');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María la Asunción');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Lachixío');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Mixtequilla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Nativitas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Nduayaco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Ozolotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Pápalo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Peñoles');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Petapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Quiegolani');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Sola');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Tataltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Tecomavaca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Temaxcalapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Temaxcaltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Teopoxco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Tepantlali');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Texcatitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Tlahuitoltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Tlalixtac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Tonameca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Totolapilla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Xadani');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Yalina');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Yavesía');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Yolotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Yosoyúa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Yucuhiti');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Zacatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Zaniza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María Zoquitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Amoltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Apoala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Apóstol');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Astata');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Atitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Ayuquililla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Cacaloxtepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Camotlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Chazumba');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Choápam');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Comaltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago del Río');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Huajolotitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Huauclilla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Ihuitlán Plumas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Ixcuintepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Ixtayutla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Jamiltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Jocotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Juxtlahuaca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Lachiguiri');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Lalopa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Laollaga');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Laxopa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Llano Grande');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Matatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Miltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Minas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Nacaltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Nejapilla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Niltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Nundiche');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Nuyoó');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Pinotepa Nacional');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Suchilquitongo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Tamazola');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Tapextla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Tenango');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Tepetlapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Tetepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Texcalcingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Textitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Tilantongo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Tillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Tlazoyaltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Xanica');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Xiacuí');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Yaitepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Yaveo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Yolomécatl');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Yosondúa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Yucuyachi');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Zacatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Zoochila');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo Albarradas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo Armenta');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo Chihuitán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo de Morelos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo Ingenio');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo Ixcatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo Nuxaá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo Ozolotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo Petapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo Roayaga');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo Tehuantepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo Teojomulco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo Tepuxtepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo Tlatayápam');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo Tomaltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo Tonalá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo Tonaltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo Xagacía');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo Yanhuitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo Yodohino');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo Zanatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santos Reyes Nopala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santos Reyes Pápalo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santos Reyes Tepejillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santos Reyes Yucuná');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Tomás Jalieza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Tomás Mazaltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Tomás Ocotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Tomás Tamazulapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Vicente Coatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Vicente Lachixío');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Vicente Nuñú');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Silacayoápam');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sitio de Xitlapehua');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Soledad Etla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tamazulápam del Espíritu Santo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tanetze de Zaragoza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Taniche');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tataltepec de Valdés');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Teococuilco de Marcos Pérez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Teotitlán de Flores Magón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Teotitlán del Valle');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Teotongo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepelmeme Villa de Morelos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tezoatlán de Segura y Luna');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlacolula de Matamoros');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlacotepec Plumas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlalixtac de Cabrera');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Totontepec Villa de Morelos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Trinidad Zaachila');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Unión Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Valerio Trujano');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa de Chilapa de Díaz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa de Etla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa de Tamazulápam del Progreso');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa de Tututepec de Melchor Ocampo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa de Zaachila');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa Díaz Ordaz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa Sola de Vega');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa Talea de Castro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa Tejúpam de la Unión');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Yaxe');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Yogana');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Yutanduchi de Guerrero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zapotitlán Lagunas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zapotitlán Palmas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zimatlán de Álvarez');

INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Puebla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acajete');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acateno');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acatzingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acteopan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ahuacatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ahuatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ahuazotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ahuehuetitla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ajalpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Albino Zertuche');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Aljojuca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Altepexi');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Amixtlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Amozoc');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Aquixtla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atempan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atexcal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atlequizayan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atlixco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atoyatempan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atzala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atzitzihuacán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atzitzintla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Axutla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ayotoxco de Guerrero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Calpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Caltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Camocuautla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cañada Morelos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Caxhuacan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chalchicomula de Sesma');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chapulco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chiautla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chiautzingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chichiquila');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chiconcuautla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chietla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chigmecatitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chignahuapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chignautla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chila');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chila de la Sal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chilchotla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chinantla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coatzingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cohetzala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cohuecan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coronango');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coxcatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coyomeapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coyotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuapiaxtla de Madero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuautempan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuautinchán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuautlancingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuayuca de Andrade');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuetzalan del Progreso');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuyoaco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Domingo Arenas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Eloxochitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Epatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Esperanza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Francisco Z. Mena');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'General Felipe Ángeles');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guadalupe');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guadalupe Victoria');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hermenegildo Galeana');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Honey');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huaquechula');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huatlatlauca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huauchinango');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huehuetla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huehuetlán el Chico');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huehuetlán el Grande');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huejotzingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hueyapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hueytamalco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hueytlalpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huitzilan de Serdán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huitziltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixcamilpa de Guerrero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixcaquixtla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixtacamaxtitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixtepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Izúcar de Matamoros');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jalpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jolalpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jonotla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jopala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Juan C. Bonilla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Juan Galindo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Juan N. Méndez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Lafragua');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Magdalena Tlatlauquitepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Libres');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Los Reyes de Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mazapiltepec de Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mixtla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Molcaxac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Naupan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nauzontla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nealtican');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nicolás Bravo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nopalucan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ocotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ocoyucan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Olintla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Oriental');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pahuatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Palmar de Bravo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pantepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Petlalcingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Piaxtla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Puebla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Quecholac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Quimixtlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Rafael Lara Grajales');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Andrés Cholula');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Antonio Cañada');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Diego la Mesa Tochimiltzingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Felipe Teotlalcingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Felipe Tepatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Gabriel Chilac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Gregorio Atzompa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Jerónimo Tecuanipan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Jerónimo Xayacatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San José Chiapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San José Miahuatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Atenco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Atzompa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Martín Texmelucan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Martín Totoltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Matías Tlalancaleca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Ixitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel Xoxtla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Nicolás Buenos Aires');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Nicolás de los Ranchos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pablo Anicano');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Cholula');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro Yeloixtlahuaca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Salvador el Seco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Salvador el Verde');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Salvador Huixcolotla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Sebastián Tlacotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Catarina Tlaltempan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Inés Ahuatempan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Isabel Cholula');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Miahuatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Tomás Hueyotlipan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Soltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tecali de Herrera');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tecamachalco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tecomatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tehuacán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tehuitzingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tenampulco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Teopantlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Teotlalco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepanco de López');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepango de Rodríguez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepatlaxco de Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepeaca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepemaxalco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepeojuma');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepetzintla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepexco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepexi de Rodríguez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepeyahualco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepeyahualco de Cuauhtémoc');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tetela de Ocampo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Teteles de Avila Castillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Teziutlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tianguismanalco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tilapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlachichuca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlacotepec de Benito Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlacuilotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlahuapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlaltenango');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlanepantla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlaola');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlapacoya');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlapanalá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlatlauquitepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlaxco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tochimilco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tochtepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Totoltepec de Guerrero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tulcingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tuzamapan de Galeana');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tzicatlacoyan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Venustiano Carranza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Vicente Guerrero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xayacatlán de Bravo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xicotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xicotlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xiutetelco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xochiapulco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xochiltepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xochitlán de Vicente Suárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xochitlán Todos Santos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Yaonáhuac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Yehualtepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zacapala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zacapoaxtla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zacatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zapotitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zapotitlán de Méndez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zaragoza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zautla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zihuateutla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zinacatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zongozotla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zoquiapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zoquitlán');


INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Querétaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Amealco de Bonfil');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Arroyo Seco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cadereyta de Montes');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Colón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Corregidora');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Marqués');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ezequiel Montes');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huimilpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jalpan de Serra');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Landa de Matamoros');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pedro Escobedo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Peñamiller');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pinal de Amoles');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Querétaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Joaquín');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan del Río');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tequisquiapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tolimán');


INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Quintana Roo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Bacalar');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Benito Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cozumel');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Felipe Carrillo Puerto');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Isla Mujeres');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'José María Morelos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Lázaro Cárdenas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Othón P. Blanco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Solidaridad');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tulum');


INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'San Luis Potosí');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ahualulco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Alaquines');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Aquismón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Armadillo de los Infante');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Axtla de Terrazas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cárdenas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Catorce');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cedral');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cerritos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cerro de San Pedro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Charcas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ciudad del Maíz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ciudad Fernández');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ciudad Valles');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coxcatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ebano');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Naranjo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guadalcázar');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huehuetlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Lagunillas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Matehuala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Matlapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mexquitic de Carmona');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Moctezuma');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Rayón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Rioverde');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Salinas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Antonio');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Ciro de Acosta');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Luis Potosí');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Martín Chalchicuautla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Nicolás Tolentino');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Catarina');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María del Río');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santo Domingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Vicente Tancuayalab');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Soledad de Graciano Sánchez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tamasopo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tamazunchale');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tampacán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tampamolón Corona');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tamuín');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tancanhuitz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tanlajás');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tanquián de Escobedo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tierra Nueva');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Vanegas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Venado');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa de Arista');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa de Arriaga');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa de Guadalupe');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa de la Paz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa de Ramos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa de Reyes');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xilitla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zaragoza');


INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Sinaloa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ahome');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Angostura');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Badiraguato');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Choix');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Concordia');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cosalá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Culiacán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Fuerte');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Elota');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Escuinapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guasave');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mazatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mocorito');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Navolato');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Rosario');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Salvador Alvarado');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Ignacio');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sinaloa');


INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Sonora');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Aconchi');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Agua Prieta');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Alamos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Altar');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Arivechi');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Arizpe');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atil');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Bacadéhuachi');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Bacanora');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Bacerac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Bacoachi');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Bácum');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Banámichi');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Baviácora');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Bavispe');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Benito Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Benjamín Hill');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Caborca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cajeme');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cananea');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Carbó');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cucurpe');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cumpas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Divisaderos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Empalme');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Etchojoa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Fronteras');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'General Plutarco Elías Calles');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Granados');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guaymas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hermosillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huachinera');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huásabas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huatabampo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huépac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Imuris');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Colorada');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Magdalena');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mazatán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Moctezuma');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Naco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nácori Chico');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nacozari de García');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Navojoa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nogales');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Onavas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Opodepe');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Oquitoa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pitiquito');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Puerto Peñasco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Quiriego');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Rayón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Rosario');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sahuaripa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Felipe de Jesús');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Ignacio Río Muerto');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Javier');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Luis Río Colorado');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Miguel de Horcasitas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pedro de la Cueva');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Ana');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Cruz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sáric');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Soyopa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Suaqui Grande');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepache');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Trincheras');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tubutama');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ures');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa Pesqueira');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Yécora');


INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Tabasco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Balancán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cárdenas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Centla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Centro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Comalcalco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cunduacán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Emiliano Zapata');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huimanguillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jalapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jalpa de Méndez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jonuta');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Macuspana');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nacajuca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Paraíso');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tacotalpa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Teapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tenosique');

INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Tamaulipas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Abasolo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Aldama');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Altamira');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Antiguo Morelos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Burgos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Bustamante');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Camargo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Casas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ciudad Madero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cruillas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Mante');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Gómez Farías');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'González');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Güémez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guerrero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Gustavo Díaz Ordaz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jaumave');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jiménez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Llera');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mainero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Matamoros');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Méndez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mier');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Miguel Alemán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Miquihuana');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nuevo Laredo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nuevo Morelos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ocampo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Padilla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Palmillas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Reynosa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Río Bravo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Carlos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Fernando');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Nicolás');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Soto la Marina');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tampico');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tula');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Valle Hermoso');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Victoria');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villagrán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xicoténcatl');


INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Tlaxcala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acuamanala de Miguel Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Amaxac de Guerrero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Apetatitlán de Antonio Carvajal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Apizaco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atlangatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atltzayanca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Benito Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Calpulalpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chiautempan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Contla de Juan Cuamatzi');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuapiaxtla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuaxomulco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Carmen Tequexquitla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Emiliano Zapata');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Españita');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huamantla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hueyotlipan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixtacuixtla de Mariano Matamoros');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixtenco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Magdalena Tlaltelulco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Lázaro Cárdenas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mazatecochco de José María Morelos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Muñoz de Domingo Arenas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nanacamilpa de Mariano Arista');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Natívitas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Panotla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Papalotla de Xicohténcatl');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sanctórum de Lázaro Cárdenas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Damián Texóloc');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Francisco Tetlanohcan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Jerónimo Zacualpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San José Teacalco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Huactzinco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Lorenzo Axocomanitla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Lucas Tecopilco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Pablo del Monte');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Ana Nopalucan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Apolonia Teacalco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Catarina Ayometla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Cruz Quilehtla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Cruz Tlaxcala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Isabel Xiloxoxtla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tenancingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Teolocholco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepetitla de Lardizábal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepeyanco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Terrenate');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tetla de la Solidaridad');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tetlatlahuca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlaxcala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlaxco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tocatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Totolac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tzompantepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xaloztoc');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xaltocan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xicohtzinco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Yauhquemehcan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zacatelco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ziltlaltépec de Trinidad Sánchez Santos');

INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Veracruz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acajete');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acayucan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Actopan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acula');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acultzingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Agua Dulce');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Álamo Temapache');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Alpatláhuac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Alto Lucero de Gutiérrez Barrios');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Altotonga');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Alvarado');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Alvarado');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Amatlán de los Reyes');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ángel R. Cabada');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Apazapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Aquila');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Astacinga');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atlahuilco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atoyac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atzacan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atzalan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ayahualulco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Banderilla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Benito Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Boca del Río');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Calcahualco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Camarón de Tejeda');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Camerino Z. Mendoza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Carlos A. Carrillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Carrillo Puerto');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Castillo de Teayo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Catemaco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cazones de Herrera');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cerro Azul');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chacaltianguis');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chalma');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chiconamel');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chiconquiaco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chicontepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chinameca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chinampa de Gorostiza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chocamán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chontla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chumatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Citlaltépetl');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coacoatzintla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coahuitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coatzacoalcos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coatzintla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coetzala');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Colipa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Comapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Córdoba');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cosamaloapan de Carpio');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Consautlán de Carvajal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coscomatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cosoleacaque');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cotaxtla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coxquihui');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Coyutla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuichapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuitláhuac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Higo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Emiliano Zapata');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Espinal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Filomeno Mata');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Fortín');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Gutiérrez Zamora');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hidalgotitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huayacocotla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hueyapan de Ocampo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huiloapan de Cuauhtémoc');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ignacio de la Llave');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ilamatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Isla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixcatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixhuacán de los Reyes');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixhuatlancillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixhuatlán del Café');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixhuatlán de Madero');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixhuatlán del Sureste');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixmatlahuacan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixtaczoquitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jalacingo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jalcomulco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jáltipan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jamapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jesús Carranza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jilotepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'José Azueta');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Juan Rodríguez Clara');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Juchique de Ferrer');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Antigua');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Landero y Coss');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'La Perla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Las Choapas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Las Minas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Las Vigas de Ramírez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Lerdo de Tejada');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Los Reyes');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Magdalena');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Maltrata');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Manlio Fabio Altamirano');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mariano Escobedo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Martínez de la Torre');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mecatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mecayapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Medellín');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Miahuatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Minatitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Misantla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mixtla de Altamirano');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Moloacán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nanchital de Lázaro Cárdenas del Río');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Naolinco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Naranjal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Naranjos Amatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nautla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nogales');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Oluta');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Omealca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Orizaba');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Otatitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Oteapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ozuluama de Mascañeras');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pajapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pánuco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Papantla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Paso del Macho');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Paso de Ovejas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Perote');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Platón Sánchez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Playa Vicente');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Poza Rica de Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pueblo Viejo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Puente Nacional');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Rafael Delgado');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Rafael Lucio');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Río Blanco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Saltabarranca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Andrés Tenejapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Andrés Tuxtla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Juan Evangelista');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Rafael');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Sochiapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santiago Tuxtla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sayula de Alemán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Soconusco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sochiapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Soledad Atzompa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Soledad de Doblado');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Soteapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tamalín');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tamiahua');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tampico Alto');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tancoco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tantima');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tantoyuca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tatatila');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tatahuicapan de Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tecolutla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tehuipango');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tempoal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tenampa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tenochtitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Teocelo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepatlaxco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepetlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepetzintla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tequila');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Texcatepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Texhuacán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Texistepec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tezonapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tihuatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tierra Blanca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlacojalpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlacolulan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlacotalpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlacotepec de Mejía');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlachichilco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlalixcoyan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlalnelhuayocan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlaltetela');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlapacoyan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlaquilpa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlilapan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tomatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tonayán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Totutla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tres Valles');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tuxpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tuxtilla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Úrsulo Galván');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Uxpanapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Vega de Alatorre');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Veracruz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa Aldama');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xalapa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xico');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xoxocotla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Yanga');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Yecuatla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zacualpan');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zaragoza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zentla');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zongolica');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zontecomatlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zozocolco de Hidalgo');

INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Yucatán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Abalá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Acanceh');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Akil');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Baca');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Bokobá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Buctzotz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cacalchén');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Calotmul');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cansahcab');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cantamayec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cantamayec');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Calestún');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cenotillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Conkal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuncunul');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuzamá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chacsinkín');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chankom');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chapab');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chemax');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chicxulub Pueblo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chichimilá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chikindzonot');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chocholá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chumayel');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Dzán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Dzemul');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Dzidzantún');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Dzilam de Bravo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Dzilam González');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Dzitás');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Dzoncauich');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Espita');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Halachó');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hocabá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hoctún');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Homún');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huhí');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Hunucmá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ixil');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Izamal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Kanasín');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Kantunil');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Kaua');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Kinchil');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Kopomá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mama');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Maní');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Maxcanú');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mayapán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mérida');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mocochá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Motul');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Muna');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Muxupip');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Opichén');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Oxkutzcab');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Panabá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Peto');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Progreso');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Río Lagartos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sacalum');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Samahil');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sanahcat');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'San Felipe');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa Elena');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Seyé');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sinanché');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sotuta');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sucilá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sudzal');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Suma de Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tahdziú');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tahmek');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Teabo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tecoh');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tekal de Venegas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tekantó');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tekax');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tekit');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tekom');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Telchac Pueblo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Telchac Puerto');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Temozón');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepakán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tetiz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Teya');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ticul');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Timucuy');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tinúm');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tixcacalcupul');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tixkokob');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tixméhuac');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tixpéhual');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tizimín');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tunkás');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tzucacab');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Uayma');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ucú');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Umán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Valladolid');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Xocchel');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Yaxcabá');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Yaxkukul');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Yobaín');

INSERT INTO state (statusid, countryid, description) VALUES (1, 1, 'Zacatecas');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Apozol');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Apulco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Atolinga');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Benito Juárez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Calera');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cañitas de Felipe Pescador');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Concepción del Oro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Cuauhtémoc');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Chalchihuites');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Fresnillo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Trinidad García de la Cadena');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Genaro Codina');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'General Enrique Estrada');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'General Francisco R. Murguía');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Plateado de Joaquín Amaro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'El Salvador');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'General Pánfilo Natera');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Guadalupe');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Huanusco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jalpa');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jerez');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Jiménez del Teul');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Juan Aldama');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Juchipila');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Loreto');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Luis Moya');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mazapil');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Melchor Ocampo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Mezquital del Oro');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Miguel Auza');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Momax');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Monte Escobedo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Morelos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Moyahua de Estrada');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Nochistlán de Mejía');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Noria de Ángeles');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Ojocaliente');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pánuco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Pinos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Río Grande');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sain Alto');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Santa María de la Paz');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Sombrerete');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Susticacán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tabasco');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepechitlán');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tepetongo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Teul de González Ortega');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Tlaltenango de Sánchez Román');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Trancoso');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Valparaíso');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Vetagrande');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa de Cos');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa García');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa González Ortega');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villa Hidalgo');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Villanueva');
INSERT INTO city (statusid, stateid, description) VALUES (1, (SELECT max(id) from state),'Zacatecas');

insert into bloodtype (description) values ('NA');
insert into bloodtype (description) values ('O+');
insert into bloodtype (description) values ('O-');
insert into bloodtype (description) values ('A+');
insert into bloodtype (description) values ('A-');
insert into bloodtype (description) values ('B+');
insert into bloodtype (description) values ('B-');
insert into bloodtype (description) values ('AB+');
insert into bloodtype (description) values ('AB-');

insert into personaldata (bloodtypeid, firstname, lastname, sex) values (1,'Ricardo','Dzul', 'MALE');
insert into locationdata (address, cellphone) values ('Merida Yuc.', '9993599516');
insert into company (statusid,personaldataid,locationdataid,description,createdat) values (1,(select max(id) from personaldata),(select max(id) from locationdata),'Default Company',now());
insert into usuario(statusid, personaldataid, locationdataid, companyid, username, password) values (1, (select max(id) from personaldata), (select max(id) from locationdata), 1, 'admin', md5('demo'));
insert into roleuser (idrole, iduser) values (1, (select max(id) from usuario));
insert into roleuser (idrole, iduser) values (2, (select max(id) from usuario));
insert into roleuser (idrole, iduser) values (3, (select max(id) from usuario));

create table eventtype (
  id bigserial not null,
  description character varying(20),
  CONSTRAINT eventtype_pkey PRIMARY KEY (id)
);
insert into eventtype (id,description) values (1,'Citas');
insert into eventtype (id,description) values (2,'Ausencia');
insert into eventtype (id,description) values (3,'Receso');

create table itinerary (
  id bigserial not null,
  doctorsofficeid bigint not null,
  statusid bigint not null,
  usercreateid bigint not null,
  createdat timestamp without time zone,
  CONSTRAINT itinerary_pkey PRIMARY KEY (id),
  CONSTRAINT itinerary_doctorsofficeid FOREIGN KEY (doctorsofficeid)
  REFERENCES doctorsoffice (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT itinerary_statusid FOREIGN KEY (statusid)
  REFERENCES status (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT itinerary_usercreate FOREIGN KEY (usercreateid)
  REFERENCES usuario (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
);

create table itinerarydetail (
  id bigserial not null,
  itineraryid bigint not null,
  statusid bigint not null,
  eventtypeid bigint not null,
  createdat timestamp without time zone,
  startdate timestamp without time zone,
  enddate timestamp without time zone,
  CONSTRAINT itinerarydetail_pkey PRIMARY KEY (id),
  CONSTRAINT itinerarydetail_doctorid FOREIGN KEY (itineraryid)
  REFERENCES itinerary (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT itinerarydetail_statusid FOREIGN KEY (statusid)
  REFERENCES status (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT itinerarydetail_usercreate FOREIGN KEY (eventtypeid)
  REFERENCES eventtype (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
);

create table vitalsigns (
  id bigserial not null,
  patientid bigint not null,
  statusid bigint not null,
  weight character varying(50),
  temperature character varying(50),
  size character varying(50),
  bloodpressure1 character varying(50),
  bloodpressure2 character varying(50),
  heartfrecuency character varying(50),
  breatingfrecuency character varying(50),
  CONSTRAINT vitalsigns_pkey PRIMARY KEY (id),
  CONSTRAINT vitalsigns_doctorsofficeid FOREIGN KEY (patientid)
  REFERENCES patient (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT vitalsigns_statusid FOREIGN KEY (statusid)
  REFERENCES status (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
);

create table medicalappointment (
  id bigserial not null,
  patientid bigint not null,
  statusid bigint not null,
  doctorsofficeid bigint not null,
  doctorid bigint,
  userid bigint not null,
  vitalsignsid bigint not null,
  startdate timestamp without time zone,
  enddate timestamp without time zone,
  createdat timestamp without time zone,
  type character varying(50),
  viarequest character varying (100),
  reason character varying(255),
  CONSTRAINT medicalappointment_pkey PRIMARY KEY (id),
  CONSTRAINT medicalappointment_patientid FOREIGN KEY (patientid)
  REFERENCES patient (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT medicalappointment_statusid FOREIGN KEY (statusid)
  REFERENCES status (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT medicalappointment_doctorsofficeid FOREIGN KEY (doctorsofficeid)
  REFERENCES doctorsoffice (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT medicalappointment_doctorid FOREIGN KEY (doctorid)
  REFERENCES doctor (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT medicalappointment_userid FOREIGN KEY (userid)
  REFERENCES usuario (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT medicalappointment_vitalsignsid FOREIGN KEY (vitalsignsid)
  REFERENCES vitalsigns (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
);

comment on column medicalappointment.type is 'First Time Or Subsecuent';
comment on column medicalappointment.viarequest is 'Personal,Phone,Email';
comment on column medicalappointment.doctorsofficeid is 'Consultorio Atiende';
comment on column medicalappointment.doctorid is 'Doctor que atendio';
comment on column medicalappointment.userid is 'Usuario que agendo';

create table medicalappointmenthistory (
  id bigserial not null,
  medicalappointmentid bigint not null,
  patientid bigint not null,
  personaldataid bigint not null,
  locationdataid bigint not null,
  statusid bigint not null,
  doctorsofficeid bigint not null,
  doctorid bigint,
  userid bigint not null,
  vitalsignsid bigint not null,
  startdate timestamp without time zone,
  enddate timestamp without time zone,
  createdat timestamp without time zone,
  type character varying(50),
  viarequest character varying (100),
  reason character varying(255),
  CONSTRAINT medicalappointmenthistory_pkey PRIMARY KEY (id),
  CONSTRAINT medicalappointmenthistory_medicalappointmentid FOREIGN KEY (medicalappointmentid)
  REFERENCES medicalappointment (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT medicalappointmenthistory_patientid FOREIGN KEY (patientid)
  REFERENCES patient (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT medicalappointmenthistory_personaldataid FOREIGN KEY (personaldataid)
  REFERENCES personaldata (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT medicalappointmenthistory_locationdataid FOREIGN KEY (locationdataid)
  REFERENCES locationdata (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT medicalappointmenthistory_statusid FOREIGN KEY (statusid)
  REFERENCES status (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT medicalappointmenthistory_doctorsofficeid FOREIGN KEY (doctorsofficeid)
  REFERENCES doctorsoffice (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT medicalappointmenthistory_doctorid FOREIGN KEY (doctorid)
  REFERENCES doctor (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT medicalappointmenthistory_userid FOREIGN KEY (userid)
  REFERENCES usuario (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT medicalappointmenthistory_vitalsignsid FOREIGN KEY (vitalsignsid)
  REFERENCES vitalsigns (id) MATCH SIMPLE
  ON UPDATE RESTRICT ON DELETE RESTRICT
);

comment on column medicalappointmenthistory.type is 'First Time Or Subsecuent';
comment on column medicalappointmenthistory.viarequest is 'Personal,Phone,Email';
comment on column medicalappointmenthistory.doctorsofficeid is 'Consultorio Atiende';
comment on column medicalappointmenthistory.doctorid is 'Doctor que atendio';
comment on column medicalappointmenthistory.userid is 'Usuario que agendo';

insert into status (id, description) values (3, 'Start');
insert into status (id, description) values (4, 'Finalize');
insert into status (id, description) values (5, 'Scheduled');
insert into status (id, description) values (6, 'Confirmed');
insert into status (id, description) values (7, 'Waiting Room');
insert into status (id, description) values (8, 'Pay');