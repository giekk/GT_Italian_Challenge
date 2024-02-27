drop table if exists Albo_d_oro;
drop table if exists Campionato_piloti;
drop table if exists Campionato_costruttori;
drop table if exists Gran_premio;
drop table if exists Collaudatore;
drop table if exists Offerta;
drop table if exists Seconda_guida;
drop table if exists Prima_guida;
drop table if exists Pilota;
drop table if exists Team_principal;
drop table if exists Auto;
drop table if exists Motore;
drop table if exists Sede;
drop table if exists Scuderia_campione;
drop table if exists Scuderia;
drop table if exists Tracciato;

create table Tracciato(
    Pista varchar(50) primary key not null,
    Km decimal(3,2) not null,
    Curve int not null,
    Stato char(2) not null,
    Città varchar(50) not null,
    Provincia char(2) not null
);

create table Scuderia(
    Nome varchar(50) primary key not null,
    Vittorie int not null
);

create table Scuderia_campione(
    Nome varchar(50) primary key not null,
    Campionati int not null,
    foreign key (Nome) references Scuderia(Nome) on update cascade on delete cascade
);

create table Sede(
    Scuderia varchar(50) primary key not null,
    Stato char(2) not null,
    Città varchar(50) not null,
    Provincia char(2) not null,
    Via varchar(50) not null,
    N_civico varchar(4) not null,
    foreign key (Scuderia) references Scuderia(Nome) on update cascade on delete cascade
);

create table Motore(
    Marchio varchar(20) primary key not null
);

create table Auto(
    Modello varchar(50) not null,
    Scuderia varchar(50) not null,
    CV int not null,
    Cc int not null,
    Peso decimal(6,2) not null,
    Motore varchar(20) not null,
    primary key (Modello, Scuderia),
    foreign key (Scuderia) references Scuderia(Nome) on update cascade on delete cascade,
    foreign key (Motore) references Motore(Marchio) on update cascade on delete cascade
);

create table Team_principal(
    CF varchar(16) primary key not null,
    Nome varchar(50) not null,
    Scuderia varchar(50) not null,
    Inizio_dirigenza date not null,
    Fine_dirigenza date check(Fine_dirigenza > Inizio_dirigenza),
    foreign key (Scuderia) references Scuderia(Nome) on update cascade on delete cascade
);

create table Pilota(
    Numero int primary key not null,
    Nome varchar(50) unique not null,
    Scuderia varchar(50) not null,
    Vittorie int not null,
    Inizio_ingaggio date not null,
    Fine_ingaggio date check(Fine_ingaggio > Inizio_ingaggio),
    foreign key (Scuderia) references Scuderia(Nome) on update cascade on delete cascade
);

create table Prima_guida(
    Numero int primary key not null,
    Retrocessione boolean not null,
    foreign key (Numero) references Pilota(Numero) on update cascade on delete cascade
);

create table Seconda_guida(
    Numero int primary key not null,
    Promozione boolean not null,
    foreign key (Numero) references Pilota(Numero) on update cascade on delete cascade
);

create table Collaudatore(
    Numero int primary key not null,
    Test_effettuati int not null,
    foreign key (Numero) references Pilota(Numero) on update cascade on delete cascade
);

create table Gran_premio(
    GP varchar(50) primary key not null,
    Tracciato varchar(50) not null,
    Data timestamp not null,
    Pilota_vincitore int,
    Scuderia_vincitrice varchar(50),
    foreign key (Tracciato) references Tracciato(Pista) on update cascade on delete cascade,
    foreign key (Pilota_vincitore) references Pilota(Numero) on update cascade on delete cascade,
    foreign key (Scuderia_vincitrice) references Scuderia(Nome) on update cascade on delete cascade
);

create table Campionato_piloti(
    Posizione serial not null,
    Pilota int not null,
    Punti int not null,
    primary key (Posizione, Pilota),
    foreign key (Pilota) references Pilota(Numero) on update cascade on delete cascade
);

create table Campionato_costruttori(
    Posizione serial not null,
    Scuderia varchar(50) not null,
    Punti int not null,
    primary key (Posizione, Scuderia),
    foreign key (Scuderia) references Scuderia(Nome) on update cascade on delete cascade
);

create table Offerta(
    Scuderia varchar(50) not null,
    Pilota int not null,
    Cifra decimal(8,2) not null,
    Accettata boolean,
    primary key (Scuderia, Pilota),
    foreign key (Scuderia) references Scuderia(Nome) on update cascade on delete cascade,
    foreign key (Pilota) references Pilota(Numero) on update cascade on delete cascade
);

