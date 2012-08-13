vk_music_converter
==================

This small script helps you to convert unreadable audio files(from chrome cache) which were downloaded from **vk.com** site into normal mp3. Also after normalization script tries to read MP3 Tag and rename file to **'artist - title.mp3'**

Pre-requirements  
----------------

1. Perl   
*perl modules:*
2. IO::File
3. Getopt::Std
4. MP3::Tag
5. File::Copy

Three of them in Ubuntu installed by default. Fourth can be install by this command:  
`sudo apt-get install libmp3-tag-perl -y `

Usage 
-----

Copy file(s) from browser cache into some directory:    
`ls -l downloads/  
total 310596  
-rw-rw-r-- 1 user user 34105372 Aug 12 19:01 0342e21c8977.mp3  
-rw-rw-r-- 1 user user 28689640 Aug 12 19:38 3396c362faf5.mp3  
-rw-rw-r-- 1 user user 47114125 Aug 12 19:38 3adabcf7a8f8.mp3  
...`
   
then run the script:   
`./vk_music_converter.pl -d downloads -o out`

when script done check **out** directory:   
`$ ls -l out  
total 53352  
-rw-rw-r-- 1 andrii andrii 11522176 Aug 12 19:55 8e36cbc364fd.mp3  
-rw-rw-r-- 1 andrii andrii  8087712 Aug 12 19:55 Some artist name1 - some song name1.mp3  
-rw-rw-r-- 1 andrii andrii 10233888 Aug 12 19:55 Some artist name2 - some song name2.mp3  
....`  
Some files might remains with the old name(*8e36cbc364fd.mp3*). It happen in case script is not able to fetch MP3 Tags.

There only three options script can be run:  
`vk_music_converter [-f filename| -d directory] -o output_directory`  



Disclaimer
----------

###Use it at your own risk. There is no warranty that script going to work as excepted. 
