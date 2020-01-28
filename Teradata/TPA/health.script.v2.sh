#! /bin/bash


       ## Intro

        # Script is currently only used on Teradata TPA nodes and some TMS servers.
        # Script gatheres some system info and faults, and output is in HTML format.



       ## Variables

        # Version info.
version=02.00.01.00

        # Temp folder for temp data.
tempfolder=/tmp/hscrypt.v2
logfile=/var/log/health.script.log
installfolder=/home/support/system.health.scripts
dumpfolder=/home/support/system.health.scripts/export
dumpfile=/home/support/system.health.scripts/export/$(cat /etc/HOSTNAME).system.health.report.log
textfile=/home/support/system.health.scripts/export/$(cat /etc/HOSTNAME).system.health.report.txt

        # SCP info.
scpuser=root
scpipaddress=10.144.179.102
scpremotefolder=/home/support/system.health.scripts/import/


       ## Run info.
echo " This script has no real output..."
echo " It is intended to be run from CRON..."
echo -e " You may look at $textfile after script completes, for a text version of output..."
echo -e " Or look at logfile $logfile, for errors..."


       ## Start of script.

        # Clear tmp folder if exist - stale data.
if [ -d $tempfolder ]
         then rm -R $tempfolder
fi

        # Create tmp folder.
if [ ! -d $tempfolder ]
     then mkdir $tempfolder
fi

        # Create log file if not exist - no clearing of file.
if [ -f $logfile ]
     then echo "$(date) :" >> $logfile ; \
     else touch $logfile ; \
          chmod 640 $logfile ; \
          echo "$(date) : " >> $logfile
fi

        # Create Text and HTML outputs.
echo " " > $dumpfile
echo " " > $textfile

        ## Start script logging
echo "$(date) : *** Script started and logging..." >> $logfile

        # Pre runs.
        # These scrips take long, so running them now in background to eleviate delays.
/opt/teradata/gsctools/bin/find_cmics > $tempfolder/cmics.found.txt &


        # Collect system type from TDput.
servertype=$(cat /etc/opt/teradata/TDput/node_info.txt | grep 'NODETYPE=' | \
     cut -d'=' -f2)
        # Logger
     echo "$(date) : Node type is $servertype." >> $logfile

        # This created the dumpfile output in HTML format.
echo -e " <HTML> \n" >> $dumpfile
echo -e "    <HEAD> \n" >> $dumpfile
echo -e "       <meta http-equiv='Content-Type' content='text/html;charset=ISO-8859-1'> \n" >> $dumpfile
echo -e "       <STYLE> \n" >> $dumpfile

        # Font and layout of text body and headers.
echo -e "          .roundedBorderHeader { \n" >> $dumpfile
echo -e "              font-family: Arial; \n" >> $dumpfile
echo -e "              font-size: 40px; \n" >> $dumpfile
echo -e "              color: white; \n" >> $dumpfile
echo -e "              font-weight: bold; \n" >> $dumpfile
echo -e "              height: 50px; \n" >> $dumpfile
echo -e "              min-width: 1000; \n" >> $dumpfile
echo -e "              border: 1px solid orange; \n" >> $dumpfile
echo -e "              border-radius: 10px; \n" >> $dumpfile
echo -e "              padding: 2px; \n" >> $dumpfile
echo -e "              background-color: orangered; \n" >> $dumpfile
echo -e "              line-height: 45px; \n" >> $dumpfile
echo -e "              } \n" >> $dumpfile
echo -e "          .roundedBorderInfo { \n" >> $dumpfile
echo -e "              margin: auto; \n" >> $dumpfile
echo -e "              font-family: Courier New; \n" >> $dumpfile
echo -e "              font-size: 10px; \n" >> $dumpfile
echo -e "              padding-top: 5px; \n" >> $dumpfile
echo -e "              padding-right: 5px; \n" >> $dumpfile
echo -e "              padding-bottom: 5px; \n" >> $dumpfile
echo -e "              padding-left: 5px; \n" >> $dumpfile
echo -e "              width: 45%; \n" >> $dumpfile
echo -e "              min-width: 1000px; \n" >> $dumpfile
echo -e "              border-style: solid; \n" >> $dumpfile
echo -e "              border-width: 2px; \n" >> $dumpfile
echo -e "              border-color: orange; \n" >> $dumpfile
echo -e "              border-radius: 10px; \n" >> $dumpfile
echo -e "              align-content: center; \n" >> $dumpfile
echo -e "              } \n" >> $dumpfile
echo -e "          .roundedButtonVMS { \n" >> $dumpfile
echo -e "              margin: auto; \n" >> $dumpfile
echo -e "              font-family: Courier New; \n" >> $dumpfile
echo -e "              font-size: 10px; \n" >> $dumpfile
echo -e "              padding-top: 5px; \n" >> $dumpfile
echo -e "              padding-right: 5px; \n" >> $dumpfile
echo -e "              padding-bottom: 5px; \n" >> $dumpfile
echo -e "              padding-left: 5px; \n" >> $dumpfile
echo -e "              max-width: 250px; \n" >> $dumpfile
echo -e "              min-width: 250px; \n" >> $dumpfile
echo -e "              max-height: 100px; \n" >> $dumpfile
echo -e "              border-style: solid; \n" >> $dumpfile
echo -e "              border-width: 2px; \n" >> $dumpfile
echo -e "              border-color: blue; \n" >> $dumpfile
echo -e "              border-radius: 10px; \n" >> $dumpfile
echo -e "              align-content: center; \n" >> $dumpfile
echo -e "              line-height: 10px; \n" >> $dumpfile
                       # Disabling hyperlinks.
