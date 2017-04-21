--
-- MoneyMoney -> MonkeyOffice Export
--
-- Generischer Exporter für MoneyMoney, um Buchungen für MonKey Office zu erzeugen.
-- 
-- Version 1.0 - Tim Pritlove
--
-- Bugs: derzeit wird der Status eines Umsatzes noch nicht ausgewertet




-- CSV settings.

local encoding     = "UTF-8"
local utf_bom      = false
local separator    = MM.localizeNumber("0.0", 0.0) == "0,0" and ";" or ","
local linebreak    = "\n"
local reverseOrder = false


Exporter{version       = 1.00,
         format        = MM.localizeText("MonkeyOffice import file"),
         fileExtension = "csv",
         reverseOrder  = reverseOrder,
         description   = MM.localizeText("Automatischer Export der Bankkonto-Transaktionen zu MonKey Office")}


-- ========================================================
-- ========================================================
-- ========================================================
-- ========================================================
-- ========================================================



-- Kostenstellen
--
-- Zur freien Verwendung in Buchungssätzen

KS_PROJEKT1             = "1000"
KS_PROJEKT2             = "2000"



-- Hashtag Trigger
--
-- Umsätzen in MoneyMoney können Hashtags per Notizfunktion hinzugefügt
-- werden, die beim Export automatisch in Werte für Buchungsfelder umgesetzt werden.
-- So können z.B. automatisch bestimmte Kostenstellen gesetzt oder
-- Steuersätze für nicht-automatische Konten vergeben werden.

Trigger = {
  ["#PROJEKT1"] = { Kostenstelle2 = KS_PROJEKT1 },
  ["#VST0"]     = { Steuersatz = "-" }
}




