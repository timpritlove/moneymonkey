# moneymoney

Diese "MoneyMoney-Extension" erlaubt es, die Umsätze auf einem oder mehreren -in "MoneyMoney" geführten- Konten direkt in eine Buchhaltungssoftware als vollständige Buchungssätze zu importieren.

Die für die Buchungssätze erforderliche Zuordung von Umsätzen zu Finanz- und Gegenkonten, Steuersätzen und Kostenstellen wird durch die Zuweisung der Umsätze in Kategorien vorgenommen.

Dieses Exportskript wurde für eine Datenübergabe an die Buchhaltungssoftware "MonKey-Office" entwickelt (und ist nur damit getestet worden). Es sollte sich aber im Prinzip auch mit vergleichbaren Buchhaltungsprogrammen vertragen, die einen DATEV-ähnlichen Import und Export von Buchungen ermöglichen.

## Konfiguration des Finanzkontos

Für jedes in "MoneyMoney" geführte Bankkonto muss in der Buchhaltungssoftware ein entsprechendes Konto eingerichtet werden. Dieses  **Finanzkonto** (z.B. 1800) muss in "MoneyMoney" in das Notizfeld der Einstellungen des Bankkontos eingetragen werden:

```
Finanzkonto=1800
```

Das Finanzkonto wird in den exportierten Buchungen automatisch als *Soll-Konto* (bei Einnahmen) bzw. als *Haben-Konto* (bei Ausgaben) eingetragen. 

## Gegenkonto konfigurieren

Zusätzlich zum Finanzkonto muss für jede Buchung ein entsprechendes **Gegenkonto** konfiguriert werden. Dieses ergibt sich aus der in "MoneyMoney" zugewiesenen Kategorie des Umsatzes.

Das Gegenkonto wird direkt an den eigentlichen Namen der Kategorie am Ende des Titels in eckigen Klammern eingetragen:

```
Bürobedarf [6815]
```

Für die Buchungskonten, die über eine *Steuerautomatik* verfügen (wo sich also der Steuersatz automatisch aus dem Buchungskonto ableitet) ist in der Regel keine weitere Angabe erforderlich.

## Steuersatz konfigurieren

Für Buchungskonten ohne Steuerautomatik oder solche mit variablen Steuersätzen kann in der Kategorie auch noch ein **Steuersatz** mit angegeben werden. Dazu muss der Steuersatz in geschweiften Klammern in den Titel geschrieben werden.

```
Reisekosten Mietwagen [6673] {VSt19}
Reisekosten Taxi [6673] {VSt7}
```

Die Bezeichnungen des Steuersatzes müssen dabei den in der Buchhaltungssoftware verwendeten Konten entsprechen (z.B. Kontenrahmen SKR03 oder SKR04), da sie vom Exportskript nur durchgereicht und nicht interpretiert werden.

## Kostenstellen konfigurieren

Zusätzlich zu Gegenkonto und Steuersatz können über Kategorien auch **Kostenstellen** spezifiziert werden. Das erlaubt es, bestimmte Buchungen automatisch einer oder zwei Kostenstellen zuzuweisen.

Die Kostenstellen werden im Kategorie-Titel über das Rautezeichen eingeleitet:

```
Einnahmen Veranstaltungen Verkauf [4400] #1000
Einnahmen Veranstaltungen Tickets [4300] #2000
```

Werden einer Buchung mehr als zwei Kostenstellen zugewiesen führt das zum Abbruch des Exports.

## Vererbung über Kategoriegruppen

"MoneyMoney" erlaubt die Gruppierung von Kategorien durch Kategoriegruppen. Wenn man in "MoneyMoney" mehrere Kategorien für bestimmte Umsätze vergeben möchte, die aber alle über die gleiche oder zumindest nur in Teilen abweichende Buchhaltungs-Konfiguration verfügen, können die gemeinsamen Werte der Kategoriegruppe zugewiesen werden.

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


## Automatischer Abbruch 

Wurde ein zu exportierender Umsatz keiner Kategorie zugeordnet oder ist für eine Kategorie kein Gegenkonto ermittelbar, bricht der Export automatisch ab, damit alle Umsätze berücksichtigt werden und der Export nicht unvollständig ist.