echo -e "              pointer-events: none; \n" >> $dumpfile
echo -e "              cursor: default; \n" >> $dumpfile
echo -e "              } \n" >> $dumpfile
echo -e "          .tableWithBorder { \n" >> $dumpfile
echo -e "              border: 1px solid black; \n" >> $dumpfile
echo -e "              width: 30%; \n" >> $dumpfile
echo -e "              } \n" >> $dumpfile
echo -e "          .tableRowForm { \n" >> $dumpfile
echo -e "              transform: scaleY(-1); \n" >> $dumpfile
echo -e "              } \n" >> $dumpfile
echo -e "          div.a1 { \n" >> $dumpfile
echo -e "              line-height: normal; \n" >> $dumpfile
echo -e "              font-family: Courier; \n" >> $dumpfile
echo -e "              font-style: normal; \n" >> $dumpfile
echo -e "              font-size: 12px; \n" >> $dumpfile
echo -e "              font-weight: bold; \n" >> $dumpfile
echo -e "              } \n" >> $dumpfile
echo -e "       </STYLE> \n" >> $dumpfile
echo -e "    </HEAD> \n" >> $dumpfile
echo -e "    <BODY> \n" >> $dumpfile

        # Header
echo -e "       <div class='roundedBorderHeader'> \n" >> $dumpfile
echo -e "       <center> System Health Report </center> \n" >> $dumpfile
echo -e "       </div> \n" >> $dumpfile

        # Scrypt header
echo -e " \n" >> $dumpfile
echo -e "System Health Report for - $(cat /etc/HOSTNAME | cut -d'_' -f1): \n" >> $dumpfile
echo -e "Version = $version \n" >> $dumpfile
echo -e " \n" >> $dumpfile

        # Table for System Info and System Summary.
        # First check if system is a Teradata TPA node.
if [ "$servertype" = "TPA" ]
     then (

        # Only run this if the above "if" command is true.
echo -e "       <div class='roundedBorderInfo'> \n" >> $dumpfile
echo -e "       <table style='width:100%'> \n" >> $dumpfile
echo -e "           <tr> \n" >> $dumpfile
echo -e "               <td style='width:70%'> \n" >> $dumpfile

        # System Info header

        # Info - collecting info from machinetype and greping fields out
echo -e "       <pre> \n" >> $dumpfile
echo -e "System info: \n" | tee -a $dumpfile $textfile > /dev/null
     /opt/teradata/gsctools/bin/machinetype | grep 'Model:' -A9 > $tempfolder/shs.systeminfo.log
          if [ ! -f $tempfolder/shs.systeminfo.log ]
               then echo "$(date) : Could not create shs.systeminfo.log." >> $logfile
          fi
        # Grep for outputs and use tee to send output to tw files.
echo -e "$(cat $tempfolder/shs.systeminfo.log | grep 'Model:') \n" | tee -a $dumpfile $textfile > /dev/null
echo -e "$(cat $tempfolder/shs.systeminfo.log | grep 'Productid:') \n" | \
     tee -a $dumpfile $textfile $tempfolder/server.make.log > /dev/null
echo -e "$(cat $tempfolder/shs.systeminfo.log | grep 'Node:') \n" | tee -a $dumpfile $textfile > /dev/null
echo -e "$(cat $tempfolder/shs.systeminfo.log | grep 'Memory:') \n" | tee -a $dumpfile $textfile > /dev/null
echo -e "$(cat $tempfolder/shs.systeminfo.log | grep 'Drivers:') \n" | tee -a $dumpfile $textfile > /dev/null
echo -e "$(cat $tempfolder/shs.systeminfo.log | grep 'OS:') \n" | tee -a $dumpfile $textfile > /dev/null
echo -e " \n" >> $dumpfile
echo -e "       </pre> \n" >> $dumpfile

        # Close System Info header
echo -e "              </td> \n" >> $dumpfile

        # System Summary header
echo -e "              <td style='width:30%'> \n" >> $dumpfile

        # Summary - collecting info from chk_all script (part of GSCTOOLS)         # Sending output to file and greping info
        # tee is used to send output to two files
echo -e "       <pre> \n" >> $dumpfile
echo -e "System Summary: \n" | tee -a $dumpfile $textfile > /dev/null
     /opt/teradata/gsctools/bin/chk_all > /dev/null
     head -30 /var/opt/teradata/gsctools/chk_all/chk_all.txt | grep 'SYSTEM SUMMARY:' -A15 > $tempfolder/chk_all.script.out.log
         if [ ! -f $tempfolder/chk_all.script.out.log ]
              then echo "$(date) : Could not create chk_all.script.out.log." >> $logfile
         fi
echo -e "$(cat $tempfolder/chk_all.script.out.log | grep 'SiteID:') \n" | tee -a $dumpfile $textfile > /dev/null
echo -e "$(cat $tempfolder/chk_all.script.out.log | grep 'System Name:') \n" | tee -a $dumpfile $textfile > /dev/null
echo -e "$(cat $tempfolder/chk_all.script.out.log | grep 'DBS Version:') \n" | tee -a $dumpfile $textfile > /dev/null
echo -e "$(cat $tempfolder/chk_all.script.out.log | grep 'PDE Version:') \n" | tee -a $dumpfile $textfile > /dev/null
echo -e "$(cat $tempfolder/chk_all.script.out.log | grep 'Number of Nodes:') \n" | tee -a $dumpfile $textfile > /dev/null
echo -e "$(cat $tempfolder/chk_all.script.out.log | grep 'Number of Cliques:') \n" | tee -a $dumpfile $textfile > /dev/null
echo -e "$(cat $tempfolder/chk_all.script.out.log | grep 'Number of AMPs:') \n" | tee -a $dumpfile $textfile > /dev/null
echo -e "       </pre> \n" >> $dumpfile

        # Close System Summary header.
echo -e "              </td> \n" >> $dumpfile

        # Close table for System Info and System Summary.
echo -e "          </tr> \n" >> $dumpfile
echo -e "       </table> \n" >> $dumpfile
echo -e "       </div> \n" >> $dumpfile

        # Closing the "if" command.
     )