create table Albo_d_oro(
    Anno int primary key not null,
    Pilota_campione varchar(50),
    Scuderia_campione varchar(50),
    foreign key (Pilota_campione) references Pilota(Nome) on update cascade on delete cascade,
    foreign key (Scuderia_campione) references Scuderia(Nome) on update cascade on delete cascade
);

insert into Tracciato(Pista, Km, Curve, Stato, Città, Provincia) values
('Mugello Circuit', 5.24, 15, 'IT', 'Scarperia e san Piero', 'FI'),
('Autodromo Internazionale di Monza', 5.79, 11, 'IT', 'Monza', 'MB'),
('Autodromo Enzo e Dino Ferrari', 4.90, 19, 'IT', 'Imola', 'BO'),
('Autodromo di Vallelunga', 4.08, 15, 'IT', 'Campagnano di Roma', 'RM'),
('Misano World Circuit', 4.22, 16, 'IT', 'Misano Adriatico', 'RI'),
('Circuito di Fiorano', 2.97, 13, 'IT', 'Fiorano Modenese', 'MO'),
('Autodromo del Levante', 1.57, 9, 'IT', 'Binetto', 'BA'),
('Adria International Raceway', 3.74, 11, 'IT', 'Adria', 'RO');

insert into Scuderia(Nome, Vittorie) values
('Gresini Racing', 1),
('RTX GT Team', 0),
('Oracle Racing Team', 2),
('Arnaldi Racing', 0),
('GTO Racing Team', 3);

insert into Scuderia_campione(Nome, Campionati) values
('Oracle Racing Team', 4);

insert into Sede(Scuderia, Stato, Città, Provincia, Via, N_civico) values
('Gresini Racing', 'IT', 'Bologna', 'BO', 'Via Sesti', 7),
('RTX GT Team', 'IT', 'Rimini', 'RN', 'Via D.Alighieri', 46),
('Oracle Racing Team', 'IT', 'Monza', 'MB', 'Via Chiesure', 12),
('Arnaldi Racing', 'IT', 'Firenze', 'FI', 'Via Gulli', 4),
('GTO Racing Team', 'IT', 'Padova', 'PD', 'Via A.Diaz', 21);

insert into Motore(Marchio) values
('Ferrari'),
('Mercedes'),
('Renault'),
('Honda'),
('Lamborghini');

insert into Auto(Modello, Scuderia, CV, Cc, Peso, Motore) values
('Aston Martin V12 Vantage GT3', 'Gresini Racing', 600, 5935, 1250.00, 'Mercedes'),
('Mclaren 650S GT3', 'RTX GT Team', 550, 3799, 1240.00, 'Mercedes'),
('Ferrari 458 Italia GT3', 'GTO Racing Team', 550, 4487, 1215.00, 'Ferrari'),
('Lamborghini Huracàn GT3', 'Oracle Racing Team', 585, 5204, 1230.00, 'Lamborghini'),
('Renault R.S.01 GT3', 'Arnaldi Racing', 542, 3799, 1220.00, 'Renault');

insert into Team_principal(CF, Nome, Scuderia, Inizio_dirigenza, Fine_dirigenza) values
('GTAVZO99I05G908P', 'Vincenzo Giaretta', 'Gresini Racing', '2016-03-21', NULL),
('BSOMCO00W10E243Q', 'Marco Basso', 'RTX GT Team', '2017-03-13', '2023-03-13'),
('SFIALA84R04T387N', 'Angela Stefani', 'Oracle Racing Team', '2020-04-19', '2024-04-19'),
('ZLOFCO04M01Q389L', 'Francesco Zilio', 'Arnaldi Racing', '2022-03-15', '2027-03-15'),
('DDEFIN94L02K097R', 'Davide Filippin', 'GTO Racing Team', '2015-03-08', NULL);

insert into Pilota(Numero, Nome, Scuderia, Vittorie, Inizio_ingaggio, Fine_ingaggio) values
(47, 'Alberto De Lorenzi', 'Gresini Racing', 1, '2019-02-25', '2024-02-25'),
(5, 'Cinzia Fraccaro', 'Arnaldi Racing', 0, '2022-03-01', '2024-03-01'),
(12, 'Chris Evans', 'RTX GT Team', 0, '2020-03-12', '2025-03-12'),
(56, 'Silvio Rini', 'Oracle Racing Team', 1, '2018-02-04', '2026-02-04'),
(33, 'Matteo Pellegrini', 'GTO Racing Team', 0, '2023-03-17', '2025-03-17'),
(21, 'Mario Bonelli', 'Gresini Racing', 0, '2022-02-20', '2025-02-20'),
(3, 'Francesco Todescato', 'Oracle Racing Team', 1, '2012-03-13', NULL),
(17, 'Mattia Lauri', 'RTX GT Team', 0, '2023-02-19', '2027-02-19'),
(77, 'William Cooper', 'GTO Racing Team', 0, '2021-03-15', '2025-03-15'),
(9, 'Angelo Bassi', 'Arnaldi Racing', 0, '2020-02-21', '2024-02-21'),
(22, 'Claudio Pasquale', 'Gresini Racing', 0, '2022-03-02', '2024-03-02'),
(99, 'Alessandro Grandi', 'Oracle Racing Team', 0, '2021-03-03', '2026-03-03'),
(89, 'Marco Cecchi', 'Arnaldi Racing', 1, '2019-03-10', '2024-03-10'),
(7, 'Davide Ceccato', 'GTO Racing Team', 3, '2015-02-16', NULL),
(58, 'Sara Castelli', 'RTX GT Team', 0, '2022-03-18', '2027-03-18');

