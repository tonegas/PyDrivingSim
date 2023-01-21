 // File for interfaces
 // WARNING! AUTOMATICALLY GENERATED - DO NOT EDIT
 // Originf file: interfaces_v1.2.csv
 // Origin CRC32: 4097400712

 #include <stdio.h>
 #include "interfaces_struct_printer_fun.h"

 #ifdef __cplusplus
 extern "C" {
 #endif

 void StructPrinterHeaderIn( const input_data_str *data_input_load, FILE *fp_input ) {
   
fprintf(
    fp_input,
    "ID\tVersion\tCycleNumber\tECUupTime\tStatus\tVLgtFild\tALgtFild\tYawRateFi"
    "ld\tSteerWhlAg\tVehicleLen\tVehicleWidth\tRequestedCruisingSpeed\tAutomati"
    "onLevel\tCurrentLane\tNrObjs\tObjID001\tObjID002\tObjID003\tObjID004\tObjI"
    "D005\tObjID006\tObjID007\tObjID008\tObjID009\tObjID010\tObjID011\tObjID012"
    "\tObjID013\tObjID014\tObjID015\tObjID016\tObjID017\tObjID018\tObjID019\tOb"
    "jID020\tObjX001\tObjX002\tObjX003\tObjX004\tObjX005\tObjX006\tObjX007\tObj"
    "X008\tObjX009\tObjX010\tObjX011\tObjX012\tObjX013\tObjX014\tObjX015\tObjX0"
    "16\tObjX017\tObjX018\tObjX019\tObjX020\tObjY001\tObjY002\tObjY003\tObjY004"
    "\tObjY005\tObjY006\tObjY007\tObjY008\tObjY009\tObjY010\tObjY011\tObjY012\t"
    "ObjY013\tObjY014\tObjY015\tObjY016\tObjY017\tObjY018\tObjY019\tObjY020\tOb"
    "jLen001\tObjLen002\tObjLen003\tObjLen004\tObjLen005\tObjLen006\tObjLen007"
    "\tObjLen008\tObjLen009\tObjLen010\tObjLen011\tObjLen012\tObjLen013\tObjLen"
    "014\tObjLen015\tObjLen016\tObjLen017\tObjLen018\tObjLen019\tObjLen020\tObj"
    "Width001\tObjWidth002\tObjWidth003\tObjWidth004\tObjWidth005\tObjWidth006"
    "\tObjWidth007\tObjWidth008\tObjWidth009\tObjWidth010\tObjWidth011\tObjWidt"
    "h012\tObjWidth013\tObjWidth014\tObjWidth015\tObjWidth016\tObjWidth017\tObj"
    "Width018\tObjWidth019\tObjWidth020\tObjVel001\tObjVel002\tObjVel003\tObjVe"
    "l004\tObjVel005\tObjVel006\tObjVel007\tObjVel008\tObjVel009\tObjVel010\tOb"
    "jVel011\tObjVel012\tObjVel013\tObjVel014\tObjVel015\tObjVel016\tObjVel017"
    "\tObjVel018\tObjVel019\tObjVel020\tObjCourse001\tObjCourse002\tObjCourse00"
    "3\tObjCourse004\tObjCourse005\tObjCourse006\tObjCourse007\tObjCourse008\tO"
    "bjCourse009\tObjCourse010\tObjCourse011\tObjCourse012\tObjCourse013\tObjCo"
    "urse014\tObjCourse015\tObjCourse016\tObjCourse017\tObjCourse018\tObjCourse"
    "019\tObjCourse020\tLaneWidth\tLatOffsLineR\tLatOffsLineL\tLaneHeading\tLan"
    "eCrvt\tAdasisCurvatureNr\tAdasisCurvatureDist001\tAdasisCurvatureDist002\t"
    "AdasisCurvatureDist003\tAdasisCurvatureDist004\tAdasisCurvatureDist005\tAd"
    "asisCurvatureDist006\tAdasisCurvatureDist007\tAdasisCurvatureDist008\tAdas"
    "isCurvatureDist009\tAdasisCurvatureDist010\tAdasisCurvatureDist011\tAdasis"
    "CurvatureDist012\tAdasisCurvatureDist013\tAdasisCurvatureDist014\tAdasisCu"
    "rvatureDist015\tAdasisCurvatureDist016\tAdasisCurvatureDist017\tAdasisCurv"
    "atureDist018\tAdasisCurvatureDist019\tAdasisCurvatureDist020\tAdasisCurvat"
    "ureDist021\tAdasisCurvatureDist022\tAdasisCurvatureDist023\tAdasisCurvatur"
    "eDist024\tAdasisCurvatureDist025\tAdasisCurvatureDist026\tAdasisCurvatureD"
    "ist027\tAdasisCurvatureDist028\tAdasisCurvatureDist029\tAdasisCurvatureDis"
    "t030\tAdasisCurvatureDist031\tAdasisCurvatureDist032\tAdasisCurvatureDist0"
    "33\tAdasisCurvatureDist034\tAdasisCurvatureDist035\tAdasisCurvatureDist036"
    "\tAdasisCurvatureDist037\tAdasisCurvatureDist038\tAdasisCurvatureDist039\t"
    "AdasisCurvatureDist040\tAdasisCurvatureDist041\tAdasisCurvatureDist042\tAd"
    "asisCurvatureDist043\tAdasisCurvatureDist044\tAdasisCurvatureDist045\tAdas"
    "isCurvatureDist046\tAdasisCurvatureDist047\tAdasisCurvatureDist048\tAdasis"
    "CurvatureDist049\tAdasisCurvatureDist050\tAdasisCurvatureDist051\tAdasisCu"
    "rvatureDist052\tAdasisCurvatureDist053\tAdasisCurvatureDist054\tAdasisCurv"
    "atureDist055\tAdasisCurvatureDist056\tAdasisCurvatureDist057\tAdasisCurvat"
    "ureDist058\tAdasisCurvatureDist059\tAdasisCurvatureDist060\tAdasisCurvatur"
    "eDist061\tAdasisCurvatureDist062\tAdasisCurvatureDist063\tAdasisCurvatureD"
    "ist064\tAdasisCurvatureDist065\tAdasisCurvatureDist066\tAdasisCurvatureDis"
    "t067\tAdasisCurvatureDist068\tAdasisCurvatureDist069\tAdasisCurvatureDist0"
    "70\tAdasisCurvatureDist071\tAdasisCurvatureDist072\tAdasisCurvatureDist073"
    "\tAdasisCurvatureDist074\tAdasisCurvatureDist075\tAdasisCurvatureDist076\t"
    "AdasisCurvatureDist077\tAdasisCurvatureDist078\tAdasisCurvatureDist079\tAd"
    "asisCurvatureDist080\tAdasisCurvatureDist081\tAdasisCurvatureDist082\tAdas"
    "isCurvatureDist083\tAdasisCurvatureDist084\tAdasisCurvatureDist085\tAdasis"
    "CurvatureDist086\tAdasisCurvatureDist087\tAdasisCurvatureDist088\tAdasisCu"
    "rvatureDist089\tAdasisCurvatureDist090\tAdasisCurvatureDist091\tAdasisCurv"
    "atureDist092\tAdasisCurvatureDist093\tAdasisCurvatureDist094\tAdasisCurvat"
    "ureDist095\tAdasisCurvatureDist096\tAdasisCurvatureDist097\tAdasisCurvatur"
    "eDist098\tAdasisCurvatureDist099\tAdasisCurvatureDist100\tAdasisCurvatureV"
    "alues001\tAdasisCurvatureValues002\tAdasisCurvatureValues003\tAdasisCurvat"
    "ureValues004\tAdasisCurvatureValues005\tAdasisCurvatureValues006\tAdasisCu"
    "rvatureValues007\tAdasisCurvatureValues008\tAdasisCurvatureValues009\tAdas"
    "isCurvatureValues010\tAdasisCurvatureValues011\tAdasisCurvatureValues012\t"
    "AdasisCurvatureValues013\tAdasisCurvatureValues014\tAdasisCurvatureValues0"
    "15\tAdasisCurvatureValues016\tAdasisCurvatureValues017\tAdasisCurvatureVal"
    "ues018\tAdasisCurvatureValues019\tAdasisCurvatureValues020\tAdasisCurvatur"
    "eValues021\tAdasisCurvatureValues022\tAdasisCurvatureValues023\tAdasisCurv"
    "atureValues024\tAdasisCurvatureValues025\tAdasisCurvatureValues026\tAdasis"
    "CurvatureValues027\tAdasisCurvatureValues028\tAdasisCurvatureValues029\tAd"
    "asisCurvatureValues030\tAdasisCurvatureValues031\tAdasisCurvatureValues032"
    "\tAdasisCurvatureValues033\tAdasisCurvatureValues034\tAdasisCurvatureValue"
    "s035\tAdasisCurvatureValues036\tAdasisCurvatureValues037\tAdasisCurvatureV"
    "alues038\tAdasisCurvatureValues039\tAdasisCurvatureValues040\tAdasisCurvat"
    "ureValues041\tAdasisCurvatureValues042\tAdasisCurvatureValues043\tAdasisCu"
    "rvatureValues044\tAdasisCurvatureValues045\tAdasisCurvatureValues046\tAdas"
    "isCurvatureValues047\tAdasisCurvatureValues048\tAdasisCurvatureValues049\t"
    "AdasisCurvatureValues050\tAdasisCurvatureValues051\tAdasisCurvatureValues0"
    "52\tAdasisCurvatureValues053\tAdasisCurvatureValues054\tAdasisCurvatureVal"
    "ues055\tAdasisCurvatureValues056\tAdasisCurvatureValues057\tAdasisCurvatur"
    "eValues058\tAdasisCurvatureValues059\tAdasisCurvatureValues060\tAdasisCurv"
    "atureValues061\tAdasisCurvatureValues062\tAdasisCurvatureValues063\tAdasis"
    "CurvatureValues064\tAdasisCurvatureValues065\tAdasisCurvatureValues066\tAd"
    "asisCurvatureValues067\tAdasisCurvatureValues068\tAdasisCurvatureValues069"
    "\tAdasisCurvatureValues070\tAdasisCurvatureValues071\tAdasisCurvatureValue"
    "s072\tAdasisCurvatureValues073\tAdasisCurvatureValues074\tAdasisCurvatureV"
    "alues075\tAdasisCurvatureValues076\tAdasisCurvatureValues077\tAdasisCurvat"
    "ureValues078\tAdasisCurvatureValues079\tAdasisCurvatureValues080\tAdasisCu"
    "rvatureValues081\tAdasisCurvatureValues082\tAdasisCurvatureValues083\tAdas"
    "isCurvatureValues084\tAdasisCurvatureValues085\tAdasisCurvatureValues086\t"
    "AdasisCurvatureValues087\tAdasisCurvatureValues088\tAdasisCurvatureValues0"
    "89\tAdasisCurvatureValues090\tAdasisCurvatureValues091\tAdasisCurvatureVal"
    "ues092\tAdasisCurvatureValues093\tAdasisCurvatureValues094\tAdasisCurvatur"
    "eValues095\tAdasisCurvatureValues096\tAdasisCurvatureValues097\tAdasisCurv"
    "atureValues098\tAdasisCurvatureValues099\tAdasisCurvatureValues100\t");
fprintf(
    fp_input,
    "AdasisSpeedLimitNr\tAdasisSpeedLimitDist001\tAdasisSpeedLimitDist002\tAdas"
    "isSpeedLimitDist003\tAdasisSpeedLimitDist004\tAdasisSpeedLimitDist005\tAda"
    "sisSpeedLimitDist006\tAdasisSpeedLimitDist007\tAdasisSpeedLimitDist008\tAd"
    "asisSpeedLimitDist009\tAdasisSpeedLimitDist010\tAdasisSpeedLimitValues001"
    "\tAdasisSpeedLimitValues002\tAdasisSpeedLimitValues003\tAdasisSpeedLimitVa"
    "lues004\tAdasisSpeedLimitValues005\tAdasisSpeedLimitValues006\tAdasisSpeed"
    "LimitValues007\tAdasisSpeedLimitValues008\tAdasisSpeedLimitValues009\tAdas"
    "isSpeedLimitValues010\tNrTrfLights\tTrfLightDist\tTrfLightCurrState\tTrfLi"
    "ghtFirstTimeToChange\tTrfLightFirstNextState\tTrfLightSecondTimeToChange\t"
    "TrfLightSecondNextState\tTrfLightThirdTimeToChange\n");

 }

 void StructPrinterDataIn( const input_data_str *data_input_load, FILE *fp_input ) {
   
fprintf(
    fp_input,
    "%d\t%d\t%d\t%f\t%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%d\t%d\t%d\t%d\t%d\t%d\t%"
    "d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%f\t%"
    "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%"
    "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%"
    "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%"
    "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%"
    "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%"
    "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%"
    "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%d\t%f\t%"
    "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%"
    "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%"
    "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%"
    "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%"
    "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%"
    "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%"
    "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%"
    "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%"
    "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%"
    "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%"
    "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%"
    "f\t",
    data_input_load->ID, data_input_load->Version, data_input_load->CycleNumber,
    data_input_load->ECUupTime, data_input_load->Status,
    data_input_load->VLgtFild, data_input_load->ALgtFild,
    data_input_load->YawRateFild, data_input_load->SteerWhlAg,
    data_input_load->VehicleLen, data_input_load->VehicleWidth,
    data_input_load->RequestedCruisingSpeed, data_input_load->AutomationLevel,
    data_input_load->CurrentLane, data_input_load->NrObjs,
    data_input_load->ObjID[0], data_input_load->ObjID[1],
    data_input_load->ObjID[2], data_input_load->ObjID[3],
    data_input_load->ObjID[4], data_input_load->ObjID[5],
    data_input_load->ObjID[6], data_input_load->ObjID[7],
    data_input_load->ObjID[8], data_input_load->ObjID[9],
    data_input_load->ObjID[10], data_input_load->ObjID[11],
    data_input_load->ObjID[12], data_input_load->ObjID[13],
    data_input_load->ObjID[14], data_input_load->ObjID[15],
    data_input_load->ObjID[16], data_input_load->ObjID[17],
    data_input_load->ObjID[18], data_input_load->ObjID[19],
    data_input_load->ObjX[0], data_input_load->ObjX[1],
    data_input_load->ObjX[2], data_input_load->ObjX[3],
    data_input_load->ObjX[4], data_input_load->ObjX[5],
    data_input_load->ObjX[6], data_input_load->ObjX[7],
    data_input_load->ObjX[8], data_input_load->ObjX[9],
    data_input_load->ObjX[10], data_input_load->ObjX[11],
    data_input_load->ObjX[12], data_input_load->ObjX[13],
    data_input_load->ObjX[14], data_input_load->ObjX[15],
    data_input_load->ObjX[16], data_input_load->ObjX[17],
    data_input_load->ObjX[18], data_input_load->ObjX[19],
    data_input_load->ObjY[0], data_input_load->ObjY[1],
    data_input_load->ObjY[2], data_input_load->ObjY[3],
    data_input_load->ObjY[4], data_input_load->ObjY[5],
    data_input_load->ObjY[6], data_input_load->ObjY[7],
    data_input_load->ObjY[8], data_input_load->ObjY[9],
    data_input_load->ObjY[10], data_input_load->ObjY[11],
    data_input_load->ObjY[12], data_input_load->ObjY[13],
    data_input_load->ObjY[14], data_input_load->ObjY[15],
    data_input_load->ObjY[16], data_input_load->ObjY[17],
    data_input_load->ObjY[18], data_input_load->ObjY[19],
    data_input_load->ObjLen[0], data_input_load->ObjLen[1],
    data_input_load->ObjLen[2], data_input_load->ObjLen[3],
    data_input_load->ObjLen[4], data_input_load->ObjLen[5],
    data_input_load->ObjLen[6], data_input_load->ObjLen[7],
    data_input_load->ObjLen[8], data_input_load->ObjLen[9],
    data_input_load->ObjLen[10], data_input_load->ObjLen[11],
    data_input_load->ObjLen[12], data_input_load->ObjLen[13],
    data_input_load->ObjLen[14], data_input_load->ObjLen[15],
    data_input_load->ObjLen[16], data_input_load->ObjLen[17],
    data_input_load->ObjLen[18], data_input_load->ObjLen[19],
    data_input_load->ObjWidth[0], data_input_load->ObjWidth[1],
    data_input_load->ObjWidth[2], data_input_load->ObjWidth[3],
    data_input_load->ObjWidth[4], data_input_load->ObjWidth[5],
    data_input_load->ObjWidth[6], data_input_load->ObjWidth[7],
    data_input_load->ObjWidth[8], data_input_load->ObjWidth[9],
    data_input_load->ObjWidth[10], data_input_load->ObjWidth[11],
    data_input_load->ObjWidth[12], data_input_load->ObjWidth[13],
    data_input_load->ObjWidth[14], data_input_load->ObjWidth[15],
    data_input_load->ObjWidth[16], data_input_load->ObjWidth[17],
    data_input_load->ObjWidth[18], data_input_load->ObjWidth[19],
    data_input_load->ObjVel[0], data_input_load->ObjVel[1],
    data_input_load->ObjVel[2], data_input_load->ObjVel[3],
    data_input_load->ObjVel[4], data_input_load->ObjVel[5],
    data_input_load->ObjVel[6], data_input_load->ObjVel[7],
    data_input_load->ObjVel[8], data_input_load->ObjVel[9],
    data_input_load->ObjVel[10], data_input_load->ObjVel[11],
    data_input_load->ObjVel[12], data_input_load->ObjVel[13],
    data_input_load->ObjVel[14], data_input_load->ObjVel[15],
    data_input_load->ObjVel[16], data_input_load->ObjVel[17],
    data_input_load->ObjVel[18], data_input_load->ObjVel[19],
    data_input_load->ObjCourse[0], data_input_load->ObjCourse[1],
    data_input_load->ObjCourse[2], data_input_load->ObjCourse[3],
    data_input_load->ObjCourse[4], data_input_load->ObjCourse[5],
    data_input_load->ObjCourse[6], data_input_load->ObjCourse[7],
    data_input_load->ObjCourse[8], data_input_load->ObjCourse[9],
    data_input_load->ObjCourse[10], data_input_load->ObjCourse[11],
    data_input_load->ObjCourse[12], data_input_load->ObjCourse[13],
    data_input_load->ObjCourse[14], data_input_load->ObjCourse[15],
    data_input_load->ObjCourse[16], data_input_load->ObjCourse[17],
    data_input_load->ObjCourse[18], data_input_load->ObjCourse[19],
    data_input_load->LaneWidth, data_input_load->LatOffsLineR,
    data_input_load->LatOffsLineL, data_input_load->LaneHeading,
    data_input_load->LaneCrvt, data_input_load->AdasisCurvatureNr,
    data_input_load->AdasisCurvatureDist[0],
    data_input_load->AdasisCurvatureDist[1],
    data_input_load->AdasisCurvatureDist[2],
    data_input_load->AdasisCurvatureDist[3],
    data_input_load->AdasisCurvatureDist[4],
    data_input_load->AdasisCurvatureDist[5],
    data_input_load->AdasisCurvatureDist[6],
    data_input_load->AdasisCurvatureDist[7],
    data_input_load->AdasisCurvatureDist[8],
    data_input_load->AdasisCurvatureDist[9],
    data_input_load->AdasisCurvatureDist[10],
    data_input_load->AdasisCurvatureDist[11],
    data_input_load->AdasisCurvatureDist[12],
    data_input_load->AdasisCurvatureDist[13],
    data_input_load->AdasisCurvatureDist[14],
    data_input_load->AdasisCurvatureDist[15],
    data_input_load->AdasisCurvatureDist[16],
    data_input_load->AdasisCurvatureDist[17],
    data_input_load->AdasisCurvatureDist[18],
    data_input_load->AdasisCurvatureDist[19],
    data_input_load->AdasisCurvatureDist[20],
    data_input_load->AdasisCurvatureDist[21],
    data_input_load->AdasisCurvatureDist[22],
    data_input_load->AdasisCurvatureDist[23],
    data_input_load->AdasisCurvatureDist[24],
    data_input_load->AdasisCurvatureDist[25],
    data_input_load->AdasisCurvatureDist[26],
    data_input_load->AdasisCurvatureDist[27],
    data_input_load->AdasisCurvatureDist[28],
    data_input_load->AdasisCurvatureDist[29],
    data_input_load->AdasisCurvatureDist[30],
    data_input_load->AdasisCurvatureDist[31],
    data_input_load->AdasisCurvatureDist[32],
    data_input_load->AdasisCurvatureDist[33],
    data_input_load->AdasisCurvatureDist[34],
    data_input_load->AdasisCurvatureDist[35],
    data_input_load->AdasisCurvatureDist[36],
    data_input_load->AdasisCurvatureDist[37],
    data_input_load->AdasisCurvatureDist[38],
    data_input_load->AdasisCurvatureDist[39],
    data_input_load->AdasisCurvatureDist[40],
    data_input_load->AdasisCurvatureDist[41],
    data_input_load->AdasisCurvatureDist[42],
    data_input_load->AdasisCurvatureDist[43],
    data_input_load->AdasisCurvatureDist[44],
    data_input_load->AdasisCurvatureDist[45],
    data_input_load->AdasisCurvatureDist[46],
    data_input_load->AdasisCurvatureDist[47],
    data_input_load->AdasisCurvatureDist[48],
    data_input_load->AdasisCurvatureDist[49],
    data_input_load->AdasisCurvatureDist[50],
    data_input_load->AdasisCurvatureDist[51],
    data_input_load->AdasisCurvatureDist[52],
    data_input_load->AdasisCurvatureDist[53],
    data_input_load->AdasisCurvatureDist[54],
    data_input_load->AdasisCurvatureDist[55],
    data_input_load->AdasisCurvatureDist[56],
    data_input_load->AdasisCurvatureDist[57],
    data_input_load->AdasisCurvatureDist[58],
    data_input_load->AdasisCurvatureDist[59],
    data_input_load->AdasisCurvatureDist[60],
    data_input_load->AdasisCurvatureDist[61],
    data_input_load->AdasisCurvatureDist[62],
    data_input_load->AdasisCurvatureDist[63],
    data_input_load->AdasisCurvatureDist[64],
    data_input_load->AdasisCurvatureDist[65],
    data_input_load->AdasisCurvatureDist[66],
    data_input_load->AdasisCurvatureDist[67],
    data_input_load->AdasisCurvatureDist[68],
    data_input_load->AdasisCurvatureDist[69],
    data_input_load->AdasisCurvatureDist[70],
    data_input_load->AdasisCurvatureDist[71],
    data_input_load->AdasisCurvatureDist[72],
    data_input_load->AdasisCurvatureDist[73],
    data_input_load->AdasisCurvatureDist[74],
    data_input_load->AdasisCurvatureDist[75],
    data_input_load->AdasisCurvatureDist[76],
    data_input_load->AdasisCurvatureDist[77],
    data_input_load->AdasisCurvatureDist[78],
    data_input_load->AdasisCurvatureDist[79],
    data_input_load->AdasisCurvatureDist[80],
    data_input_load->AdasisCurvatureDist[81],
    data_input_load->AdasisCurvatureDist[82],
    data_input_load->AdasisCurvatureDist[83],
    data_input_load->AdasisCurvatureDist[84],
    data_input_load->AdasisCurvatureDist[85],
    data_input_load->AdasisCurvatureDist[86],
    data_input_load->AdasisCurvatureDist[87],
    data_input_load->AdasisCurvatureDist[88],
    data_input_load->AdasisCurvatureDist[89],
    data_input_load->AdasisCurvatureDist[90],
    data_input_load->AdasisCurvatureDist[91],
    data_input_load->AdasisCurvatureDist[92],
    data_input_load->AdasisCurvatureDist[93],
    data_input_load->AdasisCurvatureDist[94],
    data_input_load->AdasisCurvatureDist[95],
    data_input_load->AdasisCurvatureDist[96],
    data_input_load->AdasisCurvatureDist[97],
    data_input_load->AdasisCurvatureDist[98],
    data_input_load->AdasisCurvatureDist[99],
    data_input_load->AdasisCurvatureValues[0],
    data_input_load->AdasisCurvatureValues[1],
    data_input_load->AdasisCurvatureValues[2],
    data_input_load->AdasisCurvatureValues[3],
    data_input_load->AdasisCurvatureValues[4],
    data_input_load->AdasisCurvatureValues[5],
    data_input_load->AdasisCurvatureValues[6],
    data_input_load->AdasisCurvatureValues[7],
    data_input_load->AdasisCurvatureValues[8],
    data_input_load->AdasisCurvatureValues[9],
    data_input_load->AdasisCurvatureValues[10],
    data_input_load->AdasisCurvatureValues[11],
    data_input_load->AdasisCurvatureValues[12],
    data_input_load->AdasisCurvatureValues[13],
    data_input_load->AdasisCurvatureValues[14],
    data_input_load->AdasisCurvatureValues[15],
    data_input_load->AdasisCurvatureValues[16],
    data_input_load->AdasisCurvatureValues[17],
    data_input_load->AdasisCurvatureValues[18],
    data_input_load->AdasisCurvatureValues[19],
    data_input_load->AdasisCurvatureValues[20],
    data_input_load->AdasisCurvatureValues[21],
    data_input_load->AdasisCurvatureValues[22],
    data_input_load->AdasisCurvatureValues[23],
    data_input_load->AdasisCurvatureValues[24],
    data_input_load->AdasisCurvatureValues[25],
    data_input_load->AdasisCurvatureValues[26],
    data_input_load->AdasisCurvatureValues[27],
    data_input_load->AdasisCurvatureValues[28],
    data_input_load->AdasisCurvatureValues[29],
    data_input_load->AdasisCurvatureValues[30],
    data_input_load->AdasisCurvatureValues[31],
    data_input_load->AdasisCurvatureValues[32],
    data_input_load->AdasisCurvatureValues[33],
    data_input_load->AdasisCurvatureValues[34],
    data_input_load->AdasisCurvatureValues[35],
    data_input_load->AdasisCurvatureValues[36],
    data_input_load->AdasisCurvatureValues[37],
    data_input_load->AdasisCurvatureValues[38],
    data_input_load->AdasisCurvatureValues[39],
    data_input_load->AdasisCurvatureValues[40],
    data_input_load->AdasisCurvatureValues[41],
    data_input_load->AdasisCurvatureValues[42],
    data_input_load->AdasisCurvatureValues[43],
    data_input_load->AdasisCurvatureValues[44],
    data_input_load->AdasisCurvatureValues[45],
    data_input_load->AdasisCurvatureValues[46],
    data_input_load->AdasisCurvatureValues[47],
    data_input_load->AdasisCurvatureValues[48],
    data_input_load->AdasisCurvatureValues[49],
    data_input_load->AdasisCurvatureValues[50],
    data_input_load->AdasisCurvatureValues[51],
    data_input_load->AdasisCurvatureValues[52],
    data_input_load->AdasisCurvatureValues[53],
    data_input_load->AdasisCurvatureValues[54],
    data_input_load->AdasisCurvatureValues[55],
    data_input_load->AdasisCurvatureValues[56],
    data_input_load->AdasisCurvatureValues[57],
    data_input_load->AdasisCurvatureValues[58],
    data_input_load->AdasisCurvatureValues[59],
    data_input_load->AdasisCurvatureValues[60],
    data_input_load->AdasisCurvatureValues[61],
    data_input_load->AdasisCurvatureValues[62],
    data_input_load->AdasisCurvatureValues[63],
    data_input_load->AdasisCurvatureValues[64],
    data_input_load->AdasisCurvatureValues[65],
    data_input_load->AdasisCurvatureValues[66],
    data_input_load->AdasisCurvatureValues[67],
    data_input_load->AdasisCurvatureValues[68],
    data_input_load->AdasisCurvatureValues[69],
    data_input_load->AdasisCurvatureValues[70],
    data_input_load->AdasisCurvatureValues[71],
    data_input_load->AdasisCurvatureValues[72],
    data_input_load->AdasisCurvatureValues[73],
    data_input_load->AdasisCurvatureValues[74],
    data_input_load->AdasisCurvatureValues[75],
    data_input_load->AdasisCurvatureValues[76],
    data_input_load->AdasisCurvatureValues[77],
    data_input_load->AdasisCurvatureValues[78],
    data_input_load->AdasisCurvatureValues[79],
    data_input_load->AdasisCurvatureValues[80],
    data_input_load->AdasisCurvatureValues[81],
    data_input_load->AdasisCurvatureValues[82],
    data_input_load->AdasisCurvatureValues[83],
    data_input_load->AdasisCurvatureValues[84],
    data_input_load->AdasisCurvatureValues[85],
    data_input_load->AdasisCurvatureValues[86],
    data_input_load->AdasisCurvatureValues[87],
    data_input_load->AdasisCurvatureValues[88],
    data_input_load->AdasisCurvatureValues[89],
    data_input_load->AdasisCurvatureValues[90],
    data_input_load->AdasisCurvatureValues[91],
    data_input_load->AdasisCurvatureValues[92],
    data_input_load->AdasisCurvatureValues[93],
    data_input_load->AdasisCurvatureValues[94],
    data_input_load->AdasisCurvatureValues[95],
    data_input_load->AdasisCurvatureValues[96],
    data_input_load->AdasisCurvatureValues[97],
    data_input_load->AdasisCurvatureValues[98],
    data_input_load->AdasisCurvatureValues[99]);
fprintf(fp_input,
        "%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%d\t%d\t%d\t%d\t%d\t%d\t%"
        "d\t%d\t%d\t%d\t%d\t%f\t%d\t%f\t%d\t%f\t%d\t%f\n",
        data_input_load->AdasisSpeedLimitNr,
        data_input_load->AdasisSpeedLimitDist[0],
        data_input_load->AdasisSpeedLimitDist[1],
        data_input_load->AdasisSpeedLimitDist[2],
        data_input_load->AdasisSpeedLimitDist[3],
        data_input_load->AdasisSpeedLimitDist[4],
        data_input_load->AdasisSpeedLimitDist[5],
        data_input_load->AdasisSpeedLimitDist[6],
        data_input_load->AdasisSpeedLimitDist[7],
        data_input_load->AdasisSpeedLimitDist[8],
        data_input_load->AdasisSpeedLimitDist[9],
        data_input_load->AdasisSpeedLimitValues[0],
        data_input_load->AdasisSpeedLimitValues[1],
        data_input_load->AdasisSpeedLimitValues[2],
        data_input_load->AdasisSpeedLimitValues[3],
        data_input_load->AdasisSpeedLimitValues[4],
        data_input_load->AdasisSpeedLimitValues[5],
        data_input_load->AdasisSpeedLimitValues[6],
        data_input_load->AdasisSpeedLimitValues[7],
        data_input_load->AdasisSpeedLimitValues[8],
        data_input_load->AdasisSpeedLimitValues[9],
        data_input_load->NrTrfLights, data_input_load->TrfLightDist,
        data_input_load->TrfLightCurrState,
        data_input_load->TrfLightFirstTimeToChange,
        data_input_load->TrfLightFirstNextState,
        data_input_load->TrfLightSecondTimeToChange,
        data_input_load->TrfLightSecondNextState,
        data_input_load->TrfLightThirdTimeToChange);

 }

 void StructPrinterHeaderOut( const output_data_str *data_input_load, FILE *fp_input ) {
   
fprintf(
    fp_input,
    "ID\tVersion\tCycleNumber\tECUupTime\tStatus\tNTrajectoryPoints\tTrajectory"
    "PointITime001\tTrajectoryPointITime002\tTrajectoryPointITime003\tTrajector"
    "yPointITime004\tTrajectoryPointITime005\tTrajectoryPointITime006\tTrajecto"
    "ryPointITime007\tTrajectoryPointITime008\tTrajectoryPointITime009\tTraject"
    "oryPointITime010\tTrajectoryPointITime011\tTrajectoryPointITime012\tTrajec"
    "toryPointITime013\tTrajectoryPointITime014\tTrajectoryPointITime015\tTraje"
    "ctoryPointITime016\tTrajectoryPointITime017\tTrajectoryPointITime018\tTraj"
    "ectoryPointITime019\tTrajectoryPointITime020\tTrajectoryPointITime021\tTra"
    "jectoryPointITime022\tTrajectoryPointITime023\tTrajectoryPointIX001\tTraje"
    "ctoryPointIX002\tTrajectoryPointIX003\tTrajectoryPointIX004\tTrajectoryPoi"
    "ntIX005\tTrajectoryPointIX006\tTrajectoryPointIX007\tTrajectoryPointIX008"
    "\tTrajectoryPointIX009\tTrajectoryPointIX010\tTrajectoryPointIX011\tTrajec"
    "toryPointIX012\tTrajectoryPointIX013\tTrajectoryPointIX014\tTrajectoryPoin"
    "tIX015\tTrajectoryPointIX016\tTrajectoryPointIX017\tTrajectoryPointIX018\t"
    "TrajectoryPointIX019\tTrajectoryPointIX020\tTrajectoryPointIX021\tTrajecto"
    "ryPointIX022\tTrajectoryPointIX023\tTrajectoryPointIY001\tTrajectoryPointI"
    "Y002\tTrajectoryPointIY003\tTrajectoryPointIY004\tTrajectoryPointIY005\tTr"
    "ajectoryPointIY006\tTrajectoryPointIY007\tTrajectoryPointIY008\tTrajectory"
    "PointIY009\tTrajectoryPointIY010\tTrajectoryPointIY011\tTrajectoryPointIY0"
    "12\tTrajectoryPointIY013\tTrajectoryPointIY014\tTrajectoryPointIY015\tTraj"
    "ectoryPointIY016\tTrajectoryPointIY017\tTrajectoryPointIY018\tTrajectoryPo"
    "intIY019\tTrajectoryPointIY020\tTrajectoryPointIY021\tTrajectoryPointIY022"
    "\tTrajectoryPointIY023\tTargetSpeed\tRequestedAcc\tManoeuverType\tRequeste"
    "dSteerWhlAg\n");

 }

 void StructPrinterDataOut( const output_data_str *data_input_load, FILE *fp_input ) {
   
fprintf(fp_input,
        "%d\t%d\t%d\t%f\t%d\t%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%"
        "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%"
        "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%"
        "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%"
        "f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%d\t%f\n",
        data_input_load->ID, data_input_load->Version,
        data_input_load->CycleNumber, data_input_load->ECUupTime,
        data_input_load->Status, data_input_load->NTrajectoryPoints,
        data_input_load->TrajectoryPointITime[0],
        data_input_load->TrajectoryPointITime[1],
        data_input_load->TrajectoryPointITime[2],
        data_input_load->TrajectoryPointITime[3],
        data_input_load->TrajectoryPointITime[4],
        data_input_load->TrajectoryPointITime[5],
        data_input_load->TrajectoryPointITime[6],
        data_input_load->TrajectoryPointITime[7],
        data_input_load->TrajectoryPointITime[8],
        data_input_load->TrajectoryPointITime[9],
        data_input_load->TrajectoryPointITime[10],
        data_input_load->TrajectoryPointITime[11],
        data_input_load->TrajectoryPointITime[12],
        data_input_load->TrajectoryPointITime[13],
        data_input_load->TrajectoryPointITime[14],
        data_input_load->TrajectoryPointITime[15],
        data_input_load->TrajectoryPointITime[16],
        data_input_load->TrajectoryPointITime[17],
        data_input_load->TrajectoryPointITime[18],
        data_input_load->TrajectoryPointITime[19],
        data_input_load->TrajectoryPointITime[20],
        data_input_load->TrajectoryPointITime[21],
        data_input_load->TrajectoryPointITime[22],
        data_input_load->TrajectoryPointIX[0],
        data_input_load->TrajectoryPointIX[1],
        data_input_load->TrajectoryPointIX[2],
        data_input_load->TrajectoryPointIX[3],
        data_input_load->TrajectoryPointIX[4],
        data_input_load->TrajectoryPointIX[5],
        data_input_load->TrajectoryPointIX[6],
        data_input_load->TrajectoryPointIX[7],
        data_input_load->TrajectoryPointIX[8],
        data_input_load->TrajectoryPointIX[9],
        data_input_load->TrajectoryPointIX[10],
        data_input_load->TrajectoryPointIX[11],
        data_input_load->TrajectoryPointIX[12],
        data_input_load->TrajectoryPointIX[13],
        data_input_load->TrajectoryPointIX[14],
        data_input_load->TrajectoryPointIX[15],
        data_input_load->TrajectoryPointIX[16],
        data_input_load->TrajectoryPointIX[17],
        data_input_load->TrajectoryPointIX[18],
        data_input_load->TrajectoryPointIX[19],
        data_input_load->TrajectoryPointIX[20],
        data_input_load->TrajectoryPointIX[21],
        data_input_load->TrajectoryPointIX[22],
        data_input_load->TrajectoryPointIY[0],
        data_input_load->TrajectoryPointIY[1],
        data_input_load->TrajectoryPointIY[2],
        data_input_load->TrajectoryPointIY[3],
        data_input_load->TrajectoryPointIY[4],
        data_input_load->TrajectoryPointIY[5],
        data_input_load->TrajectoryPointIY[6],
        data_input_load->TrajectoryPointIY[7],
        data_input_load->TrajectoryPointIY[8],
        data_input_load->TrajectoryPointIY[9],
        data_input_load->TrajectoryPointIY[10],
        data_input_load->TrajectoryPointIY[11],
        data_input_load->TrajectoryPointIY[12],
        data_input_load->TrajectoryPointIY[13],
        data_input_load->TrajectoryPointIY[14],
        data_input_load->TrajectoryPointIY[15],
        data_input_load->TrajectoryPointIY[16],
        data_input_load->TrajectoryPointIY[17],
        data_input_load->TrajectoryPointIY[18],
        data_input_load->TrajectoryPointIY[19],
        data_input_load->TrajectoryPointIY[20],
        data_input_load->TrajectoryPointIY[21],
        data_input_load->TrajectoryPointIY[22], data_input_load->TargetSpeed,
        data_input_load->RequestedAcc, data_input_load->ManoeuverType,
        data_input_load->RequestedSteerWhlAg);

 }

 #ifdef __cplusplus
 }
 #endif

