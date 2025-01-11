*## stata脚本（tfidf）
clear
clear matrix

*// turn more off
set more off
*// load .csv
import delimited "C:/Users/heyouwei/code/car/20230415/2013_2024_period/tfidf_panel_data_with_d_dummy.csv", clear stringcols(_all)
destring avg_wdis_rate, replace
destring avg_dis_rate, replace
destring avg_winh_rate, replace
destring avg_inh_rate, replace
destring avg_dis_rate_diff, replace
destring avg_inh_rate_diff, replace
destring avg_wnew_rate, replace
destring avg_new_rate, replace
destring avg_new_rate_diff, replace
destring normyear_avg_sim_diff, replace
destring log_price, replace
destring vfm, replace
destring rate, replace
destring newgenecountrate, replace
destring avg_anc_cd139_1, replace
destring cd139_1, replace
destring year, replace
destring d_dummy, replace
encode brand, generate(brand_id)
gen cd_dummy = (cd139_1 > 0)
keep if year >= 2014 & year <= 2023
*************
* VARIABLES *
*************
label variable avg_wdis_rate "Reduction Quality"
label variable avg_dis_rate "Reduction Quantity"
label variable avg_winh_rate "Retention Quality"
label variable avg_inh_rate "Retention Quantity"
label variable avg_wnew_rate "Addiction Quality"
label variable avg_new_rate "Addiction Quantity"
label variable avg_dis_rate_diff "Lost gene rate difference"
label variable avg_inh_rate_diff "Inherited gene rate difference"
label variable avg_new_rate_diff "New gene rate difference"
label variable avg_anc_cd139_1 "Ancestor PDI"
label variable newgenecountrate "Creation Quantity"
label variable vfm "Value of money"
label variable log_price "Price(log)"
label variable rate "Car rating"

**********
* MODELS *
**********
reghdfe cd139_1  avg_inh_rate avg_winh_rate   avg_anc_cd139_1  rate log_price newgenecountrate, absorb(year brand_id) vce(robust)
eststo TFIDF1

reghdfe cd139_1    avg_wdis_rate avg_dis_rate    avg_anc_cd139_1  rate log_price newgenecountrate, absorb(year brand_id) vce(robust)
eststo TFIDF2

reghdfe cd139_1    avg_wnew_rate avg_new_rate    avg_anc_cd139_1  rate log_price newgenecountrate, absorb(year brand_id) vce(robust)
eststo TFIDF3



* 第一模型，加入 year 和 brand 固定效应
xi: logit d_dummy avg_inh_rate avg_winh_rate avg_anc_cd139_1 rate log_price newgenecountrate i.year i.brand
eststo tfidflog1

* 第二模型，加入 year 和 brand 固定效应
xi: logit d_dummy avg_wdis_rate avg_dis_rate avg_anc_cd139_1 rate log_price newgenecountrate i.year i.brand
eststo tfidflog2

* 第三模型，加入 year 和 brand 固定效应
xi: logit d_dummy avg_wnew_rate avg_new_rate avg_anc_cd139_1 rate log_price newgenecountrate i.year i.brand
eststo tfidflog3


*esttab PI1 PI2 PI3 PI4 PI5 PI6 using "C:/Users/heyouwei/code/car/20230415/2013_2024_period/tfidf_panel_result.csv", replace  label compress b(3) se(3) stats(N r2, fmt(%20.0g %9.2f) labels("N" "R2"))  noabbrev  *nomtitles starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) keep( rate avg_wnew_rate avg_new_rate avg_wdis_rate avg_dis_rate  avg_inh_rate avg_winh_rate  avg_anc_cd139_1 newgenecountrate  log_price )
* stata脚本（tf）
*clear
*
*clear matrix

