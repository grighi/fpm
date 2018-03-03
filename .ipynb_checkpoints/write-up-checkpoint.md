---
output:
  pdf_document: default
  html_document: default
---

## Methods

Earnings poverty and the number of children in nonworking families are identified from the basic monthly CPS.[^1] Respondents of the CPS report labor force status and usual weekly earnings. Usual weekly earnings are annualized to compare to the official poverty thresholds.[^2] As for the official poverty measure, individuals are grouped into poverty units, which are used to separate primary families from other subfamilies living in a household.

[^1]: See Technical_Report.pdf

[^2]: (Note: we multiply earnings by 52, and this gives a yearly earnings measure. We should either [1] divide poverty thresholds by 52 and consider "poverty at that week" or [2] kernel sample annual incomes based on reported usual earnings)

Weekly earnings reported in the CPS are a lower bound for family earnings because earnings data are not collected for self-employed individuals. To correct for this, we nonparametrically estimate self-employment earnings using the ASEC. These are added to weekly earnings for self-employed individuals.

### Nonparametric income prediction

To estimate self-employment incomes, we calculate several nonparametric distributions of self-employment earnings in the ASEC and draw from these distributions to assign self-employment earnings in every other month of the year. We use nonparametric distributions to avoid making an assumption about the shape of the distribution of incomes. Multiple distributions have to be calculated because there are three important variables that affect the shape of the distribution: the size of the family, the number of children, and the family status (whether a family is the primary or related subfamily of a household). Conceptually our method is similar to the hotdeck using the ASEC as a donor group and self-employed monthly CPS respondents as the recipients. It is similarly accurate and much more efficient than the hotdeck. In practice, our estimates are computed by sampling from the donor group and adding a bit of noise (a "bandwidth"). This allows us to sample from an underlying kernel density estimate. The bandwidths (set to fifty dollars times a unit-normal sample) are chosen so that the underlying kernel density distribution reasonably approximates the distribution of earnings.

## Outcomes

###  Earnings Poverty

Imputed self-employment earnings are added to reported usual weekly earnings because self-employment earnings are available in the Annual Social and Economic Supplement (ASEC) but not in the basic monthly CPS. This addition affects earnings poverty rates by several percentage points. To impute self-employment earnings, we pull self-employment earnings from records in the ASEC of the same year. By matching groups identified by family income category, primary family status, number of children and number of adults in the household, we nonparametrically estimate self-employment earnings for individuals responding to the basic monthly CPS. Wage and salary, self-employment, and farm earnings values are drawn randomly with replacement from a group in the ASEC and assigned to the corresponding group in the basic CPS. The maximum of the three values is assigned as self-employment earnings and a small bandwidth is added. Imputed self-employment earnings are added to usual weekly earnings for individuals that report being self-employed, and total earnings are then multiplied by fifty to estimate annual earnings (assuming two weeks of vacation). These values are compared to poverty thresholds.

![Earnings poverty.](output2.pdf)

### Children in Non-Working Families

We count the proportion of children living in households where no eligible adults are working. Individuals are defined as eligible to work if they are older than 14, not disabled, retired, or otherwise not in the labor force (NILF). Workers are added back into the labor force if they are NILF for an unspecified reason or if they want to work and are not disabled.

![Children in non-working families overlayed with official poverty measure.](output3.pdf)