Konfiguration = {

  -- Konfiguration: Zuordnung von Bankkonto-Namen zu Steuerkonten
  --
  -- Der in MoneyMoney vergebene Name des Kontos wird hier auf ein Finanzkonto abgebildet,
  -- das in den Buchungen als SollKonto bzw. (bei negativen Beträgen) als HabenKonto verwendet wird.

  Bankkonten = {
    ["Girokonto"]         = "1800",
    ["PayPal"]            = "1810"
    },

  -- Konfiguration: Zuordnung von HabenKonto, Steuersatz und Kostenstellen
  -- Erster Eintrag: Suchkriterien (wenn keine vorhanden: Default)
  -- Zweiter Eintrag: Zu setzende Felder (wenn keine vorhanden: Umsatz nicht exportieren)


  -- Die Beispiele gelten für einen Kontenrahmen SKR_04
  
  Zuordnung = {

    -- Sonderfälle
    {
      { Kategorie = "PayPal Fremdwährung" }, -- PayPal Umbuchungen in anderen Währungen, die da eigentlich nichts verloren haben
      { Exportieren = false }
    },
    {
      { Kategorie = "Einnahmen - Verkauf Anlagevermögen" }, -- Anlagevermögen muss manuell gebucht werden
      { KontoHaben = "8300" }
    },
    {
      { Kategorie = "Ausgaben - Kauf Anlagevermögen" }, -- Anlagevermögen muss manuell gebucht werden
      { KontoHaben = "8300" }
    },
    {
      { Betrag = "0,00" }, -- Nullbuchungen nicht exportieren
      { Exportieren = false }
    },


    --- Zuordnung über die Kategorie


    -- Offene Posten und Kreditoren-/Debitorenzahlungen

    {
      { Kategorie = "Einnahmen - Debitorenzahlungen" },
      { KontoHaben = "8100" }
    },

    -- Offene Posten und Kreditoren-/Debitorenzahlungen

    {
      { Kategorie = "Ausgaben - Kreditorenzahlungen" },
      { KontoHaben = "8200" }
    },

    -- Einnahmen

    {
      { Kategorie = "Einnahmen - Erlöse 19%" },
      { KontoHaben = "4400" } -- Erlöse 19% Ust
    },
    {
      { Kategorie = "Einnahmen - Projekt" },
      { KontoHaben = "4400", Kostenstelle1 = KS_PROJEKT1  }
    },
    {
      { Kategorie = "Einnahmen - Privateinlage" },
      { KontoHaben = "2180" } -- Privateinlage
    },
    {
      { Kategorie = "Einnahmen - Zinsen" },
      { KontoHaben = "7020" } -- Zinsen
    },


    -- AUSGABEN

    {
      { Kategorie = "Ausgaben - Privatentnahme" },
      { KontoHaben = "2100" } -- Privatentnahmen
    },
    {
      { Kategorie = "Ausgaben - Wareneinkauf" },
      { KontoHaben = "5400" } -- Wareneingang 19%
    },
    {
      { Kategorie = "Ausgaben - Kontogebühren" },
      { KontoHaben = "6855" }
    },
    {
      { Kategorie = "Ausgaben - Geschenke 0%" },
      { KontoHaben = "6610", Steuersatz="-" } -- Geschenke abzugsfähig ohne § 37b EStG
    },
    {
      { Kategorie = "Ausgaben - Geschenke 19%" },
      { KontoHaben = "6610", Steuersatz="VSt19"  } -- Geschenke
    },
    {
      { Kategorie = "Ausgaben - Porto" },
      { KontoHaben = "6800" }
    },
    {
      { Kategorie = "Ausgaben - Betriebsausgaben 19%", },
      { KontoHaben = "6300" } -- Sonstige Betriebliche Aufwendungen
    },
    {
      { Kategorie = "Ausgaben - Betriebsausgaben 0%", },
      { KontoHaben = "6300", Steuersatz="-" } -- Sonstige Betriebliche Aufwendungen
    },
    {
      { Kategorie = "Ausgaben - Studio - Miete" },
      { KontoHaben = "6310", Steuersatz = "-" } -- Miete (keine Umsatzsteuer)
    },
    {
      { Kategorie = "Ausgaben - Gas" },
      { KontoHaben = "6325" } -- Gas / Strom
    },
    {
      { Kategorie = "Ausgaben - Strom" },
      { KontoHaben = "6325" } -- Gas / Strom
    },
    {
      { Kategorie = "Ausgaben - Telekommunikation" },
      { KontoHaben = "6805" } -- Telefon
    },
    {
      { Kategorie = "Ausgaben - Bürobedarf",     },
      { KontoHaben = "6815" } -- Bürobedarf
    },
    {
      { Kategorie = "Ausgaben - Weiterbildung" },
      { KontoHaben = "6821" } -- Fortbildungskosten
    },
  
    -- Ausgaben: Reisekosten

    {
      { Kategorie = "Ausgaben - Reisekosten - Flüge" },
      { KontoHaben = "6670" } -- Reisekosten
    },
    {
      { Kategorie = "Ausgaben - Reisekosten - Übernachtung" },
      { KontoHaben = "6680" } -- Übernachtung
    },
    {
      { Kategorie = "Ausgaben - Reisekosten - Taxi / Nahverkehr" },
      { KontoHaben = "6673", Steuersatz = "VSt7" }
    },
    {
      { Kategorie = "Ausgaben - Reisekosten - Mietwagen" },
      { KontoHaben = "6673", Steuersatz = "VSt19" }
    },
    {
      { Kategorie = "Ausgaben - Reisekosten - Bahn" },
      { KontoHaben = "6673", Steuersatz = "VSt19" }
    },

    -- Ausgaben: Versicherungen

    {
      { Kategorie = "Privates - Rentenversicherung" },
      { KontoHaben = "2200" } -- Sonderausgaben beschränkt abzugsfähig
    },
    {
      { Kategorie = "Privates - Krankenversicherung" },
      { KontoHaben = "2200" } -- Sonderausgaben beschränkt abzugsfähig
    },
    {
      { Kategorie = "Privates - Private Versicherungen" },
      { KontoHaben = "2200" } -- Sonderausgaben beschränkt abzugsfähig
    },

    -- Ausgaben: Steuern
    {
      { Kategorie = "Privates - Steuern - Einkommensteuer" },
      { KontoHaben = "2150" } -- Privatsteuern VH
    },
    {
      { Kategorie = "Ausgaben - Steuern - Umsatzsteuer - Umsatzsteuer Vorauszahlung" },
      { KontoHaben = "3820" } -- UST VA - auch für Einnnahmen
    },
    {
      { Kategorie = "Ausgaben - Steuern - Umsatzsteuer - Umsatzsteuer Vorjahr" },
      { KontoHaben = "3841" } -- Umsatzsteuer Vorjahr
    },
    {
      { Kategorie = "Ausgaben - Steuern - Umsatzsteuer - Umsatzsteuer frühere Jahre" },
      { KontoHaben = "3845" } -- Umsatzsteuer frühere Jahre
    },
    {
      { Kategorie = "Ausgaben - Steuern - Umsatzsteuer - Einfuhrumsatzsteuer" },
      { KontoHaben = "1433" } -- Entstandene Einfuhrumsatzsteuer
    },


    -- Ausgaben: Sonstiges

    {
      { Kategorie = "Umbuchungen - Fehlbuchungen" },
      { KontoHaben = "7552" }
    },
    {
      { Kategorie = "Umbuchungen - Geldtransit" },
      { KontoHaben = "1460" }
    },
    {
      { }, -- Default
      { KontoHaben = "8999" } -- Alle anderen Buchungen auf Habenkonto 8999 buchen (CATCHALL)
    }
  }
}






-- Definition der Reihenfolge und Titel der zu exportierenden Felder
-- Key, Titel

