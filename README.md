# LJInboxArchive
LJInboxArchive is a perl script for making an archive of a Livejournal Inbox.  Its only programmatic dependency is wget. It outputs a working, navigable stand-alone local website (HTML files and their js, css, and image dependencies) of your Livejournal Inbox.  It works even if you haven't accepted the new LJ ToS.

## Requirements

• perl (tested against v5.10.0 and v5.10.1)<br />
• wget (tested against v1.11.4 and v1.12)<br />
• a cookie file that wget can read ("Netscape-style") that has your authenticated LJ cookies (instructions below.)

## Usage

0) Make a directory in which your want your archive to go.  cd into it.

1) Download this script; put it someplace convenient, like into your archive directory; and make it executable (<code>chmod u+x downloadLJinbox.pl</code>).

2) Come up with your cookie file (instructions below).  Name it "authenticatedcookies.txt".  Put it in your archive directory (required).

3) In your directory for the archive, invoke the script: ./downloadLJinbox.pl  

4) After it has completed, open a web browser.  Use the File Open method to open your new directory; you will get a directory listing with a bunch of stuff in it.  Click on index.html to get to the main page of your archive.

## Making a Cookie File

The most efficient way I know to make a wget-compatible cookie file is to use a browser add-on for the job.  I'm partial to the <a href="https://addons.mozilla.org/en-US/firefox/addon/export-cookies/?src=userprofile">"Export Cookies" add-on to Firefox</a>, and mdlbear at dreamwidth recommends the <a href="https://chrome.google.com/webstore/detail/cookietxt-export/lopabhfecdfhgogdbojmaicoicjekelh?hl=en">"cookie.txt export" add-on for Chrome</a>.  Once you have your browser with the appropriate add-on installed, you can log in to LJ as usual, and once logged in – it's okay if the ToS pop-up is there, just ignore it and don't click anything in the window – use the add-on to export the cookies (in Firefox, the Tools menu &gt; "Export Cookies..." to save them to a file; in Chrome, click the toolbar button and the cut-and-paste the cookies into a text file).
