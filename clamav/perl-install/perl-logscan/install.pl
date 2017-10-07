#!/usr/bin/perl
# This is by vijay vijay\@ericavijay.net version 1.3.7
# Touch the required settings here if you are familiar. 
# Easiest thing is change the local language.
$grandtotal="Grand Total"; # Needs other language translation
@MONTHS=("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
%COMMANDS=(
"CLAMAV" => "grep 'FOUND\$' | sed -e 's/.*:\\(.*\\) FOUND/\\1/' | grep -v Test",
"RAV" => "grep \"infected with\"| sed -e s/.*with//",
"VEXIRA" => "grep 'Alert!' | sed -e 's/.*contains \"//' | sed -e 's/\".*//'"  );
$nstart=1; # you might want this to be 0 for openbsd newsyslog 
$perlpath="/usr/bin/perl";
$outfile="statsout";
# Polish is the only other language available.  You can edit and
# add German or other text.
print "Please select your language for Statistics display:

1-English (Default)
2-German
3-French
4-Polish
4-Romanian
5-Spanish
6-Swedish
7-Italian
8-Lithuanian
9-Portuguese
(If your language is not seen you can edit english.txt and send
me your changes.  I will include it for others benefit vijay\@ericavijay.net
):";
chomp($lang=<STDIN>);
$avlang="english|english|german|french|polish|romanian|spanish|swedish|italian|litunia|potuguese";
@langs=split(/\|/,$avlang);
if ( -f "./$langs[$lang].txt") { require("./$langs[$lang].txt");}
else { require("./english.txt"); }

Getscanner:
print "Enter now your scanning engine:
Options CLAMAV, RAV,VEXIRA 
Spell it exactly all capitalized 
:";
$SCANNER=<STDIN>;
$SCANNER=~s/\s//sgi;
if ( $COMMANDS{"$SCANNER"} eq undef) {
print "OOPS YOUR SCANNER IS NOT REGISTERED\n";
goto Getscanner;
}


Getit:
print "Enter the location of your logfile, Typical
    Clamav (LogSyslog) =>  /var/log/messages or /var/adm/messages 
                           or /var/log/maillog
    Clamav (LogFile) => /var/log/clamd.log or 'auto-detect'
            [auto-detect will get log file information from clamd.conf 
	     or traditional clamav.conf]
    RAV (<8.3) => /var/log/maillog
    RAV (8.4) => /var/opt/rav/global
    VEXIRA => /var/log/maillog or /var/log/messages
:";
$logfile=<STDIN>;
if ($logfile =~ /auto\-detect/) {
foreach $sconf ("clamav.conf","clamd.conf") {
if (-f "/usr/local/etc/$sconf") {
$clamavconf="/usr/local/etc/$sconf";
last;
}
elsif (-f "/etc/$sconf") {
$clamavconf="/etc/$sconf";
last;
}
}

if (! -f $clamavconf ) {
print "NOT ABLE TO FIND YOUR CLAMAV CONF FILES, PLEASE ENTER INFO MANUALLY\n";
goto Getit;
}


open(iFILE,"$clamavconf"); 
@loglocation=grep(!/^#/,<iFILE>); 
close(iFILE);
@loglocation=grep(/LogFile/,@loglocation);
$logfile=$loglocation[0];
$logfile=~s/LogFile//;
}
$logfile=~s/\s//sgi;
unless (-f "$logfile") { 
print "YOUR LOG FILE SPECIFIED DOES NOT EXIST PLEASE TRY AGAIN\n"; 
goto Getit;
}

print "Enter now the number of cycles 
before the log is rotated (typical/default:4) :\n";
chomp($nweeks=<STDIN>);
# If it is a non digit then make it 4
if(($nweeks =~ /\D/) || ($nweeks eq "") || ($nweeks<4)) { $nweeks=4; }
Getidir:
print "Enter now the location of your /cgi-bin/virus directory 
    *BSD/RedHat/Linux => /var/www/cgi-bin/virus/
    Apache custom install  => /usr/local/apache/cgi-bin/virus/
";
$idir=<STDIN>;
$idir=~s/\s//sgi;
if (length($idir) < 5) {
print "PLEASE SPECIFY THE CGI-BIN DIRECCTORY LOCATION: 
THERE IS NOT DEFAULT VALUE FOR THIS\n";
goto Getidir;
}
unless (-d "$idir") {
system("mkdir -p $idir");
}
chdir("$idir");
if (! -f "$logfile") {
print "WARNING: Your log files may be gzipped so I will try to use
zcat to open and read the log files
";
}
print "Generating first time stats";
$imax=$nweeks+1;
for ($i=$nstart;$i<$imax;$i++) {
   open(OUTFILE,">$idir/$outfile.$i") || die "Cannot make/open file  $idir/$outfile.$i";
    print "$i.";
$cmdcat="cat $logfile.$i";
$cmdtail="tail -n 1 $logfile.$i";
$tlogfile="$logfile.$i";
unless(-f "$logfile.$i") {
if (-f "$logfile.$i.gz") { 
$cmdcat="zcat $logfile.$i.gz"; 
$cmdtail="$cmdcat | tail -n 1";
$tlogfile="$logfile.$i.gz";
}
elsif (-f "$logfile") { 
$cmdcat="cat $logfile";
$cmdtail="cmdcat | tail -n 1";
$tlogfile="$logfile";
}
else { 
print "YOU SEEM TO HAVE NO LOGFILES ROTATED OR 
ONLY CURRENT LOG FILE ONLY ONE
WEEK STATS WILL BE AVAILABLE";
next; 
}
}
$execute="$cmdcat | $COMMANDS{$SCANNER}";
$allfound="";
    $data =`$execute`;
    print ".";
    $total=0;
    @ddata = split(/\n/,$data);
    foreach $duata (@ddata) {
	if ($allfound=~/\Q$duata\E\|/) {
	    $CNT{$duata}++;
}
	else {
	    $CNT{$duata}=1;
            $allfound.="$duata|";
    }
    }

foreach $duata (keys %CNT) {
$total = $total + $CNT{$duata};
print OUTFILE "$duata\t$CNT{$duata}\n";
}
@filedate=lstat("$tlogfile");
@filedate=localtime ($filedate[9]);
$ldate="$filedate[3]-$MONTHS[$filedate[4]]-".eval($filedate[5]+1900);
    print OUTFILE "$totalinfo $ldate\t$total\n";
    close(OUTFILE);
undef %CNT;
    print ".";
}

open(DFILE,">$idir/display.pl");
print DFILE <<"EOTy!";
#!$perlpath
\$titleinfo="$titleinfo";
\$titleinfo2="$titleinfo2";
\$virusname="$virusname";
\$totalinfo="$totalinfo";
\$numberofviruses="$numberofviruses";
\$nodataavailable="$nodataavailable";
\$weekofdisplay="$weekofdisplay";
\$numberofvirushtm="$numberofvirushtm";
\$virusscanweeklygraph="$virusscanweeklygraph";


    \$openfile="statsout";
    print "Content-type:text/html

<!DOCTYPE html PUBLIC  '-//IETF//DTD HTML 2.0//EN'>
\$titleinfo

";
\$colors="#FFCF2F #00DD00 #FFCDEF #0000dd #00FFFF #EE0000 orange #FF0ABC D2CC22 red lime yellow #FFBBAA";
\$overalltable="<table summary='HTML bar graphs' border bgcolor=#FFCDEF><tr><td>\$weekofdisplay</td><td>\$numberofviruses</td></tr>\\n";
	    \$allcount=0;

for (\$i=1;\$i<=$nweeks;\$i++) {
     \@color=split(/\\s/,\$colors);
     \$wdata="";
     if ( -f "\$openfile.\$i") {
     open(FILE,"\$openfile.\$i");
     \@data=<FILE>;
     close(FILE);
 }
elsif  ( -f "$idir/\$openfile.\$i") {
     open(FILE,"$idir/\$openfile.\$i");
     \@data=<FILE>;
     close(FILE);
 }
     else { \@data = ("\$nodataavailable\\t0"); 
	\$color[0]="white"; }

    if (\$#color <\$#data) {
	\$icount=\$#color+1;
	\$jcount=0;
	while (\$icount<\$#data) {
	       \$color[\$icount]=\$color[\$jcount];
	       \$icount++;
	       \$jcount++;
	   }

    }
    \$color[\$#data]="white";
	    if (\$ENV{'QUERY_STRING'} =~ /name/) {
		for (\$icount=0;\$icount<\$#data;\$icount++) {
		    push(\@vdata,\$data[\$icount]);
		}
		\@vdata=sort(\@vdata);
		push (\@vdata,\$data[\$#data]);
		undef \@data;
		push(\@data,\@vdata);
		undef \@vdata;
	    }
	    elsif (\$ENV{'QUERY_STRING'} =~ /number/) {
		for (\$icount=0;\$icount<\$#data;\$icount++) {
		    (\$virus,\$count)=split(/\\t/,\$data[\$icount]);
		    push(\@vdata,"\$count\\t\$virus");
		}
		\@vdata=sort { \$b <=> \$a} (\@vdata);
		for (\$icount=0;\$icount<\$#data;\$icount++) {
		    (\$count,\$virus)=split(/\\t/,\$vdata[\$icount]);
		    \$data[\$icount]="\$virus\\t\$count\\n";
		}
		undef \@vdata;
	    }


	    \$j=0;
	    foreach \$data (\@data) {
		(\$vweek,\$vcount)=split(/\\t/,\$data);
		\$jj=\$j+1;

 		if (\$jj <= \$#data ) {
 		\$data = "<tr><td bgcolor=\$color[\$j]>
<font face=verdana size=2>\$jj. \$data"; 
 		\$eachvweek .="\$jj|";
 		\$eachvcount .="\$vcount|";
 	    }
 		else {
 		\$data = "<tr><td bgcolor=\$color[\$j]>
 <font face=verdana  size=2>\$data</font></td>"; 
 		}
		\$j++;
		\$data =~ s/\\t/<td align=right bgcolor=\$color[\$j-1]><font face=verdana size=2>/g;
		\$data .= "</font></td></tr>
";
		\$wdata .= \$data;
	    }
     \$eachvweek=~s/\\|\$//sgi;
     \$eachvcount=~s/\\|\$//sgi;
     \$bcolors=join("|",\@color);
     \$vweek=~s/.* (\\S+)\$/\$1/;
     \$vweeks.="\$vweek|";
     \$vcounts.="\$vcount|";
	    \$allcount=\$allcount+\$vcount;
     \$overalltable.="<tr><td>$weekofdisplay \$vweek</td><td align=right>\$vcount</td></tr>\\n";
\$thisweekgraph=&bargraph(\$eachvcount,\$eachvweek,\$bcolors,"$weekofdisplay \$vweek","$numberofvirushtm","$virusname","10","white");
     \$eachvweek="";
     \$eachvcount="";
\$tabledata .= "<table summary ='HTML Bar graphs' border> <tr><td> 
\$titleinfo2
<table summary='HTML Bar graphs' border> <tr> <td>  <font face=verdana size=2> 
\$virusname
</font></td> <td> 
<font face=verdana size=2>
\$numberofviruses </font></td>
</tr> 
";
	  \$tabledata .= "\$wdata";
	    \$tabledata .= "</table></td><td>\$thisweekgraph</td></tr></table><hr>";
	    \@color="";
	}
\$overalltable.="
<tr><td> $grandtotal - $nweeks - cycles </td><td align=right>\$allcount</td></tr>
</table>";
\$vweeks=~s/\\|\$//sgi;
\$vcounts=~s/\\|\$//sgi;
     \@yjunk=split(/\\|/,\$vweeks);
     \$vweeks=join("|",reverse \@yjunk);
     \@yjunk=split(/\\|/,\$vcounts);
     \$vcounts=join("|",reverse \@yjunk);

# Make a new subroutine here to work for HTML graphics.
# bargraph subroutine requires data in this format
# bargraph(X-values-array,Y-values-array,Colors-array[Red],X-Axis-label,Y-Axis-label,GraphMax-in-pixels,Background-color[Blue])
\$writeme=&bargraph(\$vcounts,\$vweeks,"","\$virusscanweeklygraph","\$numberofvirushtm","\$weekofdisplay","10","white");

print "
<p align=center>
<font face=verdana size=4 color=blue>
Virus Scan Statistics</font> <br>
<font face=verdana size=2> by Vijay Sarvepalli 
Vijay  AT ericavijay.net </font><br>
Sort by
<a href=\$ENV{'SCRIPT_NAME'}?name>\$virusname</a>
OR <a href=\$ENV{'SCRIPT_NAME'}?number>\$numberofviruses</a>
</p>

<table summary='HTML Bar graphs' border><tr><td> \$overalltable</td><td>\$writeme </td></tr>
</table>
\$tabledata
"; exit();




sub bargraph {
    local (\$xaxi,\$yaxi,\$colori,\$fulltitle,\$xtitle,\$ytitle,\$pxmax,\$xybgcolor) = \@_;
    \@xaxis=split(/\\|/,\$xaxi);
    \@yaxis=split(/\\|/,\$yaxi);
    \@xcolor=split(/\\|/,\$colori);
    if (\$#xaxis ne \$#yaxis) {
	return "Graph values dont match 
X-axis has \$#axis numbers Y-Axis has \$#yaxis numbers ";
    }
    \$xmaximum=1;
# Find Maximum value first 
    foreach (\@xaxis) {
	if (\$_ > \$xmaximum) { \$xmaximum = \$_; }
    }
\$graphmax=\$pxmax;;
\$is=0;
foreach \$xaxi (\@xaxis) {
    \$jstart=\$pxmax-int(\$xaxi*\$pxmax/\$xmaximum);
    if (\$jstart>\$pxmax-1) { \$jstart=\$pxmax-1; }
    if (\$xcolor[\$is]) { \$thiscolor=\$xcolor[\$is]; }     
    else {\$thiscolor="red"; }
    \$tcolor{\$jstart.\$is}="\$thiscolor align=center> 
<font face=Verdana size=1 color=white>\$xaxi</font";
    for (\$js=\$jstart+1;\$js<\$pxmax;\$js++) { 
	\$tcolor{\$js.\$is}=\$thiscolor;
    }
    \$is++;
}
\$returnme="
<font face=verdana size=4 color=blue> \$fulltitle</font>
<table summary='HTML Bar Graphs' border>
<tr><td align=center valign=top>
<font face=verdana size=1 color=red>
Max-\$xmaximum^
</font>
<p>\$xtitle
</font></td><td>
<table summary='HTML Bar Graphs' cellpadding=0 cellspacing=0 align=center bgcolor=\$xybgcolor>";
for (\$js=0;\$js<\$pxmax;\$js++) {
    \$returnme .= "<tr>";
    \$lastrow="";
    for (\$is=0;\$is<=\$#xaxis;\$is++) { 
	 \$returnme .= "<td 
bgcolor=\$tcolor{\$js.\$is}>
</td> <td bgcolor=white>\\&nbsp;</td>"; 
	 \$lastrow.="
<td border align=center bgcolor=black><font face=verdana size=1 color=white>
\$yaxis[\$is]</td><td bgcolor=black>\\&nbsp;</td>";
	 \$tcolor{\$js.\$is}="";
     }
    \$returnme .= "</tr>";
}
    return \$returnme."
<tr>\$lastrow</tr></table></td><tr><td colspan=2 align=center>
<font face=verdana size=1 color=blue> \$ytitle --\\&gt;</font>
</td></tr> </table>
";
}



EOTy!

close(DFILE);    
open(DFILE,">$idir/crontab.pl");
print DFILE <<"EOTxX";
\#!$perlpath
\@MONTHS=("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec");
\$nstart=$nstart;
\$nweeks="$nweeks";
\$outfile="$outfile";
\$logfile="$logfile";
\$totalinfo="$totalinfo";
chdir("$idir");
unlink "\$outfile.$nweeks";
for (\$i=0;\$i<\$nweeks-1;\$i++) {
\$nw=\$nweeks-\$i;
\$nws=\$nw-1;
if (-f "\$outfile.\$nws") { system("mv -f \$outfile.\$nws \$outfile.\$nw"); }
}
if (-f "\$logfile.\$nstart") { 
    \$execute="cat \$logfile.\$nstart";
    \$tlogfile="\$logfile.\$nstart";
}
elsif (-f "\$logfile.\$nstart.gz") {
    \$execute="zcat \$logfile.\$nstart.gz";
    \$tlogfile="\$logfile.\$nstart.gz";
}
elsif (-f "\$logfile.\$nstart.bz2") {
    \$execute="bzmore \$logfile.\$nstart.bz2";
    \$tlogfile="\$logfile.\$nstart.bz2";
}
else { die "No log files found"; }

\$execute.=<<'EOTt';
 | $COMMANDS{$SCANNER}
EOTt

open(OUTFILE,">\$outfile.1");
\$data=`\$execute`;
\$allfound="";
   \$total=0;
    \@ddata = split(/\\n/,\$data);
    foreach \$duata (\@ddata) {
	if (\$allfound=~/\\Q\$duata\\E\\|/) {
	    \$CNT{\$duata}++;
	}
	else {
	    \$CNT{\$duata}=1;
            \$allfound.="\$duata|";
    }
    }

foreach \$duata (keys \%CNT) {
\$total = \$total + \$CNT{\$duata};
print OUTFILE "\$duata\\t\$CNT{\$duata}\\n";
}
\@filedate=lstat("\$tlogfile");
\@filedate=localtime (\$filedate[9]);
\$ldate="\$filedate[3]-\$MONTHS[\$filedate[4]]-".eval(\$filedate[5]+1900);
    print OUTFILE "\$totalinfo \$ldate\\t\$total\\n";
    close(OUTFILE);
undef \%CNT;
exit 0;
EOTxX


chmod 0744,"$idir/crontab.pl";
chmod 0755,"$idir/display.pl";
$hostname=`hostname`;
chomp($hostname);
print "Point your browser to http://$hostname/cgi-bin/virus/display.pl\n";
print "You can run the file $idir/crontab.pl every time you rotate the logfiles\n";
print "Questions?? : Contact vijay \@ ericavijay.net \nENJOY\n";
