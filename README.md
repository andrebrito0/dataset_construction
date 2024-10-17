# CO-DA

This repository will serve as the main aggregator of sources and datasets for the construction of CO-DA, the combined COVID Dataset.

# Main variables

## 1. Demographic Variables
- **Population Size**: Total population [INE, per municipality]
- **Age Distribution**: Age groups [INE, per municipality]
- **Gender Distribution**: Males, females, others [INE, per municipality]
- **Population Density**: People per square km/mile [GHSL, Copernicus](https://human-settlement.emergency.copernicus.eu/ghs_pop2023.php)
- **Socioeconomic Indicators**: Income, education, poverty rate [INE, per municipality, material deprivation indicators]
- **Urban vs Rural**: Degree of urbanisation [GHSL, Copernicus](https://human-settlement.emergency.copernicus.eu/ghs_smod2023.php)

## 2. Epidemiological Variables 
_To confirm with INSA - data available and granularity_
- **Total Confirmed Cases**: Cumulative case count
- **Incidence Rate**: New cases per 100,000 population
- **Prevalence Rate**: Proportion of the population infected
- **Testing Rate**: Tests conducted per 1,000 or 100,000 people [Our World in Data](https://ourworldindata.org/explorers/covid?Metric=Tests&Interval=Cumulative&Relative+to+population=true&country=~PRT)
- **Positivity Rate**: Percentage of positive tests
- **Mortality Rate**: Deaths per 100,000 population
- **Case Fatality Rate (CFR)**: Deaths among confirmed cases
- **Recovery Rate**: Proportion of confirmed cases recovered
- **Variant breakdowns**

## 3. Geographical Variables
- **Mobility Data**: Movement patterns within and between regions [Google Mobility Reports]
- **Environmental Factors**: Air pollution, temperature, humidity [Data Climate Store, Copernicus](https://cds.climate.copernicus.eu)

## 4. Intervention and Policy Measures
- **Lockdown Dates**: Start/end of lockdowns or restrictions [Several Sources](https://www.consilium.europa.eu/pt/policies/coronavirus-pandemic/timeline/)
- **Stringency Index**: Dates of school closures/reopenings [Our World in Data](https://ourworldindata.org/explorers/covid?uniformYAxis=0&Metric=Stringency+index&Interval=Cumulative&Relative+to+population=true&country=~PRT)
- **Containment and Health Index** [Our World in Data](https://ourworldindata.org/grapher/covid-containment-and-health-index?tab=chart&country=~PRT)

## 6. Vaccination Variables
- **Vaccination Coverage**: Percentage of population vaccinated
- **Vaccine Rollout Dates**

## 7. Testing Variables
- **Testing Capacity**: Maximum daily tests possible
- **Testing Availability**: Percentage of population tested
- **Testing Policies**: Testing policies over time (symptomatic, contacts, etc.)

## 9. Behavioral Variables
- **Mask Usage Rate**: Percentage wearing masks consistently
- **Compliance with Social Distancing**: Adherence to social distancing rules