insert into Prima_guida(Numero, Retrocessione) values
(47, FALSE),
(3, FALSE),
(9, TRUE),
(12, TRUE),
(7, FALSE);

insert into Seconda_guida(Numero, Promozione) values
(21, FALSE),
(56, FALSE),
(89, TRUE),
(17, TRUE),
(77, FALSE);

insert into Collaudatore(Numero, Test_effettuati) values
(5, 3),
(33, 0),
(22, 2),
(99, 5),
(58, 4);

insert into Gran_premio(GP, Tracciato, Data, Pilota_vincitore, Scuderia_vincitrice) values
('Gran Premio di Toscana', 'Mugello Circuit', '2023-03-30 15:00:00', 7, 'GTO Racing Team'),
('Gran Pemio di Italia', 'Autodromo Internazionale di Monza', '2023-04-17 15:00:00', 3, 'Oracle Racing Team'),
('Gran Premio di Emilia Romagna', 'Autodromo Enzo e Dino Ferrari', '2023-05-14 14:00:00', 7, 'GTO Racing Team'),
('Gran Premio di Roma', 'Autodromo di Vallelunga', '2023-05-21 15:00:00', 7, 'GTO Racing Team'),
('Gran Premio di San Marino', 'Misano World Circuit', '2023-06-18 14:00:00', 47, 'Gresini Racing'),
('Gran Premio di Modena', 'Circuito di Fiorano', '2023-07-12 15:00:00', 56, 'Oracle Racing Team'),
('Gran Premio di Puglia', 'Autodromo del Levante', '2023-09-19 15:00:00', 89, 'Arnaldi Racing'),
('Gran Premio del Veneto', 'Adria International Raceway', '2023-10-22 14:00:00', NULL, NULL);

insert into Campionato_piloti(Posizione, Pilota, Punti) values
(01, 7, 47),
(02, 3, 30),
(03, 47, 25),
(04, 56, 17),
(05, 89, 15),
(06, 21, 9),
(07, 77, 2),
(08, 5, 0),
(09, 12, 0),
(10, 33, 0),
(11, 17, 0),
(12, 9, 0),
(13, 22, 0),
(14, 99, 0),
(15, 58, 0);

insert into Campionato_costruttori(Posizione, Scuderia, Punti) values
(01, 'GTO Racing Team', 49),
(02, 'Oracle Racing Team', 47),
(03, 'Gresini Racing', 34),
(04, 'Arnaldi Racing', 15),
(05, 'RTX GT Team', 0);

insert into Offerta(Scuderia, Pilota, Cifra, Accettata) values
('Gresini Racing', 77, 137000.00, TRUE),
('Oracle Racing Team', 7, 241500.00, FALSE),
('RTX GT Team', 56, 187000.00, FALSE),
('Arnaldi Racing', 21, 176500.00, TRUE),
('Gresini Racing', 3, 167450.00, NULL),
('Arnaldi Racing', 7, 201000.00, FALSE),
('RTX GT Team', 3, 217000.00, NULL),
('Gresini Racing', 7, 198000.00, FALSE),
('GTO Racing Team', 47, 216000.00, NULL);

insert into Albo_d_oro(Anno, Pilota_campione, Scuderia_campione) values
(2012, 'Francesco Todescato', 'Oracle Racing Team'),
(2013, 'Francesco Todescato', 'Oracle Racing Team'),
(2014, 'Davide Ceccato', 'Oracle Racing Team'),
(2015, 'Davide Ceccato', 'GTO Racing Team'), 
(2016, 'Davide Ceccato', 'GTO Racing Team'),
(2017, 'Francesco Todescato', 'Oracle Racing Team'),
(2018, 'Davide Ceccato', 'GTO Racing Team'),
(2019, 'Alberto De Lorenzi', 'Gresini Racing'),
(2020, 'Alberto De Lorenzi', 'Gresini Racing'),
(2021, 'Marco Cecchi', 'Arnaldi Racing'),
(2022, 'Davide Ceccato', 'GTO Racing Team'),
(2023, NULL, NULL);


