RF:
{ 
  #Device   = 0;            # SDR selection by device index, can be verified with "sudo rtl_eeprom -d 0" or "-d 1", ...
  #DeviceSerial = ;   # SDR selection by serial number (as an alternative)
  ${OGN_DEVICE_TPL}; 
  FreqCorr =  ${OGN_FREQCORR};          # [ppm] big black/blue R820T(2) sticks have 40-80ppm correction factors, measure it with gsm_scan
                           # sticks with TCXO: silver/orange have near zero frequency correction and you can ommit this parameter
  SampleRate = ${OGN_SAMPLERATE};        # [MHz] 1.0 or 2.0MHz, a bit more CPU is needed to run 2MHz but if you want to capture PilotAware you need it
  BiasTee  = ${OGN_BIASTEE};    

                           # You can ommit the whole GSM section for sticks with TCXO
  GSM:                     # for frequency calibration based on GSM signals
  { CenterFreq  = ${OGN_GSM_CENTERFREQ};   # [MHz] find the best GSM frequency with gsm_scan
    Gain        = ${OGN_GSM_GAIN};   # [dB]  RF input gain, you normally don't need the full gain
  } ;

  OGN:
  { CenterFreq = ${OGN_CENTERFREQ};    # [MHz] with 868.8MHz and 2MHz bandwidth you can capture all systems: FLARM/OGN/FANET/PilotAware
    Gain       = ${OGN_GAIN};    # [dB]  Normally use full gain, unless intermodulation occurs of you run with an LNA, then you need to find best value
    MinNoise   = ${OGN_MINNOISE};    # default minimum allowed noise, you can ommit this parameter
    MaxNoise   = ${OGN_MAXNOISE};    # default maximum allowed noise, you can ommit this parameter
  } ;

} ;

Demodulator:             # this section can be ommited as the defaults are reasonable
{ ScanMargin = ${OGN_DEMODULATOR_SCANMARGIN};     # [kHz] frequency tolerance for reception, most signals should normally be +/-15kHz but some are more off frequency
  DetectSNR  = ${OGN_DEMODULATOR_DETECTSNR};     # [dB]  detection threshold for FLARM/OGN
  ${OGN_OPENSKY_ENABLED_TPL}MergeServer = "flarm-collector.opensky-network.org:20002"; # Feed data to OpenSky Network
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

ADSB:                      # feeding Open Glider Network with ADS-B traffic
{
  ${OGN_ADSB_ENABLED_TPL}AVR = "${OGN_ADSB_RECEIVER_HOST}:${OGN_ADSB_RECEIVER_PORT}"; # disable this line if you DO NOT WANT to feed Open Glider Network with ADS-B traffic
  MaxAlt = ${OGN_ADSB_MAXALT};          # [ft] default maximum altitude, feel free to increase but this will potentially increase your internet traffic
};

HTTP:
{
  Port = 8082;
};

FRB:
{
  DetectSNR = 10.0;
  Server = "ogn3.glidernet.org:50000";
};