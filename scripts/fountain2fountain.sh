# DESCRIPTION
# Converts a fountain format plain text file screenplay into a fountain file with semantic linefeeds (AKA ventilated prose or sense lines) joined. Result is printed to `<inputFileBasename>_unventilated.fountain`. Adapted from:
#    fountain2pdf.sh

# USAGE
# Run with one parameter, which is the input fountain file:
#    fountain2fountain.sh input-file.fountain
# NOTES
# - This script expects everything after the title page of the screenplay (the actual screenplay body text) to start with a line that starts and ends with "> FADE IN:" (but without the quote marks), and you may expect this script to not work if that is not the case.
# - This script sets a variable named targetFountainFileName, which is a string variable for the target file name. If you call this script from another script, via `source`, like this:
#        source fountain2fountain.sh input-file.fountain
# -- then the set variable will be available to the calling script after this script terminates, as `source` does magicky things to cause that. You can then use that variable in the calling script to do other things with that file name.
# - If you have text connecting punctuation like a double-dash (for emdash) :
#        one phrase--another phrase
# --and you break the connecting punctuation over lines of ventilated prose, like this:
#        one phrase--
#        another phrase
# --the script will add a space in the punctuation when it joins lines, which is probably not what you want. To avoid this, don't break connecting punctuation over lines: keep it on the same line.


# CODE
if [ ! -e $1 ]; then echo proposed input file $1 not found. Terminating script.; fi
fileNameNoExt=${1%.*}
# Kludgy and arbitrarily inflexible (instead of pattern matching any title page elements
# and temporarily cutting them out), but:
# - to avoid the sed command mangling title page info, cut everything before and after
# the initial > FADE IN: (which is now an exact match requirement--MUST be present in the
# fountain script!--) into two separate files, work on the second, then rejoin them:
#  - get line number (of match) to split on:
tail_from=`awk '/> FADE IN:/{print NR;exit}' $1`
let head_to=tail_from-1
head -n $head_to $1 > tmp_head_wYSNpHgq.fountain
tail -n +$tail_from $1 > tmp_tail_wYSNpHgq.fountain
dos2unix tmp_head_wYSNpHgq.fountain tmp_tail_wYSNpHgq.fountain
#  - join semantic linefeeds into that tail file, in-place:
# Adapted from: https://backreference.org/2009/12/23/how-to-match-newlines-in-sed/
# sed ':begin;$!N;s/FOO\nBAR/FOOBAR/;tbegin;P;D'   # if a line ends in FOO and the next
# starts with BAR, join them
#   - Also don't match [ .@~] characters at start of line (don't join if those fountain syntax
# marks are present:
sed -i ':begin;$!N;s/\(^[^ .\(~@\n].*[a-z].*\)\n\(^[^ .\(~@\n].*[a-z].*\)/\1 \2/;tbegin;P;D' tmp_tail_wYSNpHgq.fountain
targetFountainFileName="$fileNameNoExt"_unventilated.fountain
cat tmp_head_wYSNpHgq.fountain tmp_tail_wYSNpHgq.fountain > $targetFountainFileName
rm ./tmp_head_wYSNpHgq.fountain ./tmp_tail_wYSNpHgq.fountain
