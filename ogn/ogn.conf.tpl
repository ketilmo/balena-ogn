RF:
{ 
  #Device   = 0;            # SDR selection by device index, can be verified with "sudo rtl_eeprom -d 0" or "-d 1", ...
  #DeviceSerial = ;   # SDR selection by serial number (as an alternative)
  ${OGN_DEVICE_TPL}; 
  FreqCorr = +0;          # [ppm] big black/blue R820T(2) sticks have 40-80ppm correction factors, measure it with gsm_scan
                           # sticks with TCXO: silver/orange have near zero frequency correction and you can ommit this parameter
  SampleRate = 2.0;        # [MHz] 1.0 or 2.0MHz, a bit more CPU is needed to run 2MHz but if you want to capture PilotAware you need it

                           # You can ommit the whole GSM section for sticks with TCXO
  GSM:                     # for frequency calibration based on GSM signals
  { CenterFreq  = 948.2;   # [MHz] find the best GSM frequency with gsm_scan
    Gain        =  40.0;   # [dB]  RF input gain, you normally don't need the full gain
  } ;

  OGN:
  { CenterFreq = 868.8;    # [MHz] with 868.8MHz and 2MHz bandwidth you can capture all systems: FLARM/OGN/FANET/PilotAware
    Gain       =  50.0;    # [dB]  Normally use full gain, unless intermodulation occurs of you run with an LNA, then you need to find best value
  } ;

} ;

Demodulator:             # this section can be ommited as the defaults are reasonable
{ ScanMargin = 30.0;     # [kHz] frequency tolerance for reception, most signals should normally be +/-15kHz but some are more off frequency
  DetectSNR  = 11.0;     # [dB]  detection threshold for FLARM/OGN
  MergeServer = "flarm-collector.opensky-network.org:20002"; 
} ;

Position:
{ Latitude   =   ${LAT}; # [deg] Antenna coordinates
  Longitude  =   ${LON}; # [deg]
  Altitude   =   ${ALT}; # [m]   Altitude AMSL (not critical)
  # GeoidSepar =         45; # [m]   Geoid separation to convert from HAE to MSL
} ;                        # for best results ommit GeoidSepar and download the WW15MGH.DAC file with getEGM.sh script

APRS:
{ Call = "${OGN_CALLSIGN}";     # APRS callsign (max. 9 characters) set you own name: airfield ID or locaiion name
                         # Please refer to http://wiki.glidernet.org/receiver-naming-convention
} ;

HTTP:
{
  Port = 8082;
};

FRB:
{
  DetectSNR = 10.0;
  Server = "ogn3.glidernet.org:50000";
};