--
-- Export von MoneyMoney Umsätzen zu direkt importierbaren Steuer-Buchungssätzen.
--
-- Dieses Skript ist getestet mit MonKey Office, sollte aber im Prinzip auch mit allen
-- anderen Buchhaltungsprogrammen funktionieren, die Buchungssätze als CSV-Datei
-- direkt importieren können (was vermutlich nahezu alle sind).
--
-- Das Skript liest eine zweite Lua-Datei ein, in der sich die eigentliche Konfiguration
-- befindet. Diese muss an die eigenen Bedürfnisse und Verhältnisse angepasst werden.
--
-- Die Konfiguration sorgt im wesentlichen dafür, dass den verwendeten Bankkonten in
-- MoneyMoney Finanzkonten und den Umsätzen selbst (z.B. auf Basis der in MoneyMoney zugewiesenen
-- Kategorien) entsprechende Gegenkonten zugewiesen werden. Können für einen Umsatz
-- ein Finanzkonto und ein Gegenkonto ermittelt werden, wird der Umsatz exportiert.
--
-- TODO:
--
-- * Abbuchungen (negative Beträge) sollten bereits im Export zum Vertauschen
--   von Finanzkonto und Gegenkonto führen und den Betrag das Minuszeichen entziehen

--


-- CSV Dateieinstellungen

local encoding     = "UTF-8"
local utf_bom      = false
local separator    = MM.localizeNumber("0.0", 0.0) == "0,0" and ";" or ","
local linebreak    = "\n"
local reverseOrder = false

-- Exportformat bei MoneyMoney anmelden

Exporter{version       = 1.00,
         format        = MM.localizeText("GDPdU Buchungssätze"),
         fileExtension = "csv",
         reverseOrder  = reverseOrder,
         description   = MM.localizeText("Export von MoneyMoney Umsätzen zu direkt importierbaren Steuer-Buchungssätzen.")}


-- Zugriffsklasse für Kostenstelle einrichten.
-- Zugriff auf nicht definierte Kostenstellen führen zum Abbruch des Exports.


KS = setmetatable ({},
  {
    __index = function(_, key)
      local ks = Kostenstellen[key]
      if ks then
        return ks
      end

      error("Kostenstelle " .. key .. " nicht definiert.")
    end
  }
)

-- Konfiguration einlesen

require("conf/buchungen")


-- Definition der Reihenfolge und Titel der zu exportierenden Buchungsfelder
-- Format: Key (Internes Feld), Titel (in der ersten Zeile der CSV-Datei)

Exportdatei = {
 { "Datum",          "Datum" },
 { "Betrag",         "Betrag" },
 { "Waehrung",       "Währung" },
 { "Text",           "Text" },
 { "Finanzkonto",    "KontoSoll" },
 { "Gegenkonto",     "KontoHaben" },
 { "Steuersatz",     "Steuersatz" },
 { "Kostenstelle1",  "Kostenstelle1" },
 { "Kostenstelle2",  "Kostenstelle2" },
 { "Bemerkung",      "Bemerkung" }
}



--
-- Hilfsfunktionen zur String-Behandlung
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
      Finanzkonto = nil,
      Gegenkonto = nil,
      Betrag = Umsatz.Betrag,
      Steuersatz = nil,
      Kostenstelle1 = nil,
      Kostenstelle2 = nil,
      BelegNr = "",
      Referenz = "",
      Waehrung = Umsatz.Waehrung,
      Bemerkung = concatenate ("(", Umsatz.Kontonummer, ") [", Umsatz.Kategorie, "] {", Umsatz.Typ, "}" )
    }


    -- Finanzkonto für verwendetes Bankkonto ermitteln

    if ( account.comment == "" ) then
      -- Zuweisung des Finanzkontos aus der Konfiguration auf Basis des Kontonamens
      Umsatz.Finanzkonto = Konfiguration.Bankkonten[account.name]
    else
      -- Zuweisung des Finanzkontos aus Notizfeld des MoneyMoney Kontos
      Umsatz.Finanzkonto = account.comment
    end

    if ( Umsatz.Finanzkonto == "" ) then
      error ( "Kein Finanzkonto für " .. account.name .. " gesetzt" )
    end



    -- Buchungsfelder auf Basis der Zuordnung automatisch setzen

    for Index, Eintrag in pairs(Konfiguration.Zuordnung) do
      local ErsterEintrag = true
      local Treffer = false

      -- Alle Kriterien im müssen erfüllt sein, damit Buchungsfelder gesetzt werden können

      for Feld, Wert in pairs(Eintrag[1]) do
        if ErsterEintrag then
          ErsterEintrag = false
          Treffer = (Umsatz[Feld] == Wert)
        else
          Treffer = (Treffer and (Umsatz[Feld] == Wert) )
        end
      end


      -- Wenn alle Umsatz-Kriterien stimmen, setze alle eingestellten Buchungsfelder

      if (Treffer) then
        for Feld, Wert in pairs(Eintrag[2]) do
          Buchung[Feld] = Wert
        end
        break -- keine weiteren Vergleiche durchführen
      end
    end


    -- Suche nach Tags in den Umsatznotizen und setze die entsprechenden Buchungsfelder

    for tag in string.gmatch(transaction.comment, "#%w+") do
      local Match = Konfiguration.Tags[tag]
      if (Match) then
        for Feld, Wert in pairs(Match) do
          Buchung[Feld] = Wert
        end
      end
    end


    -- Export der Buchung vorbereiten

    Buchung.Finanzkonto = Umsatz.Finanzkonto

    if (Buchung.Finanzkonto and Buchung.Gegenkonto and Buchung.Exportieren) then

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