*// turn more o*ff
*set more off
*// load .csv
import delimited "C:/Users/heyouwei/code/car/20230415/2013_2024_period/tf_panel_data_with_d_dummy.csv", clear stringcols(_all)
destring avg_wdis_rate, replace
destring avg_dis_rate, replace
destring avg_winh_rate, replace
destring avg_inh_rate, replace
destring avg_dis_rate_diff, replace
destring avg_inh_rate_diff, replace
destring avg_wnew_rate, replace
destring avg_new_rate, replace
destring avg_new_rate_diff, replace
destring normyear_avg_sim_diff, replace
destring log_price, replace
destring vfm, replace
destring rate, replace
destring newgenecountrate, replace
destring avg_anc_cd139_1, replace
destring cd139_1, replace
destring year, replace
destring d_dummy, replace
encode brand, generate(brand_id)
gen cd_dummy = (cd139_1 > 0)
*************
* VARIABLES *
*************
label variable avg_wdis_rate "Reduction Quality"
label variable avg_dis_rate "Reduction Quantity"
label variable avg_winh_rate "Retention Quality"
label variable avg_inh_rate "Retention Quantity"
label variable avg_wnew_rate "Addiction Quality"
label variable avg_new_rate "Addiction Quantity"
label variable avg_dis_rate_diff "Lost gene rate difference"
label variable avg_inh_rate_diff "Inherited gene rate difference"
label variable avg_new_rate_diff "New gene rate difference"
label variable avg_anc_cd139_1 "Ancestor PDI"
label variable newgenecountrate "Creation Quantity"
label variable vfm "Value of money"
label variable log_price "Price(log)"
label variable rate "Car rating"
keep if year >= 2014 & year <= 2023
**********
* MODELS *
**********
reghdfe cd139_1  avg_inh_rate avg_winh_rate   avg_anc_cd139_1  rate log_price newgenecountrate, absorb(year brand_id) vce(robust)
eststo TF1

reghdfe cd139_1    avg_wdis_rate avg_dis_rate    avg_anc_cd139_1  rate log_price newgenecountrate, absorb(year brand_id) vce(robust)
eststo TF2

reghdfe cd139_1    avg_wnew_rate avg_new_rate    avg_anc_cd139_1  rate log_price newgenecountrate, absorb(year brand_id) vce(robust)
eststo TF3


* 第一模型，加入 year 和 brand 固定效应
xi: logit d_dummy avg_inh_rate avg_winh_rate avg_anc_cd139_1 rate log_price newgenecountrate i.year i.brand
eststo tflog1

* 第二模型，加入 year 和 brand 固定效应
xi: logit d_dummy avg_wdis_rate avg_dis_rate avg_anc_cd139_1 rate log_price newgenecountrate i.year i.brand
eststo tflog2

* 第三模型，加入 year 和 brand 固定效应
xi: logit d_dummy avg_wnew_rate avg_new_rate avg_anc_cd139_1 rate log_price newgenecountrate i.year i.brand
eststo tflog3

* stata脚本（合并tf于tfidf模型）
esttab tflog1 tflog2 tflog3 tfidflog1 tfidflog2 tfidflog3 , replace label compress b(3) se(3) mlabels("TF" "TF" "TF" "TF-IDF" "TF-IDF" "TF-IDF") stats(N r2_p, fmt(%20.0g %9.3f) labels("N" "R2")) noabbrev nomtitles starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) keep(rate avg_wnew_rate avg_new_rate avg_wdis_rate avg_dis_rate avg_inh_rate avg_winh_rate avg_anc_cd139_1 newgenecountrate log_price )

esttab tflog1 tflog2 tflog3 tfidflog1 tfidflog2 tfidflog3 using "C:/Users/heyouwei/code/car/20230415/2013_2024_period/new1324twoweight_logit_result.csv", replace label compress b(3) se(3) mlabels("TF" "TF" "TF" "TF-IDF" "TF-IDF" "TF-IDF") stats(N r2_p, fmt(%20.0g %9.3f) labels("N" "Pseudo R2")) noabbrev nomtitles starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) keep(rate avg_wnew_rate avg_new_rate avg_wdis_rate avg_dis_rate avg_inh_rate avg_winh_rate avg_anc_cd139_1 newgenecountrate log_price )


esttab TF1 TF2 TF3 TFIDF1 TFIDF2 TFIDF3 , replace label compress b(3) se(3) mlabels("Frequency weight" "Frequency weight" "Frequency weight" "TF-IDF weight" "TF-IDF weight" "TF-IDF weight") stats(N r2, fmt(%20.0g %9.3f) labels("N" "R2")) noabbrev nomtitles starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) keep(rate avg_wnew_rate avg_new_rate avg_wdis_rate avg_dis_rate avg_inh_rate avg_winh_rate avg_anc_cd139_1 newgenecountrate log_price )

esttab TF1 TF2 TF3 TFIDF1 TFIDF2 TFIDF3 using "C:/Users/heyouwei/code/car/20230415/2013_2024_period/new1324twoweight_panel_result.csv", replace label compress b(3) se(3) mlabels("Frequency weight" "Frequency weight" "Frequency weight" "TF-IDF weight" "TF-IDF weight" "TF-IDF weight") stats(N r2, fmt(%20.0g %9.3f) labels("N" "R2")) noabbrev nomtitles starlevels(+ 0.1 * 0.05 ** 0.01 *** 0.001) keep(rate avg_wnew_rate avg_new_rate avg_wdis_rate avg_dis_rate avg_inh_rate avg_winh_rate avg_anc_cd139_1 newgenecountrate log_price )