fi

#################################
#### System Type and output #####
#################################


cat /etc/opt/teradata/tdconfig/mpplist | grep byn | awk '{print $1}' > $tempfolder/tpa.mpplist.log
echo -e " <pre> \n" >> $dumpfile
echo -e "List of server(s) in this scripts output... \n" | tee -a $dumpfile $textfile > /dev/null
echo -e "$( cat $tempfolder/tpa.mpplist.log | tr '[:lower:]' '[:upper:]' ) \n" | tee -a $dumpfile $textfile > /dev/null
echo -e " </pre> \n" >> $dumpfile



###########################################
##### All scripts for graphing.       #####
##### CPU data.                       #####
##### Gater system type and then do.  #####
###########################################

if [ $servertype = "TPA" ]
   then (


echo -e "
#!/bin/bash

tempfolder=/tmp/hscrypt.v2
         # Create an array for the 24 hours.
fulldayinhoursarray=( 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 )
        # Then we use array in for loop - we get idle time avarage per hour and devide by 12.
        # Using paste -sd+ to put plus signs inbetween values, and then use bc to do Sum.
   for i in \"\${fulldayinhoursarray[@]}\"
       do echo \$( sar -f /var/log/sa/sa$(date +%d -d yesterday) | \\
           grep \"\$i:\" | head -12 | grep -v CPU | awk '{print \$8}' | \\
           cut -d'.' -f1 | grep -v 'You have' | paste -sd+ | bc ) / 12 | bc
       done > \$tempfolder/\$(cat /etc/HOSTNAME).cpu.data.idle.time.24hours.txt

        # Now subtract 100 from idle time in 'cpu.data.idle.time.24hours.txt' to get cpu usage.
awk '{print \$1}' \$tempfolder/\$(cat /etc/HOSTNAME).cpu.data.idle.time.24hours.txt | \\
   while read linecpuinput
       do let \" cpuusage = 100 - \$linecpuinput \"
           echo \$cpuusage
       done > \$tempfolder/\$(cat /etc/HOSTNAME).cpu.data.usage.time.24hours.txt
rm \$tempfolder/\$(cat /etc/HOSTNAME).cpu.data.idle.time.24hours.txt

        # Closing echo.
        " > $tempfolder/psh.collect.cpu.info.sh

        # Collecting outputs.
chmod 700 $tempfolder/psh.collect.cpu.info.sh
/opt/teradata/tdat/pde/$(/usr/pde/bin/pdepath -i | grep PDE: | cut -d' ' -f2)/bin/psh \
    "mkdir $tempfolder" > /dev/null 2>&1
echo "$(date) : PCL sending psh.collect.cpu.info.sh for execution on all TPA nodes." >> $logfile
/opt/teradata/tdat/pde/$(/usr/pde/bin/pdepath -i | grep PDE: | cut -d' ' -f2)/bin/pcl -send \
    $tempfolder/psh.collect.cpu.info.sh $tempfolder >> $logfile 2>> $logfile
/opt/teradata/tdat/pde/$(/usr/pde/bin/pdepath -i | grep PDE: | cut -d' ' -f2)/bin/psh \
    "$tempfolder/psh.collect.cpu.info.sh" > /dev/null 2>&1

/opt/teradata/tdat/pde/$(/usr/pde/bin/pdepath -i | grep PDE: | cut -d' ' -f2)/bin/psh \
    "cat $tempfolder/*.cpu.data.usage.time.24hours.txt" > $tempfolder/ALL.Nodes.cpu.data.usage.time.24hours.txt

        # Drive Space usage.
/opt/teradata/tdat/pde/$(/usr/pde/bin/pdepath -i | grep PDE: | cut -d' ' -f2)/bin/psh \
    "df -hT" > $tempfolder/ALL.Nodes.disk.space.data.usage.time.24hours.txt

        # Server sensor data.
/opt/teradata/tdat/pde/$(/usr/pde/bin/pdepath -i | grep PDE: | cut -d' ' -f2)/bin/psh \
    "/usr/bin/ipmitool sdr" > $tempfolder/ALL.Nodes.sensor.data.txt

       # Server internal Drive data.
servermake=$(cat $tempfolder/server.make.log | cut -d '=' -f5 | grep .)
if [ $servermake = "INTEL" ]
     then (
/opt/teradata/tdat/pde/$(/usr/pde/bin/pdepath -i | grep PDE: | cut -d' ' -f2)/bin/psh \
    "/opt/MegaRAID/CmdTool2/CmdTool2 -LDPDInfo -a0 \
     | egrep 'Slot Number|Firmware state|Drive Temperature|Drive has flagged'" > \
     $tempfolder/ALL.Nodes.int.drive.info.log
     )
fi

servermake=$(cat $tempfolder/server.make.log | cut -d '=' -f5 | grep .)
if [ $servermake = "DELL" ]
     then (
/opt/teradata/tdat/pde/$(/usr/pde/bin/pdepath -i | grep PDE: | cut -d' ' -f2)/bin/psh \
    "/opt/dell/srvadmin/sbin/omreport storage pdisk controller=0 \
     | egrep 'ID|State|Failure Predicted' \
     | egrep -v 'Mirror Set ID|Vendor ID|Non-RAID HDD Disk Cache Policy'" > \
     $tempfolder/ALL.Nodes.int.drive.info.log
     )
fi

        # servertype = TPA done...

       )
