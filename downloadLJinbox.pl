#!/usr/bin/perl
use strict; 

my $authenticatedcookies = 'authenticatedcookies.txt';

if ( ! -f $authenticatedcookies) { die "Couldn't find authenticatedcookies.txt, giving up.\n"; }

main();

sub wget_inbox_folder_type {
	#takes an inbox folder type
	#returns the webpage for that folder as a string
	my $folder = $_[0];	
	my $url  = "http://www.livejournal.com/inbox/?view=" . $folder  ;
	
	my $commandstring = "wget -q --cookies=on --keep-session-cookies --save-cookies cookiejar.txt --load-cookies $authenticatedcookies --header \"X-LJ-Auth: cookie\"  -O - $url";
	
	print $commandstring."\n";
	return `$commandstring `;
} #takes an inbox folder type, returns the webpage for that folder as a string

sub extract_pagecount {
	#takes a folder webpage as a string
	#returns max number of pages in that folder as an int
	my $skip = 0;
	for my $line (split /^/, $_[0]) {
		if ($line =~ /span class="page-number"/) {
			$skip = 1;
        } elsif ( $skip == 1 && $line =~ /Page \d* of (\d*)/) {
        	return $1;
        	last;
		}
	}
} #takes a folder webpage as a string, returns max number of pages in that folder as an int

