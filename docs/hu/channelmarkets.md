# Lightning channel piacok összehasonlító táblázata

| lista | használat egyszerűsége | likviditás költsége | kétirányú likviditás | lánchoz kötött díj terhelés | bizalom/kikényszerítés |
| - | :--- | :--- |:-- |:-- |:-- |
| channel swap-ok |egyszerű| tetszőleges / ingyenes |igen, két channel | mindkettő | minimális/LN|
| bizalmi swap-ok | egyszerű|tetszőleges / ingyenes| igen, a swap-olt pénz egy channel-ben tolódik | egyik fél | bizalmi/LN |
| rings of fire | bonyolult | ingyenes | igen, két channel | fejenként egy channel| minimális/LN|
| lightningnetwork.plus | egyszerű | ingyenes | igen, két channel | fejenként egy channel | minimális/LN|
| LL Pool | bonyolult | alapdíj + ppm (+ 1000 ppm az LL-nek)| csak bejövő | eladó fedezi | minimális/poold+LN|
| liquidity ads | csak CLI | alapdíj + ppm kizárólag a Peer-nek fizetve | igen | vevő fedezi | minimális / az eladó pénze zárolva van a lejáratig |
| Amboss.space Magma | egyszerű | ppm (+ a díj 10%-a az Amboss-nak)| csak bejövő | eladó fedezi | közösségi, reputációs rendszeren alapul |
