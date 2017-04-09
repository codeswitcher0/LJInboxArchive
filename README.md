# LJInboxArchive
LJInboxArchive is a perl script for making an archive of a Livejournal Inbox.  Its only programmatic dependency is wget. It outputs a working, navigable stand-alone local website (HTML files and their js, css, and image dependencies) of your Livejournal Inbox.  It works even if you haven't accepted the new LJ ToS.

## Requirements

• perl (tested against v5.10.1)<br />
• wget (tested against v1.12)<br />
• a cookie file that wget can read ("Netscape-style") that has your authenticated LJ cookies (instructions below.)

## Usage

0) Make a directory in which your want your archive to go.  cd into it.

1) Download this script; put it someplace convenient, like into your archive directory; and make it executable (<code>chmod u+x downloadLJinbox.pl</code>).

2) Come up with your cookie file (instructions below).  Name it "authenticatedcookies.txt".  Put it in your archive directory (required).

3) In your directory for the archive, invoke the script: ./downloadLJinbox.pl  

4) After it has completed, open a web browser.  Use the File Open method to open your $directory/www.livejournal.com/inbox/ .  The main page of your archive is the first one index.html?page=1&view=all.html

## Making a Cookie File

The most efficient way I know to make a wget-compatible cookie file is to use the <a href="https://addons.mozilla.org/en-US/firefox/addon/export-cookies/?src=userprofile">"Export Cookies" add-on to Firefox</a>.  Once you have Firefox with that add-on installed, you can log in to LJ as usual, and once logged in – it's okay if the ToS pop-up is there, just ignore it and don't click anything in the window – use the "Export Cookies..." item under the Firefox Tools menu. 
