# MoneyMonkey

**MoneyMonkey** ist eine Erweiterung (Plugin, Extension) für das Online-Banking-Programm _[MoneyMoney](https://moneymoney-app.com)_ (macOS). Mit **MoneyMonkey** können Umsätze von einem oder mehreren in _MoneyMoney_ geführten Konten direkt in eine Buchhaltungssoftware als vollständige Buchungssätze importiert werden und damit den Buchungsvorgang automatisieren.

Die für die Buchungssätze erforderliche Zuordnung von Umsätzen zu Finanz- und Gegenkonten, Steuersätzen und Kostenstellen wird durch die Zuweisung der Umsätze in Kategorien vorgenommen.

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

Wird für eine Kategorie das Gegenkonto `[0000]` bestimmt, werden die dieser Kategorie zugewiesenen Umsätze automatisch übersprungen, also **NICHT** exportiert.

Diese Funktion sollte nur in Ausnahmefällen gewählt werden (z.B. für Buchungen in Fremdwährungen, wofür sich aber eher die Einstellung einer Währung für das Bankkonto (siehe oben) empfiehlt).

Wenn Buchungen, deren Saldo nicht null ist aus dem Export herausgenommen werden, werden in der Buchhaltung falsche Saldi erzeugt, die dann manuell korrigiert werden müssten.

### Steuersatz konfigurieren

Für die Gegenkonten, die über eine *Steuerautomatik* verfügen (wo sich also der Steuersatz automatisch aus dem Buchungskonto ableitet) ist in der Regel keine Angabe eines Steuersatzes erforderlich.

Für Gegenkonten ohne Steuerautomatik oder solche mit variablen Steuersätzen kann in der Kategorie auch noch ein **Steuersatz** mit angegeben werden. Dazu muss der Steuersatz in geschweiften Klammern in den Titel geschrieben werden.

```
Reisekosten Mietwagen [6673] {VSt19}
Reisekosten Taxi [6673] {VSt7}
```

Die Bezeichnungen des Steuersatzes müssen dabei den in der Buchhaltungssoftware verwendeten Konten entsprechen (z.B. Kontenrahmen SKR03 oder SKR04), da sie vom Exportskript nur durchgereicht und nicht interpretiert werden.

### Kostenstellen konfigurieren

Zusätzlich zu Gegenkonto und Steuersatz können über Kategorien auch **Kostenstellen** spezifiziert werden. Das erlaubt es, bestimmte Buchungen automatisch einer oder zwei Kostenstellen zuzuweisen.

Die Kostenstellen werden im Kategorie-Titel über das Rautezeichen eingeleitet:

```
Einnahmen Veranstaltungen Verkauf [4400] #1000
Einnahmen Veranstaltungen Tickets [4300] #2000
```

Werden einer Buchung mehr als zwei Kostenstellen zugewiesen führt das zum Abbruch des Exports.

### Vererbung über Kategoriegruppen

_MoneyMoney_ erlaubt die Gruppierung von Kategorien durch Kategoriegruppen. Wenn man mehrere Unterkategorien für bestimmte Umsätze unterscheiden möchte, die aber alle über die gleiche oder zumindest nur in Teilen abweichende Buchhaltungs-Konfiguration verfügen, können die gemeinsamen Werte der Kategoriegruppe zugewiesen werden.

Diese Einstellungen werden automatisch an die darunter liegenden Kategorien nach folgenden Regeln vererbt:

* Werden in den Unterkategorien das *Gegenkonto* oder der *Steuersatz* ein weiteres Mal spezifiziert, *überschreiben* diese Werte die Vorgabe der Gruppe.
* Werden in der Unterkategorie *Kostenstellen* spezifiziert, so *ergänzen* diese die vorher benannten Kostenstellen.

Folgende Kategorie-Hierarchie:

* `Reisekosten [6673] {VSt19} #2000`
  * `car2go #2010`
  * `DriveNow #2020`
  * `Flinkster #2030`
  * `Taxi {VSt7} #2040`

ist äquivalent zu

* `car2go [6673] {VSt19} #2000 #2010`
* `DriveNow [6673] {VSt19} #2000 #2020`
* `Flinkster [6673] {VSt19} #2000 #2030`
* `Taxi [6673] {VSt7} #2000 #2040`

aber deutlich übersichtlicher und einfacher zu verwalten.


## MoneyMonkey starten

Wenn nun in _MoneyMoney_ Umsätze ausgewählt werden, kann man im Menü `Konto` den Eintrag `Umsätze exportieren …` auswählen. In der Folge erscheint ein Dialog zur Bestimmung einer Exportdatei. In dem Auswahlmenü unten in diesem Dialog kann man nun den Punkt `Buchungssätze (.csv)` auswählen. Damit wird das Plugin für den Export ausgewählt.

Wenn keine Konfigurationsfehler gefunden werden startet **MoneyMonkey** anschließend den Export in die angegebene Datei.

Das Skript _beendet_ den Export vorzeitig wenn einer der folgenden Fehler detektiert wurde:

* Ein Umsatz wurde keiner Kategorie zugeordnet
* Für eine eingestellte Kategorie ist kein Gegenkonto ermittelbar
* Der Umsatz wurde nicht bestätigt (Kästchen)
* Es wurden einer Kategorie mehr als zwei Kostenstellen zugeordnet

Der Fehler wird entsprechend in einem Dialog angezeigt. In jedem dieser Fälle wird keine Datei erzeugt.

## Import in MonKey Office

Wenn die Exportdatei geschrieben wurde kann sie anschließend über die Funktion "Import & Export -> Textdatei importieren" importiert werden.

###Import konfigurieren

Um die Datei imporieren zu können muss zunächst eine Einstellung dafür angelegt werden. Diese muss mit den folgenden Einstellungen angelegt werden:

* Bereich: **Buchungen**
* Trennzeichen für Felder: **Komma**
* Trennzeichen für Datensätze: **LF**
* Text in Anführungszeichen: **Doppelt "**
* Zeichensatz für: **UTF-8**
* Importieren ab Zeile: *2*
* Steuerautomatik: _abhängig von der Buchhaltungssystematik_
* Einzeilig: **AUS**

Über den Button _Felder zuordnen_ können die Spalten in der Exportdatei den Feldern der Buchhaltung zugeordnet werden. Die Spaltentitel der Exportdatei entsprechen dabei 1:1 den Bezeichnungen in MonKey Office und sollten daher leicht zu finden sein.

## Import starten

Wenn die Einstellungen für den Import vorgenommen wurden kann die Exportdatei importiert werden. Dabei sollte ggf. noch mal überprüft werden, ob die richtigen Spalten gewählt wurden und ob den Buchungen die richtigen Finanz- bzw. Gegenkonten, Steuersätze und Kostenstellen zugeordnet wurden.

Nach dem Import sind die Buchungen sofort gültig und müssen nicht noch einmal bestätigt werden.
