# MoneyMonkey v1.6

**MoneyMonkey** ist eine Erweiterung (Plugin, Extension) für das Online-Banking-Programm _[MoneyMoney](https://moneymoney-app.com)_ (macOS). Mit **MoneyMonkey** können Umsätze von einem oder mehreren in _MoneyMoney_ geführten Konten direkt in eine Buchhaltungssoftware als vollständige Buchungssätze importiert werden und damit den Buchungsvorgang automatisieren.

Die für die Buchungssätze erforderliche Zuordnung von Umsätzen zu Finanz- und Gegenkonten, Steuersätzen und Kostenstellen wird durch die Zuweisung der Umsätze in Kategorien bzw. durch Anmerkungen in den Kommentarfeldern der Umsätze vorgenommen.

## MonKey Office

Dieses Exportskript wurde für eine automatisierte Datenübergabe an die Buchhaltungssoftware _[MonKey Office](http://www.monkey-office.de/products/monkeyoffice/index.html)_ entwickelt (und ist bisher nur damit getestet worden). Es sollte sich aber im Prinzip auch mit vergleichbaren Buchhaltungsprogrammen vertragen, die einen DATEV-ähnlichen Import von Buchungen ermöglichen.

Mit **MoneyMonkey** ist es möglich, eine Online-Banking-gestützte Buchhaltung weitgehend automatisiert zu unterhalten, erfordert aber nach wie vor Kenntnisse in der Buchhaltungssoftware, um die Ergebnisse zu prüfen und ggf. noch weitere Umbuchungen vorzunehmen.

**MoneyMonkey** ersetzt dafür die lästigen Wege über die nervige Bankauszug-Funktion von _MonKey Office_ und ist besonders effizient, wenn viele wiederkehrende Buchungstypen vorliegen, da diese dann in _MoneyMoney_ oft [automatisch bestimmten Buchungskategorien zugeordnet werden können]( https://moneymoney-app.com/categorization/ ).

## Installation

Starte _MoneyMoney_ und wähle aus dem Menü `Hilfe` den Eintrag `Zeige Datenbank im Finder`. Im Finder öffnet sich dann der _MoneyMoney_-Ordner, der die Datenbank, die Kontoauszüge und die Erweiterungen anzeigen.

Kopiere die Datei `MoneyMonkey.lua` in den Ordner `Extensions`. Das war's.

## Konfiguration

Bevor der Export der Buchungen durchgeführt werden kann, müssen innerhalb von _MoneyMoney_ die Bankkonten mit Informationen angereichert und Kategorien eingerichtet werden.

### Konfiguration der Bankkonten

Für jedes in _MoneyMoney_ geführte Bankkonto muss in der Buchhaltungssoftware ein entsprechendes Konto eingerichtet sein.

Dieses  **Finanzkonto**  (z.B. _1800_ für ein Girokonto im Kontenrahmen SKR 04) muss in _MoneyMoney_ in die _benutzerdefinierten Felder_ jedes Bankkontos eingetragen werden, das später exportiert werden soll.

1. Konto in der Seitenleiste auswählen
2. Aus dem Kontextmenü den Eintrag `Einstellungen …` auswählen (oder `CMD-I` drücken)
3. In der Seitenleiste des Einstellungen-Fensters den Bereich `Notizen` auswählen
4. In der Tabelle _Benutzerdefinierte Felder_ in der Spalte _Attribut_ `Finanzkonto` und für _Wert_ das entsprechende Konto aus der Buchhaltung eintragen, das dieses Bankkonto repräsentiert (z.B. `1800`)
5. Dialog mit OK beenden

_Anmerkung:_ Benutzerdefinierte Felder stehen in _MoneyMoney_ seit Version 2.3.0 bereit. In Vorgängerversionen mussten die Felder mit einer `Attribut=Wert` Notation direkt in das Notizfeld eingetragen werden. Das wird immer noch unterstützt, es sollte aber auf das neue Modell umgestiegen werden.

Das Finanzkonto wird in den exportierten Buchungen automatisch als *Soll-Konto* (bei Einnahmen) bzw. als *Haben-Konto* (bei Ausgaben) eingetragen.

#### Währung für Bankkonto spezifizieren

Zusätzlich zum Finanzkonto kann für das Bankkonto optional auch noch die Währung gesetzt werden. Dazu muss entsprechend die Spalte _Attribut_ auf `Waehrung` und die Spalte _Wert_ auf das entsprechende Währungskennzeichen  (z.B. auf `EUR`).

Wenn **MoneyMonkey** die Währung des Kontos kennt, so werden Buchungen in einer anderen Währung automatisch übersprungen. Das ist z.B. bei PayPal-Konten hilfreich, da _MoneyMoney_ diese Buchungen selbst nicht trennt und gemeinsam exportiert. Würden diese Buchungen übernommen, würde der Saldo nicht stimmen.

### Kategorien einrichten

Zusätzlich zum Finanzkonto muss für jede Buchung ein entsprechendes **Gegenkonto** konfiguriert werden. Dieses ergibt sich aus der in _MoneyMoney_ zugewiesenen _Kategorie_ des Umsatzes.

Das Gegenkonto wird direkt an den eigentlichen Namen der Kategorie am Ende des Titels in eckigen Klammern eingetragen (z.B. `Bürobedarf [6815]`).

Um den Namen einer Kategorie zu ändern, wählt man die Kategorie in der Seitenleiste aus und wählt aus dem Kontextmenü den Eintrag `Einstellungen …` (oder CMD-I drücken).

#### Umsätze überspringen

Umsätze, deren Betrag 0,00 ist, werden generell  **NICHT** exportiert.

Wird für eine Kategorie das Gegenkonto `[0000]` bestimmt, werden die dieser Kategorie zugewiesenen Umsätze automatisch übersprungen, also **NICHT** exportiert. Diese Funktion sollte nur in Ausnahmefällen gewählt werden (z.B. für Buchungen in Fremdwährungen, wofür sich aber eher die Einstellung einer Währung für das Bankkonto (siehe oben) empfiehlt).

_Hinweis_: Wenn Buchungen, deren Saldo nicht null ist, aus dem Export herausgenommen werden, werden in der Buchhaltung falsche Saldi erzeugt, die dann manuell korrigiert werden müssten.

### Steuersatz konfigurieren

Für die Gegenkonten, die über eine *Steuerautomatik* verfügen (wo sich also der Steuersatz automatisch aus dem Buchungskonto ableitet) ist in der Regel keine Angabe eines Steuersatzes erforderlich.

Für Gegenkonten ohne Steuerautomatik oder solche mit variablen Steuersätzen kann in der Kategorie auch noch ein **Steuersatz** mit angegeben werden. Dazu muss der Steuersatz in geschweiften Klammern in den Titel geschrieben werden.

```
Reisekosten Mietwagen [6673] {VSt19}
Reisekosten Taxi [6673] {VSt7}
Betriebsausgaben 0% [6300] {-}
```

Die Bezeichnungen des Steuersatzes müssen dabei den in der Buchhaltungssoftware verwendeten Konten entsprechen (z.B. Kontenrahmen SKR03 oder SKR04), da sie vom Exportskript nur durchgereicht und nicht interpretiert werden.

#### Abweichenden Steuersatz pro Umsatz einstellen

Wenn man nur für einen oder wenige Umsätze einen abweichenden Steuersatz angeben möchte, lohnt sich Anlegen einer Kategorie dafür oft nicht und die Liste der Kategorien würde nur unnötig aufgebläht und entsprechend unübersichtlich werden. Daher kann man für diese Ausnahmen den Steuersatz auch direkt im Notizfeld eines Umsatzes angeben.

Dazu wählt man den Menüeintrag `Konto -> Notiz hinzufügen...` (bzw. aus dem Kontextmenü) aus und trägt einen entsprechenden Text ein, der den gewünschten Steuersatz wie oben beschrieben angibt.

### Kostenstellen konfigurieren

Zusätzlich zu Gegenkonto und Steuersatz können über Kategorien auch **Kostenstellen** spezifiziert werden. Das erlaubt es, bestimmte Buchungen automatisch einer oder zwei Kostenstellen zuzuweisen.

Die Kostenstellen werden im Kategorie-Titel über das Rautezeichen eingeleitet:

```
Einnahmen Veranstaltungen Verkauf [4400] #EVENT
Einnahmen Veranstaltungen Tickets [4300] #EVENT
```

Werden einer Buchung mehr als zwei unterschiedliche Kostenstellen zugewiesen führt das zum Abbruch des Exports.

_Hinweis:_ *MonKey Office* erlaubt es, Kostenstellen mit beliebigen Zeichen (einschließlich Leerzeichen) zu benennen. *MoneyMonkey* unterstützt aus Gründen der Übersichtlichkeit und als Analogie zu Hashtags nur alphanumerische Bezeichner (Groß- und Kleinbuchstaben und Ziffern) zzgl. des Unterstrichs ("_") aber keine Leerzeichen).



#### Kostenstellen pro Umsatz einstellen

Wie schon beim Steuersatz können auch die Kostenstellen pro Umsatz angegeben werden, in dem sie in das Notizfeld des Umsatzes eingetragen werden (`Konto -> Notiz hinzufügen...`). So können auch Einzelumsätze unabhängig von Ihrer Kategorie z.B. einzelnen Projekten zugewiesen und später in *MonKey Office* ausgewertet werden.


### Vererbung über Kategoriegruppen

_MoneyMoney_ erlaubt die Gruppierung von Kategorien durch Kategoriegruppen. Wenn man mehrere Unterkategorien für bestimmte Umsätze unterscheiden möchte, die aber alle über die gleiche oder zumindest nur in Teilen abweichende Buchhaltungs-Konfiguration verfügen, können die gemeinsamen Werte der Kategoriegruppe zugewiesen werden.

Diese Einstellungen werden automatisch an die darunter liegenden Kategorien nach folgenden Regeln vererbt:

* Werden in den Unterkategorien das *Gegenkonto* oder der *Steuersatz* ein weiteres Mal spezifiziert, *überschreiben* diese Werte die Vorgabe der Gruppe.
* Werden in der Unterkategorie *Kostenstellen* spezifiziert, so *ergänzen* diese die vorher benannten Kostenstellen.

Folgende Kategorie-Hierarchie:

* `Reisekosten [6673] {VSt19} #REISE`
  * `car2go #CAR2GO`
  * `DriveNow #DRIVENOW`
  * `Flinkster #FLINKSTER`
  * `Taxi {VSt7} #TAXI`

ist äquivalent zu

* `car2go [6673] {VSt19} #REISE #CAR2GO`
* `DriveNow [6673] {VSt19} #REISE #DRIVENOW`
* `Flinkster [6673] {VSt19} #REISE #FLINKSTER`
* `Taxi [6673] {VSt7} #REISE #TAXI`

ist aber deutlich übersichtlicher und einfacher zu verwalten.

Wie schon bei einer einzelnen Buchung gilt: werden einer Buchung durch Vererbung mehr als zwei unterschiedliche Kostenstellen zugewiesen führt das zum Abbruch des Exports.


## MoneyMonkey starten

Wenn nun in _MoneyMoney_ Umsätze ausgewählt werden, kann man im Menü `Konto` den Eintrag `Umsätze exportieren …` auswählen. In der Folge erscheint ein Dialog zur Bestimmung einer Exportdatei. In dem Auswahlmenü unten in diesem Dialog kann man nun den Punkt `MoneyMonkey (.csv)` auswählen. Damit wird das Plugin für den Export ausgewählt.

Wurde das Plugin ausgewählt, erscheint darunter noch eine Option `Umsätze müssen als erledigt markiert sein`. Ist diese Option gesetzt, muss bei allen zu exportierenden Umsätzen in _MoneyMoney_ das Markierungsfeld hinter dem Umsatz ausgewählt sein. Fehlt dieses bei einem Umsatz bricht der Export mit einer entsprechenden Fehlermeldung ab. Mit dieser Option kann man sicherstellen, dass jeder Umsatz bevor er in die Buchhaltung übernommen wird eine explizite Prüfung erfahren hat (Plausibilität, korrekte Kategoriezuordnung, Beleg vorhanden etc.). Wenn man auf eine solche Prüfung verzichten möchte oder zu Testzwecken einen Export vornehmen will kann man diese Option auch ausschalten, sie ist aber empfohlen.

Eine zweite Option heißt "Nur Umsätze mit gültigem Buchungskonto exportieren". Wenn diese Option gesetzt ist, werden nur Umsätze exportiert, die einem gültigen Buchungskonto zugeordnet sind. Diese Option ist empfohlen, da sonst auch Umsätze exportiert werden, die keinem gültigen Buchungskonto zugeordnet sind.

Wenn keine Konfigurationsfehler gefunden werden startet **MoneyMonkey** anschließend den Export der ausgewählten Umsätze in die angegebene Datei.

Ein Umsatz wird _nicht_ exportiert wenn eine der folgenden Bedingungen erfüllt ist

* Der Umsatz wurde dem Gegenkonto [0000] zugeordnet
* Im Bankkonto eines Umsatzes wurde eine Währung konfiguriert und der Umsatz hat eine andere Währung als die dort eingestellte

Das Skript _beendet_ den Export vorzeitig wenn einer der folgenden Fehler detektiert wurde:

* Ein Umsatz wurde keiner Kategorie zugeordnet
* Für das Bankkonto eines Umsatzes wurde kein Finanzkonto konfiguriert
* Für eine eingestellte Kategorie ist kein Gegenkonto ermittelbar
* Der Umsatz wurde nicht bestätigt (Markierungsfeld gesetzt - nur wenn die Option gesetzt wurde, s.o.)
* Es wurden einer Kategorie mehr als zwei Kostenstellen zugeordnet

Der Fehler wird entsprechend in einem Dialog angezeigt. In jedem dieser Fälle wird keine Datei erzeugt.


## Format der Exportdatei

Die Exportdatei ist eine klassische CSV-Datei mit den Spalten "Buchungskonto", "Gegenkonto", "Betrag", "Währung", "Steuersatz", "Kostenstellen", "Notiz". Die Felder sind durch Kommas getrennt, wenn Werte Leerzeichen oder Kommas enthalten, werden diese in Anführungszeichen gesetzt. Diese Datei sollte sich mit jeder CSV-kompatiblen Software öffnen lassen.

Das Feld "Text" enthält den Buchungstext, der sich aus dem Verwendungszweck und der manuellen Notiz des Umsatzes zusammensetzt (die man in MoneyMoney in den Kommentar des Umsatzes via CMD-Shift-K eintragen kann).

Das Feld "Notiz" enthält weitere Metadaten, die für die Buchhaltung relevant sein die der Banktransaktion entnommen werden können. Bei SEPA-Überweisungen werden z.B. von manchen Bankendie Felder "Umsatzart", "Mandatsreferenz", "Kreditor-ID" und "End-To-End-Reference" ausgefüllt. Sind diese Felder enthalten schreibt MoneyMoney diese in einem "Feld=Wert" Format und durch Semikolon getrennt in das Feld "Notiz", so dass man diese ggf. auch noch automatisiert übernehmen kann.

## Import in MonKey Office

Wenn die Exportdatei geschrieben wurde kann sie anschließend über die Funktion "Import & Export -> Textdatei importieren" importiert werden.

###Import konfigurieren

Um die Datei imporieren zu können muss zunächst eine Einstellung dafür angelegt werden. Diese muss mit den folgenden Einstellungen angelegt werden:

* Bereich: `Buchungen`
* Trennzeichen für Felder: `Komma`
* Trennzeichen für Datensätze: `LF`
* Text in Anführungszeichen: `Doppelt "`
* Zeichensatz für: `UTF-8`
* Importieren ab Zeile: `2`
* Steuerautomatik: _abhängig von der Buchhaltungssystematik_
* Einzeilig: **AUS**

Bevor es losgehen kann müssen noch die Felder aus der MoneyMonkey-Exportdatei den Feldern der Buchhaltung zugeordnet werden. Das kann halbautomatisch erfolgen, da die Spaltentitel der Exportdatei dabei 1:1 den Bezeichnungen in MonKey Office entsprechen. Dazu folgende Schritte vornehmen:

1. Über den Button _Datei_ eine MoneyMonkey-Exportdatei ausgewählen
2. Die Einstellung _Importieren ab Zeile_ vorübergehend auf den Wert `1` setzen
3. Den Button _Felder zuordnen_ klicken. Damit sollten alle Spalten in der Exportdatei den Feldern der Buchhaltung zugeordnet werden. Zur Sicherheit noch mal drüber schauen, ob alles geklappt hat, sonst manuell zuordnen.
4. Die Einstellung _Importieren ab Zeile_ wieder auf den Wert `2` setzen

Damit kann die Import-Einstellung verwendet werden. Neben dem Button `Datei` wird nun noch der Name der zuvor ausgewählten Datei angezeigt und darunter unter `Ordner` der Ordner, in dem sich diese Datei befand. Wenn beide Felder so belassen werden, wird beim Aktivieren der Einstellung automatisch auf genau diese Datei zugegriffen. Wenn man den Eintrag bei `Datei` löscht, erscheint beim Aktivieren des Imports automatisch ein Dateiauswahlfenster (voreingestellt auf den eingestellten Ordner). Darüber kann man sich beim Import entweder Zeit sparen oder auch sicherstellen, dass man explizit eine bestimmte Datei (oder einen bestimmten Ordner) manuell auswählen muss.


### Import starten

Wenn die Einstellungen für den Import vorgenommen wurden kann die Exportdatei importiert werden. Dabei sollte ggf. noch mal überprüft werden, ob die richtigen Spalten gewählt wurden und ob den Buchungen die richtigen Finanz- bzw. Gegenkonten, Steuersätze und Kostenstellen zugeordnet wurden.

Nach dem Import sind die Buchungen sofort gültig und müssen nicht noch einmal bestätigt werden. Damit lassen sich auch große Zahlen an Umsätzen schnell in Buchungen überführen.

Vorsicht: In der Importdatei angegebene Kostenstellen werden von **MonKey Office** automatisch angelegt (und sollten dann später in `Vorgaben -> Kostenstellen` noch entsprechend benannt werden).

### Empfohlener Workflow

Wie oft und mit welcher Granularität importiert werden soll hängt stark vom Bedarf ab. Üblicherweise sollte man mindestens monatlich die Daten von **MoneyMoney** in **MonKey Office** überführen allein schon um sicherzustellen, dass man bei der Vergabe der Kategorien und/oder Kostenstellen keine Fehler gemacht hat. Typische Fehlbuchungen lassen sich zumeist mit `Buchhaltung -> Summen und Salden` bzw. dem `Buchhaltung -> Kontoauszug` gut erkennen und entsprechende Fehler aufspüren.

Der Name der jeweils gewählten Exportdatei ist in den exportierten Umsätze jeweils im Feld "BelegNr" abgelegt. Damit lassen sich Umsätze aus einem bestimmten Exportvorgang problemlos über den Buchungsfilter wiederfinden und bei Bedarf auch löschen, so dass ein Import auch wiederholt werden kann, ohne die sonstigen Buchungen zu beeinflussen.