fi

        ## Creating outputs for the script - one per server.
        # Creating iframe for every server.

################################
### CPU Graphs into table ######
################################

       ## Collect CPU infor from TPA system and output to table format into dumpfile.
echo -e "       <table style='width:100%'> \n" >> $dumpfile
echo -e "           <tr'> \n" >> $dumpfile
        # Get Nodes for mmplist, the echo displays output next to each other in one line.
      tablenewline=1
for bynname in $( echo $(cat $tempfolder/tpa.mpplist.log) )
   do
echo -e "               <td class='tableWithBorder'> \n" >> $dumpfile &&
echo -e "$servertype Node $bynname \n" >> $dumpfile &&
echo -e "               <div class='tableRowForm'> \n" >> $dumpfile &&
echo -e "               <svg width='400' height='140'> \n" >> $dumpfile &&
echo -e "                  <line x1='15' y1='20' x2='381' y2='20' style='stroke:rgb(0,0,0);stroke-width:2'></line> \
     \n" >> $dumpfile &&
echo -e "                  <line x1='20' y1='15' x2='20' y2='123' style='stroke:rgb(0,0,0);stroke-width:2'></line> \
     \n" >> $dumpfile &&
echo -e "                  <line x1='15' y1='123' x2='21' y2='123' style='stroke:rgb(0,0,0);stroke-width:2'></line> \
     \n" >> $dumpfile &&
