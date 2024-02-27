#include <cstdio>
#include <iostream>
#include <fstream>
#include "/usr/include/postgresql/libpq-fe.h"

#define PG_HOST "127.0.0.1"
#define PG_USER "gtoso"                      //Change this
#define PG_DB "gtoso"                        //Change this
#define PG_PASS "postgres"                   //Change this
#define PG_PORT 5432                         //Change this


void CheckResult(PGresult* res, const PGconn* conn){
    if(PQresultStatus(res) != PGRES_TUPLES_OK){
        std::cout << "Non e' stato restituito un risultato" << PQerrorMessage(conn) << std::endl;
        PQclear(res);
        exit(1);
    }
}


PGconn* connect(const char* host, const char* user, const char* db, const char* pass, int port) {
    char conninfo[256];
    snprintf(conninfo, 256, "user = %s, password = %s, dbname = %s, hostaddr =%s, port = %d", user, pass, db, host, port);

    PGconn* conn = PQconnectdb(conninfo);

    if (PQstatus(conn) != CONNECTION_OK) {
        std::cout << "Errore di connessione" << std::endl << PQerrorMessage(conn);
        PQfinish(conn);
        exit(1);
    }
    else{
        std::cout << "Connessione riuscita" << std::endl;
    }

    return conn;
}

