# Kiegyensúlyozott csatorna létrehozása megbízható partnerrel (Balanced channel creation)

## Megbízható csere

Megbízható onchain-offchain csere végrehajtása.

Előny:

* Kétirányú likviditást hoz létre mindkét oldalon.
* Közvetlen LN csatornán történő fizetés a partnernek ingyenes.

Hogyan kell:

* Nyiss egy csatornát egy megbízható partnerhez.
* A csatorna megerősítése után fizess ki egy invoice-t, amelyet a partner ad meg \(használd a csatorna kapacitásának felét, hogy tökéletesen kiegyensúlyozott csatornát kapj\) - ez a fizetés ingyenes.
* Küldj a partnernek egy onchain címet, amelyre visszautalhatja az invoice összegét \(használj alacsony hálózati díjat\).

## Kiegyensúlyozott csatorna nyitása megbízható partnerrel (Balanced channel creation)

Nyiss egy kétoldalúan finanszírozott, kiegyensúlyozott csatornát egy megbízható partnerrel a parancssor segítségével, amely egy Lightning és egy onchain tranzakciót igényel.

Az alábbiakban bemutatjuk, hogyan hozhatsz létre egy 2 millió sats kapacitású kiegyensúlyozott csatornát az `A` és `B` node-ok között.

Előnyök:

* Csak egyetlen onchain tranzakció szükséges \(olcsóbb\).
* Az eredmény egy 2M sats kapacitású csatorna lesz 2x1M helyett, ugyanannyi lekötött összeg mellett \(hatékonyabb\).

Követelmények:

* `A`-nak 1M sats kimenő likviditása van.
* `B`-nek 1M sats bejövő likviditása + 2M sats onchain összege van \(megbízható node\).
* `A` és `B` között létezik fizetési útvonal 1M sats-ra.

Hogyan kell:

* `B` küld egy invoice-t, amellyel 1M sats-ot fogad `A`-tól.
* `A` kifizet 1M sats-ot `B`-nek.
* Győződj meg róla, hogy A és B peerek.
* `B` nyit egy 2M sats csatornát A felé az alábbi paranccsal:

  `lncli openchannel <nodeID_of_A> --local_amt 2000000 --push_amt 1000000 --sat_per_byte 2`

Nem kell sietni, ezért használj alacsony díjat az onchain tranzakcióhoz. Ellenőrizd a [https://whatthefee.io/](https://whatthefee.io/) oldalon a mempool aktuális állapotát, vagy használd a `--conf_target 10` opciót az automatikus díjbecsléshez, amellyel ~10 blokkon belüli megerősítést célozhatsz meg.

Ennek eredménye egy kiegyensúlyozott csatorna lesz, mindkét oldalon 1M sats-szal \(mínusz a commit díj\).

![kiegyensúlyozott csatorna a ZeusLN-ben](../assets/balancedChannel.jpg)

## A likviditás költsége

A Lightning Network-ön a likviditás biztosítása tranzakciós költségekkel, alternatív költségekkel és hot wallet kockázatokkal jár.
A likviditás sem bőségesen rendelkezésre álló, sem ingyenes nem.
Más node-üzemeltetőktől bejövő likviditást kérni szívességet jelent.
Egy javaslat \(példa\) a likviditás árazására:

* Minimum 1M sats csatornákat nyiss.
* Fizess a szolgáltatónak 0,02% = 2000 ppm sats-ot az összeg csatornába allokálásáért, amely fedezi a bányász díjakat \(nyitás és zárás + kényszerített lezárás kockázata\).
* Állapodjatok meg egy routing díjban \(például 100 ppm\).
* Állapodjatok meg egy időtartamban, ameddig a csatorna nyitva marad \(például minimum egy hónap\).
