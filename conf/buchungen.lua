-- Buchungen Export: Konfiguration

-- Kostenstellen
-- Anlegen von Namen für Kostenstellen


Kostenstellen = {
  PROJEKT1    = "1000",
  PROJEKT2    = "2000",
}

Konfiguration = {

  -- Konfiguration: Zuordnung von Bankkonto-Namen zu Finanzkonten
  
  Bankkonten = {
    ["Girokonto"]         = "1800",
    ["PayPal"]            = "1810"
    },


  -- Konfiguration: Zuordnung von Gegenkonto, Steuersatz und Kostenstellen
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
  },

  
  -- Hashtags

  Tags = {
    ["#PROJEKT1"] = { Kostenstelle2 = KS.PROJEKT1 },
    ["#VST0"]     = { Steuersatz = "-" }
  }


}