int main(){
    PGconn* conn = connect(PG_HOST, PG_USER, PG_DB, PG_PASS, PG_PORT);


    std::cout <<"Query 1:"<< std::endl;
    std::cout << "Restituire il nome dei piloti che hanno vinto più di un gran premio insieme alla posizione in classifica piloti e la scuderia per cui corre" << std::endl;
    PGresult* res;
    res = PQexec(conn, "select distinct c.Posizione, p.Nome, p.Scuderia from Pilota p, Campionato_piloti c, Gran_premio g where c.Pilota = p.Numero and p.Numero = (select Pilota_vincitore from Gran_premio group by Pilota_vincitore having count(*) > 1)");
   
    CheckResult(res, conn);
   
    int tuple = PQntuples(res);
    int campi = PQnfields(res);
   
    //stampo intestazioni
    for(int i = 0; i < campi; ++i){
        std::cout << PQfname(res, i) << "\t\t";
    }
    std::cout << std::endl;
   
    //stampo valori selezionati
    for(int i = 0; i < tuple; ++i){
        for(int j = 0; j < campi; ++j){
            std::cout << PQgetvalue(res, i, j) << "\t\t";
        }
        std::cout << std::endl;
    }
    PQclear(res);

    std::cout <<"Query 2:"<< std::endl;
    std::cout <<"Restituire il modello di auto e il nome del pilota che la guida con il ruolo di prima guida eccetto quelli che saranno in retrocessione la stagione successiva e che hanno 0 punti in campionato"<< std::endl;
    
    res = PQexec(conn, "select a.Modello, p.Nome from Auto a, Pilota p, Prima_guida g where a.Scuderia = p.Scuderia and p.Numero = g.Numero except select a.Modello, p.Nome from Auto a, Pilota p, Prima_guida g, Campionato_piloti c where a.Scuderia = p.Scuderia and p.Numero = g.Numero and g.Retrocessione = TRUE and g.Numero = c.Pilota and c.Punti = 0");
    
    CheckResult(res, conn);
    
    tuple = PQntuples(res);
    campi = PQnfields(res);
    
    //stampo intestazioni
    for(int i = 0; i < campi; ++i){
        std::cout << PQfname(res, i) << "\t\t";
    }
    std::cout << std::endl;
   
    //stampo valori selezionati
    for(int i = 0; i < tuple; ++i){
        for(int j = 0; j < campi; ++j){
            std::cout << PQgetvalue(res, i, j) << "\t\t";
        }
        std::cout << std::endl;
    }
    PQclear(res);

    std::cout <<"Query 3:"<< std::endl;
    std::cout <<"Per ogni scuderia selezionare il nome del pilota collaudatore, e tra questi estrarre solamente quelli che hanno effettuato almeno un test sulla vettura ordinati per nome"<< std::endl;
    
    res = PQexec(conn, "drop view if exists CollaudatoriScuderie; create view CollaudatoriScuderie(Scuderia, Collaudatore) as select p.Scuderia, p.Nome from Pilota p, Collaudatore c where p.Numero = c.Numero; select s.Collaudatore, s.Scuderia from CollaudatoriScuderie s, Collaudatore c, Pilota p where s.Collaudatore = p.Nome and p.Numero = c.Numero and c.Test_effettuati > 0 order by s.Collaudatore");
    
    CheckResult(res, conn);
   
    tuple = PQntuples(res);
    campi = PQnfields(res);
    
    //stampo intestazioni
    for(int i = 0; i < campi; ++i){
        std::cout << PQfname(res, i) << "\t\t";
    }
    std::cout << std::endl;
    
    //stampo valori selezionati
    for(int i = 0; i < tuple; ++i){
        for(int j = 0; j < campi; ++j){
            std::cout << PQgetvalue(res, i, j) << "\t\t";
        }
        std::cout << std::endl;
    }
    PQclear(res);

    std::cout <<"Query 4:"<< std::endl;
    std::cout <<"Per ogni scuderia estrarre il codice fiscale del team_principal, il Numero del pilota con il ruolo di prima guida e il totale dei campionati vinti nell'albo d'oro del campionato. Estrarre solo i dati delle scuderie con almeno un titolo e fare il tutto ordinato per numero di titoli vinti"<< std::endl;
    
    res = PQexec(conn, "drop view if exists ScuderieTitolate; create view ScuderieTitolate(Scuderia, Campionati) as select Scuderia_campione, count(*) from Albo_d_oro group by Scuderia_campione; select a.Scuderia, t.CF, p.Numero, a.Campionati from ScuderieTitolate a, Team_principal t, Pilota p where a.Scuderia = t.Scuderia and a.Scuderia = p.Scuderia and p.Numero in (select Numero from Prima_guida) order by a.Campionati desc");
   
    CheckResult(res, conn);
   
    tuple = PQntuples(res);
    campi = PQnfields(res);
    
    //stampo intestazioni
    for(int i = 0; i < campi; ++i){
        std::cout << PQfname(res, i) << "\t\t";
    }
    std::cout << std::endl;
   
    //stampo valori selezionati
    for(int i = 0; i < tuple; ++i){
        for(int j = 0; j < campi; ++j){
            std::cout << PQgetvalue(res, i, j) << "\t\t";
        }
        std::cout << std::endl;
    }
    PQclear(res);

    std::cout <<"Query 5:"<< std::endl;
    std::cout <<"Per ogni Motore che motorizza almeno 2 auto estrarre il totale di auto che esso motorizza e il totale di campionati che le scuderie che utilizzano tale motore hanno vinto"<< std::endl;
    
    res = PQexec(conn, "drop view if exists AutoPerMotore; create view AutoPerMotore(Motore, TotAuto) as select Motore, count(*) from Auto group by Motore having count(*) > 1; select m.Motore, m.TotAuto, count(a.Scuderia_campione) from AutoPerMotore m, Albo_d_oro a, Auto b where m.Motore = b.Motore and b.Scuderia = a.Scuderia_campione group by m.Motore, m.TotAuto");
   
    CheckResult(res, conn);
   
    tuple = PQntuples(res);
    campi = PQnfields(res);
   
    //stampo intestazioni
    for(int i = 0; i < campi; ++i){
        std::cout << PQfname(res, i) << "\t\t";
    }
    std::cout << std::endl;
   
    //stampo valori selezionati
    for(int i = 0; i < tuple; ++i){
        for(int j = 0; j < campi; ++j){
            std::cout << PQgetvalue(res, i, j) << "\t\t";
        }
        std::cout << std::endl;
    }
    PQclear(res);

    std::cout <<"Query 6:"<< std::endl;
    std::cout <<"Estrarre il nome, la scuderia e la data di fine ingaggio di ogni pilota che ha ricevuto almeno un' offerta, insieme al totale di offerte ricevute e alla media in denaro ad esso offerta (da chi ne ha ricevute di più a chi meno)"<< std::endl;
    
    res = PQexec(conn, "select distinct p.Nome, p.Scuderia, p.Fine_ingaggio, count(o.Pilota) as tot_offerte, round(avg(o.Cifra), 2) as media_offerte from Pilota p, Offerta o, Team_principal t where p.Numero in (select Pilota from Offerta) and p.Numero = o.Pilota group by p.Nome, p.Scuderia, p.Fine_ingaggio, t.Nome order by count(Pilota) desc");
   
    CheckResult(res, conn);
   
    tuple = PQntuples(res);
    campi = PQnfields(res);
   
    //stampo intestazioni
    for(int i = 0; i < campi; ++i){
        std::cout << PQfname(res, i) << "\t\t";
    }
    std::cout << std::endl;
   
    //stampo valori selezionati
    for(int i = 0; i < tuple; ++i){
        for(int j = 0; j < campi; ++j){
            std::cout << PQgetvalue(res, i, j) << "\t\t";
        }
        std::cout << std::endl;
    }
    PQclear(res);

    PQfinish(conn);
    return 0;
}