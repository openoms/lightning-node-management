# Comparison table of lightning channel markets

| list | ease of use | cost of liquidity| bidirectional liquidity | chain fee burden | trust/enforcement |
| - | :--- | :--- |:-- |:-- |:-- |
| channel swaps |easy| arbitrary / free |yes, two channels | both | min/LN|
| trusted swaps | easy|arbitrary / free| yes, swapped funds pushed in one channel | one side | trusted/LN |
| rings of fire | complicated | free | yes, two channels | one channel each| min/LN|
| lightningnetwork.plus | easy | free | yes, two channels | one channel each | min/LN|
| LL Pool | complicated | base fee + ppm (+ 1000 ppm to LL)| inbound only | seller covers | min/poold+LN|
| liquidity ads | CLI only | base fee + ppm paid to the Peer only | yes | buyer covers | min / seller funds are locked until expiry |
| Amboss.space Magma | easy | ppm (+ 10% of the fee to Amboss)| inbound only | seller covers | social based on reputation system |