echo -e "                  <line x1='381' y1='21' x2='381' y2='15' style='stroke:rgb(0,0,0);stroke-width:2'></line> \
     \n" >> $dumpfile &&
      cpuperline=123
   while [ $cpuperline -ge 33 ]
         do
   echo -e "                  <line x1='23' y1='$cpuperline' x2='381' y2='$cpuperline' style='stroke:rgb(240,240,240);stroke-width:1'></line>" \
         >> $dumpfile &&
            cpuperline=$(( $cpuperline - 10 ))
         done &&
        # Out put each Node with previous day (24 hour) CPU load and output to file.
      cat $tempfolder/ALL.Nodes.cpu.data.usage.time.24hours.txt | \
          grep "$bynname" -A25 > $tempfolder/$bynname.node.cpu.data.usage.time.24hours.txt
        # Variable to selct line number to start displaying from.
      cputime=1
      xaxis=23
   while [ $cputime -le 24 ]
         do
            cpuline=$(cat $tempfolder/$bynname.node.cpu.data.usage.time.24hours.txt | \
               grep -v "$bynname" | head -n $cputime | tail -1)
                 if [ $cpuline -lt 10 ]
                    then cpucolor='57,239,5'
                    elif [ $cpuline -lt 20 ]
                       then cpucolor='193,239,5'
                    elif [ $cpuline -lt 30 ]
                       then cpucolor='225,239,5'
                    elif [ $cpuline -lt 40 ]
                       then cpucolor='239,205,5'
                    elif [ $cpuline -lt 50 ]
                       then cpucolor='239,173,5'
                    elif [ $cpuline -lt 60 ]
                       then cpucolor='239,157,5'
                    elif [ $cpuline -lt 70 ]
                       then cpucolor='239,109,5'
                    elif [ $cpuline -lt 80 ]
                       then cpucolor='239,77,5'
                    elif [ $cpuline -lt 90 ]
                       then cpucolor='239,13,5'
                    elif [ $cpuline -lt 101 ]
                       then cpucolor='196,45,196'
                    else cpucolor='0,0,0'
                 fi ;
   echo -e "                  <rect width='13' height='$cpuline' x='$xaxis' y='23' style='fill:rgb($cpucolor);stroke-width:0'></rect>" \
               >> $dumpfile
            cputime=$(( $cputime + 1 ))
            xaxis=$(( $xaxis + 15 ))
         done &&
      rm $tempfolder/$bynname.node.cpu.data.usage.time.24hours.txt &&
echo -e "Sorry, your browser or mail client, does not support inline SVG... \n" >> $dumpfile
echo -e "               </svg> \n" >> $dumpfile
echo -e "               </div> \n" >> $dumpfile


######################################
### DiskSpace Graphs into table ######
######################################

echo -e "               <div> \n" >> $dumpfile

diskspaceheightroot=$( cat $tempfolder/ALL.Nodes.disk.space.data.usage.time.24hours.txt | grep $bynname -A8 | \
              grep '/dev/sda' | grep -v '/var' | awk '{print $6}' | cut -d '%' -f1 )
diskspaceheightvar=$( cat $tempfolder/ALL.Nodes.disk.space.data.usage.time.24hours.txt | grep $bynname -A8 | \
              grep '/dev/sda' | grep '/var' | grep -v '/var/opt' | awk '{print $6}' | cut -d '%' -f1 )
diskspaceheighttd=$( cat $tempfolder/ALL.Nodes.disk.space.data.usage.time.24hours.txt | grep $bynname -A8 | \
              grep '/dev/sda' | grep '/var/opt/teradata' | awk '{print $6}' | cut -d '%' -f1 )

echo -e "    <font>Filesystem usage for TPA server $bynname</font></br> \n" >> $dumpfile
echo -e "    <svg width='105' height='15'>" >> $dumpfile
echo -e "        <rect width='100' height='13' rx='5px' \
                     style='fill: rgb(255,255,255) ; \
                     stroke: rgb(0,0,0) ; \
                     stroke-width: 0.3' />" >> $dumpfile
echo -e "        <rect width='$diskspaceheightroot' height='13' rx='5px' \
                     style='fill: rgb(235,170,96) ; \
                     stroke: rgb(0,0,0) ; \
                     stroke-width: 0' />" >> $dumpfile
echo -e "    </svg>" >> $dumpfile
echo -e "        <a style='font-size:12px'>/ $diskspaceheightroot%</a>" >> $dumpfile
echo -e "    </br>" >> $dumpfile


echo -e "    <svg width='105' height='15'>" >> $dumpfile
echo -e "        <rect width='100' height='13' rx='5px' \
                     style='fill: rgb(255,255,255) ; \
                     stroke: rgb(0,0,0) ; \
                     stroke-width: 0.3' />" >> $dumpfile
echo -e "        <rect width='$diskspaceheightvar' height='13' rx='5px' \
                     style='fill: rgb(0,0,255) ; \
                     stroke: rgb(0,0,0)' ; \
                     stroke-width: 0' />" >> $dumpfile
echo -e "    </svg>" >> $dumpfile
echo -e "        <a style='font-size:12px'>/var $diskspaceheightvar%</a>" >> $dumpfile
echo -e "    </br>" >> $dumpfile


echo -e "    <svg width='105' height='15'>" >> $dumpfile
echo -e "        <rect width='100' height='13' rx='5px' \
                     style='fill: rgb(255,255,255) ; \
                     stroke: rgb(0,0,0) ; \
                     stroke-width: 0.3' />" >> $dumpfile
echo -e "        <rect width='$diskspaceheighttd' height='13' rx='5px' \
                     style='fill: rgb(0,0,255) ; \
                     stroke: rgb(0,0,0)' ; \
                     stroke-width: 0' />" >> $dumpfile
echo -e "    </svg>" >> $dumpfile
echo -e "        <a style='font-size:12px'>/var/opt/teradata $diskspaceheighttd%</a>" >> $dumpfile
echo -e "               </div> \n" >> $dumpfile

#####Diskspace completed.#####


##############################
##### Sensor Data start. #####
##############################

         # Onboard sensors.
         # The SED command here "greps" from the bynet name down to the first space after bynet name.
