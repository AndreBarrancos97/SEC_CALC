
# PlanAhead Launch Script for Post PAR Floorplanning, created by Project Navigator

create_project -name V2_Project_Calc -dir "/home/andre/Documents/SEC_CALC/testes/V2_Project_Calc_WorkingInThis/planAhead_run_2" -part xc3s100ecp132-4
set srcset [get_property srcset [current_run -impl]]
set_property design_mode GateLvl $srcset
set_property edif_top_file "/home/andre/Documents/SEC_CALC/testes/V2_Project_Calc_WorkingInThis/xtop.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/andre/Documents/SEC_CALC/testes/V2_Project_Calc_WorkingInThis} }
set_property target_constrs_file "xtop.ucf" [current_fileset -constrset]
add_files [list {xtop.ucf}] -fileset [get_property constrset [current_run]]
link_design
read_xdl -file "/home/andre/Documents/SEC_CALC/testes/V2_Project_Calc_WorkingInThis/xtop.ncd"
if {[catch {read_twx -name results_1 -file "/home/andre/Documents/SEC_CALC/testes/V2_Project_Calc_WorkingInThis/xtop.twx"} eInfo]} {
   puts "WARNING: there was a problem importing \"/home/andre/Documents/SEC_CALC/testes/V2_Project_Calc_WorkingInThis/xtop.twx\": $eInfo"
}
