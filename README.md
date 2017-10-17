# MoneyMonkey

**MoneyMonkey** ist eine Erweiterung (Plugin, Extension) für das Programm _MoneyMoney_ (macOS). Mit _MoneyMonkey_ können Umsätze auf einem oder mehreren in _MoneyMoney_ geführten Konten direkt in eine Buchhaltungssoftware als vollständige Buchungssätze zu importieren.

Die für die Buchungssätze erforderliche Zuordnung von Umsätzen zu Finanz- und Gegenkonten, Steuersätzen und Kostenstellen wird durch die Zuweisung der Umsätze in Kategorien vorgenommen.

## MonKey Office

Dieses Exportskript wurde für eine automatisierte Datenübergabe an die Buchhaltungssoftware _MonKey Office_ entwickelt (und ist nur damit getestet worden). Es sollte sich aber im Prinzip auch mit vergleichbaren Buchhaltungsprogrammen vertragen, die einen DATEV-ähnlichen Import und Export von Buchungen ermöglichen.

Mit **MoneyMonkey** ist es möglich, eine Online-Banking-gestützte Buchhaltung weitgehend automatisiert zu unterhalteb, erfordert aber nach wie vor Kenntnisse in der Buchhaltungssoftware.

**MoneyMonkey** ersetzt dafür die lästigen Wege über die nervige Bankauzug-Funktion von _MonKey Office_ und ist besonders effizient, wenn viele wiederkehrende Buchungstypen vorliegen, da diese dann in _MoneyMoney_ meist automatisch bestimmten Buchungskategorien zugeordnet werden können.

## Installation der Erweiterung

Starte _MoneyMoney_ und wähle aus dem Menü `Hilfe` den Eintrag `Zeige Datenbank im Finder`. Im Finder öffnet sich dann der _MoneyMoney_-Ordner, der die Datenbank, die Kontoauszüge und die Erweiterungen anzeigen.

Kopiere die Datei `MoneyMonkey.lua` in den Ordner "Extensions". Das war's.

## Konfiguration

### Konfiguration des Finanzkontos

Für jedes in _MoneyMoney_ geführte Bankkonto muss in der Buchhaltungssoftware ein entsprechendes Konto eingerichtet werden.

Dieses  **Finanzkonto** (z.B. 1800) muss in _MoneyMoney_ in die Attribute des Bankkontos eingetragen werden.

1. Konto in der Seitenleiste auswählen
2. Aus dem Kontextmenü den Eintrag "Einstellungen …" auswählen (oder CMD-I)
3. In der Seitenleiste des Einstellungen-Fensters den Bereich "Notizen" auswählen
4. In der Tabelle "Benutzerdefinierte Felder" für `Attribut` "Finanzkonto" und für `Wert` das entsprechende Konto aus der Buchhaltung eintragen, das dieses Bankkonto repräsentiert (z.B. 1800 für ein Girokonto im Kontenrahmen SKR 04)
5. Dialog mit OK beenden

Hinweis: Benutzerdefinierte Felder stehen in _MoneyMoney_ seit Version 2.3.0 bereit. In Vorgängerversionen mussten die Felder mit einer `Attribut=Wert` Notation direkt in das Notizfeld eingetragen werden. Das wird immer noch unterstützt, es sollte aber auf das neue Modell umgestiegen werden.

Das Finanzkonto wird in den exportierten Buchungen automatisch als *Soll-Konto* (bei Einnahmen) bzw. als *Haben-Konto* (bei Ausgaben) eingetragen.

#### Währung spezifizieren

Zusätzlich zum Finanzkonto kann für das Bankkonto auch noch die Währung gesetzt werden. Dazu muss entsprechend das Attribut `Waehrung` gesetzt werden (z.B. auf _EUR_).