echo -e "               <pre> \n" >> $dumpfile
cat $tempfolder/ALL.Nodes.sensor.data.txt \
     | sed -n "/$bynname/,/^$/p" \
     | egrep 'Fan[0-9]|Temp|Current|Voltage|Mem ECC|Mem CRC|Mem Fatal|Pwr Consumption' \
     | awk -F '|' '{print $1 $2 $3 $4}' \
     | tee -a $dumpfile $textfile > /dev/null
echo -e "               </pre> \n" >> $dumpfile



         # Internal drives.
         # The first SED command here "greps" from the bynet name down to the first space after bynet name.
         # The second SED command here, removes first line from output.
echo -e "               <pre> \n" >> $dumpfile
cat $tempfolder/ALL.Nodes.int.drive.info.log  \
     | sed -n "/$bynname/,/^$/p" \
     | sed '1d' \
     | tee -a $dumpfile $textfile > /dev/null
echo -e "               </pre> \n" >> $dumpfile




############################
##### Sensor Data end. #####
############################

###############################
##### Closing Table data. #####
###############################

echo -e "               </td> \n" >> $dumpfile
      if [ $tablenewline -eq 3 ]
         then
echo -e "           </tr> \n" >> $dumpfile
echo -e "           <tr> \n" >> $dumpfile
        # if tablenewline = 4 then restart loop for <tr>.
      elif [ $tablenewline -eq 4 ]
         then tablenewline=1
      fi ;
      tablenewline=$(( $tablenewline + 1 ))
   done
echo -e "           </tr> \n" >> $dumpfile
echo -e "           </table> \n" >> $dumpfile

##############################
##### Closed Table data. #####
##############################

#######################
### Global scripts. ###
#######################


### Checking to see if PDE is up.

echo -e "<div class='a1'>PDE / DBS Status:</div>" >> $dumpfile
echo -e "           <pre> \n" >> $dumpfile
if [ $servertype = "TPA" ]
   then (

/opt/teradata/tdat/pde/$(/usr/pde/bin/pdepath -i | grep PDE: | cut -d' ' -f2)/bin/psh \
    "/opt/teradata/tdat/pde/$(/usr/pde/bin/pdepath -i | grep PDE: | cut -d' ' -f2)/bin/pdestate -a" \
    | sed '1d' \
    | tee -a $dumpfile $textfile > /dev/null

   )
fi
echo -e "           </pre> \n" >> $dumpfile


### Check for any down AMP's or Nodes.

echo -e "<div class='a1'>AMP / Node Status:</div>" >> $dumpfile
echo -e "           <pre> \n" >> $dumpfile
if [ $servertype = "TPA" ]
   then (

/opt/teradata/tdat/tdbms/$(/usr/pde/bin/pdepath -i | grep 'TDBMS:' | cut -d' ' -f2)/bin/vprocmanager -g \
     | egrep 'AMP |RSG |GTW |TVS |PE ' | grep -v 'ONLINE' | grep -v 'Vproc' \
     | tee -a $tempfolder/down.amps.txt > /dev/null
 # Checking if file is empty - if it is empty then echo the ok.
 if [[ -s $down.amps.txt/down.amps.txt ]]
    then echo -e "*****There are Down AMPs*****\n Following AMPs are down:\n " \
       | tee -a $dumpfile $textfile > /dev/null
         cat $tempfolder/down.amps.txt \
            | tee -a $dumpfile $textfile > /dev/null
    else echo "All AMPs seems to be ONLINE" \
       | tee -a $dumpfile $textfile > /dev/null
 fi
   rm $tempfolder/down.amps.txt
   )
fi
echo -e "           </pre> \n" >> $dumpfile


### Checking date on all servers.

echo -e "<div class='a1'>Date:</div>" >> $dumpfile
echo -e "           <pre> \n" >> $dumpfile
if [ $servertype = "TPA" ]
   then (

/opt/teradata/tdat/pde/$(/usr/pde/bin/pdepath -i | grep PDE: | cut -d' ' -f2)/bin/psh /bin/date \
     > $tempfolder/shs.date.log
   cat $tempfolder/shs.date.log | tee -a $dumpfile $textfile > /dev/null
   rm $tempfolder/shs.date.log
   )
fi
echo -e "           </pre> \n" >> $dumpfile


### NTP status.

echo -e "<div class='a1'>NTP status:</div>" >> $dumpfile
echo -e "           <pre> \n" >> $dumpfile
if [ $servertype = "TPA" ]
   then (

/opt/teradata/tdat/pde/$(/usr/pde/bin/pdepath -i | grep PDE: | cut -d' ' -f2)/bin/psh "/usr/sbin/ntpq -p | grep '*'" \
     > $tempfolder/ntp.server.status.log
 # sed $ removes empty lines s and g teplace string with string
   cat $tempfolder/ntp.server.status.log | sed '/^$/d' | sed 's/---------------------//g' | sed 's/-----------//g' \
         | sed 's/</-/g' | sed 's/>//g' \
         | tee -a $dumpfile $textfile > /dev/null
   rm $tempfolder/ntp.server.status.log
   )
