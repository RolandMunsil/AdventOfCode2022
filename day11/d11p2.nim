import strutils
import strscans
import sequtils
import algorithm

var strFile = readFile("input.txt")

type Monkey = object
    items: seq[int]
    chOp: char
    strOperand: string
    nDiv: int
    iMonkeyTrue: int
    iMonkeyFalse: int

var monkeys: array[8, Monkey]

while true:
    var
        monkey: Monkey
        iMonkey: int
        strItems: string

    assert strFile.scanf(
        "Monkey $i:\n  Starting items: $+\n  Operation: new = old $c $+\n  Test: divisible by $i\n    If true: throw to monkey $i\n    If false: throw to monkey $i",
        iMonkey, strItems, monkey.chOp, monkey.strOperand, monkey.nDiv, monkey.iMonkeyTrue, monkey.iMonkeyFalse)

    monkey.items = strItems.split(", ").mapIt(it.parseInt)
    monkeys[iMonkey] = monkey

    let iNextMonkey = strFile.find("Monkey", 1)
    if iNextMonkey < 0: break
    strFile = strFile.substr(iNextMonkey)

var inspectCts: array[8, int]

let mul = monkeys.mapIt(it.nDiv).foldl(a * b)

for round in 1..10000:
    for iM in 0..<monkeys.len:
        var monkey = monkeys[iM]
        for itemOld in monkey.items:
            var item = itemOld mod mul
            inc inspectCts[iM]
            let operand = (if monkey.strOperand == "old": item else: monkey.strOperand.parseInt)
            case monkey.chOp:
            of '*': item = (item * operand)
            of '+': item = (item + operand)
            else: discard
            let iMonkeyNext = (if item mod monkey.nDiv == 0: monkey.iMonkeyTrue else: monkey.iMonkeyFalse)
            monkeys[iMonkeyNext].items.add(item)
        monkeys[iM].items.setLen(0)

inspectCts.sort(SortOrder.Descending)
echo inspectCts[0] * inspectCts[1]