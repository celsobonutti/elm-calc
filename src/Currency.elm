module Currency exposing (..)

type Currency
    = USD
    | BRL

toString : Currency -> String
toString currency = case currency of
    USD -> "USD"
    BRL -> "BRL"

possibilities : List Currency
possibilities =
    [ USD
    , BRL
    ]