Exportdatei = {
 { "Datum",          "Datum" },
 { "Betrag",         "Betrag" },
 { "Waehrung",       "Währung" },
 { "Text",           "Text" },
 { "KontoSoll",      "KontoSoll" },
 { "KontoHaben",     "KontoHaben" },
 { "Steuersatz",     "Steuersatz" },
 { "Kostenstelle1",  "Kostenstelle1" },
 { "Kostenstelle2",  "Kostenstelle2" },
 { "Bemerkung",      "Bemerkung" }
}



--
-- Hilfsfunktionen
--

local function csvField (str)
  -- Helper function for quoting separator character and escaping double quotes.
  if str == nil then
    return ""
  elseif string.find(str, '[' .. separator .. '"]') then
    return '"' .. string.gsub(str, '"', '""') .. '"'
  else
    return str
  end
end

local function concatenate (...)
  local catstring = ""
  for _, str in pairs({...}) do
    catstring = catstring .. ( str or "")
  end
  return catstring
end




--
-- WriteHeader: Erste Zeile der Exportdatei schreiben
--


function WriteHeader (account, startDate, endDate, transactionCount)
  -- Write CSV header.

  local line = ""
  for Position, Eintrag in ipairs(Exportdatei) do
    if Position ~= 1 then
      line = line .. separator
    end
    line = line .. csvField(Eintrag[2])
  end
  assert(io.write(MM.toEncoding(encoding, line .. linebreak, utf_bom)))

end



--
-- WriteTransactions: Jede Buchung in eine Zeile der Exportdatei schreiben
--


function WriteTransactions (account, transactions)
  for _,transaction in ipairs(transactions) do

    -- Trage Umsatzdaten aus der Transaktion in der später zu expotierenden Form zusammen

    local Umsatz = {
      Typ = transaction.bookingText,
      Name = transaction.name or "",
      Kontonummer = transaction.accountNumber or "",
      Bankcode = transaction.bankcode or "", 
      Kategorie = string.gsub(transaction.category, [[\]], " - "),
      Datum = MM.localizeDate(transaction.bookingDate),
      Betrag = MM.localizeNumber("0.00", transaction.amount),
      Notiz = transaction.comment or "",
      Verwendungszweck = transaction.purpose or "",
      Waehrung = transaction.currency or ""
    }


    -- Daten für den zu schreibenden Buchungsdatensatz
    local Buchung = {
      Umsatzart = Umsatz.Typ,
      Exportieren = true,
      Datum = Umsatz.Datum,
      Text = Umsatz.Name .. ": " .. Umsatz.Verwendungszweck .. ((Umsatz.Notiz ~= "") and ( " (" .. Umsatz.Notiz .. ")") or ""),
      KontoSoll = nil,
      KontoHaben = nil,
      Betrag = Umsatz.Betrag,
      Steuersatz = nil,
      Kostenstelle1 = nil,
      Kostenstelle2 = nil,
      BelegNr = "",
      Referenz = "",
      Waehrung = Umsatz.Waehrung,
      Bemerkung = concatenate ("(", Umsatz.Kontonummer, ") [", Umsatz.Kategorie, "] {", Umsatz.Typ, "}" )
    }

    Buchung.KontoSoll = Konfiguration.Bankkonten[account.name]



    -- Buchungsfelder auf Basis der Konfiguration automatisch setzen


    for Index, Eintrag in pairs(Konfiguration.Zuordnung) do
      local Treffer = false

      for Feld, Wert in pairs(Eintrag[1]) do
        if (Umsatz[Feld] == Wert) then
          Treffer = true
        end
      end
      if (Treffer) then
        for Feld, Wert in pairs(Eintrag[2]) do
          Buchung[Feld] = Wert
        end
      end
    end

    -- Buchungsfelder zusätzlich über Hashtags anpassen

    for tag in string.gmatch(transaction.comment, "#%w+") do
       local Match = Trigger[tag]
       if (Match) then
         for Feld, Wert in pairs(Match) do
           Buchung[Feld] = Wert
         end
       end
     end



    if (Buchung.KontoSoll and Buchung.KontoHaben and Buchung.Exportieren) then

      local line = ""
      for Position, Eintrag in ipairs(Exportdatei) do
        if Position ~= 1 then
          line = line .. separator
        end
        line = line .. csvField(Buchung[Eintrag[1]])
      end
      assert(io.write(MM.toEncoding(encoding, line .. linebreak, utf_bom)))


    else
      if (not Buchung.Exportieren) then
        print ("Unvollständig: ", Umsatz.Datum, " ", Umsatz.Betrag, Umsatz.Waehrung, Umsatz.Kategorie, Umsatz.Verwendungszweck, Umsatz.Notiz)
      end
    end
  end
end



function WriteTail (account)
  -- Nothing to do.
end