fi
echo -e "           </pre> \n" >> $dumpfile


### Looking for any system dumps.

echo -e "<div class='a1'>System dumps:</div>" >> $dumpfile
echo -e "           <pre> \n" >> $dumpfile
if [ $servertype = "TPA" ]
   then (

/opt/teradata/tdat/pde/$(/usr/pde/bin/pdepath -i | grep PDE: | cut -d' ' -f2)/bin/csp -mode list \
     > $tempfolder/shs.csp.log
   cat $tempfolder/shs.csp.log | tee -a $dumpfile $textfile > /dev/null
   rm $tempfolder/shs.csp.log
   )
fi
echo -e "           </pre> \n" >> $dumpfile


### Database start time.

echo -e "<div class='a1'>Database start time:</div>" >> $dumpfile
echo -e "           <pre> \n" >> $dumpfile
if [ $servertype = "TPA" ]
   then (

/opt/teradata/tdat/pde/$(/usr/pde/bin/pdepath -i | grep PDE: | cut -d' ' -f2)/bin/tpatrace -s | grep PDE \
     > $tempfolder/shs.trace.log
   cat $tempfolder/shs.trace.log | tee -a $dumpfile $textfile > /dev/null
   rm $tempfolder/shs.trace.log
   )
fi
echo -e "           </pre> \n" >> $dumpfile


### Test DNS.

echo -e "<div class='a1'>DNS Test:</div>" >> $dumpfile
echo -e "           <pre> \n" >> $dumpfile
if [ $servertype = "TPA" ]
   then (

/opt/teradata/tdat/pde/$(/usr/pde/bin/pdepath -i | grep PDE: | cut -d' ' -f2)/bin/psh \
     "ping -c1 google.com | grep PING" > $tempfolder/dns.test.log
   cat $tempfolder/dns.test.log | tee -a $dumpfile $textfile > /dev/null
   rm $tempfolder/dns.test.log
   )
fi
echo -e "           </pre> \n" >> $dumpfile


### Active Directory Logon Test.

echo -e "<div class='a1'>Active Directory Logon Test:</div>" >> $dumpfile
echo -e "           <pre> \n" >> $dumpfile
if [ $servertype = "TPA" ]
   then (

/opt/teradata/tdat/tdgss/$(rpm -qa | grep tdgss | sort | tail -1 | cut -d'-' -f2)/bin/tdsbind -u SA23360003 -w \
     $(cat /etc/lp.dat) > $tempfolder/ad.test.log
   cat /tmp/ad.test.log \
      | grep -v ' FQDN:' \
      | grep -v 'LdapServiceFQDN' \
      | grep -v 'AuthUser' \
      | tee -a $dumpfile $textfile > /dev/null
   )
fi
echo -e "           </pre> \n" >> $dumpfile


### Kerberos Authentication Test.

echo -e "<div class='a1'>Kerberos Authentication Test:</div>" >> $dumpfile
echo -e "           <pre> \n" >> $dumpfile
if [ $servertype = "TPA" ]
   then (

/usr/lib/mit/bin/klist -ke /etc/teradata.keytab | grep -i cop \
     > $tempfolder/krlist.out.txt
        sleep 2
            for i in $(cat $tempfolder/krlist.out.txt | sed -e 's/^[[:space:]]*//' \
                | cut -d' ' -f2 | cut -d'@' -f1) ; \
                    do /usr/lib/mit/bin/kvno $i ; \
            done > $tempfolder/krlist.out.2.txt
   cat $tempfolder/krlist.out.2.txt | tee -a $dumpfile $textfile > /dev/null
   )
fi
echo -e "           </pre> \n" >> $dumpfile


### GetHost output for Kerberos.

echo -e "<div class='a1'>GetHost test for Kerberos:</div>" >> $dumpfile
echo -e "           <pre> \n" >> $dumpfile
if [ $servertype = "TPA" ]
   then (

for i in $(cat $tempfolder/krlist.out.2.txt | cut -d' ' -f1 | cut -d'/' -f2 |  cut -d'@' -f1)
   do /opt/teradata/tdat/tdgss/$(/usr/pde/bin/pdepath -i | grep 'TDBMS:' | cut -d' ' -f2)/bin/gethost -c $i ;
   done | grep 'TERADATA' > $tempfolder/krlist.out.3.txt
   cat $tempfolder/krlist.out.3.txt | sed 's/^ *//g' | tee -a $dumpfile $textfile > /dev/null
rm $tempfolder/krlist.out*.txt
   )
fi
echo -e "           </pre> \n" >> $dumpfile



#########################
##########TESTS##########
#########################

#
#
#
#
#


#########################
#########TESTS END#######
#########################



        # VMS and CMIC info.
