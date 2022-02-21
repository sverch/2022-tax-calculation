# 2022-tax-calculation

Usage:

```
$ column -t -s$'\t' brackets.tsv
Tax Rate   For Single Filers      For Married Individuals Filing Joint Returns   For Heads of Households
10%        $0 to $10,275          $0 to $20,550                                  $0 to $14,650
12%        $10,275 to $41,775     $20,550 to $83,550                             $14,650 to $55,900
22%        $41,775 to $89,075     $83,550 to $178,150                            $55,900 to $89,050
24%        $89,075 to $170,050    $178,150 to $340,100                           $89,050 to $170,050
32%        $170,050 to $215,950   $340,100 to $431,900                           $170,050 to $215,950
35%        $215,950 to $539,900   $431,900 to $647,850                           $215,950 to $539,900
37%        $539,900 or more       $647,850 or more                               $539,900 or more
```

```
$ bash google-sheets-formula.sh A1
=SUM(
IF((A1 - 12950) > 0, (IF((A1 - 12950) > 10275, 10275, (A1 - 12950)) - 0) * 0.10, 0),
IF((A1 - 12950) > 10275, (IF((A1 - 12950) > 41775, 41775, (A1 - 12950)) - 10275) * 0.12, 0),
IF((A1 - 12950) > 41775, (IF((A1 - 12950) > 89075, 89075, (A1 - 12950)) - 41775) * 0.22, 0),
IF((A1 - 12950) > 89075, (IF((A1 - 12950) > 170050, 170050, (A1 - 12950)) - 89075) * 0.24, 0),
IF((A1 - 12950) > 170050, (IF((A1 - 12950) > 215950, 215950, (A1 - 12950)) - 170050) * 0.32, 0),
IF((A1 - 12950) > 215950, (IF((A1 - 12950) > 539900, 539900, (A1 - 12950)) - 215950) * 0.35, 0),
IF((A1 - 12950) > 539900, (IF((A1 - 12950) > 100000000, 100000000, (A1 - 12950)) - 539900) * 0.37, 0),
0)
```

Sources:

- https://srcco.de/posts/tsv-tab-separated-values.html
- https://taxfoundation.org/2022-tax-brackets/
- https://www.irs.gov/newsroom/irs-provides-tax-inflation-adjustments-for-tax-year-2022