/*QUERY*/

/* 1) Restituire il nome dei piloti che hanno vinto più di un gran premio
      insieme alla posizione in classifica piloti e la scuderia
      per cui corre*/

select distinct c.Posizione, p.Nome, p.Scuderia
from Pilota p, Campionato_piloti c, Gran_premio g
where c.Pilota = p.Numero and p.Numero = (select Pilota_vincitore 
										  from Gran_premio 
			                              group by Pilota_vincitore
			                              having count(*) > 1)

/* 2) Restituire il modello di auto e il nome del pilota che la guida
      con il ruolo di prima guida eccetto quelli che saranno in retrocessione
      la stagione successiva e che hanno 0 punti in campionato*/ 

select a.Modello, p.Nome
from Auto a, Pilota p, Prima_guida g
where a.Scuderia = p.Scuderia and p.Numero = g.Numero
except
select a.Modello, p.Nome
from Auto a, Pilota p, Prima_guida g, Campionato_piloti c
where a.Scuderia = p.Scuderia and p.Numero = g.Numero
    and g.Retrocessione = TRUE and g.Numero = c.Pilota and c.Punti = 0
	    

/* 3) Per ogni scuderia selezionare il nome del pilota collaudatore, e tra questi
      estrarre solamente quelli che hanno effettuato almeno un test
      sulla vettura ordinati per nome*/

drop view if exists CollaudatoriScuderie;
create view CollaudatoriScuderie(Scuderia, Collaudatore) as
select p.Scuderia, p.Nome
from Pilota p, Collaudatore c
where p.Numero = c.Numero;

select s.Collaudatore, s.Scuderia
from CollaudatoriScuderie s, Collaudatore c, Pilota p
where s.Collaudatore = p.Nome and p.Numero = c.Numero 
    and c.Test_effettuati > 0
order by s.Collaudatore

/* 4) Per ogni scuderia estrarre il codice fiscale del team_principal,
      il Numero del pilota con il ruolo di prima guida e il totale
      dei campionati vinti nell'albo d'oro del campionato. Estrarre solo
      i dati delle scuderie con almeno un titolo e fare il tutto 
      ordinato per numero di titoli vinti*/

drop view if exists ScuderieTitolate;
create view ScuderieTitolate(Scuderia, Campionati) as
select Scuderia_campione, count(*)
from Albo_d_oro
group by Scuderia_campione;

select a.Scuderia, t.CF, p.Numero, a.Campionati
from ScuderieTitolate a, Team_principal t, Pilota p
where a.Scuderia = t.Scuderia and a.Scuderia = p.Scuderia and
    p.Numero in (select Numero from Prima_guida)
order by a.Campionati desc


/* 5) Per ogni Motore che motorizza almeno 2 auto estrarre il totale 
      di auto che esso motorizza e il totale di campionati che le scuderie 
      che utilizzano tale motore hanno vinto*/

drop view if exists AutoPerMotore;
create view AutoPerMotore(Motore, TotAuto) as
select Motore, count(*)
from Auto
group by Motore
having count(*) > 1;

select m.Motore, m.TotAuto, count(a.Scuderia_campione)
from AutoPerMotore m, Albo_d_oro a, Auto b
where m.Motore = b.Motore and b.Scuderia = a.Scuderia_campione
group by m.Motore, m.TotAuto

/* 6) Estrarre il nome, la scuderia e la data di fine ingaggio di ogni pilota che ha ricevuto
almeno un' offerta, insieme al totale di offerte ricevute e alla media in denaro
ad esso offerta (da chi ne ha ricevute di più a chi meno)
*/

select distinct p.Nome, p.Scuderia, p.Fine_ingaggio, count(o.Pilota) as tot_offerte, 
    round(avg(o.Cifra), 2) as media_offerte
from Pilota p, Offerta o, Team_principal t
where p.Numero in (select Pilota from Offerta) and p.Numero = o.Pilota 
group by p.Nome, p.Scuderia, p.Fine_ingaggio, t.Nome
order by count(Pilota) desc


/*INDICI*/

/*indice per la ricerca delle offerte*/
drop index if exists Ricerca_offerta;
create index Ricerca_offerta on Offerta(Scuderia, Pilota, Cifra);

/*indice per la ricerca della posizione in classifica dei piloti*/
drop index if exists Posizione_pilota;
create index Posizione_pilota on Campionato_piloti(Posizione, Pilota, Punti);

/*indice per la ricerca della posizione in classifica delle scuderie*/
drop index if exists Posizione_scuderia;
create index Posizione_scuderia on Campionato_costruttori(Posizione, Scuderia, Punti);