echo -e "       <div class='roundedButtonVMS'> \n" >> $dumpfile
echo -e "       <pre> \n" >> $dumpfile
echo -e "VMS and CMIC versions: \n" | tee -a $dumpfile $textfile > /dev/null
/opt/teradata/gsctools/bin/get_cmic_version > $tempfolder/cmic.ver.txt
/opt/teradata/gsctools/bin/vmscmd vmsutil -v | grep 'VMS Version:' > $tempfolder/vms.ver.txt
echo -e "CMIC Version:          $(cat $tempfolder/cmic.ver.txt) \n" | tee -a $dumpfile $textfile > /dev/null
echo -e "$(cat $tempfolder/vms.ver.txt | cut -d'(' -f1) \n" | tee -a $dumpfile $textfile > /dev/null
         if [ ! -f $tempfolder/cmics.found.txt ]
              then sleep 10 ; echo "$(date) : Could not find CMIC heartbeats - sleeping 10 seconds - and retry" >> \
                   $logfile
         fi
echo -e "CMIC's found - \n" | tee -a $dumpfile $textfile > /dev/null
echo -e "$(grep -v -F 'Listening' < $tempfolder/cmics.found.txt) \n" | tee -a $dumpfile $textfile > /dev/null
rm $tempfolder/cmic.ver.txt
rm $tempfolder/vms.ver.txt
rm $tempfolder/cmics.found.txt
echo -e "        </pre> \n" >> $dumpfile
echo -e "        </div> \n" >> $dumpfile

#########################################
### Send all outputs to text log file ###
#########################################

       ## Sending info to text output file
       # First cleaning up file.
sed -i '/^$/d' $textfile

       # Then send output from TPA scripts.
sed 's/--//g' $tempfolder/ALL.Nodes.cpu.data.usage.time.24hours.txt >> $textfile


###########################################
##### All scripts for graphing.       #####
##### Done....                        #####
###########################################





       ## Messages from /var/log/messages
        # WARNINGS
echo -e "        <pre> \n" >> $dumpfile
echo -e " Warnings: \n" | tee -a $dumpfile $textfile > /dev/null
cat /var/log/messages | grep "`date --date="yesterday" +%b\ %e`" | grep -i 'warning' | tee -a $dumpfile $textfile > /dev/null
        # FAILURES
echo -e " Failures: \n" | tee -a $dumpfile $textfile > /dev/null
cat /var/log/messages | grep "`date --date="yesterday" +%b\ %e`" | grep -i 'fail' | tee -a $dumpfile $textfile > /dev/null
        # ERRORS
echo -e " Errors: \n" | tee -a $dumpfile $textfile > /dev/null
cat /var/log/messages | grep "`date --date="yesterday" +%b\ %e`" | grep -i 'error' | tee -a $dumpfile $textfile > /dev/null
echo -e " Aborted Sessions: \n" | tee -a $dumpfile $textfile > /dev/null
cat /var/log/messages | grep "`date --date="yesterday" +%b\ %e`" | grep -i 'Transaction has been Aborted' -A3 | tee -a $dumpfile $textfile > /dev/null
echo -e "        </pre> \n" >> $dumpfile




       ## Testing section.
# cat /var/opt/teradata/gsctools/chk_all/chk_all.txt | grep "pdepath_chk" -A11 | sort -u


        # Ending dumpfile.
echo -e "    </BODY> \n" >> $dumpfile
echo -e " </HTML> \n" >> $dumpfile


       ## Cleanup of output file.
        # Send file to e-mail server.
/usr/bin/scp $dumpfile $scpuser@$scpipaddress:$scpremotefolder > /dev/null 2>&1
     if [ $? -eq 0 ]
          then echo "$(date) : Successfully send output file to E-mail server." >> $logfile
          else echo "$(date) : Failed to send output file to E-mail server." >> $logfile
     fi

/usr/bin/scp $textfile $scpuser@$scpipaddress:$scpremotefolder > /dev/null 2>&1
     if [ $? -eq 0 ]
          then echo "$(date) : Successfully send text file to E-mail server." >> $logfile
          else echo "$(date) : Failed to send text file to E-mail server." >> $logfile
     fi

#############################################
##### Cleanup old log and output files  #####
#############################################

     rm $tempfolder/chk_all.script.out.log
     rm $tempfolder/shs.systeminfo.log



        # Make Text output file - more readable.
awk 'NF > 0' $textfile > $tempfolder/pre.out.master.txt
     sleep 1
     mv $tempfolder/pre.out.master.txt $textfile

# Remeber to add line below at end to make file nice and readable and keep on system for viewing, currently it is only nice in e-mail form.
# Add zombie processes and more.
# If put output else and not Teradata installed in script


##############################
##### Script History.... #####
##############################

## 02.00.00.00
## Total redesign and initial release.
##
## 02.00.10.00
## Added some system information scripts for Teradata TPA systems.
##
## Tasks
##  -- Added proper logging.
##  -- Fix TEXT version - output needs attention.