sub pruneCrap {
	# Takes nothing, 
	# returns nothing, 
	# edits a lot of files and deletes some stuff

	#for every file in cur dir
	my @files = <www.livejournal.com/inbox/index.html*>;

	for my $inboxfile (@files) { 
		#...except	
		if ($inboxfile =~ /_NEW/) {
			next;
		}	
	# 	open file for read
		print "Fixing $inboxfile...";
		open ( INBOXFILE, "<", $inboxfile ) or die $!;
	# 	read in,  copy into variable leaving out the junk
		my $accumulator ="";
		my $skip=0;
		my $now=`date`;
		while (my $line = <INBOXFILE>) {
			if ($line =~ /<\!-- Google Tag Manager -->/ 
				|| $line =~ /<\!-- Google Analytics -->/ 
				|| $line =~ /<\!-- Begin comScore Tag -->/
				) {
				$skip = 1;
				next;
			} elsif ($line =~ /<div class="b-fader"><\/div>/ ) {
				$accumulator .= "</body>\n</html>\n";
				last;
			} elsif ($skip == 1) {
				if ($line =~ /<\!-- End Google Tag Manager -->/ 
				|| $line =~ /<\!-- End Google Analytics -->/ 
				|| $line =~ /<\!-- End comScore Tag -->/ 
				) {
					$skip = 0;
				}
				next;
			} elsif ( $line =~ /        window.location.href = "http:\/\/www\.livejournal\.com\/inbox\/\?page=" \+ \(pageNum (.) 1\) \+ args;/
				) {
				$line = 
					'        window.location.href = "index.html%3Fpage=" + (pageNum '.$1.' 1) + args + ".html" ;'."\n"
					# WORKS!
			} elsif ( $line =~ /id="RefreshLink">Refresh<\/a>/) {
				next;
			} elsif ( $skip == 2) {
				if ($line =~ /<\/form>/) {
					$skip = 0;
				}
				next;
			} elsif ($line =~ /inbox\/compose\.bml\" method="GET"/) {
				$skip = 2;
				next;
			} elsif ($skip == 3) {
				if ($line =~ /<\/ul>/) {
					$skip = 0;
				}
				next;
			} elsif ($line =~ /<ul class="s-footer-main-nav-lang">/) {
				$skip = 3;
				next;
			} elsif ( $line =~ /<td class="checkbox">.*all_CheckAll_." \/><\/td>/) {
				$line =~ s/<input type='checkbox' class="InboxItem_Check" id="all_CheckAll_." \/>//;
	#			print "Line is now: $line \n";
			} elsif ( $line =~ /<input type="submit" name="markRead_." value="Read"  id="all_MarkRead_." \/>/) {
				$line =~ s/id="all_MarkRead_(.)" /id="all_MarkRead_$1" disabled /;
			} elsif ( $line =~ /<input type="submit" name="markUnread_." value="Unread" id="all_MarkUnread_." \/>/) {
				$line =~ s/id="all_MarkUnread_(.)" /id="all_MarkUnread_$1" disabled /;
				$line =~ s/id="all_Spam_(.)" /id="all_Spam_$1" disabled /;
				$line =~ s/id="all_Delete_(.)" /id="all_Delete_$1" disabled /;
			} elsif ( $line =~ /class="InboxItem_Check"/) {
				$line =~ s/<input type='checkbox' name="all_Check-.*" class="InboxItem_Check" id="all_Check-.*" \/> <\/td>/ <\/td>/;
			} elsif ( $line =~ /class="inbox-massactions-read"/ ||
				$line =~ /class="inbox-massactions-delete"/) {
				next;
			} elsif ( $line =~ /<div class='actions'>/) {
				# The greediness of globs handles the commented out case too!
	#				$line =~ s/<div class='actions'> <a href='.*'>Reply<\/a> \| <a href='.*'>Add as friend<\/a> \| <a href='.*' class='mark-spam'>Mark as Spam<\/a><\/div>//; 
				$line =~ s/<div class='actions'> <a href='.*'>Reply<\/a> \| <a href='.*' class='mark-spam'>Mark as Spam<\/a><\/div>//;
			} elsif ( $line =~ /<a href=.http:\/\/www\.livejournal\.com\/inbox\/('|")>/) { #JFC pick a damned quote convention already
				$line =~ s/http:\/\/www\.livejournal\.com\/inbox\//index.html%3Fpage=1&view=all.html/ ;
			} elsif ( $line =~ /<a href="http:\/\/www\.livejournal\.com\/inbox\/\?view=/) { 
	#			print "Line was: $line \n";
				$line =~ s/http:\/\/www\.livejournal\.com\/inbox\/\?view=usermsg_recvd/index.html%3Fpage=1&view=usermsg_recvd.html/ ;
				$line =~ s/http:\/\/www\.livejournal\.com\/inbox\/\?view=friendplus/index.html%3Fpage=1&view=friendplus.html/ ;
				$line =~ s/http:\/\/www\.livejournal\.com\/inbox\/\?view=birthday/index.html%3Fpage=1&view=birthday.html/ ;
				$line =~ s/http:\/\/www\.livejournal\.com\/inbox\/\?view=befriended/index.html%3Fpage=1&view=befriended.html/ ;
				$line =~ s/http:\/\/www\.livejournal\.com\/inbox\/\?view=entrycomment/index.html%3Fpage=1&view=entrycomment.html/ ;
				$line =~ s/http:\/\/www\.livejournal\.com\/inbox\/\?view=spam/index.html%3Fpage=1&view=spam.html/ ;
				$line =~ s/http:\/\/www\.livejournal\.com\/inbox\/\?view=bookmark/index.html%3Fpage=1&view=bookmark.html/ ;
				$line =~ s/http:\/\/www\.livejournal\.com\/inbox\/\?view=usermsg_sent/index.html%3Fpage=1&view=usermsg_sent.html/ ;
				$line =~ s/http:\/\/www\.livejournal\.com\/inbox\/('|")/index.html%3Fpage=1&view=all.html$1/ ;
	#			print "Line is: $line \n";
				# WORKS!
			} elsif ( $line =~ /<h1 class='s-title logged-in'>Inbox<\/h1>/) {
				$line =~ s/Inbox/Inbox ARCHIVE $now/;
			} elsif ( $line =~ /<title>Inbox<\/title>/) {
				$line =~ s/Inbox/Inbox ARCHIVE $now/;		
			}
			$accumulator .= $line;
		}
	# close file for read
		close INBOXFILE;
	# open file for write
		open ( INBOXFILE, ">", $inboxfile ) or die $!;
	# write out new file
		print INBOXFILE $accumulator;
	# close file for write
		close INBOXFILE;
		print "done with $inboxfile.\n";
	}


} # Takes nothing, returns nothing, edits a lot of files and deletes some stuff

sub main {
	my %msgtypelen;
	
# numbers of pages
	$msgtypelen{all} = 0;
	$msgtypelen{usermsg_recvd} = 0;
	$msgtypelen{friendplus} = 0;
	$msgtypelen{birthday} = 0;
	$msgtypelen{befriended} = 0;
	$msgtypelen{entrycomment} = 0;
	$msgtypelen{spam} = 0;
	$msgtypelen{bookmark} = 0;
	$msgtypelen{usermsg_sent} = 0;
	
# download just the nine index pages to scrape for number of pages
	for my $folder (keys %msgtypelen) {
		my $page = wget_inbox_folder_type($folder);
		$msgtypelen{$folder} = extract_pagecount($page) ;
	}
	
	#for my $folder (keys %msgtypelen) {
	#	print '$msgtypelen{$folder}: '.$msgtypelen{$folder}."\n";
	#}


# generate the input file for wget
#	open inputfile for writing
	open (URLLIST, ">", "URLLIST.txt") or die $!;
# 	for each key in msgtype
	for my $msgtype (keys %msgtypelen) {
		for (my $i=1; $i <= $msgtypelen{$msgtype}; $i++) {
			print URLLIST 'http://www.livejournal.com/inbox/?page=' .$i. '&view=' . $msgtype."\n" ;
		}
	}
	#close inputfile
	close URLLIST;
# run the wget (-i inputfile)
	system 'wget -p --span-hosts --adjust-extension --convert-links --cookies=on --keep-session-cookies --save-cookies cookiejar.txt  --load-cookies "'.$authenticatedcookies.'" --header \"X-LJ-Auth:\ cookie\" -i URLLIST.txt';

# run the pruner
	pruneCrap;
	
# delete the inputfile, cookiefile
	unlink 'URLLIST.txt';
	unlink 'cookiejar.txt';
	
}


