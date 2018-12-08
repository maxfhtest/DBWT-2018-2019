# DBWT-2018-2019
Semester Project

# Example of the Views
## Product View
| id | description                   | name       | stock | available | category_id | VGT | VGN | HEX(blob_data) | alttext             | title                | guest | student | employee |
|----|-------------------------------|------------|-------|-----------|-------------|-----|-----|----------------|---------------------|----------------------|-------|---------|----------|
| 1  | Ein leckerer Wok              | Curry Wok  | 12    | 1         | 6           | 0   | 0   | 0x123456ABCDEF | wokbildtext         | wokbildtitle         | 9,95  | 1,95    | 51,95    |
| 2  | Paniertes Glück               | Schnitzel  | 14    | 1         | 7           | 0   | 0   | 0x123456ABCDEF | schnitzelbildtext   | schnitzelbildtitle   | 10,95 | 2,95    | 52,95    |
| 3  | Aus Holland                   | Bratrolle  | 0     | 0         | 10          | 0   | 0   | 0x123456ABCDEF | bratrollbildetext   | bratrollebildtitle   | 11,95 | 3,95    | 53,95    |
| 4  | Fuer Doener                   | Krautsalat | 0     | 0         | 4           | 1   | 1   | 0x123456ABCDEF | krautsalatbildtext  | krautsalatbildtitle  | 12,95 | 4,95    | 54,95    |
| 5  | Die gesunde Alternative       | Falafel    | 2     | 1         | 12          | 1   | 1   | 0x123456ABCDEF | falafelbildtext     | falafelbildtitlte    | 13,95 | 5,95    | 55,95    |
| 6  | Baustellenklassiker           | Currywurst | 5     | 1         | 7           | 0   | 0   | 0x123456ABCDEF | currywurstbildtext  | currywurstbildtitle  | 14,95 | 6,95    | 56,95    |
| 7  | Wie für den Schweizer gemacht | Käsestulle | 7     | 1         | 13          | 1   | 0   | 0x123456ABCDEF | kaesestullebildtext | kaesestullebildtitle | 15,99 | 7,95    | 57,95    |
| 8  | Wenns schnell gehen muss      | Spiegelei  | 2     | 1         | 3           | 1   | 1   | 0x123456ABCDEF | spiegeleibildtext   | spiegeleibildtitlte  | 16,95 | 8,95    | 58,95    |

## Category View
| child            | childID | parent         | parentID |
|------------------|---------|----------------|----------|
| Hauptspeisen     | 1       |                |         |
| Kleinigkeiten    | 2       |                |          |
| Smoothies        | 3       | Kleinigkeiten  | 2        |
| Snacks           | 4       | Kleinigkeiten  | 2        |
| Burger und Co    | 5       | Hauptspeisen   | 1        |
| Asiatisch        | 6       | Hauptspeisen   | 1        |
| Klassiker        | 7       | Hauptspeisen   | 1        |
| Italienisch      | 8       | Hauptspeisen   | 1        |
| Aktionen         | 9       |                |         |
| Weihnachten      | 10      | Aktionen       | 9        |
| Sommergenuss     | 11      | Aktionen       | 9        |
| Mensa Vital      | 12      | Aktionen       | 9        |
| Sonderangebote   | 13      |                |          |
| Ersti-Woche      | 14      | Sonderangebote | 13       |
| Geburtstagsessen | 15      | Sonderangebote | 13       |

## User View
| id | salt                             | hash                     | firstname | lastname   | active | loginname | Rolle    |
|----|----------------------------------|--------------------------|-----------|------------|--------|-----------|----------|
| 2  | 12345678901234567890123456789012 | 123456789012345678901234 | Maria     | Mustermann | 1      | MariaMu   | student  |
| 3  | 12345678901234567890123456789012 | 123456789012345678901234 | Peter     | Mastermann | 1      | PeterMa   | student  |
| 21 | +6AOUlRpIO9fIBUXtO8xLc0YjMuam7ky | cnXcn4xLb9uBHHYJ+kRQsMW3 | Bugs      | Findmore   | 1      | bugfin    | student  |
| 22 | Ydn1iGl08JvvkVExSEiKDQhfYOaCtgOO | m5kZ68YVNU3xBiDqorthK9UP | Donald    | Truck      | 1      | dot       | employee |
| 23 | I5GXy7BwYU2t3pHZ5YkBfKMbvN7Sr81O | oYylNvPe7YmjO1IHNdLA/XxJ | Fiona     | Index      | 1      | fionad    |          |
| 24 | t1TAVguVwIiejXf3baaObIAtPx7Y+2iY | IMK2n5r8RUVFo4bMMS8uDyH4 | Wendy     | Burger     | 1      | bkahuna   | guest    |
| 25 | dX8YsBM9atpYto9caWHJM6Eet7bUngxk | nRt3MSBdNUHPj/q02WPgXaDA | Monster   | Robot      | 1      | root      |          |

Tables generated with : https://www.tablesgenerator.com/markdown_tables