Wenn **MoneyMonkey** die Währung des Kontos kennt, so werden Buchungen in einer anderen Währung automatisch übersprungen. Das ist z.B. bei PayPal-Konten hilfreich, da _MoneyMoney_ diese Buchungen selbst nicht trennt und gemeinsam exportiert. Würden diese Buchungen übernommen, würde der Saldo nicht stimmen.

### Gegenkonto konfigurieren

Zusätzlich zum Finanzkonto muss für jede Buchung ein entsprechendes **Gegenkonto** konfiguriert werden. Dieses ergibt sich aus der in _MoneyMoney_ zugewiesenen _Kategorie_ des Umsatzes.

Das Gegenkonto wird direkt an den eigentlichen Namen der Kategorie am Ende des Titels in eckigen Klammern eingetragen (z.B. `Bürobedarf [6815]`).

Um den Namen einer Kategorie zu ändern, wählt man die Kategorie in der Seitenleiste aus und wählt aus dem Kontextmenü den Eintrag `Einstellungen …` (oder CMD-I).

#### Umsätze überspringen

Wird für eine Kategorie das Gegenkonto `[0000]` ausgewählt, werden die dieser Kategorie zugewiesenen Umsätze automatisch **NICHT** exportiert.

Diese Funktion sollte nur in Ausnahmefällen gewählt werden (z.B. für Buchungen in Fremdwährungen, wofür sich aber eher die Einstellung einer Währung für das Bankkonto (siehe oben) empfiehlt).

### Steuersatz konfigurieren

Für die Buchungskonten, die über eine *Steuerautomatik* verfügen (wo sich also der Steuersatz automatisch aus dem Buchungskonto ableitet) ist in der Regel keine  Angabe eines Steuersatzes erforderlich.

Für Buchungskonten ohne Steuerautomatik oder solche mit variablen Steuersätzen kann in der Kategorie auch noch ein **Steuersatz** mit angegeben werden. Dazu muss der Steuersatz in geschweiften Klammern in den Titel geschrieben werden.

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

_MoneyMoney_ erlaubt die Gruppierung von Kategorien durch Kategoriegruppen. Wenn man in _MoneyMoney_ mehrere Kategorien für bestimmte Umsätze vergeben möchte, die aber alle über die gleiche oder zumindest nur in Teilen abweichende Buchhaltungs-Konfiguration verfügen, können die gemeinsamen Werte der Kategoriegruppe zugewiesen werden.

Diese Konfigurationswerte werden automatisch an die darunter liegenden Kategorien vererbt. Werden in den Unterkategorien das *Gegenkonto* oder der *Steuersatz* ein weiteres Mal spezifiziert, *überschreiben* diese Werte die Vorgabe der Gruppe. Werden in der Unterkategorie *Kostenstellen* spezifiziert, so *ergänzen* diese die vorher benannten Kostenstellen.

Folgende Hierarchie:

```
Reisekosten [6673] {VSt19} #2000
-- car2go #2010
-- DriveNow #2020
-- Flinkster #2030
-- Taxi {VSt7} #2040
```

ist äquivalent zu

```
car2go [6673] {VSt19} #2000 #2010
DriveNow [6673] {VSt19} #2000 #2020
Flinkster [6673] {VSt19} #2000 #2030
Taxi [6673] {VSt7} #2000 #2040
```

aber deutlich übersichtlicher und einfacher zu verwalten.


## MoneyMonkey starten

Wenn nun Umsätze angezeigt werden, kann man im Menü `Konto` den Eintrag `Umsätze exportieren …` auswählen. In der Folge erscheint ein Dialog zur Bestimmung einer Exportdatei. In dem Auswahlmenü unten in diesem Dialog kann man nun den Punkt `Buchungssätze (.csv)` auswählen. Damit wird das Plugin für den Export ausgewählt.

Wenn keine Konfigurationsfehler gefunden werden startet **MoneyMonkey** anschließend den Export in die angegebene Datei.

Das Skript beendet den Export vorzeitig wenn einer der folgenden Fehler detektiert wurde:

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
